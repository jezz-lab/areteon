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
-- DEFAULTS
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

local function GetRoot()
    local character = LocalPlayer.Character

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- SECTION
--==================================================

local function Section(parent, title)
    local frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),

        BackgroundColor3 = Color3.fromRGB(
            23,
            23,
            29
        ),

        BorderSizePixel = 0
    }, parent)

    Corner(frame, 8)

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

        TextColor3 = Color3.fromRGB(
            235,
            235,
            240
        ),

        TextSize = 14,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, frame)

    return frame
end

--==================================================
-- CONTROL BOX
--==================================================

local function ControlBox(
    parent,
    title,
    height
)

    local frame = Create("Frame", {
        Size = UDim2.new(
            0.5,
            -5,
            0,
            height or 90
        ),

        BackgroundColor3 = Color3.fromRGB(
            27,
            27,
            34
        ),

        BorderSizePixel = 0
    }, parent)

    Corner(frame, 7)

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
            -20,
            0,
            22
        ),

        Font = Enum.Font.GothamBold,

        Text = title,

        TextColor3 = Color3.fromRGB(
            235,
            235,
            240
        ),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, frame)

    return frame
end

--==================================================
-- INPUT
--==================================================

local function Input(
    parent,
    text,
    position,
    size
)

    local box = Create("TextBox", {
        Position = position,

        Size = size,

        BackgroundColor3 =
            Color3.fromRGB(
                35,
                35,
                43
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

    Corner(box, 6)

    return box
end

--==================================================
-- CHECKBOX
--==================================================

local function Checkbox(
    parent,
    callback
)

    local button = Create("TextButton", {
        AnchorPoint =
            Vector2.new(
                1,
                0.5
            ),

        Position =
            UDim2.new(
                1,
                -10,
                0,
                20
            ),

        Size =
            UDim2.new(
                0,
                22,
                0,
                22
            ),

        BackgroundColor3 =
            Color3.fromRGB(
                38,
                38,
                47
            ),

        BorderSizePixel = 0,

        Text = ""
    }, parent)

    Corner(button, 5)

    local enabled = false

    local function Update()
        if enabled then
            button.BackgroundColor3 =
                Color3.fromRGB(
                    80,
                    140,
                    255
                )

            button.Text = "✓"
        else
            button.BackgroundColor3 =
                Color3.fromRGB(
                    38,
                    38,
                    47
                )

            button.Text = ""
        end
    end

    button.MouseButton1Click:Connect(function()
        enabled = not enabled

        Update()

        if callback then
            callback(enabled)
        end
    end)

    Update()

    return button
end

--==================================================
-- SLIDER
--==================================================

local function Slider(
    parent,
    minimum,
    maximum,
    defaultValue,
    callback
)

    local holder = Create("Frame", {
        Position = UDim2.new(
            0,
            10,
            0,
            63
        ),

        Size = UDim2.new(
            1,
            -20,
            0,
            16
        ),

        BackgroundTransparency = 1
    }, parent)

    local bar = Create("Frame", {
        AnchorPoint =
            Vector2.new(
                0,
                0.5
            ),

        Position =
            UDim2.new(
                0,
                0,
                0.5,
                0
            ),

        Size =
            UDim2.new(
                1,
                0,
                0,
                5
            ),

        BackgroundColor3 =
            Color3.fromRGB(
                50,
                50,
                60
            ),

        BorderSizePixel = 0
    }, holder)

    Corner(bar, 5)

    local fill = Create("Frame", {
        Size =
            UDim2.new(
                0,
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
    }, bar)

    Corner(fill, 5)

    local knob = Create("TextButton", {
        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        Position =
            UDim2.new(
                0,
                0,
                0.5,
                0
            ),

        Size =
            UDim2.new(
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
    }, bar)

    Corner(knob, 10)

    local dragging = false
    local value = defaultValue

    local function SetValue(inputX)
        local startX = bar.AbsolutePosition.X
        local width = bar.AbsoluteSize.X

        local percent =
            math.clamp(
                (inputX - startX) / width,
                0,
                1
            )

        value =
            minimum +
            ((maximum - minimum) * percent)

        value =
            math.floor(
                value + 0.5
            )

        local normalized =
            (value - minimum) /
            (maximum - minimum)

        fill.Size =
            UDim2.new(
                normalized,
                0,
                1,
                0
            )

        knob.Position =
            UDim2.new(
                normalized,
                0,
                0.5,
                0
            )

        if callback then
            callback(value)
        end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
        then
            SetValue(input.Position.X)
        end
    end)

    bar.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        then
            SetValue(input.Position.X)
        end
    end)

    task.defer(function()
        local normalized =
            (defaultValue - minimum) /
            (maximum - minimum)

        fill.Size =
            UDim2.new(
                normalized,
                0,
                1,
                0
            )

        knob.Position =
            UDim2.new(
                normalized,
                0,
                0.5,
                0
            )
    end)

    return holder
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
-- START
--==================================================

function Page.Start(state)

    DisconnectAll()

    local PageFrame = Create("Frame", {
        Name = "Player",

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
    -- SCROLLING AREA
    --==================================================

    local Scroll = Create("ScrollingFrame", {
        Name = "PlayerScroll",

        Position = UDim2.new(
            0,
            10,
            0,
            10
        ),

        Size = UDim2.new(
            1,
            -20,
            1,
            -20
        ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        CanvasSize = UDim2.new(
            0,
            0,
            0,
            0
        ),

        AutomaticCanvasSize =
            Enum.AutomaticSize.Y,

        ScrollBarThickness = 5,

        ScrollBarImageTransparency = 0.15,

        ScrollingDirection =
            Enum.ScrollingDirection.Y
    }, PageFrame)

    local Layout = Create("UIListLayout", {
        Padding = UDim.new(
            0,
            10
        ),

        SortOrder =
            Enum.SortOrder.LayoutOrder
    }, Scroll)

    Create("UIPadding", {
        PaddingTop = UDim.new(
            0,
            5
        ),

        PaddingBottom = UDim.new(
            0,
            15
        )
    }, Scroll)

    --==================================================
    -- TITLE
    --==================================================

    Create("TextLabel", {
        LayoutOrder = 1,

        Size = UDim2.new(
            1,
            -10,
            0,
            40
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
    }, Scroll)

    --==================================================
    -- MOVEMENT SECTION
    --==================================================

    local Movement =
        Section(
            Scroll,
            "Movement"
        )

    Movement.LayoutOrder = 2

    --==================================================
    -- MOVEMENT GRID
    --==================================================

    local MovementGrid = Create("Frame", {
        LayoutOrder = 3,

        Size = UDim2.new(
            1,
            -10,
            0,
            205
        ),

        BackgroundTransparency = 1
    }, Scroll)

    local Grid = Create("UIGridLayout", {
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
    }, MovementGrid)

    --==================================================
    -- WALK SPEED
    --==================================================

    local SpeedPanel =
        ControlBox(
            MovementGrid,
            "WalkSpeed",
            95
        )

    SpeedPanel.LayoutOrder = 1

    local SpeedBox =
        Input(
            SpeedPanel,
            tostring(
                DEFAULT_WALK_SPEED
            ),
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
                27
            )
        )

    local function SetWalkSpeed(value)
        local humanoid = GetHumanoid()

        if humanoid then
            humanoid.WalkSpeed = value
        end
    end

    SpeedBox.FocusLost:Connect(function()
        local value =
            tonumber(
                SpeedBox.Text
            )

        if not value then
            SpeedBox.Text =
                tostring(
                    DEFAULT_WALK_SPEED
                )
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

        SetWalkSpeed(value)
    end)

    Slider(
        SpeedPanel,
        MIN_WALK_SPEED,
        MAX_WALK_SPEED,
        DEFAULT_WALK_SPEED,
        function(value)
            SpeedBox.Text =
                tostring(value)

            SetWalkSpeed(value)
        end
    )

    --==================================================
    -- JUMP POWER
    --==================================================

    local JumpPanel =
        ControlBox(
            MovementGrid,
            "JumpPower",
            95
        )

    JumpPanel.LayoutOrder = 2

    local JumpBox =
        Input(
            JumpPanel,
            tostring(
                DEFAULT_JUMP_POWER
            ),
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

    JumpBox.FocusLost:Connect(function()
        local value =
            tonumber(
                JumpBox.Text
            )

        if not value then
            JumpBox.Text =
                tostring(
                    DEFAULT_JUMP_POWER
                )
            return
        end

        local humanoid =
            GetHumanoid()

        if humanoid then
            humanoid.JumpPower = value
        end
    end)

    --==================================================
    -- FLY
    --==================================================

    local FlyPanel =
        ControlBox(
            MovementGrid,
            "Fly",
            95
        )

    FlyPanel.LayoutOrder = 3

    Checkbox(
        FlyPanel,
        function(enabled)

            if enabled then
                print(
                    "[Areteon] Fly enabled"
                )
            else
                print(
                    "[Areteon] Fly disabled"
                )
            end

        end
    )

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position = UDim2.new(
            0,
            10,
            0,
            38
        ),

        Size = UDim2.new(
            0,
            55,
            0,
            25
        ),

        Font = Enum.Font.Gotham,

        Text = "Speed",

        TextColor3 =
            Color3.fromRGB(
                170,
                170,
                180
            ),

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, FlyPanel)

    local FlySpeedBox =
        Input(
            FlyPanel,
            tostring(
                DEFAULT_FLY_SPEED
            ),
            UDim2.new(
                0,
                62,
                0,
                34
            ),
            UDim2.new(
                1,
                -72,
                0,
                30
            )
        )

    FlySpeedBox.FocusLost:Connect(function()
        local value =
            tonumber(
                FlySpeedBox.Text
            )

        if not value then
            FlySpeedBox.Text =
                tostring(
                    DEFAULT_FLY_SPEED
                )
            return
        end

        FlySpeedBox.Text =
            tostring(
                math.max(
                    0,
                    value
                )
            )
    end)

    --==================================================
    -- NOCLIP
    --==================================================

    local NoclipPanel =
        ControlBox(
            MovementGrid,
            "Noclip",
            95
        )

    NoclipPanel.LayoutOrder = 4

    Checkbox(
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
        Section(
            Scroll,
            "Extras"
        )

    Extras.LayoutOrder = 4

    local ExtrasGrid = Create("Frame", {
        LayoutOrder = 5,

        Size = UDim2.new(
            1,
            -10,
            0,
            95
        ),

        BackgroundTransparency = 1
    }, Scroll)

    Create("UIGridLayout", {
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
    }, ExtrasGrid)

    --==================================================
    -- INFINITE JUMP
    --==================================================

    local InfinitePanel =
        ControlBox(
            ExtrasGrid,
            "Infinite Jump",
            95
        )

    InfinitePanel.LayoutOrder = 1

    Checkbox(
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
        ControlBox(
            ExtrasGrid,
            "Click Teleport",
            95
        )

    TeleportPanel.LayoutOrder = 2

    Checkbox(
        TeleportPanel,
        function(enabled)

            if enabled then
                print(
                    "[Areteon] Click Teleport enabled"
                )
            else
                print(
                    "[Areteon] Click Teleport disabled"
                )
            end

        end
    )

    --==================================================
    -- PLAYER SECTION
    --==================================================

    local PlayerSection =
        Section(
            Scroll,
            "Player"
        )

    PlayerSection.LayoutOrder = 6

    --==================================================
    -- RESET / RESPAWN
    --==================================================

    local PlayerGrid = Create("Frame", {
        LayoutOrder = 7,

        Size = UDim2.new(
            1,
            -10,
            0,
            50
        ),

        BackgroundTransparency = 1
    }, Scroll)

    Create("UIGridLayout", {
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
    }, PlayerGrid)

    local ResetButton =
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

    Corner(
        ResetButton,
        7
    )

    ResetButton.MouseButton1Click:Connect(
        function()

            local humanoid =
                GetHumanoid()

            if humanoid then
                humanoid.Health = 0
            end

        end
    )

    local RespawnButton =
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

    Corner(
        RespawnButton,
        7
    )

    RespawnButton.MouseButton1Click:Connect(
        function()

            LocalPlayer:LoadCharacter()

        end
    )

    --==================================================
    -- RETURN
    --==================================================

    return PageFrame
end

return Page
