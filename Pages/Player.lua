--==================================================
-- ARETEON | Player.lua
--==================================================

local Page = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Connections = {}

--==================================================
-- CONFIG
--==================================================

local DEFAULT_WALK_SPEED = 16
local DEFAULT_JUMP_POWER = 50
local DEFAULT_FLY_SPEED = 50

local MIN_WALK_SPEED = 0
local MAX_WALK_SPEED = 200

--==================================================
-- HELPERS
--==================================================

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
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
end

local function GetHumanoid()
    local character = LocalPlayer.Character

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

--==================================================
-- CLEANUP
--==================================================

local function DisconnectAll()
    for _, connection in ipairs(Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(Connections)
end

--==================================================
-- SECTION
--==================================================

local function CreateSection(parent, title)

    local section = Create("Frame", {

        Size = UDim2.new(
            1,
            -30,
            0,
            40
        ),

        BackgroundColor3 =
            Color3.fromRGB(
                23,
                23,
                29
            ),

        BorderSizePixel = 0

    }, parent)

    Corner(section, 8)

    Create("TextLabel", {

        BackgroundTransparency = 1,

        Position = UDim2.new(
            0,
            12,
            0,
            0
        ),

        Size = UDim2.new(
            1,
            -24,
            1,
            0
        ),

        Font = Enum.Font.GothamBold,

        Text = title,

        TextColor3 =
            Color3.fromRGB(
                235,
                235,
                240
            ),

        TextSize = 14,

        TextXAlignment =
            Enum.TextXAlignment.Left

    }, section)

    return section
end

--==================================================
-- CONTROL PANEL
--==================================================

local function CreatePanel(
    parent,
    title
)

    local panel = Create("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                27,
                27,
                34
            ),

        BorderSizePixel = 0

    }, parent)

    Corner(panel, 7)

    Create("TextLabel", {

        BackgroundTransparency = 1,

        Position = UDim2.new(
            0,
            10,
            0,
            8
        ),

        Size = UDim2.new(
            1,
            -45,
            0,
            20
        ),

        Font = Enum.Font.GothamBold,

        Text = title,

        TextColor3 =
            Color3.fromRGB(
                235,
                235,
                240
            ),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left

    }, panel)

    return panel
end

--==================================================
-- INPUT
--==================================================

local function CreateInput(
    parent,
    text,
    position,
    size
)

    local input = Create("TextBox", {

        Position = position,

        Size = size,

        BackgroundColor3 =
            Color3.fromRGB(
                38,
                38,
                47
            ),

        BorderSizePixel = 0,

        Font = Enum.Font.Gotham,

        Text = text,

        TextColor3 =
            Color3.fromRGB(
                220,
                220,
                225
            ),

        PlaceholderColor3 =
            Color3.fromRGB(
                140,
                140,
                150
            ),

        TextSize = 12,

        ClearTextOnFocus = false

    }, parent)

    Corner(input, 6)

    return input
end

--==================================================
-- CHECKBOX
--==================================================

local function CreateCheckbox(
    parent,
    callback
)

    local checkbox = Create("TextButton", {

        AnchorPoint =
            Vector2.new(
                1,
                0
            ),

        Position = UDim2.new(
            1,
            -10,
            0,
            8
        ),

        Size = UDim2.new(
            0,
            22,
            0,
            22
        ),

        BackgroundColor3 =
            Color3.fromRGB(
                42,
                42,
                50
            ),

        BorderSizePixel = 0,

        Text = "",

        Font = Enum.Font.GothamBold,

        TextSize = 14,

        AutoButtonColor = false

    }, parent)

    Corner(checkbox, 5)

    local enabled = false

    local function Update()

        if enabled then

            checkbox.BackgroundColor3 =
                Color3.fromRGB(
                    80,
                    140,
                    255
                )

            checkbox.Text = "✓"

            checkbox.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

        else

            checkbox.BackgroundColor3 =
                Color3.fromRGB(
                    42,
                    42,
                    50
                )

            checkbox.Text = ""

        end

    end

    checkbox.MouseButton1Click:Connect(
        function()

            enabled = not enabled

            Update()

            if callback then
                callback(enabled)
            end

        end
    )

    Update()

    return checkbox
end

--==================================================
-- SLIDER
--==================================================

local function CreateSlider(
    parent,
    minimum,
    maximum,
    default,
    callback
)

    local slider = Create("Frame", {

        Position = UDim2.new(
            0,
            10,
            0,
            67
        ),

        Size = UDim2.new(
            1,
            -20,
            0,
            6
        ),

        BackgroundColor3 =
            Color3.fromRGB(
                48,
                48,
                58
            ),

        BorderSizePixel = 0

    }, parent)

    Corner(slider, 5)

    local normalized =
        (default - minimum) /
        (maximum - minimum)

    local fill = Create("Frame", {

        Size = UDim2.new(
            normalized,
            0,
            1,
            0
        ),

        BackgroundColor3 =
            Color3.fromRGB(
                80,
                140,
                255
            ),

        BorderSizePixel = 0

    }, slider)

    Corner(fill, 5)

    local knob = Create("TextButton", {

        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        Position = UDim2.new(
            normalized,
            0,
            0.5,
            0
        ),

        Size = UDim2.new(
            0,
            14,
            0,
            14
        ),

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BorderSizePixel = 0,

        Text = "",

        AutoButtonColor = false

    }, slider)

    Corner(knob, 10)

    local dragging = false

    local function SetValue(x)

        local startX =
            slider.AbsolutePosition.X

        local width =
            slider.AbsoluteSize.X

        if width <= 0 then
            return
        end

        local percent =
            math.clamp(
                (x - startX) / width,
                0,
                1
            )

        local value =
            minimum +
            (
                (maximum - minimum)
                * percent
            )

        value =
            math.floor(
                value + 0.5
            )

        local newNormalized =
            (value - minimum) /
            (maximum - minimum)

        fill.Size =
            UDim2.new(
                newNormalized,
                0,
                1,
                0
            )

        knob.Position =
            UDim2.new(
                newNormalized,
                0,
                0.5,
                0
            )

        if callback then
            callback(value)
        end

    end

    slider.InputBegan:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
            then

                dragging = true

                SetValue(
                    input.Position.X
                )

            end

        end
    )

    table.insert(
        Connections,

        UserInputService.InputEnded:Connect(
            function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                then

                    dragging = false

                end

            end
        )
    )

    table.insert(
        Connections,

        UserInputService.InputChanged:Connect(
            function(input)

                if not dragging then
                    return
                end

                if input.UserInputType ==
                    Enum.UserInputType.MouseMovement
                then

                    SetValue(
                        input.Position.X
                    )

                end

            end
        )
    )

    return slider
end

--==================================================
-- START
--==================================================

function Page.Start(state)

    DisconnectAll()

    --==================================================
    -- REMOVE OLD PAGE
    --==================================================

    local oldPage =
        state.Content:FindFirstChild(
            "Player"
        )

    if oldPage then
        oldPage:Destroy()
    end

    --==================================================
    -- PAGE FRAME
    --==================================================

    local PageFrame = Create("Frame", {

        Name = "Player",

        Visible = true,

        Active = true,

        Size = UDim2.new(
            1,
            0,
            1,
            0
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            0
        ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ClipsDescendants = true

    }, state.Content)

    --==================================================
    -- CONTENT CONTAINER
    --==================================================

    local Content = Create("Frame", {

        Name = "PlayerContent",

        Position = UDim2.new(
            0,
            15,
            0,
            15
        ),

        Size = UDim2.new(
            1,
            -30,
            1,
            -30
        ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0

    }, PageFrame)

    --==================================================
    -- TITLE
    --==================================================

    local Title = Create("TextLabel", {

        Position = UDim2.new(
            0,
            0,
            0,
            0
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            35
        ),

        BackgroundTransparency = 1,

        Font = Enum.Font.GothamBold,

        Text = "Player",

        TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        TextSize = 22,

        TextXAlignment =
            Enum.TextXAlignment.Left

    }, Content)

    --==================================================
    -- MOVEMENT SECTION
    --==================================================

    local Movement =
        CreateSection(
            Content,
            "Movement"
        )

    Movement.Position =
        UDim2.new(
            0,
            0,
            0,
            45
        )

    --==================================================
    -- MOVEMENT GRID
    --==================================================

    local MovementGrid = Create("Frame", {

        Position = UDim2.new(
            0,
            0,
            0,
            95
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            200
        ),

        BackgroundTransparency = 1

    }, Content)

    Create(
        "UIGridLayout",
        {
            CellSize = UDim2.new(
                0.5,
                -5,
                0,
                95
            ),

            CellPadding = UDim2.new(
                0,
                10,
                0,
                10
            ),

            SortOrder =
                Enum.SortOrder.LayoutOrder
        },
        MovementGrid
    )

    --==================================================
    -- WALK SPEED
    --==================================================

    local SpeedPanel =
        CreatePanel(
            MovementGrid,
            "WalkSpeed"
        )

    SpeedPanel.LayoutOrder = 1

    local SpeedBox =
        CreateInput(
            SpeedPanel,
            "16",
            UDim2.new(
                0,
                10,
                0,
                32
            ),
            UDim2.new(
                1,
                -20,
                0,
                25
            )
        )

    SpeedBox.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    SpeedBox.Text
                )

            if not value then

                SpeedBox.Text =
                    "16"

                return

            end

            value =
                math.clamp(
                    value,
                    MIN_WALK_SPEED,
                    MAX_WALK_SPEED
                )

            SpeedBox.Text =
                tostring(value)

            local humanoid =
                GetHumanoid()

            if humanoid then
                humanoid.WalkSpeed =
                    value
            end

        end
    )

    CreateSlider(
        SpeedPanel,
        MIN_WALK_SPEED,
        MAX_WALK_SPEED,
        DEFAULT_WALK_SPEED,
        function(value)

            SpeedBox.Text =
                tostring(value)

            local humanoid =
                GetHumanoid()

            if humanoid then
                humanoid.WalkSpeed =
                    value
            end

        end
    )

    --==================================================
    -- JUMP POWER
    --==================================================

    local JumpPanel =
        CreatePanel(
            MovementGrid,
            "JumpPower"
        )

    JumpPanel.LayoutOrder = 2

    local JumpBox =
        CreateInput(
            JumpPanel,
            "50",
            UDim2.new(
                0,
                10,
                0,
                38
            ),
            UDim2.new(
                1,
                -20,
                0,
                32
            )
        )

    JumpBox.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    JumpBox.Text
                )

            if not value then

                JumpBox.Text =
                    "50"

                return

            end

            local humanoid =
                GetHumanoid()

            if humanoid then
                humanoid.JumpPower =
                    value
            end

        end
    )

    --==================================================
    -- FLY
    --==================================================

    local FlyPanel =
        CreatePanel(
            MovementGrid,
            "Fly"
        )

    FlyPanel.LayoutOrder = 3

    CreateCheckbox(
        FlyPanel,
        function(enabled)

            print(
                "[Areteon] Fly:",
                enabled
            )

        end
    )

    local FlySpeed =
        CreateInput(
            FlyPanel,
            "50",
            UDim2.new(
                0,
                10,
                0,
                38
            ),
            UDim2.new(
                1,
                -20,
                0,
                30
            )
        )

    FlySpeed.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    FlySpeed.Text
                )

            if not value then

                FlySpeed.Text =
                    "50"

                return

            end

            FlySpeed.Text =
                tostring(
                    math.max(
                        0,
                        value
                    )
                )

        end
    )

    --==================================================
    -- NOCLIP
    --==================================================

    local NoclipPanel =
        CreatePanel(
            MovementGrid,
            "Noclip"
        )

    NoclipPanel.LayoutOrder = 4

    CreateCheckbox(
        NoclipPanel,
        function(enabled)

            if enabled then

                local connection =
                    RunService.Stepped:Connect(
                        function()

                            local character =
                                LocalPlayer.Character

                            if not character then
                                return
                            end

                            for _, object in
                                ipairs(
                                    character:GetDescendants()
                                )
                            do

                                if object:IsA(
                                    "BasePart"
                                ) then

                                    object.CanCollide =
                                        false

                                end

                            end

                        end
                    )

                table.insert(
                    Connections,
                    connection
                )

            end

        end
    )

    --==================================================
    -- EXTRAS
    --==================================================

    local Extras =
        CreateSection(
            Content,
            "Extras"
        )

    Extras.Position =
        UDim2.new(
            0,
            0,
            0,
            305
        )

    local ExtrasGrid = Create("Frame", {

        Position = UDim2.new(
            0,
            0,
            0,
            355
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            95
        ),

        BackgroundTransparency = 1

    }, Content)

    Create(
        "UIGridLayout",
        {
            CellSize = UDim2.new(
                0.5,
                -5,
                0,
                95
            ),

            CellPadding = UDim2.new(
                0,
                10,
                0,
                0
            )
        },
        ExtrasGrid
    )

    --==================================================
    -- INFINITE JUMP
    --==================================================

    local InfinitePanel =
        CreatePanel(
            ExtrasGrid,
            "Infinite Jump"
        )

    InfinitePanel.LayoutOrder = 1

    CreateCheckbox(
        InfinitePanel,
        function(enabled)

            if enabled then

                local connection =
                    UserInputService.JumpRequest:Connect(
                        function()

                            local humanoid =
                                GetHumanoid()

                            if humanoid then

                                humanoid:ChangeState(
                                    Enum.HumanoidStateType.Jumping
                                )

                            end

                        end
                    )

                table.insert(
                    Connections,
                    connection
                )

            end

        end
    )

    --==================================================
    -- CLICK TELEPORT
    --==================================================

    local TeleportPanel =
        CreatePanel(
            ExtrasGrid,
            "Click Teleport"
        )

    TeleportPanel.LayoutOrder = 2

    CreateCheckbox(
        TeleportPanel,
        function(enabled)

            print(
                "[Areteon] Click Teleport:",
                enabled
            )

        end
    )

    --==================================================
    -- PLAYER
    --==================================================

    local PlayerSection =
        CreateSection(
            Content,
            "Player"
        )

    PlayerSection.Position =
        UDim2.new(
            0,
            0,
            0,
            460
        )

    local PlayerGrid = Create("Frame", {

        Position = UDim2.new(
            0,
            0,
            0,
            510
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            45
        ),

        BackgroundTransparency = 1

    }, Content)

    Create(
        "UIGridLayout",
        {
            CellSize = UDim2.new(
                0.5,
                -5,
                0,
                45
            ),

            CellPadding = UDim2.new(
                0,
                10,
                0,
                0
            )
        },
        PlayerGrid
    )

    --==================================================
    -- RESET
    --==================================================

    local Reset =
        Create(
            "TextButton",
            {
                BackgroundColor3 =
                    Color3.fromRGB(
                        27,
                        27,
                        34
                    ),

                BorderSizePixel = 0,

                Font = Enum.Font.Gotham,

                Text = "Reset Character",

                TextColor3 =
                    Color3.fromRGB(
                        220,
                        220,
                        225
                    ),

                TextSize = 12
            },
            PlayerGrid
        )

    Corner(Reset, 7)

    Reset.MouseButton1Click:Connect(
        function()

            local humanoid =
                GetHumanoid()

            if humanoid then
                humanoid.Health = 0
            end

        end
    )

    --==================================================
    -- RESPAWN
    --==================================================

    local Respawn =
        Create(
            "TextButton",
            {
                BackgroundColor3 =
                    Color3.fromRGB(
                        27,
                        27,
                        34
                    ),

                BorderSizePixel = 0,

                Font = Enum.Font.Gotham,

                Text = "Respawn",

                TextColor3 =
                    Color3.fromRGB(
                        220,
                        220,
                        225
                    ),

                TextSize = 12
            },
            PlayerGrid
        )

    Corner(Respawn, 7)

    Respawn.MouseButton1Click:Connect(
        function()

            LocalPlayer:LoadCharacter()

        end
    )

    --==================================================
    -- RETURN PAGE
    --==================================================

    PageFrame.Visible = true

    return PageFrame
end

return Page
