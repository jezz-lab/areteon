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

--==================================================
-- CORNER
--==================================================

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
end

--==================================================
-- FORMAT TIME
--==================================================

local function FormatTime(seconds)

    seconds = tonumber(seconds) or 0

    if seconds <= 0 then
        return "Expired"
    end

    local days = math.floor(
        seconds / 86400
    )

    seconds = seconds % 86400

    local hours = math.floor(
        seconds / 3600
    )

    seconds = seconds % 3600

    local minutes = math.floor(
        seconds / 60
    )

    if days > 0 then
        return string.format(
            "%dd %dh",
            days,
            hours
        )
    end

    if hours > 0 then
        return string.format(
            "%dh %dm",
            hours,
            minutes
        )
    end

    return string.format(
        "%dm",
        minutes
    )
end

--==================================================
-- APPLY THEME
--==================================================

local function ApplyTheme(state)

    if not state then
        return
    end

    if not state.Theme then
        return
    end

    local theme = state.Theme

    if state.Main then
        state.Main.BackgroundColor3 =
            theme.Background

        state.Main.BackgroundTransparency =
            state.Settings.BackgroundTransparency
    end

    if state.Sidebar then
        state.Sidebar.BackgroundColor3 =
            theme.Panel
    end

    if state.TopBar then
        state.TopBar.BackgroundColor3 =
            theme.Panel
    end

    -- Floating icon intentionally
    -- does not use the theme.
end

--==================================================
-- COLOR PICKER
--==================================================

local function OpenColorPicker(
    state,
    colorName,
    currentColor,
    callback
)

    if state.ColorPicker then
        state.ColorPicker:Destroy()
        state.ColorPicker = nil
    end

    if not state.Gui then
        warn(
            "[Areteon] Settings: Gui missing."
        )

        return
    end

    local picker = Create(
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
                    300
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

    Corner(picker, 10)

    state.ColorPicker = picker

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
                "Change " ..
                colorName,

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
        picker
    )

    --==================================================
    -- PREVIEW
    --==================================================

    local preview = Create(
        "Frame",
        {
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
                    40
                ),

            BackgroundColor3 =
                currentColor,

            BorderSizePixel = 0,

            ZIndex = 101
        },
        picker
    )

    Corner(preview, 6)

    --==================================================
    -- RGB
    --==================================================

    local red =
        math.floor(
            currentColor.R * 255
        )

    local green =
        math.floor(
            currentColor.G * 255
        )

    local blue =
        math.floor(
            currentColor.B * 255
        )

    local function MakeInput(
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
            picker
        )

        local input = Create(
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
            picker
        )

        Corner(input, 6)

        return input
    end

    local redBox =
        MakeInput(
            "R",
            red,
            105
        )

    local greenBox =
        MakeInput(
            "G",
            green,
            145
        )

    local blueBox =
        MakeInput(
            "B",
            blue,
            185
        )

    local function GetValue(text)

        local value =
            tonumber(text)

        if not value then
            return 0
        end

        return math.clamp(
            value,
            0,
            255
        )
    end

    local function UpdatePreview()

        preview.BackgroundColor3 =
            Color3.fromRGB(
                GetValue(redBox.Text),
                GetValue(greenBox.Text),
                GetValue(blueBox.Text)
            )
    end

    redBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        UpdatePreview
    )

    greenBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        UpdatePreview
    )

    blueBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        UpdatePreview
    )

    --==================================================
    -- APPLY
    --==================================================

    local apply = Create(
        "TextButton",
        {
            Position =
                UDim2.new(
                    0,
                    20,
                    0,
                    235
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

            ZIndex = 101
        },
        picker
    )

    Corner(apply, 7)

    apply.MouseButton1Click:Connect(
        function()

            local color =
                Color3.fromRGB(
                    GetValue(redBox.Text),
                    GetValue(greenBox.Text),
                    GetValue(blueBox.Text)
                )

            callback(color)

            picker:Destroy()

            state.ColorPicker = nil
        end
    )

    --==================================================
    -- CANCEL
    --==================================================

    local cancel = Create(
        "TextButton",
        {
            Position =
                UDim2.new(
                    0,
                    160,
                    0,
                    235
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
        picker
    )

    Corner(cancel, 7)

    cancel.MouseButton1Click:Connect(
        function()

            picker:Destroy()

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

    local row = Create(
        "Frame",
        {
            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    38
                ),

            BackgroundTransparency = 1,

            BorderSizePixel = 0
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
        row
    )

    local preview = Create(
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
        row
    )

    Corner(preview, 6)

    preview.MouseButton1Click:Connect(
        function()

            OpenColorPicker(
                state,
                name,
                state.Theme[name],
                function(newColor)

                    state.Theme[name] =
                        newColor

                    preview.BackgroundColor3 =
                        newColor

                    ApplyTheme(state)
                end
            )
        end
    )

    return row
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

    local box = Create(
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

    Corner(box, 10)

    local header = Create(
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
        box
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
        header
    )

    local content = Create(
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
        box
    )

    local expanded = true

    header.MouseButton1Click:Connect(
        function()

            expanded = not expanded

            if expanded then

                header.Text =
                    "^  " .. title

                content.Visible = true

                box.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        expandedHeight
                    )

            else

                header.Text =
                    "v  " .. title

                content.Visible = false

                box.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        42
                    )
            end
        end
    )

    return box, content
end

--==================================================
-- ADMIN PLAYER ROW
--==================================================

local function CreateAdminPlayerRow(
    state,
    parent,
    player
)

    local userId = player.UserId

    local isAdmin =
        state.Admins
        and state.Admins[userId] == true

    local isException =
        state.Exceptions
        and state.Exceptions[userId] == true

    local data =
        state.KeyData
        and state.KeyData[userId]

    local status = "Free"
    local keyStatus = "No Key"
    local timeRemaining = "N/A"

    if isAdmin then

        status = "ADMIN"
        keyStatus = "Bypass"
        timeRemaining = "∞"

    elseif isException then

        status = "EXCEPTION"
        keyStatus = "Bypass"
        timeRemaining = "∞"

    elseif data then

        status =
            data.Status
            or "Free"

        keyStatus =
            data.KeyStatus
            or "Unknown"

        if data.ExpiresAt then

            local remaining =
                data.ExpiresAt -
                os.time()

            timeRemaining =
                FormatTime(
                    remaining
                )

        elseif data.TimeRemaining then

            timeRemaining =
                FormatTime(
                    data.TimeRemaining
                )
        end
    end

    local row = Create(
        "Frame",
        {
            Size =
                UDim2.new(
                    1,
                    -5,
                    0,
                    64
                ),

            BackgroundColor3 =
                state.Theme.Background,

            BorderSizePixel = 0
        },
        parent
    )

    Corner(row, 7)

    --==================================================
    -- NAME
    --==================================================

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
                    0.28,
                    0,
                    0,
                    22
                ),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamBold,

            Text =
                player.Name,

            TextColor3 =
                state.Theme.Primary,

            TextSize = 12,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        row
    )

    --==================================================
    -- STATUS
    --==================================================

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(
                    0.28,
                    0,
                    0,
                    5
                ),

            Size =
                UDim2.new(
                    0.24,
                    0,
                    0,
                    22
                ),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamMedium,

            Text =
                status,

            TextColor3 =
                state.Theme.Primary,

            TextSize = 11,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        row
    )

    --==================================================
    -- KEY
    --==================================================

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(
                    0.52,
                    0,
                    0,
                    5
                ),

            Size =
                UDim2.new(
                    0.23,
                    0,
                    0,
                    22
                ),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.Gotham,

            Text =
                keyStatus,

            TextColor3 =
                state.Theme.Secondary,

            TextSize = 11,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        row
    )

    --==================================================
    -- TIME
    --==================================================

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(
                    0.75,
                    0,
                    0,
                    5
                ),

            Size =
                UDim2.new(
                    0.25,
                    -10,
                    0,
                    22
                ),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.Gotham,

            Text =
                timeRemaining,

            TextColor3 =
                state.Theme.Secondary,

            TextSize = 11,

            TextXAlignment =
                Enum.TextXAlignment.Right
        },
        row
    )

    --==================================================
    -- USER ID
    --==================================================

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(
                    0,
                    10,
                    0,
                    34
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
                "UserId: " ..
                tostring(userId),

            TextColor3 =
                state.Theme.Secondary,

            TextSize = 10,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        row
    )

    return row
end

--==================================================
-- START
--==================================================

function Settings.Start(state)

    if not state then
        warn(
            "[Areteon] Settings: state missing."
        )

        return nil
    end

    if not state.Content then
        warn(
            "[Areteon] Settings: " ..
            "state.Content missing."
        )

        return nil
    end

    --==================================================
    -- STATE
    --==================================================

    state.Theme =
        state.Theme
        or
        {
            Background =
                Settings.DefaultTheme.Background,

            Primary =
                Settings.DefaultTheme.Primary,

            Secondary =
                Settings.DefaultTheme.Secondary,

            Buttons =
                Settings.DefaultTheme.Buttons,

            Panel =
                Settings.DefaultTheme.Panel
        }

    state.Settings =
        state.Settings
        or
        {
            BackgroundTransparency =
                Settings.DefaultSettings
                    .BackgroundTransparency
        }

    state.Admins =
        state.Admins
        or
        {}

    state.Exceptions =
        state.Exceptions
        or
        {}

    state.KeyData =
        state.KeyData
        or
        {}

    --==================================================
    -- PAGE
    --==================================================

    local page = Create(
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
        page
    )

    --==================================================
    -- LIST
    --==================================================

    local list = Create(
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
        page
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
        list
    )

    --==================================================
    -- COLORS
    --==================================================

    local colorsBox, colorsContent =
        CreateDropdown(
            state,
            list,
            "Colors",
            250
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
        colorsContent
    )

    CreateColorRow(
        state,
        colorsContent,
        "Background"
    )

    CreateColorRow(
        state,
        colorsContent,
        "Primary"
    )

    CreateColorRow(
        state,
        colorsContent,
        "Secondary"
    )

    CreateColorRow(
        state,
        colorsContent,
        "Buttons"
    )

    CreateColorRow(
        state,
        colorsContent,
        "Panel"
    )

    --==================================================
    -- GENERAL
    --==================================================

    local generalBox, generalContent =
        CreateDropdown(
            state,
            list,
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
        generalContent
    )

    local transparency = Create(
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
        generalContent
    )

    Corner(transparency, 6)

    transparency.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    transparency.Text
                )

            if not value then

                transparency.Text = "0"

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

            transparency.Text =
                tostring(value)

            ApplyTheme(state)
        end
    )

    --==================================================
    -- ADMIN PANEL
    --==================================================

    if state.IsAdmin then

        local adminBox, adminContent =
            CreateDropdown(
                state,
                list,
                "Admin Panel",
                300
            )

        local onlineLabel =
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
                        Enum.Font.GothamBold,

                    Text =
                        "Online Players",

                    TextColor3 =
                        state.Theme.Primary,

                    TextSize = 14,

                    TextXAlignment =
                        Enum.TextXAlignment.Left
                },
                adminContent
            )

        local playerList = Create(
            "ScrollingFrame",
            {
                Position =
                    UDim2.new(
                        0,
                        5,
                        0,
                        35
                    ),

                Size =
                    UDim2.new(
                        1,
                        -10,
                        0,
                        245
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

                ScrollBarThickness = 5,

                ScrollBarImageTransparency = 0.2
            },
            adminContent
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
            playerList
        )

        local function RefreshPlayers()

            onlineLabel.Text =
                "Online Players: " ..
                tostring(
                    #Players:GetPlayers()
                )

            for _, child in
                ipairs(
                    playerList:GetChildren()
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

                CreateAdminPlayerRow(
                    state,
                    playerList,
                    player
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

    return page
end

return Settings
