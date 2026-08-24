--==================================================
-- ARETEON | Settings.lua
--==================================================

local Page = {}

--==================================================
-- HELPERS
--==================================================

local function Create(
    className,
    properties,
    parent
)

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

local function Corner(
    object,
    radius
)

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(
            0,
            radius or 8
        )

    corner.Parent = object
end

--==================================================
-- START
--==================================================

function Page.Start(state)

    local PageFrame =
        Create("Frame", {

            Name = "Settings",

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

        Text = "Settings",

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
    -- ADMIN PANEL
    --==================================================

    local Admin =
        Create("Frame", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    70
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    90
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    23,
                    23,
                    29
                ),

            BorderSizePixel = 0

        }, PageFrame)

    Corner(Admin, 9)

    Create("TextLabel", {

        BackgroundTransparency = 1,

        Position =
            UDim2.new(
                0,
                15,
                0,
                10
            ),

        Size =
            UDim2.new(
                1,
                -30,
                0,
                25
            ),

        Font =
            Enum.Font.GothamBold,

        Text = "Admin Panel",

        TextColor3 =
            Color3.fromRGB(
                240,
                240,
                245
            ),

        TextSize = 14,

        TextXAlignment =
            Enum.TextXAlignment.Left

    }, Admin)

    local Logs =
        Create("TextButton", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    45
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    32
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    30,
                    30,
                    38
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.Gotham,

            Text = "Logs",

            TextColor3 =
                Color3.fromRGB(
                    210,
                    210,
                    218
                ),

            TextSize = 13

        }, Admin)

    Corner(Logs, 6)

    Logs.MouseButton1Click:Connect(
        function()

            print(
                "[Areteon] Logs requested."
            )

        end
    )

    --==================================================
    -- GENERAL
    --==================================================

    local General =
        Create("Frame", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    175
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    125
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    23,
                    23,
                    29
                ),

            BorderSizePixel = 0

        }, PageFrame)

    Corner(General, 9)

    Create("TextLabel", {

        BackgroundTransparency = 1,

        Position =
            UDim2.new(
                0,
                15,
                0,
                10
            ),

        Size =
            UDim2.new(
                1,
                -30,
                0,
                25
            ),

        Font =
            Enum.Font.GothamBold,

        Text = "General Settings",

        TextColor3 =
            Color3.fromRGB(
                240,
                240,
                245
            ),

        TextSize = 14,

        TextXAlignment =
            Enum.TextXAlignment.Left

    }, General)

    local State = false

    local Toggle =
        Create("TextButton", {

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    50
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    35
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    30,
                    30,
                    38
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.Gotham,

            Text =
                "Notifications [OFF]",

            TextColor3 =
                Color3.fromRGB(
                    210,
                    210,
                    218
                ),

            TextSize = 13,

            TextXAlignment =
                Enum.TextXAlignment.Left

        }, General)

    Corner(Toggle, 7)

    Create("UIPadding", {
        PaddingLeft =
            UDim.new(0, 12)
    }, Toggle)

    Toggle.MouseButton1Click:Connect(
        function()

            State = not State

            if State then

                Toggle.Text =
                    "Notifications [ON]"

            else

                Toggle.Text =
                    "Notifications [OFF]"

            end

        end
    )

    return PageFrame
end

return Page
