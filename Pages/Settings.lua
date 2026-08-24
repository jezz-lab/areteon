--==================================================
-- ARETEON | Pages/Settings.lua
--==================================================

local Settings = {}

local Players = game:GetService("Players")

--==================================================
-- DEFAULT THEME
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

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
end

--==================================================
-- THEME
--==================================================

local function ApplyTheme(state)

    local theme = state.Theme

    if state.Main then
        state.Main.BackgroundColor3 =
            theme.Background

        state.Main.BackgroundTransparency =
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

    -- Floating icon intentionally does NOT use
    -- the theme colors.

end

--==================================================
-- COLOR PICKER
--==================================================

local function OpenColorPicker(
    state,
    colorName,
    currentColor,
    onApply
)

    if state.ColorPicker then
        state.ColorPicker:Destroy()
        state.ColorPicker = nil
    end

    if not state.Gui then
        warn(
            "[Areteon] Settings: state.Gui missing."
        )
        return
    end

    local Picker =
        Create(
            "Frame",
            {
                Name = "ColorPicker",

                AnchorPoint =
                    Vector2.new(0.5, 0.5),

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
                        260
                    ),

                BackgroundColor3 =
                    Color3.fromRGB(
                        25,
                        25,
                        32
                    ),

                BorderSizePixel = 0,

                ZIndex = 100
            },
            state.Gui
        )

    state.ColorPicker = Picker

    Corner(Picker, 10)

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
                "Choose " .. colorName,

            TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            TextSize = 15,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            ZIndex = 101
        },
        Picker
    )

    --==================================================
    -- PREVIEW
    --==================================================

    local Preview =
        Create(
            "Frame",
            {
                Position =
                    UDim2.new(
                        0,
                        15,
                        0,
                        48
                    ),

                Size =
                    UDim2.new(
                        1,
                        -30,
                        0,
                        40
                    ),

                BackgroundColor3 =
                    currentColor,

                BorderSizePixel = 0,

                ZIndex = 101
            },
            Picker
        )

    Corner(Preview, 6)

    --==================================================
    -- RGB VALUES
    --==================================================

    local R =
        math.floor(
            currentColor.R * 255
        )

    local G =
        math.floor(
            currentColor.G * 255
        )

    local B =
        math.floor(
            currentColor.B * 255
        )

    local function RGBInput(
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
                        25,
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

                TextSize = 12,

                ZIndex = 101
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
                            50,
                            0,
                            y
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -70,
                            0,
                            30
                        ),

                    BackgroundColor3 =
                        Color3.fromRGB(
                            40,
                            40,
                            48
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

                    ZIndex = 101
                },
                Picker
            )

        Corner(Input, 6)

        return Input
    end

    local RBox =
        RGBInput(
            "R",
            R,
            100
        )

    local GBox =
        RGBInput(
            "G",
            G,
            135
        )

    local BBox =
        RGBInput(
            "B",
            B,
            170
        )

    --==================================================
    -- UPDATE PREVIEW
    --==================================================

    local function UpdatePreview()

        local r =
            math.clamp(
                tonumber(RBox.Text) or R,
                0,
                255
            )

        local g =
            math.clamp(
                tonumber(GBox.Text) or G,
                0,
                255
            )

        local b =
            math.clamp(
                tonumber(BBox.Text) or B,
                0,
                255
            )

        Preview.BackgroundColor3 =
            Color3.fromRGB(
                r,
                g,
                b
            )

    end

    RBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(UpdatePreview)

    GBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(UpdatePreview)

    BBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(UpdatePreview)

    --==================================================
    -- APPLY
    --==================================================

    local Apply =
        Create(
            "TextButton",
            {
                Position =
                    UDim2.new(
                        0,
                        20,
                        1,
                        -45
                    ),

                Size =
                    UDim2.new(
                        0,
                        120,
                        0,
                        32
                    ),

                BackgroundColor3 =
                    Color3.fromRGB(
                        50,
                        50,
                        65
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

                ZIndex = 101
            },
            Picker
        )

    Corner(Apply, 6)

    Apply.MouseButton1Click:Connect(
        function()

            local r =
                math.clamp(
                    tonumber(RBox.Text) or R,
                    0,
                    255
                )

            local g =
                math.clamp(
                    tonumber(GBox.Text) or G,
                    0,
                    255
                )

            local b =
                math.clamp(
                    tonumber(BBox.Text) or B,
                    0,
                    255
                )

            local newColor =
                Color3.fromRGB(
                    r,
                    g,
                    b
                )

            onApply(newColor)

            Picker:Destroy()

            state.ColorPicker = nil

        end
    )

    --==================================================
    -- CANCEL
    --==================================================

    local Cancel =
        Create(
            "TextButton",
            {
                Position =
                    UDim2.new(
                        1,
                        -140,
                        1,
                        -45
                    ),

                Size =
                    UDim2.new(
                        0,
                        120,
                        0,
                        32
                    ),

                BackgroundColor3 =
                    Color3.fromRGB(
                        40,
                        40,
                        48
                    ),

                BorderSizePixel = 0,

                Font =
                    Enum.Font.GothamBold,

                Text = "Cancel",

                TextColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    ),

                TextSize = 12,

                ZIndex = 101
            },
            Picker
        )

    Corner(Cancel, 6)

    Cancel.MouseButton1Click:Connect(
        function()

            Picker:Destroy()

            state.ColorPicker = nil

        end
    )

end

--==================================================
-- COLOR ROW
--==================================================

local function CreateColorRow(
    state,
    parent,
    name
)

    local Row =
        Create(
            "Frame",
            {
                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        38
                    ),

                BackgroundTransparency = 1
            },
            parent
        )

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -70,
                    1,
                    0
                ),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamMedium,

            Text = name,

            TextColor3 =
                state.Theme.Primary,

            TextSize = 12,

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
                    UDim2.new(
                        1,
                        -55,
                        0,
                        5
                    ),

                Size =
                    UDim2.new(
                        0,
                        40,
                        0,
                        28
                    ),

                BackgroundColor3 =
                    state.Theme[name],

                BorderSizePixel = 0,

                Text = ""
            },
            Row
        )

    Corner(ColorButton, 6)

    ColorButton.MouseButton1Click:Connect(
        function()

            OpenColorPicker(
                state,
                name,
                state.Theme[name],
                function(newColor)

                    state.Theme[name] =
                        newColor

                    ColorButton.BackgroundColor3 =
                        newColor

                    ApplyTheme(state)

                end
            )

        end
    )

end

--==================================================
-- DROPDOWN
--==================================================

local function CreateDropdown(
    state,
    parent,
    title,
    expandedHeight
)

    local Box =
        Create(
            "Frame",
            {
                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        expandedHeight
                    ),

                BackgroundColor3 =
                    state.Theme.Panel,

                BorderSizePixel = 0,

                ClipsDescendants = true
            },
            parent
        )

    Corner(Box, 10)

    local Header =
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

                Text =
                    "^  " .. title,

                TextColor3 =
                    state.Theme.Primary,

                TextSize = 14,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            Box
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
        Header
    )

    local Content =
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
                        expandedHeight - 50
                    ),

                BackgroundTransparency = 1
            },
            Box
        )

    local Expanded = true

    Header.MouseButton1Click:Connect(
        function()

            Expanded = not Expanded

            if Expanded then

                Header.Text =
                    "^  " .. title

                Box.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        expandedHeight
                    )

                Content.Visible = true

            else

                Header.Text =
                    "v  " .. title

                Box.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        42
                    )

                Content.Visible = false

            end

        end
    )

    return Box, Content
end

--==================================================
-- START
--==================================================

function Settings.Start(state)

    if not state then
        warn("[Areteon] Settings: state missing.")
        return
    end

    if not state.Content then
        warn(
            "[Areteon] Settings: " ..
            "state.Content missing."
        )
        return
    end

    --==================================================
    -- STATE
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
                        900
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
    -- DROPDOWN LIST
    --==================================================

    local List =
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
                        800
                    ),

                BackgroundTransparency = 1
            },
            Page
        )

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
        List
    )

    --==================================================
    -- COLORS
    --==================================================

    local ColorsBox, ColorsContent =
        CreateDropdown(
            state,
            List,
            "Colors",
            250
        )

    CreateColorRow(
        state,
        ColorsContent,
        "Background"
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Primary"
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Secondary"
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Buttons"
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Panel"
    )

    --==================================================
    -- GENERAL
    --==================================================

    local GeneralBox, GeneralContent =
        CreateDropdown(
            state,
            List,
            "General",
            120
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
                    0.55,
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

    local Transparency =
        Create(
            "TextBox",
            {
                Position =
                    UDim2.new(
                        0.58,
                        0,
                        0,
                        3
                    ),

                Size =
                    UDim2.new(
                        0.38,
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

    Corner(Transparency, 6)

    Transparency.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    Transparency.Text
                )

            if value == nil then
                return
            end

            value =
                math.clamp(
                    value,
                    0,
                    100
                )

            state.Settings
                .BackgroundTransparency =
                value / 100

            Transparency.Text =
                tostring(value)

            ApplyTheme(state)

        end
    )

    --==================================================
    -- ADMIN PANEL
    --==================================================

    if state.IsAdmin then

        local AdminBox, AdminContent =
            CreateDropdown(
                state,
                List,
                "Admin Panel",
                250
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
                        25
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

        local PlayerList =
            Create(
                "ScrollingFrame",
                {
                    Position =
                        UDim2.new(
                            0,
                            5,
                            0,
                            38
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -10,
                            0,
                            190
                        ),

                    BackgroundTransparency = 1,

                    BorderSizePixel = 0,

                    ScrollBarThickness = 5,

                    AutomaticCanvasSize =
                        Enum.AutomaticSize.Y,

                    CanvasSize =
                        UDim2.new(
                            0,
                            0,
                            0,
                            0
                        )
                },
                AdminContent
            )

        Create(
            "UIListLayout",
            {
                Padding =
                    UDim.new(
                        0,
                        5
                    ),

                SortOrder =
                    Enum.SortOrder.LayoutOrder
            },
            PlayerList
        )

        local function RefreshPlayers()

            for _, child in
                ipairs(
                    PlayerList:GetChildren()
                )
            do

                if not child:IsA(
                    "UIListLayout"
                ) then
                    child:Destroy()
                end

            end

            for _, player in
                ipairs(
                    Players:GetPlayers()
                )
            do

                local Row =
                    Create(
                        "Frame",
                        {
                            Size =
                                UDim2.new(
                                    1,
                                    -5,
                                    0,
                                    50
                                ),

                            BackgroundColor3 =
                                state.Theme.Background,

                            BorderSizePixel = 0
                        },
                        PlayerList
                    )

                Corner(Row, 6)

                Create(
                    "TextLabel",
                    {
                        Position =
                            UDim2.new(
                                0,
                                10,
                                0,
                                5
                            ),

                        Size =
                            UDim2.new(
                                0.5,
                                0,
                                0,
                                20
                            ),

                        BackgroundTransparency = 1,

                        Font =
                            Enum.Font.GothamMedium,

                        Text =
                            player.DisplayName,

                        TextColor3 =
                            state.Theme.Primary,

                        TextSize = 12,

                        TextXAlignment =
                            Enum.TextXAlignment.Left
                    },
                    Row
                )

                Create(
                    "TextLabel",
                    {
                        Position =
                            UDim2.new(
                                0,
                                10,
                                0,
                                25
                            ),

                        Size =
                            UDim2.new(
                                1,
                                -20,
                                0,
                                18
                            ),

                        BackgroundTransparency = 1,

                        Font =
                            Enum.Font.Gotham,

                        Text =
                            "@" ..
                            player.Name,

                        TextColor3 =
                            state.Theme.Secondary,

                        TextSize = 10,

                        TextXAlignment =
                            Enum.TextXAlignment.Left
                    },
                    Row
                )

            end

        end

        RefreshPlayers()

        Players.PlayerAdded:Connect(
            RefreshPlayers
        )

        Players.PlayerRemoving:Connect(
            RefreshPlayers
        )

    end

    --==================================================
    -- INITIAL THEME
    --==================================================

    ApplyTheme(state)

    return Page
end

return Settings
