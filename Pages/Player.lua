--==================================================
-- ARETEON | Pages/Player.lua
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
-- CREATE
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

--==================================================
-- CORNER
--==================================================

local function Corner(object, radius)

    local corner = Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, radius or 8)

    corner.Parent = object

end

--==================================================
-- HUMANOID
--==================================================

local function GetHumanoid()

    local character =
        LocalPlayer.Character

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass(
        "Humanoid"
    )

end

--==================================================
-- SECTION
--==================================================

local function Section(parent, title)

    local section =
        Create(
            "Frame",
            {
                Size =
                    UDim2.new(
                        1,
                        0,
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
            },
            parent
        )

    Corner(section, 8)

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    12,
                    0,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -24,
                    1,
                    0
                ),

            Font =
                Enum.Font.GothamBold,

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
        },
        section
    )

    return section
end

--==================================================
-- PANEL
--==================================================

local function Panel(parent, title)

    local panel =
        Create(
            "Frame",
            {
                BackgroundColor3 =
                    Color3.fromRGB(
                        27,
                        27,
                        34
                    ),

                BorderSizePixel = 0
            },
            parent
        )

    Corner(panel, 7)

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    7
                ),

            Size =
                UDim2.new(
                    1,
                    -45,
                    0,
                    20
                ),

            Font =
                Enum.Font.GothamBold,

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
        },
        panel
    )

    return panel
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

    local box =
        Create(
            "TextBox",
            {
                Position = position,

                Size = size,

                BackgroundColor3 =
                    Color3.fromRGB(
                        38,
                        38,
                        47
                    ),

                BorderSizePixel = 0,

                Font =
                    Enum.Font.Gotham,

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
            },
            parent
        )

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

    local button =
        Create(
            "TextButton",
            {
                AnchorPoint =
                    Vector2.new(
                        1,
                        0
                    ),

                Position =
                    UDim2.new(
                        1,
                        -10,
                        0,
                        7
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
                        42,
                        42,
                        50
                    ),

                BorderSizePixel = 0,

                Text = "",

                Font =
                    Enum.Font.GothamBold,

                TextSize = 14,

                AutoButtonColor = false
            },
            parent
        )

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

            button.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

        else

            button.BackgroundColor3 =
                Color3.fromRGB(
                    42,
                    42,
                    50
                )

            button.Text = ""

        end

    end

    button.MouseButton1Click:Connect(
        function()

            enabled =
                not enabled

            Update()

            if callback then
                callback(enabled)
            end

        end
    )

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
    default,
    callback
)

    local bar =
        Create(
            "Frame",
            {
                Position =
                    UDim2.new(
                        0,
                        10,
                        0,
                        67
                    ),

                Size =
                    UDim2.new(
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
            },
            parent
        )

    Corner(bar, 5)

    local percent =
        (default - minimum) /
        (maximum - minimum)

    local fill =
        Create(
            "Frame",
            {
                Size =
                    UDim2.new(
                        percent,
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
            },
            bar
        )

    Corner(fill, 5)

    local knob =
        Create(
            "TextButton",
            {
                AnchorPoint =
                    Vector2.new(
                        0.5,
                        0.5
                    ),

                Position =
                    UDim2.new(
                        percent,
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
            },
            bar
        )

    Corner(knob, 10)

    local dragging = false

    local function SetValue(x)

        local startX =
            bar.AbsolutePosition.X

        local width =
            bar.AbsoluteSize.X

        if width <= 0 then
            return
        end

        local percentage =
            math.clamp(
                (x - startX) / width,
                0,
                1
            )

        local value =
            minimum +
            (
                maximum -
                minimum
            ) * percentage

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

    bar.InputBegan:Connect(
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

end

--==================================================
-- START
--==================================================

function Page.Start(state)

    --==================================================
    -- REMOVE OLD PAGE
    --==================================================

    local old =
        state.Content:FindFirstChild(
            "Player"
        )

    if old then
        old:Destroy()
    end

    --==================================================
    -- PAGE
    --==================================================

    local PageFrame =
        Create(
            "Frame",
            {
                Name = "Player",

                Visible = true,

                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Size =
                    UDim2.new(
                        1,
                        -10,
                        0,
                        0
                    ),

                AutomaticSize =
                    Enum.AutomaticSize.Y
            },
            state.Content
        )

    --==================================================
    -- LAYOUT
    --==================================================

    local Layout =
        Create(
            "UIListLayout",
            {
                Padding =
                    UDim.new(
                        0,
                        10
                    ),

                SortOrder =
                    Enum.SortOrder.LayoutOrder
            },
            PageFrame
        )

    --==================================================
    -- PADDING
    --==================================================

    Create(
        "UIPadding",
        {
            PaddingTop =
                UDim.new(
                    0,
                    15
                ),

            PaddingLeft =
                UDim.new(
                    0,
                    15
                ),

            PaddingRight =
                UDim.new(
                    0,
                    15
                ),

            PaddingBottom =
                UDim.new(
                    0,
                    20
                )
        },
        PageFrame
    )

    --==================================================
    -- TITLE
    --==================================================

    local title =
        Create(
            "TextLabel",
            {
                LayoutOrder = 1,

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        35
                    ),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.GothamBold,

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
            },
            PageFrame
        )

    --==================================================
    -- MOVEMENT
    --==================================================

    local movement =
        Section(
            PageFrame,
            "Movement"
        )

    movement.LayoutOrder = 2

    --==================================================
    -- MOVEMENT GRID
    --==================================================

    local movementGrid =
        Create(
            "Frame",
            {
                LayoutOrder = 3,

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        200
                    ),

                BackgroundTransparency = 1
            },
            PageFrame
        )

    Create(
        "UIGridLayout",
        {
            CellSize =
                UDim2.new(
                    0.5,
                    -5,
                    0,
                    95
                ),

            CellPadding =
                UDim2.new(
                    0,
                    10,
                    0,
                    10
                ),

            SortOrder =
                Enum.SortOrder.LayoutOrder
        },
        movementGrid
    )

    --==================================================
    -- WALKSPEED
    --==================================================

    local speedPanel =
        Panel(
            movementGrid,
            "WalkSpeed"
        )

    speedPanel.LayoutOrder = 1

    local speedBox =
        Input(
            speedPanel,
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
                25
            )
        )

    speedBox.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    speedBox.Text
                )

            if not value then

                speedBox.Text =
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

            speedBox.Text =
                tostring(value)

            local humanoid =
                GetHumanoid()

            if humanoid then
                humanoid.WalkSpeed =
                    value
            end

        end
    )

    Slider(
        speedPanel,
        MIN_WALK_SPEED,
        MAX_WALK_SPEED,
        DEFAULT_WALK_SPEED,
        function(value)

            speedBox.Text =
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

    local jumpPanel =
        Panel(
            movementGrid,
            "JumpPower"
        )

    jumpPanel.LayoutOrder = 2

    local jumpBox =
        Input(
            jumpPanel,
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

    jumpBox.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    jumpBox.Text
                )

            if not value then

                jumpBox.Text =
                    tostring(
                        DEFAULT_JUMP_POWER
                    )

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

    local flyPanel =
        Panel(
            movementGrid,
            "Fly"
        )

    flyPanel.LayoutOrder = 3

    Checkbox(
        flyPanel,
        function(enabled)

            print(
                "[Areteon] Fly:",
                enabled
            )

        end
    )

    local flySpeed =
        Input(
            flyPanel,
            tostring(
                DEFAULT_FLY_SPEED
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
                30
            )
        )

    flySpeed.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    flySpeed.Text
                )

            if not value then

                flySpeed.Text =
                    tostring(
                        DEFAULT_FLY_SPEED
                    )

                return
            end

            flySpeed.Text =
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

    local noclipPanel =
        Panel(
            movementGrid,
            "Noclip"
        )

    noclipPanel.LayoutOrder = 4

    Checkbox(
        noclipPanel,
        function(enabled)

            if not enabled then
                return
            end

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
    )

    --==================================================
    -- EXTRAS
    --==================================================

    local extras =
        Section(
            PageFrame,
            "Extras"
        )

    extras.LayoutOrder = 4

    local extrasGrid =
        Create(
            "Frame",
            {
                LayoutOrder = 5,

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        95
                    ),

                BackgroundTransparency = 1
            },
            PageFrame
        )

    Create(
        "UIGridLayout",
        {
            CellSize =
                UDim2.new(
                    0.5,
                    -5,
                    0,
                    95
                ),

            CellPadding =
                UDim2.new(
                    0,
                    10,
                    0,
                    0
                )
        },
        extrasGrid
    )

    --==================================================
    -- INFINITE JUMP
    --==================================================

    local infinitePanel =
        Panel(
            extrasGrid,
            "Infinite Jump"
        )

    infinitePanel.LayoutOrder = 1

    Checkbox(
        infinitePanel,
        function(enabled)

            if not enabled then
                return
            end

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
    )

    --==================================================
    -- CLICK TELEPORT
    --==================================================

    local teleportPanel =
        Panel(
            extrasGrid,
            "Click Teleport"
        )

    teleportPanel.LayoutOrder = 2

    Checkbox(
        teleportPanel,
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

    local playerSection =
        Section(
            PageFrame,
            "Player"
        )

    playerSection.LayoutOrder = 6

    local playerGrid =
        Create(
            "Frame",
            {
                LayoutOrder = 7,

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        45
                    ),

                BackgroundTransparency = 1
            },
            PageFrame
        )

    Create(
        "UIGridLayout",
        {
            CellSize =
                UDim2.new(
                    0.5,
                    -5,
                    0,
                    45
                ),

            CellPadding =
                UDim2.new(
                    0,
                    10,
                    0,
                    0
                )
        },
        playerGrid
    )

    --==================================================
    -- RESET
    --==================================================

    local reset =
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

                Font =
                    Enum.Font.Gotham,

                Text = "Reset Character",

                TextColor3 =
                    Color3.fromRGB(
                        220,
                        220,
                        225
                    ),

                TextSize = 12
            },
            playerGrid
        )

    Corner(reset, 7)

    reset.MouseButton1Click:Connect(
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

    local respawn =
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

                Font =
                    Enum.Font.Gotham,

                Text = "Respawn",

                TextColor3 =
                    Color3.fromRGB(
                        220,
                        220,
                        225
                    ),

                TextSize = 12
            },
            playerGrid
        )

    Corner(respawn, 7)

    respawn.MouseButton1Click:Connect(
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
