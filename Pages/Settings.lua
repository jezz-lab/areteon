--==================================================
-- ARETEON | Pages/Settings.lua
--==================================================

local Settings = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

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

local function ClampColor(value)
    return math.clamp(
        tonumber(value) or 0,
        0,
        255
    )
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

    local Gui = state.Gui

    if not Gui then
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
                        320,
                        0,
                        330
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
            Gui
        )

    Corner(Picker, 10)

    state.ColorPicker = Picker

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
                "Change " .. colorName,

            TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            TextSize = 16,

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
                        45
                    ),

                BackgroundColor3 =
                    currentColor,

                BorderSizePixel = 0,

                ZIndex = 101
            },
            Picker
        )

    Corner(Preview, 7)

    --==================================================
    -- RGB
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

    local function CreateRGBInput(
        name,
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

                Text = name,

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

                    ZIndex = 101
                },
                Picker
            )

        Corner(Input, 6)

        return Input
    end

    local RBox =
        CreateRGBInput(
            "R",
            R,
            105
        )

    local GBox =
        CreateRGBInput(
            "G",
            G,
            145
        )

    local BBox =
        CreateRGBInput(
            "B",
            B,
            185
        )

    --==================================================
    -- UPDATE PREVIEW
    --==================================================

    local function UpdatePreview()

        local r =
            ClampColor(RBox.Text)

        local g =
            ClampColor(GBox.Text)

        local b =
            ClampColor(BBox.Text)

        Preview.BackgroundColor3 =
            Color3.fromRGB(
                r,
                g,
                b
            )
    end

    RBox:GetPropertyChangedSignal("Text"):
        Connect(UpdatePreview)

    GBox:GetPropertyChangedSignal("Text"):
        Connect(UpdatePreview)

    BBox:GetPropertyChangedSignal("Text"):
        Connect(UpdatePreview)

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
                        0,
                        240
                    ),

                Size =
                    UDim2.new(
                        0,
                        130,
                        0,
                        38
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

                ZIndex = 101
            },
            Picker
        )

    Corner(Apply, 7)

    Apply.MouseButton1Click:Connect(
        function()

            local r =
                ClampColor(RBox.Text)

            local g =
                ClampColor(GBox.Text)

            local b =
                ClampColor(BBox.Text)

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
                        0,
                        165,
                        0,
                        240
                    ),

                Size =
                    UDim2.new(
                        0,
                        130,
                        0,
                        38
                    ),

                BackgroundColor3 =
                    Color3.fromRGB(
                        35,
                        35,
                        43
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

    Corner(Cancel, 7)

    Cancel.MouseButton1Click:Connect(
        function()

            Picker:Destroy()

            state.ColorPicker = nil

        end
    )

end

--==================================================
-- APPLY THEME
--==================================================

local function ApplyTheme(state)

    local Theme = state.Theme

    if not Theme then
        return
    end

    -- Main hub background

    if state.Main then

        state.Main.BackgroundColor3 =
            Theme.Background

        state.Main.BackgroundTransparency =
            state.Settings.BackgroundTransparency

    end

    -- Sidebar

    if state.Sidebar then

        state.Sidebar.BackgroundColor3 =
            Theme.Background

    end

    -- Top bar

    if state.TopBar then

        state.TopBar.BackgroundColor3 =
            Theme.Panel

    end

    -- IMPORTANT:
    -- Floating icon is intentionally
    -- NOT modified here.

end

--==================================================
-- COLOR ROW
--==================================================

local function CreateColorRow(
    state,
    parent,
    name,
    color
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

    local Label =
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

    local Preview =
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
                    color,

                BorderSizePixel = 0,

                Text = ""
            },
            Row
        )

    Corner(Preview, 6)

    Preview.MouseButton1Click:Connect(
        function()

            OpenColorPicker(
                state,
                name,
                state.Theme[name],
                function(newColor)

                    state.Theme[name] =
                        newColor

                    Preview.BackgroundColor3 =
                        newColor

                    ApplyTheme(state)

                end
            )

        end
    )

    return Row
end

--==================================================
-- DROPDOWN
--==================================================

local function CreateDropdown(
    state,
    parent,
    title,
    height
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
                        height
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
                        height - 50
                    ),

                BackgroundTransparency = 1
            },
            Box
        )

    local expanded = true

    Header.MouseButton1Click:Connect(
        function()

            expanded = not expanded

            if expanded then

                Header.Text =
                    "^  " .. title

                Box.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        height
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

    if not state or not state.Content then

        warn(
            "[Areteon] Settings: " ..
            "state.Content is missing."
        )

        return nil

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
    -- DROPDOWN CONTAINER
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
            260
        )

    CreateColorRow(
        state,
        ColorsContent,
        "Background",
        state.Theme.Background
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Primary",
        state.Theme.Primary
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Secondary",
        state.Theme.Secondary
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Buttons",
        state.Theme.Buttons
    )

    CreateColorRow(
        state,
        ColorsContent,
        "Panel",
        state.Theme.Panel
    )

    --==================================================
    -- GENERAL
    --==================================================

    local GeneralBox, GeneralContent =
        CreateDropdown(
            state,
            List,
            "General",
            155
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

            if not value then
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

        local PlayerList =
            Create(
                "ScrollingFrame",
                {
                    Position =
                        UDim2.new(
                            0,
                            5,
                            0,
                            42
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -10,
                            0,
                            180
                        ),

                    BackgroundTransparency = 1,

                    BorderSizePixel = 0,

                    CanvasSize =
                        UDim2.new(
                            0,
                            0,
                            0,
                            0
                        ),

                    AutomaticCanvasSize =
                        Enum.AutomaticSize.Y,

                    ScrollBarThickness = 5
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

                if
                    not child:IsA(
                        "UIListLayout"
                    )
                then

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
                                0.45,
                                0,
                                0,
                                20
                            ),

                        BackgroundTransparency = 1,

                        Font =
                            Enum.Font.GothamMedium,

                        Text =
                            player.Name,

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
                                0.45,
                                0,
                                0,
                                5
                            ),

                        Size =
                            UDim2.new(
                                0.55,
                                -10,
                                0,
                                20
                            ),

                        BackgroundTransparency = 1,

                        Font =
                            Enum.Font.Gotham,

                        Text =
                            "Status: Unknown",

                        TextColor3 =
                            state.Theme.Secondary,

                        TextSize = 11,

                        TextXAlignment =
                            Enum.TextXAlignment.Right
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
                                26
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
                            "Key: Unknown   •   Time: N/A",

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
    -- APPLY INITIAL THEME
    --==================================================

    ApplyTheme(state)

    return Page
end

return Settings
