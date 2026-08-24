--==================================================
-- ARETEON | Player.lua
--==================================================

local Page = {}

local Players =
    game:GetService("Players")

local UserInputService =
    game:GetService("UserInputService")

local RunService =
    game:GetService("RunService")

local LocalPlayer =
    Players.LocalPlayer

local Connections = {}

--==================================================
-- HELPERS
--==================================================

local function Create(className, properties, parent)

    local object =
        Instance.new(className)

    for property, value in
        pairs(properties or {})
    do

        pcall(function()
            object[property] = value
        end)

    end

    object.Parent = parent

    return object
end

local function Corner(object, radius)

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, radius or 8)

    corner.Parent = object

end

local function Section(parent, title, y)

    local frame =
        Create("Frame", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    y
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    45
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    23,
                    23,
                    29
                ),

            BorderSizePixel = 0

        }, parent)

    Corner(frame, 8)

    Create("TextLabel", {

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

    }, frame)

    return frame
end

local function Toggle(
    parent,
    title,
    y,
    callback
)

    local button =
        Create("TextButton", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    y
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    38
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    27,
                    27,
                    34
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.Gotham,

            Text = title,

            TextColor3 =
                Color3.fromRGB(
                    210,
                    210,
                    218
                ),

            TextSize = 13,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            AutoButtonColor = true

        }, parent)

    Corner(button, 7)

    Create("UIPadding", {
        PaddingLeft =
            UDim.new(0, 12)
    }, button)

    local enabled = false

    button.MouseButton1Click:Connect(
        function()

            enabled = not enabled

            if enabled then

                button.Text =
                    title .. "  [ON]"

            else

                button.Text =
                    title .. "  [OFF]"

            end

            if callback then
                callback(enabled)
            end

        end
    )

    return button
end

--==================================================
-- START
--==================================================

function Page.Start(state)

    local PageFrame =
        Create("Frame", {

            Name = "Player",

            Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                ),

            Position =
                UDim2.new(
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
    -- TITLE
    --==================================================

    Create("TextLabel", {

        BackgroundTransparency = 1,

        Position =
            UDim2.new(
                0,
                15,
                0,
                15
            ),

        Size =
            UDim2.new(
                1,
                -30,
                0,
                35
            ),

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

    }, PageFrame)

    --==================================================
    -- MOVEMENT
    --==================================================

    Section(
        PageFrame,
        "Movement",
        65
    )

    --==================================================
    -- WALK SPEED
    --==================================================

    local SpeedBox =
        Create("TextBox", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    120
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    38
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    27,
                    27,
                    34
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.Gotham,

            PlaceholderText =
                "WalkSpeed",

            Text = "16",

            TextColor3 =
                Color3.fromRGB(
                    220,
                    220,
                    225
                ),

            TextSize = 13,

            ClearTextOnFocus = false

        }, PageFrame)

    Corner(SpeedBox, 7)

    SpeedBox.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    SpeedBox.Text
                )

            if not value then
                return
            end

            local character =
                LocalPlayer.Character

            if not character then
                return
            end

            local humanoid =
                character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid then
                humanoid.WalkSpeed =
                    value
            end

        end
    )

    --==================================================
    -- JUMP POWER
    --==================================================

    local JumpBox =
        Create("TextBox", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    165
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    38
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    27,
                    27,
                    34
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.Gotham,

            PlaceholderText =
                "JumpPower",

            Text = "50",

            TextColor3 =
                Color3.fromRGB(
                    220,
                    220,
                    225
                ),

            TextSize = 13,

            ClearTextOnFocus = false

        }, PageFrame)

    Corner(JumpBox, 7)

    JumpBox.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    JumpBox.Text
                )

            if not value then
                return
            end

            local character =
                LocalPlayer.Character

            if not character then
                return
            end

            local humanoid =
                character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid then
                humanoid.JumpPower =
                    value
            end

        end
    )

    --==================================================
    -- FLY
    --==================================================

    Toggle(
        PageFrame,
        "Fly",
        210,
        function(enabled)

            -- Toggle state is provided here.
            -- Add your own flight implementation
            -- if required by your game.

            print(
                "[Areteon] Fly:",
                enabled
            )

        end
    )

    --==================================================
    -- NOCLIP
    --==================================================

    Toggle(
        PageFrame,
        "Noclip",
        255,
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

    Section(
        PageFrame,
        "Extras",
        310
    )

    Toggle(
        PageFrame,
        "Infinite Jump",
        365,
        function(enabled)

            if enabled then

                local connection =
                    UserInputService.JumpRequest:Connect(
                        function()

                            local character =
                                LocalPlayer.Character

                            if not character then
                                return
                            end

                            local humanoid =
                                character:FindFirstChildOfClass(
                                    "Humanoid"
                                )

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
    -- PLAYER
    --==================================================

    Section(
        PageFrame,
        "Player",
        420
    )

    local Teleport =
        Create("TextButton", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    475
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    38
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    27,
                    27,
                    34
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.Gotham,

            Text =
                "Click Teleport",

            TextColor3 =
                Color3.fromRGB(
                    220,
                    220,
                    225
                ),

            TextSize = 13

        }, PageFrame)

    Corner(Teleport, 7)

    --==================================================
    -- RETURN
    --==================================================

    return PageFrame
end

return Page
