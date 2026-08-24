--==================================================
-- ARETEON | Pages/Settings.lua
--==================================================

local Page = {}

local Players =
    game:GetService("Players")

--==================================================
-- CREATE
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

            object[property] =
                value

        end)

    end

    object.Parent = parent

    return object
end

--==================================================
-- CORNER
--==================================================

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
-- ACCESS FROM STATE
--==================================================

local function GetAccessType(
    player,
    state
)

    if
        state.Admins
        and
        state.Admins[player.UserId] == true
    then

        return "ADMIN"

    end

    if
        state.Exceptions
        and
        state.Exceptions[player.UserId] == true
    then

        return "EXCEPTION"

    end

    return "USER"
end

--==================================================
-- PLAYER ROW
--==================================================

local function CreatePlayerRow(
    parent,
    player,
    state
)

    local row =
        Create(
            "Frame",
            {
                Name =
                    "Player_" ..
                    tostring(
                        player.UserId
                    ),

                Size =
                    UDim2.new(
                        1,
                        -10,
                        0,
                        68
                    ),

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

    Corner(row, 8)

    --==================================================
    -- NAME
    --==================================================

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    12,
                    0,
                    8
                ),

            Size =
                UDim2.new(
                    0,
                    180,
                    0,
                    22
                ),

            Font =
                Enum.Font.GothamBold,

            Text =
                player.DisplayName,

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
        row
    )

    --==================================================
    -- USERNAME
    --==================================================

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    12,
                    0,
                    32
                ),

            Size =
                UDim2.new(
                    0,
                    180,
                    0,
                    18
                ),

            Font =
                Enum.Font.Gotham,

            Text =
                "@" ..
                player.Name,

            TextColor3 =
                Color3.fromRGB(
                    145,
                    145,
                    155
                ),

            TextSize = 11,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        row
    )

    --==================================================
    -- ACCESS
    --==================================================

    local access =
        GetAccessType(
            player,
            state
        )

    local status =
        "UNKNOWN"

    local keyStatus =
        "UNKNOWN"

    local remaining =
        "UNKNOWN"

    if access == "ADMIN" then

        status =
            "ADMIN"

        keyStatus =
            "KEYLESS"

        remaining =
            "—"

    elseif access == "EXCEPTION" then

        status =
            "EXCEPTION"

        keyStatus =
            "KEYLESS"

        remaining =
            "—"

    end

    --==================================================
    -- STATUS
    --==================================================

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    195,
                    0,
                    10
                ),

            Size =
                UDim2.new(
                    0,
                    90,
                    0,
                    20
                ),

            Font =
                Enum.Font.GothamMedium,

            Text = status,

            TextColor3 =
                Color3.fromRGB(
                    210,
                    210,
                    218
                ),

            TextSize = 10,

            TextXAlignment =
                Enum.TextXAlignment.Center
        },
        row
    )

    --==================================================
    -- KEY
    --==================================================

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    290,
                    0,
                    10
                ),

            Size =
                UDim2.new(
                    0,
                    90,
                    0,
                    20
                ),

            Font =
                Enum.Font.GothamMedium,

            Text = keyStatus,

            TextColor3 =
                Color3.fromRGB(
                    170,
                    170,
                    180
                ),

            TextSize = 10,

            TextXAlignment =
                Enum.TextXAlignment.Center
        },
        row
    )

    --==================================================
    -- TIME
    --==================================================

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    385,
                    0,
                    10
                ),

            Size =
                UDim2.new(
                    1,
                    -400,
                    0,
                    20
                ),

            Font =
                Enum.Font.Gotham,

            Text =
                "Time: " ..
                remaining,

            TextColor3 =
                Color3.fromRGB(
                    150,
                    150,
                    160
                ),

            TextSize = 10,

            TextXAlignment =
                Enum.TextXAlignment.Right
        },
        row
    )

    return row
end

--==================================================
-- START
--==================================================

function Page.Start(state)

    local PageFrame =
        Create(
            "Frame",
            {
                Name = "Settings",

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        state.IsAdmin
                            and 700
                            or 250
                    ),

                BackgroundTransparency = 1,

                BorderSizePixel = 0
            },
            state.Content
        )

    --==================================================
    -- TITLE
    --==================================================

    Create(
        "TextLabel",
        {
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
        },
        PageFrame
    )

    --==================================================
    -- ADMIN PANEL
    --==================================================

    local adminPanel =
        Create(
            "Frame",
            {
                Name = "AdminPanel",

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
                        400
                    ),

                BackgroundColor3 =
                    Color3.fromRGB(
                        23,
                        23,
                        29
                    ),

                BorderSizePixel = 0,

                Visible =
                    state.IsAdmin == true
            },
            PageFrame
        )

    Corner(adminPanel, 10)

    --==================================================
    -- ADMIN TITLE
    --==================================================

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    12
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

            TextSize = 15,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        adminPanel
    )

    --==================================================
    -- PLAYER COUNT
    --==================================================

    local playerCount =
        Create(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.new(
                        0,
                        15,
                        0,
                        38
                    ),

                Size =
                    UDim2.new(
                        1,
                        -30,
                        0,
                        20
                    ),

                Font =
                    Enum.Font.Gotham,

                Text =
                    "Online Players: 0",

                TextColor3 =
                    Color3.fromRGB(
                        150,
                        150,
                        160
                    ),

                TextSize = 12,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            adminPanel
        )

    --==================================================
    -- HEADERS
    --==================================================

    local headers = {

        {
            Text = "PLAYER",
            X = 12,
            Width = 180
        },

        {
            Text = "STATUS",
            X = 195,
            Width = 90
        },

        {
            Text = "KEY",
            X = 290,
            Width = 90
        },

        {
            Text = "TIME REMAINING",
            X = 385,
            Width = 200
        }

    }

    for _, header in
        ipairs(headers)
    do

        Create(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.new(
                        0,
                        header.X,
                        0,
                        66
                    ),

                Size =
                    UDim2.new(
                        0,
                        header.Width,
                        0,
                        20
                    ),

                Font =
                    Enum.Font.GothamBold,

                Text =
                    header.Text,

                TextColor3 =
                    Color3.fromRGB(
                        125,
                        125,
                        135
                    ),

                TextSize = 10,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            adminPanel
        )

    end

    --==================================================
    -- PLAYER LIST
    --==================================================

    local playerList =
        Create(
            "ScrollingFrame",
            {
                Name = "PlayerList",

                Position =
                    UDim2.new(
                        0,
                        10,
                        0,
                        92
                    ),

                Size =
                    UDim2.new(
                        1,
                        -20,
                        1,
                        -102
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

                ScrollingDirection =
                    Enum.ScrollingDirection.Y
            },
            adminPanel
        )

    Create(
        "UIListLayout",
        {
            Padding =
                UDim.new(0, 6),

            SortOrder =
                Enum.SortOrder.LayoutOrder
        },
        playerList
    )

    --==================================================
    -- REFRESH
    --==================================================

    local function RefreshPlayers()

        for _, child in
            ipairs(
                playerList:GetChildren()
            )
        do

            if child:IsA("GuiObject") then
                child:Destroy()
            end

        end

        local online =
            Players:GetPlayers()

        playerCount.Text =
            "Online Players: " ..
            tostring(#online)

        if not state.IsAdmin then
            return
        end

        for _, player in
            ipairs(online)
        do

            CreatePlayerRow(
                playerList,
                player,
                state
            )

        end
    end

    RefreshPlayers()

    --==================================================
    -- JOIN
    --==================================================

    local added =
        Players.PlayerAdded:Connect(
            function()

                if not state.Destroyed then

                    task.wait()

                    RefreshPlayers()

                end

            end
        )

    --==================================================
    -- LEAVE
    --==================================================

    local removing =
        Players.PlayerRemoving:Connect(
            function()

                if not state.Destroyed then

                    task.defer(
                        RefreshPlayers
                    )

                end

            end
        )

    --==================================================
    -- GENERAL
    --==================================================

    local generalY =
        state.IsAdmin
            and 480
            or 65

    local General =
        Create(
            "Frame",
            {
                Name =
                    "GeneralSettings",

                Position =
                    UDim2.new(
                        0,
                        15,
                        0,
                        generalY
                    ),

                Size =
                    UDim2.new(
                        1,
                        -30,
                        0,
                        140
                    ),

                BackgroundColor3 =
                    Color3.fromRGB(
                        23,
                        23,
                        29
                    ),

                BorderSizePixel = 0
            },
            PageFrame
        )

    Corner(General, 10)

    Create(
        "TextLabel",
        {
            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    0,
                    15,
                    0,
                    12
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

            Text =
                "General Settings",

            TextColor3 =
                Color3.fromRGB(
                    240,
                    240,
                    245
                ),

            TextSize = 14,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        General
    )

    --==================================================
    -- NOTIFICATIONS
    --==================================================

    local notifications = false

    local NotificationButton =
        Create(
            "TextButton",
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
            },
            General
        )

    Corner(NotificationButton, 7)

    Create(
        "UIPadding",
        {
            PaddingLeft =
                UDim.new(0, 12)
        },
        NotificationButton
    )

    NotificationButton.MouseButton1Click:Connect(
        function()

            notifications =
                not notifications

            NotificationButton.Text =
                notifications
                    and "Notifications [ON]"
                    or "Notifications [OFF]"

        end
    )

    --==================================================
    -- FLOATING ICON
    --==================================================

    local floatingIcon = true

    local IconButton =
        Create(
            "TextButton",
            {
                Position =
                    UDim2.new(
                        0,
                        15,
                        0,
                        92
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
                    "Floating Icon [ON]",

                TextColor3 =
                    Color3.fromRGB(
                        210,
                        210,
                        218
                    ),

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            General
        )

    Corner(IconButton, 7)

    Create(
        "UIPadding",
        {
            PaddingLeft =
                UDim.new(0, 12)
        },
        IconButton
    )

    IconButton.MouseButton1Click:Connect(
        function()

            floatingIcon =
                not floatingIcon

            if state.Icon then

                state.Icon.Visible =
                    floatingIcon

            end

            IconButton.Text =
                floatingIcon
                    and "Floating Icon [ON]"
                    or "Floating Icon [OFF]"

        end
    )

    --==================================================
    -- CONNECTION CLEANUP
    --==================================================

    task.spawn(
        function()

            while
                not state.Destroyed
                and
                PageFrame.Parent
            do

                task.wait(1)

            end

            pcall(function()
                added:Disconnect()
            end)

            pcall(function()
                removing:Disconnect()
            end)

        end
    )

    return PageFrame
end

return Page
