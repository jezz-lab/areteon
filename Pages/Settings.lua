--==================================================
-- ARETEON | Pages/Settings.lua
--==================================================

local Settings = {}

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- DEFAULT CONFIG
--==================================================

Settings.DefaultTheme = {
    Background = Color3.fromRGB(15, 15, 19),
    Primary = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(170, 170, 180),
    Buttons = Color3.fromRGB(35, 35, 43),
    Panel = Color3.fromRGB(22, 22, 28)
}

Settings.DefaultSettings = {
    BackgroundTransparency = 0
}

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

    corner.CornerRadius =
        UDim.new(0, radius or 8)

    corner.Parent = object

end

--==================================================
-- COLOR BUTTON
--==================================================

local function CreateColorRow(
    parent,
    name,
    currentColor,
    onChanged
)

    local Row =
        Create(
            "Frame",
            {
                Size =
                    UDim2.new(1, 0, 0, 42),

                BackgroundTransparency = 1
            },
            parent
        )

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(0, 10, 0, 0),

            Size =
                UDim2.new(1, -65, 1, 0),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamMedium,

            Text = name,

            TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            TextSize = 13,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        Row
    )

    local ColorButton =
        Create(
            "TextButton",
            {
                Position =
                    UDim2.new(1, -50, 0, 6),

                Size =
                    UDim2.new(0, 40, 0, 30),

                BackgroundColor3 =
                    currentColor,

                BorderSizePixel = 0,

                Text = ""
            },
            Row
        )

    Corner(ColorButton, 6)

    ColorButton.MouseButton1Click:Connect(
        function()

            -- Simple RGB picker window.
            -- The actual picker can be replaced
            -- with your preferred picker later.

            local oldPicker =
                parent.Parent.Parent.Parent:
                    FindFirstChild(
                        "ColorPicker"
                    )

            if oldPicker then
                oldPicker:Destroy()
            end

            local Picker =
                Create(
                    "Frame",
                    {
                        Name = "ColorPicker",

                        AnchorPoint =
                            Vector2.new(
                                0.5,
                                0.5
                            ),

                        Position =
                            UDim2.new(
                                0.5,
                                0,
                                0.5,
                                0
                            ),

                        Size =
                            UDim2.new(
                                0,
                                300,
                                0,
                                250
                            ),

                        BackgroundColor3 =
                            Color3.fromRGB(
                                25,
                                25,
                                32
                            ),

                        BorderSizePixel = 0,

                        ZIndex = 50
                    },
                    parent.Parent.Parent.Parent
                )

            Corner(Picker, 10)

            Create(
                "TextLabel",
                {
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
                            30
                        ),

                    BackgroundTransparency = 1,

                    Font =
                        Enum.Font.GothamBold,

                    Text =
                        "Change " .. name,

                    TextColor3 =
                        Color3.fromRGB(
                            255,
                            255,
                            255
                        ),

                    TextSize = 16,

                    ZIndex = 51
                },
                Picker
            )

            local r =
                math.floor(
                    currentColor.R * 255
                )

            local g =
                math.floor(
                    currentColor.G * 255
                )

            local b =
                math.floor(
                    currentColor.B * 255
                )

            local function CreateInput(
                label,
                value,
                y
            )

                Create(
                    "TextLabel",
                    {
                        Position =
                            UDim2.new(
                                0,
                                20,
                                0,
                                y
                            ),

                        Size =
                            UDim2.new(
                                0,
                                30,
                                0,
                                30
                            ),

                        BackgroundTransparency = 1,

                        Font =
                            Enum.Font.GothamBold,

                        Text = label,

                        TextColor3 =
                            Color3.fromRGB(
                                255,
                                255,
                                255
                            ),

                        TextSize = 13,

                        ZIndex = 51
                    },
                    Picker
                )

                local Input =
                    Create(
                        "TextBox",
                        {
                            Position =
                                UDim2.new(
                                    0,
                                    55,
                                    0,
                                    y
                                ),

                            Size =
                                UDim2.new(
                                    0,
                                    200,
                                    0,
                                    30
                                ),

                            BackgroundColor3 =
                                Color3.fromRGB(
                                    35,
                                    35,
                                    43
                                ),

                            BorderSizePixel = 0,

                            Font =
                                Enum.Font.Gotham,

                            Text =
                                tostring(value),

                            TextColor3 =
                                Color3.fromRGB(
                                    255,
                                    255,
                                    255
                                ),

                            TextSize = 12,

                            ClearTextOnFocus = false,

                            ZIndex = 51
                        },
                        Picker
                    )

                Corner(Input, 6)

                return Input
            end

            local R =
                CreateInput(
                    "R",
                    r,
                    50
                )

            local G =
                CreateInput(
                    "G",
                    g,
                    90
                )

            local B =
                CreateInput(
                    "B",
                    b,
                    130
                )

            local Apply =
                Create(
                    "TextButton",
                    {
                        Position =
                            UDim2.new(
                                0,
                                20,
                                0,
                                180
                            ),

                        Size =
                            UDim2.new(
                                0,
                                120,
                                0,
                                35
                            ),

                        BackgroundColor3 =
                            Color3.fromRGB(
                                45,
                                45,
                                58
                            ),

                        BorderSizePixel = 0,

                        Font =
                            Enum.Font.GothamBold,

                        Text = "Apply",

                        TextColor3 =
                            Color3.fromRGB(
                                255,
                                255,
                                255
                            ),

                        TextSize = 12,

                        ZIndex = 51
                    },
                    Picker
                )

            Corner(Apply, 7)

            Apply.MouseButton1Click:Connect(
                function()

                    local newR =
                        math.clamp(
                            tonumber(R.Text)
                                or r,
                            0,
                            255
                        )

                    local newG =
                        math.clamp(
                            tonumber(G.Text)
                                or g,
                            0,
                            255
                        )

                    local newB =
                        math.clamp(
                            tonumber(B.Text)
                                or b,
                            0,
                            255
                        )

                    local newColor =
                        Color3.fromRGB(
                            newR,
                            newG,
                            newB
                        )

                    ColorButton.BackgroundColor3 =
                        newColor

                    onChanged(newColor)

                    Picker:Destroy()

                end
            )

        end
    )

    return Row
end

--==================================================
-- APPLY THEME
--==================================================

local function ApplyTheme(state)

    local theme =
        state.Theme

    if not theme then
        return
    end

    local Main =
        state.Main

    if Main then

        Main.BackgroundColor3 =
            theme.Background

        Main.BackgroundTransparency =
            state.Settings.BackgroundTransparency

    end

    if state.Sidebar then

        state.Sidebar.BackgroundColor3 =
            theme.Background

    end

    if state.TopBar then

        state.TopBar.BackgroundColor3 =
            theme.Panel

    end

    -- Floating icon deliberately NOT changed.
end

--==================================================
-- START
--==================================================

function Settings.Start(state)

    if not state or not state.Content then

        warn(
            "[Areteon] Settings: Content missing."
        )

        return nil

    end

    --==================================================
    -- INITIAL STATE
    --==================================================

    state.Theme =
        state.Theme
        or
        table.clone(
            Settings.DefaultTheme
        )

    state.Settings =
        state.Settings
        or
        table.clone(
            Settings.DefaultSettings
        )

    --==================================================
    -- PAGE
    --==================================================

    local Page =
        Create(
            "Frame",
            {
                Name = "SettingsPage",

                Size =
                    UDim2.new(
                        1,
                        -20,
                        0,
                        800
                    ),

                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Visible = false
            },
            state.Content
        )

    --==================================================
    -- TITLE
    --==================================================

    Create(
        "TextLabel",
        {
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

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamBold,

            Text = "Settings",

            TextColor3 =
                state.Theme.Primary,

            TextSize = 22,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        Page
    )

    --==================================================
    -- COLORS SECTION
    --==================================================

    local Colors =
        Create(
            "Frame",
            {
                Position =
                    UDim2.new(
                        0,
                        15,
                        0,
                        65
                    ),

                Size =
                    UDim2.new(
                        1,
                        -30,
                        0,
                        300
                    ),

                BackgroundColor3 =
                    state.Theme.Panel,

                BorderSizePixel = 0
            },
            Page
        )

    Corner(Colors, 10)

    Create(
        "TextLabel",
        {
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
                    30
                ),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamBold,

            Text = "Colors",

            TextColor3 =
                state.Theme.Primary,

            TextSize = 15,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        Colors
    )

    local ColorList =
        Create(
            "Frame",
            {
                Position =
                    UDim2.new(
                        0,
                        10,
                        0,
                        48
                    ),

                Size =
                    UDim2.new(
                        1,
                        -20,
                        0,
                        240
                    ),

                BackgroundTransparency = 1
            },
            Colors
        )

    Create(
        "UIListLayout",
        {
            Padding =
                UDim.new(
                    0,
                    2
                ),

            SortOrder =
                Enum.SortOrder.LayoutOrder
        },
        ColorList
    )

    local function ChangeColor(name, color)

        state.Theme[name] = color

        ApplyTheme(state)

    end

    CreateColorRow(
        ColorList,
        "Background",
        state.Theme.Background,
        function(color)
            ChangeColor(
                "Background",
                color
            )
        end
    )

    CreateColorRow(
        ColorList,
        "Primary",
        state.Theme.Primary,
        function(color)
            ChangeColor(
                "Primary",
                color
            )
        end
    )

    CreateColorRow(
        ColorList,
        "Secondary",
        state.Theme.Secondary,
        function(color)
            ChangeColor(
                "Secondary",
                color
            )
        end
    )

    CreateColorRow(
        ColorList,
        "Buttons",
        state.Theme.Buttons,
        function(color)
            ChangeColor(
                "Buttons",
                color
            )
        end
    )

    CreateColorRow(
        ColorList,
        "Panel",
        state.Theme.Panel,
        function(color)
            ChangeColor(
                "Panel",
                color
            )
        end
    )

    --==================================================
    -- GENERAL
    --==================================================

    local General =
        Create(
            "Frame",
            {
                Position =
                    UDim2.new(
                        0,
                        15,
                        0,
                        380
                    ),

                Size =
                    UDim2.new(
                        1,
                        -30,
                        0,
                        150
                    ),

                BackgroundColor3 =
                    state.Theme.Panel,

                BorderSizePixel = 0
            },
            Page
        )

    Corner(General, 10)

    local GeneralButton =
        Create(
            "TextButton",
            {
                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        42
                    ),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.GothamBold,

                Text = "▼  General",

                TextColor3 =
                    state.Theme.Primary,

                TextSize = 14,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            General
        )

    Create(
        "UIPadding",
        {
            PaddingLeft =
                UDim.new(
                    0,
                    15
                )
        },
        GeneralButton
    )

    local GeneralContent =
        Create(
            "Frame",
            {
                Position =
                    UDim2.new(
                        0,
                        10,
                        0,
                        45
                    ),

                Size =
                    UDim2.new(
                        1,
                        -20,
                        0,
                        95
                    ),

                BackgroundTransparency = 1
            },
            General
        )

    local TransparencyLabel =
        Create(
            "TextLabel",
            {
                Position =
                    UDim2.new(
                        0,
                        5,
                        0,
                        5
                    ),

                Size =
                    UDim2.new(
                        0.5,
                        0,
                        0,
                        30
                    ),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.GothamMedium,

                Text =
                    "Background Transparency",

                TextColor3 =
                    state.Theme.Primary,

                TextSize = 12,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            GeneralContent
        )

    local TransparencyBox =
        Create(
            "TextBox",
            {
                Position =
                    UDim2.new(
                        0.55,
                        0,
                        0,
                        3
                    ),

                Size =
                    UDim2.new(
                        0.4,
                        0,
                        0,
                        32
                    ),

                BackgroundColor3 =
                    state.Theme.Background,

                BorderSizePixel = 0,

                Font =
                    Enum.Font.Gotham,

                Text =
                    tostring(
                        state.Settings
                            .BackgroundTransparency
                            * 100
                    ),

                TextColor3 =
                    state.Theme.Primary,

                TextSize = 12,

                ClearTextOnFocus = false
            },
            GeneralContent
        )

    Corner(TransparencyBox, 6)

    TransparencyBox.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    TransparencyBox.Text
                )

            if value then

                value =
                    math.clamp(
                        value,
                        0,
                        100
                    )

                state.Settings
                    .BackgroundTransparency =
                    value / 100

                TransparencyBox.Text =
                    tostring(value)

                ApplyTheme(state)

            end

        end
    )

    GeneralButton.MouseButton1Click:Connect(
        function()

            local open =
                GeneralContent.Visible

            GeneralContent.Visible =
                not open

            if open then
                GeneralButton.Text =
                    "▶  General"
            else
                GeneralButton.Text =
                    "▼  General"
            end

        end
    )

    --==================================================
    -- ADMIN PANEL
    --==================================================

    local AdminPanel

    if state.IsAdmin then

        AdminPanel =
            Create(
                "Frame",
                {
                    Position =
                        UDim2.new(
                            0,
                            15,
                            0,
                            545
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -30,
                            0,
                            300
                        ),

                    BackgroundColor3 =
                        state.Theme.Panel,

                    BorderSizePixel = 0
                },
                Page
            )

        Corner(AdminPanel, 10)

        local AdminButton =
            Create(
                "TextButton",
                {
                    Size =
                        UDim2.new(
                            1,
                            0,
                            0,
                            42
                        ),

                    BackgroundTransparency = 1,

                    Font =
                        Enum.Font.GothamBold,

                    Text = "▶  Admin Panel",

                    TextColor3 =
                        state.Theme.Primary,

                    TextSize = 14,

                    TextXAlignment =
                        Enum.TextXAlignment.Left
                },
                AdminPanel
            )

        Create(
            "UIPadding",
            {
                PaddingLeft =
                    UDim.new(
                        0,
                        15
                    )
            },
            AdminButton
        )

        local AdminContent =
            Create(
                "Frame",
                {
                    Position =
                        UDim2.new(
                            0,
                            10,
                            0,
                            45
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -20,
                            0,
                            240
                        ),

                    BackgroundTransparency = 1,

                    Visible = false
                },
                AdminPanel
            )

        Create(
            "TextLabel",
            {
                Position =
                    UDim2.new(
                        0,
                        5,
                        0,
                        5
                    ),

                Size =
                    UDim2.new(
                        1,
                        -10,
                        0,
                        30
                    ),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.GothamMedium,

                Text =
                    "Online Players: " ..
                    tostring(
                        #Players:GetPlayers()
                    ),

                TextColor3 =
                    state.Theme.Primary,

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            AdminContent
        )

        Create(
            "TextLabel",
            {
                Position =
                    UDim2.new(
                        0,
                        5,
                        0,
                        40
                    ),

                Size =
                    UDim2.new(
                        1,
                        -10,
                        0,
                        30
                    ),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.Gotham,

                Text =
                    "Player Name / Status / Key Status / Time Remaining",

                TextColor3 =
                    state.Theme.Secondary,

                TextSize = 12,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            AdminContent
        )

        AdminButton.MouseButton1Click:Connect(
            function()

                local open =
                    AdminContent.Visible

                AdminContent.Visible =
                    not open

                if open then
                    AdminButton.Text =
                        "▶  Admin Panel"
                else
                    AdminButton.Text =
                        "▼  Admin Panel"
                end

            end
        )

    end

    --==================================================
    -- APPLY INITIAL THEME
    --==================================================

    ApplyTheme(state)

    return Page
end

return Settings
