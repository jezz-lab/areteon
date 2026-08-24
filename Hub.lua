local Hub = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local function Corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = object
    return c
end

local function Stroke(object)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(70, 70, 80)
    s.Thickness = 1
    s.Parent = object
    return s
end

local function MakeDraggable(frame, handle)
    handle = handle or frame

    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

function Hub.Start(Data)
    Data = Data or {}

    local AccessType = Data.AccessType or "FREE"
    Player = Data.Player or Players.LocalPlayer

    local PlayerGui = Player:WaitForChild("PlayerGui")

    local old = PlayerGui:FindFirstChild("ScriptHub")

    if old then
        old:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScriptHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    --------------------------------------------------
    -- MAIN
    --------------------------------------------------

    local Window = Instance.new("Frame")
    Window.Size = UDim2.fromOffset(850, 550)
    Window.Position = UDim2.new(0.5, -425, 0.5, -275)
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Window.BorderSizePixel = 0
    Window.Parent = ScreenGui

    Corner(Window, 10)
    Stroke(Window)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Window

    Corner(TitleBar, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.fromOffset(15, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "◉  SCRIPT HUB"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    MakeDraggable(Window, TitleBar)

    --------------------------------------------------
    -- SIDEBAR
    --------------------------------------------------

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -48)
    Sidebar.Position = UDim2.fromOffset(0, 48)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Window

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 15)
    SidebarPadding.Parent = Sidebar

    --------------------------------------------------
    -- PAGES
    --------------------------------------------------

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -170, 1, -68)
    Pages.Position = UDim2.fromOffset(160, 58)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Window

    local pageObjects = {}

    local function CreatePage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.CanvasSize = UDim2.fromOffset(0, 0)
        page.Visible = false
        page.Parent = Pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.Parent = page

        local padding = Instance.new("UIPadding")
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = page

        layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function()
            page.CanvasSize = UDim2.fromOffset(
                0,
                layout.AbsoluteContentSize.Y + 20
            )
        end)

        pageObjects[name] = page

        return page
    end

    local function ShowPage(name)
        for _, page in pairs(pageObjects) do
            page.Visible = false
        end

        if pageObjects[name] then
            pageObjects[name].Visible = true
        end
    end

    --------------------------------------------------
    -- COMPONENTS
    --------------------------------------------------

    local function Label(parent, text, size, position)
        local label = Instance.new("TextLabel")
        label.Size = size or UDim2.new(1, 0, 0, 35)
        label.Position = position or UDim2.new()
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 15
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
        return label
    end

    local function Button(parent, text, size)
        local b = Instance.new("TextButton")
        b.Size = size or UDim2.new(1, -16, 0, 42)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        b.BorderSizePixel = 0
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 14
        b.Font = Enum.Font.Gotham
        b.Parent = parent

        Corner(b, 6)

        return b
    end

    local function Card(parent, height)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, height)
        card.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
        card.BorderSizePixel = 0
        card.Parent = parent

        Corner(card, 8)

        return card
    end

    local function Checkbox(parent, text, default, callback)
        local b = Button(
            parent,
            text .. ": " .. (default and "ON" or "OFF"),
            UDim2.new(1, 0, 0, 42)
        )

        local state = default

        b.MouseButton1Click:Connect(function()
            state = not state

            b.Text =
                text ..
                ": " ..
                (state and "ON" or "OFF")

            callback(state)
        end)

        return b
    end

    --------------------------------------------------
    -- HOME
    --------------------------------------------------

    local Home = CreatePage("Home")

    Label(Home, "HOME", UDim2.new(1, 0, 0, 35))

    local Profile = Card(Home, 100)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.fromOffset(70, 70)
    Avatar.Position = UDim2.fromOffset(15, 15)
    Avatar.BackgroundTransparency = 1

    local ok, image = pcall(
        Players.GetUserThumbnailAsync,
        Players,
        Player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )

    if ok then
        Avatar.Image = image
    end

    Avatar.Parent = Profile

    Label(
        Profile,
        Player.DisplayName,
        UDim2.new(1, -110, 0, 30),
        UDim2.fromOffset(100, 15)
    )

    Label(
        Profile,
        "@" .. Player.Name,
        UDim2.new(1, -110, 0, 25),
        UDim2.fromOffset(100, 45)
    )

    Label(
        Profile,
        "ID: " .. tostring(Player.UserId),
        UDim2.new(1, -110, 0, 20),
        UDim2.fromOffset(100, 70)
    )

    local Access = Card(Home, 60)

    Label(
        Access,
        "⏱  KEY STATUS",
        UDim2.new(1, -20, 0, 25),
        UDim2.fromOffset(10, 5)
    )

    Label(
        Access,
        "Access: " .. tostring(AccessType),
        UDim2.new(1, -20, 0, 25),
        UDim2.fromOffset(10, 30)
    )

    Card(Home, 50)
    Card(Home, 50)
    Card(Home, 50)

    --------------------------------------------------
    -- SCRIPTS
    --------------------------------------------------

    local Scripts = CreatePage("Scripts")

    Label(Scripts, "📜  SCRIPTS")

    local SpeedCard = Card(Scripts, 145)

    Label(
        SpeedCard,
        "Speed",
        UDim2.new(1, -30, 0, 25),
        UDim2.fromOffset(15, 5)
    )

    local SpeedInput = Instance.new("TextBox")
    SpeedInput.Size = UDim2.fromOffset(90, 35)
    SpeedInput.Position = UDim2.fromOffset(15, 40)
    SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SpeedInput.BorderSizePixel = 0
    SpeedInput.Text = "16"
    SpeedInput.TextColor3 = Color3.new(1, 1, 1)
    SpeedInput.TextSize = 14
    SpeedInput.Font = Enum.Font.Gotham
    SpeedInput.ClearTextOnFocus = false
    SpeedInput.Parent = SpeedCard

    Corner(SpeedInput, 6)

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -140, 0, 8)
    Slider.Position = UDim2.fromOffset(125, 55)
    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Slider.BorderSizePixel = 0
    Slider.Parent = SpeedCard

    Corner(Slider, 4)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Slider

    Corner(Fill, 4)

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.fromOffset(18, 18)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(0, 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.BorderSizePixel = 0
    Knob.Text = ""
    Knob.Parent = Slider

    Corner(Knob, 20)

    local speed = 16

    local function SetSpeed(value)
        speed = math.clamp(
            math.floor(value + 0.5),
            1,
            250
        )

        SpeedInput.Text = tostring(speed)

        local character = Player.Character

        if not character then
            return
        end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end

    local function SetSlider(value)
        local alpha =
            math.clamp(
                (value - 1) / 249,
                0,
                1
            )

        Fill.Size =
            UDim2.new(alpha, 0, 1, 0)

        Knob.Position =
            UDim2.new(alpha, 0, 0.5, 0)

        SetSpeed(value)
    end

    local sliding = false

    local function UpdateSlider(input)
        local x =
            input.Position.X -
            Slider.AbsolutePosition.X

        local alpha =
            math.clamp(
                x / Slider.AbsoluteSize.X,
                0,
                1
            )

        SetSlider(1 + alpha * 249)
    end

    Slider.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch then

            sliding = true
            UpdateSlider(input)
        end
    end)

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch then

            sliding = true
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not sliding then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
        or input.UserInputType ==
            Enum.UserInputType.Touch then

            UpdateSlider(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch then

            sliding = false
        end
    end)

    SpeedInput.FocusLost:Connect(function()
        local value = tonumber(SpeedInput.Text)

        if value then
            SetSlider(value)
        else
            SpeedInput.Text = tostring(speed)
        end
    end)

    local Default = Button(
        SpeedCard,
        "DEFAULT",
        UDim2.fromOffset(110, 35)
    )

    Default.Position =
        UDim2.new(1, -125, 1, -45)

    Default.MouseButton1Click:Connect(function()
        SetSlider(16)
    end)

    SetSlider(16)

    --------------------------------------------------
    -- NOCLIP
    --------------------------------------------------

    local noclip = false

    Checkbox(
        Scripts,
        "Noclip",
        false,
        function(value)
            noclip = value

            if not value then
                local character = Player.Character

                if character then
                    for _, obj in ipairs(
                        character:GetDescendants()
                    ) do
                        if obj:IsA("BasePart") then
                            obj.CanCollide = true
                        end
                    end
                end
            end
        end
    )

    RunService.Stepped:Connect(function()
        if not noclip then
            return
        end

        local character = Player.Character

        if not character then
            return
        end

        for _, obj in ipairs(
            character:GetDescendants()
        ) do
            if obj:IsA("BasePart") then
                obj.CanCollide = false
            end
        end
    end)

    --------------------------------------------------
    -- FLY
    --------------------------------------------------

    local flying = false
    local flyConnection

    local function SetFly(value)
        flying = value

        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end

        if not flying then
            return
        end

        flyConnection =
            RunService.RenderStepped:Connect(function()
                local character = Player.Character

                if not character then
                    return
                end

                local root =
                    character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local humanoid =
                    character:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if not root or not humanoid then
                    return
                end

                local camera =
                    workspace.CurrentCamera

                local direction = Vector3.zero

                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    direction += camera.CFrame.LookVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    direction -= camera.CFrame.LookVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    direction += camera.CFrame.RightVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    direction -= camera.CFrame.RightVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    direction += Vector3.yAxis
                end

                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    direction -= Vector3.yAxis
                end

                if direction.Magnitude > 0 then
                    direction = direction.Unit
                end

                root.AssemblyLinearVelocity =
                    direction * 60
            end)
    end

    Checkbox(
        Scripts,
        "Fly",
        false,
        SetFly
    )

    --------------------------------------------------
    -- UNLIMITED JUMP
    --------------------------------------------------

    local infiniteJump = false

    Checkbox(
        Scripts,
        "Unlimited Jump",
        false,
        function(value)
            infiniteJump = value
        end
    )

    UIS.JumpRequest:Connect(function()
        if not infiniteJump then
            return
        end

        local character = Player.Character

        if not character then
            return
        end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end)

    --------------------------------------------------
    -- CLICK TELEPORT
    --------------------------------------------------

    local clickTeleport = false

    Checkbox(
        Scripts,
        "Click Teleport",
        false,
        function(value)
            clickTeleport = value
        end
    )

    UIS.InputBegan:Connect(function(input, processed)
        if processed or not clickTeleport then
            return
        end

        if input.UserInputType ~=
            Enum.UserInputType.MouseButton1 then
            return
        end

        local mouse = Player:GetMouse()
        local hit = mouse.Hit

        if not hit then
            return
        end

        local character = Player.Character

        if not character then
            return
        end

        local root =
            character:FindFirstChild(
                "HumanoidRootPart"
            )

        if root then
            root.CFrame =
                CFrame.new(hit.Position + Vector3.new(0, 3, 0))
        end
    end)

    --------------------------------------------------
    -- ESP
    --------------------------------------------------

    local espEnabled = false
    local espName = true
    local espDistance = true
    local espHealth = true

    local espObjects = {}

    local function RemoveESP(player)
        local object = espObjects[player]

        if object then
            object:Destroy()
            espObjects[player] = nil
        end
    end

    local function CreateESP(player)
        if player == Player then
            return
        end

        RemoveESP(player)

        local character = player.Character

        if not character then
            return
        end

        local root =
            character:FindFirstChild(
                "HumanoidRootPart"
            )

        if not root then
            return
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "AreteonESP"
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.Parent = character

        espObjects[player] = highlight

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "AreteonESPInfo"
        billboard.Size = UDim2.fromOffset(180, 60)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = root
        billboard.Parent = highlight

        local text = Instance.new("TextLabel")
        text.Size = UDim2.fromScale(1, 1)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.new(1, 1, 1)
        text.TextStrokeTransparency = 0
        text.TextSize = 13
        text.Font = Enum.Font.GothamBold
        text.Parent = billboard

        local function Update()
            if not espEnabled then
                return
            end

            local parts = {}

            if espName then
                table.insert(parts, player.Name)
            end

            if espDistance then
                local myCharacter = Player.Character
                local myRoot =
                    myCharacter and
                    myCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if myRoot then
                    local distance =
                        math.floor(
                            (myRoot.Position -
                                root.Position).Magnitude
                        )

                    table.insert(
                        parts,
                        distance .. " studs"
                    )
                end
            end

            if espHealth then
                local humanoid =
                    character:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if humanoid then
                    table.insert(
                        parts,
                        "HP " ..
                            math.floor(humanoid.Health)
                    )
                end
            end

            text.Text =
                table.concat(parts, "\n")
        end

        local connection

        connection =
            RunService.RenderStepped:Connect(function()
                if not highlight.Parent then
                    connection:Disconnect()
                    return
                end

                Update()
            end)

        highlight.Destroying:Connect(function()
            if connection then
                connection:Disconnect()
            end
        end)
    end

    local function EnableESP()
        espEnabled = true

        for _, player in ipairs(
            Players:GetPlayers()
        ) do
            CreateESP(player)
        end
    end

    local function DisableESP()
        espEnabled = false

        for player in pairs(espObjects) do
            RemoveESP(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if espEnabled then
                task.wait(1)
                CreateESP(player)
            end
        end)
    end)

    Players.PlayerRemoving:Connect(RemoveESP)

    --------------------------------------------------
    -- ESP UI
    --------------------------------------------------

    Checkbox(
        Scripts,
        "ESP",
        false,
        function(value)
            if value then
                EnableESP()
            else
                DisableESP()
            end
        end
    )

    Checkbox(
        Scripts,
        "ESP Name",
        true,
        function(value)
            espName = value
        end
    )

    Checkbox(
        Scripts,
        "ESP Distance",
        true,
        function(value)
            espDistance = value
        end
    )

    Checkbox(
        Scripts,
        "ESP Health",
        true,
        function(value)
            espHealth = value
        end
    )

    --------------------------------------------------
    -- SETTINGS
    --------------------------------------------------

    local Settings = CreatePage("Settings")

    Label(Settings, "⚙  SETTINGS")

    local appearance = Card(Settings, 60)

    Label(
        appearance,
        "🎨  APPEARANCE",
        UDim2.new(1, -20, 0, 35),
        UDim2.fromOffset(10, 10)
    )

    local interface = Card(Settings, 60)

    Label(
        interface,
        "🖥  INTERFACE",
        UDim2.new(1, -20, 0, 35),
        UDim2.fromOffset(10, 10)
    )

    --------------------------------------------------
    -- ADMIN
    --------------------------------------------------

    if AccessType == "ADMIN" then
        local AdminSection = Card(Settings, 60)

        Label(
            AdminSection,
            "🛡  ADMIN",
            UDim2.new(1, -20, 0, 35),
            UDim2.fromOffset(10, 10)
        )

        local AdminButton = Button(
            Settings,
            "🛡  ADMIN PANEL",
            UDim2.new(1, 0, 0, 42)
        )

        AdminButton.MouseButton1Click:Connect(function()
            local ok, source = pcall(function()
                return game:HttpGet(
                    "https://raw.githubusercontent.com/" ..
                    "jezz-lab/areteon/main/adminPanel.lua"
                )
            end)

            if not ok then
                warn("[Admin] Download failed.")
                return
            end

            local fn, err = loadstring(source)

            if not fn then
                warn("[Admin] Compile failed: " .. tostring(err))
                return
            end

            local success, AdminPanel = pcall(fn)

            if not success or type(AdminPanel) ~= "table" then
                warn("[Admin] Failed to load panel.")
                return
            end

            if type(AdminPanel.Open) == "function" then
                AdminPanel.Open(Player)
            end
        end)
    end

    --------------------------------------------------
    -- NAVIGATION
    --------------------------------------------------

    local function NavButton(text, page)
        local b = Button(
            Sidebar,
            text,
            UDim2.new(1, -16, 0, 42)
        )

        b.MouseButton1Click:Connect(function()
            ShowPage(page)
        end)

        return b
    end

    NavButton("🏠  HOME", "Home")
    NavButton("📜  SCRIPTS", "Scripts")
    NavButton("⚙  SETTINGS", "Settings")

    ShowPage("Home")

    --------------------------------------------------
    -- FLOATING TOGGLE
    --------------------------------------------------

    local Toggle = Instance.new("TextButton")
    Toggle.Name = "HubToggle"
    Toggle.Size = UDim2.fromOffset(55, 55)
    Toggle.Position = UDim2.fromOffset(20, 200)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    Toggle.BorderSizePixel = 0
    Toggle.Text = "◉"
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextSize = 22
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Parent = ScreenGui

    Corner(Toggle, 28)
    Stroke(Toggle)

    MakeDraggable(Toggle)

    Toggle.MouseButton1Click:Connect(function()
        Window.Visible = not Window.Visible
    end)

    print("[Areteon] Loaded:", AccessType)

    return {
        Gui = ScreenGui,
        Window = Window,
        AccessType = AccessType
    }
end

return Hub
