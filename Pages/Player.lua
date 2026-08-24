--==================================================
-- ARETEON | Pages/Player.lua
--==================================================

local PlayerPage = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local State = {
    WalkSpeed = 16,
    JumpPower = 50,

    Fly = false,
    Noclip = false,
    InfiniteJump = false,
    ClickTeleport = false,

    ESP = false,
    Names = false,
    Distance = false,
    Health = false,
    Highlight = false,
    TeamCheck = false,

    FlySpeed = 50
}

local Connections = {}
local ESPObjects = {}

--==================================================
-- HELPERS
--==================================================

local function Disconnect(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local character = GetCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

local function GetRoot()
    local character = GetCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        pcall(function()
            object[property] = value
        end)
    end

    object.Parent = parent

    return object
end

local function Corner(object, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 7)
    }, object)
end

--==================================================
-- MOVEMENT
--==================================================

local function UpdateMovement()
    local humanoid = GetHumanoid()

    if not humanoid then
        return
    end

    humanoid.WalkSpeed = State.WalkSpeed
    humanoid.JumpPower = State.JumpPower
end

local function SetFly(enabled)
    State.Fly = enabled

    Disconnect("Fly")

    if not enabled then
        return
    end

    Connections.Fly = RunService.RenderStepped:Connect(function()
        local root = GetRoot()

        if not root then
            return
        end

        local camera = workspace.CurrentCamera

        if not camera then
            return
        end

        local direction = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.yAxis
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction -= Vector3.yAxis
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        root.AssemblyLinearVelocity =
            direction * State.FlySpeed
    end)
end

local function SetNoclip(enabled)
    State.Noclip = enabled

    Disconnect("Noclip")

    if not enabled then
        local character = GetCharacter()

        if character then
            for _, object in ipairs(character:GetDescendants()) do
                if object:IsA("BasePart") then
                    object.CanCollide = true
                end
            end
        end

        return
    end

    Connections.Noclip = RunService.Stepped:Connect(function()
        local character = GetCharacter()

        if not character then
            return
        end

        for _, object in ipairs(character:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false
            end
        end
    end)
end

--==================================================
-- INFINITE JUMP
--==================================================

local function SetInfiniteJump(enabled)
    State.InfiniteJump = enabled

    Disconnect("InfiniteJump")

    if not enabled then
        return
    end

    Connections.InfiniteJump =
        UserInputService.JumpRequest:Connect(function()
            local humanoid = GetHumanoid()

            if humanoid then
                humanoid:ChangeState(
                    Enum.HumanoidStateType.Jumping
                )
            end
        end)
end

--==================================================
-- ESP
--==================================================

local function RemoveESP(player)
    local objects = ESPObjects[player]

    if not objects then
        return
    end

    for _, object in pairs(objects) do
        if object and object.Parent then
            object:Destroy()
        end
    end

    ESPObjects[player] = nil
end

local function IsEnemy(player)
    if player == LocalPlayer then
        return false
    end

    if not State.TeamCheck then
        return true
    end

    return player.Team ~= LocalPlayer.Team
end

local function CreateESP(player)
    if player == LocalPlayer then
        return
    end

    RemoveESP(player)

    if not State.ESP then
        return
    end

    if not IsEnemy(player) then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local objects = {}

    -- Highlight
    if State.Highlight then
        local highlight = Instance.new("Highlight")

        highlight.Name = "AreteonHighlight"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character

        objects.Highlight = highlight
    end

    -- Billboard
    if State.Names or State.Distance or State.Health then
        local head = character:FindFirstChild("Head")

        if head then
            local billboard = Create("BillboardGui", {
                Name = "AreteonESP",
                Adornee = head,
                Size = UDim2.new(0, 180, 0, 70),
                StudsOffset = Vector3.new(0, 3, 0),
                AlwaysOnTop = true
            }, head)

            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextStrokeTransparency = 0,
                TextSize = 12,
                TextWrapped = true
            }, billboard)

            local function UpdateText()
                if not label.Parent then
                    return
                end

                local lines = {}

                if State.Names then
                    table.insert(
                        lines,
                        player.DisplayName ..
                        " (@" ..
                        player.Name ..
                        ")"
                    )
                end

                if State.Distance then
                    local myRoot = GetRoot()
                    local theirRoot =
                        character:FindFirstChild(
                            "HumanoidRootPart"
                        )

                    if myRoot and theirRoot then
                        local distance =
                            math.floor(
                                (myRoot.Position -
                                theirRoot.Position).Magnitude
                            )

                        table.insert(
                            lines,
                            "Distance: " ..
                            tostring(distance) ..
                            " studs"
                        )
                    end
                end

                if State.Health then
                    local humanoid =
                        character:FindFirstChildOfClass(
                            "Humanoid"
                        )

                    if humanoid then
                        table.insert(
                            lines,
                            "Health: " ..
                            math.floor(humanoid.Health) ..
                            "/" ..
                            math.floor(humanoid.MaxHealth)
                        )
                    end
                end

                label.Text = table.concat(
                    lines,
                    "\n"
                )
            end

            UpdateText()

            objects.Billboard = billboard

            objects.Update = RunService.RenderStepped:Connect(
                UpdateText
            )
        end
    end

    ESPObjects[player] = objects
end

local function RefreshESP()
    for player in pairs(ESPObjects) do
        RemoveESP(player)
    end

    if not State.ESP then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        CreateESP(player)
    end
end

--==================================================
-- CLICK TELEPORT
--==================================================

local function SetClickTeleport(enabled)
    State.ClickTeleport = enabled

    Disconnect("ClickTeleport")

    if not enabled then
        return
    end

    local mouse = LocalPlayer:GetMouse()

    Connections.ClickTeleport =
        mouse.Button1Down:Connect(function()
            if not State.ClickTeleport then
                return
            end

            local hit = mouse.Hit

            if not hit then
                return
            end

            local root = GetRoot()

            if root then
                root.CFrame =
                    CFrame.new(
                        hit.Position +
                        Vector3.new(0, 3, 0)
                    )
            end
        end)
end

--==================================================
-- GUI HELPERS
--==================================================

local function Section(parent, title)
    local container = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(24, 24, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    }, parent)

    Corner(container, 9)

    local layout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, container)

    local header = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        Font = Enum.Font.GothamBold,
        Text = "▼  " .. title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, container)

    local body = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2
    }, container)

    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, body)

    local opened = true

    header.MouseButton1Click:Connect(function()
        opened = not opened

        body.Visible = opened

        header.Text =
            (opened and "▼  " or "▶  ") ..
            title
    end)

    return body
end

local function Toggle(parent, text, value, callback)
    local button = Create("TextButton", {
        BackgroundColor3 = Color3.fromRGB(34, 34, 42),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Font = Enum.Font.GothamMedium,
        Text = "",
        LayoutOrder = 1
    }, parent)

    Corner(button, 7)

    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -65, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Color3.fromRGB(225, 225, 230),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, button)

    local status = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -55, 0, 0),
        Size = UDim2.new(0, 45, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = value and "ON" or "OFF",
        TextColor3 = value
            and Color3.fromRGB(100, 220, 140)
            or Color3.fromRGB(150, 150, 160),
        TextSize = 11
    }, button)

    local current = value

    button.MouseButton1Click:Connect(function()
        current = not current

        status.Text = current and "ON" or "OFF"

        status.TextColor3 = current
            and Color3.fromRGB(100, 220, 140)
            or Color3.fromRGB(150, 150, 160)

        callback(current)
    end)

    return button
end

local function Input(parent, text, default, callback)
    local frame = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34)
    }, parent)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Color3.fromRGB(210, 210, 215),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local box = Create("TextBox", {
        BackgroundColor3 = Color3.fromRGB(34, 34, 42),
        BorderSizePixel = 0,
        Position = UDim2.new(0.55, 0, 0, 0),
        Size = UDim2.new(0.45, 0, 1, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = tostring(default),
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        ClearTextOnFocus = false
    }, frame)

    Corner(box, 7)

    box.FocusLost:Connect(function()
        local number = tonumber(box.Text)

        if number then
            callback(number)
        else
            box.Text = tostring(default)
        end
    end)

    return box
end

--==================================================
-- START
--==================================================

function PlayerPage.Start(state)

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local old = PlayerGui:FindFirstChild("AreteonPlayer")

    if old then
        old:Destroy()
    end

    local Gui = Create("ScreenGui", {
        Name = "AreteonPlayer",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    local Window = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 560, 0, 600),
        BackgroundColor3 = Color3.fromRGB(15, 15, 19),
        BorderSizePixel = 0
    }, Gui)

    Corner(Window, 12)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "Player",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Window)

    local Scroll = Create("ScrollingFrame", {
        Position = UDim2.new(0, 12, 0, 55),
        Size = UDim2.new(1, -24, 1, -67),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, Window)

    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Scroll)

    --==================================================
    -- MOVEMENT
    --==================================================

    local Movement = Section(
        Scroll,
        "Movement"
    )

    Input(
        Movement,
        "WalkSpeed",
        State.WalkSpeed,
        function(value)
            State.WalkSpeed = value
            UpdateMovement()
        end
    )

    Input(
        Movement,
        "JumpPower",
        State.JumpPower,
        function(value)
            State.JumpPower = value
            UpdateMovement()
        end
    )

    Toggle(
        Movement,
        "Fly",
        false,
        SetFly
    )

    Toggle(
        Movement,
        "Noclip",
        false,
        SetNoclip
    )

    --==================================================
    -- VISUAL
    --==================================================

    local Visual = Section(
        Scroll,
        "Visual"
    )

    Toggle(
        Visual,
        "ESP",
        false,
        function(value)
            State.ESP = value
            RefreshESP()
        end
    )

    Toggle(
        Visual,
        "Names",
        false,
        function(value)
            State.Names = value
            RefreshESP()
        end
    )

    Toggle(
        Visual,
        "Distance",
        false,
        function(value)
            State.Distance = value
            RefreshESP()
        end
    )

    Toggle(
        Visual,
        "Health",
        false,
        function(value)
            State.Health = value
            RefreshESP()
        end
    )

    Toggle(
        Visual,
        "Highlight",
        false,
        function(value)
            State.Highlight = value
            RefreshESP()
        end
    )

    Toggle(
        Visual,
        "Team Check",
        false,
        function(value)
            State.TeamCheck = value
            RefreshESP()
        end
    )

    --==================================================
    -- EXTRAS
    --==================================================

    local Extras = Section(
        Scroll,
        "Extras"
    )

    Toggle(
        Extras,
        "Infinite Jump",
        false,
        SetInfiniteJump
    )

    --==================================================
    -- PLAYER
    --==================================================

    local PlayerSection = Section(
        Scroll,
        "Player"
    )

    Toggle(
        PlayerSection,
        "Click Teleport",
        false,
        SetClickTeleport
    )

    --==================================================
    -- CHARACTER RESPAWN
    --==================================================

    Connections.CharacterAdded =
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)

            UpdateMovement()

            if State.Fly then
                SetFly(true)
            end

            if State.Noclip then
                SetNoclip(true)
            end

            if State.ESP then
                task.wait(0.5)
                RefreshESP()
            end
        end)

    --==================================================
    -- PLAYER EVENTS
    --==================================================

    Connections.PlayerAdded =
        Players.PlayerAdded:Connect(function(player)
            if State.ESP then
                task.wait(1)
                CreateESP(player)
            end

            player.CharacterAdded:Connect(function()
                if State.ESP then
                    task.wait(0.5)
                    CreateESP(player)
                end
            end)
        end)

    Connections.PlayerRemoving =
        Players.PlayerRemoving:Connect(function(player)
            RemoveESP(player)
        end)

    UpdateMovement()

    print("[Areteon] Player page initialized.")

    return Gui
end

return PlayerPage
