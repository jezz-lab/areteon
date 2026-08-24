--==================================================
-- ARETEON | Pages/Settings.lua
--==================================================

local Settings = {}

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

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

local function Clear(parent)
    for _, child in ipairs(parent:GetChildren()) do
        child:Destroy()
    end
end

--==================================================
-- START
--==================================================

function Settings.Start(state)

    if not state or not state.Content then
        warn("[Areteon] Settings: Content was not provided.")
        return nil
    end

    local Content = state.Content

    local Page =
        Create(
            "Frame",
            {
                Name = "SettingsPage",

                Size =
                    UDim2.new(1, -20, 0, 650),

                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Visible = false
            },
            Content
        )

    --==================================================
    -- TITLE
    --==================================================

    Create(
        "TextLabel",
        {
            Name = "Title",

            Position =
                UDim2.new(0, 15, 0, 15),

            Size =
                UDim2.new(1, -30, 0, 35),

            BackgroundTransparency = 1,

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
        Page
    )

    --==================================================
    -- GENERAL
    --==================================================

    local General =
        Create(
            "Frame",
            {
                Name = "General",

                Position =
                    UDim2.new(0, 15, 0, 65),

                Size =
                    UDim2.new(1, -30, 0, 190),

                BackgroundColor3 =
                    Color3.fromRGB(
                        22,
                        22,
                        28
                    ),

                BorderSizePixel = 0
            },
            Page
        )

    Corner(General, 10)

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(0, 15, 0, 12),

            Size =
                UDim2.new(1, -30, 0, 25),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamBold,

            Text = "General Settings",

            TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            TextSize = 15,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        General
    )

    --==================================================
    -- HUB TOGGLE
    --==================================================

    local HubToggle =
        Create(
            "TextButton",
            {
                Position =
                    UDim2.new(0, 15, 0, 52),

                Size =
                    UDim2.new(1, -30, 0, 40),

                BackgroundColor3 =
                    Color3.fromRGB(
                        35,
                        35,
                        43
                    ),

                BorderSizePixel = 0,

                Font =
                    Enum.Font.GothamMedium,

                Text = "Hub: Enabled",

                TextColor3 =
                    Color3.fromRGB(
                        225,
                        225,
                        230
                    ),

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            General
        )

    Corner(HubToggle, 7)

    Create(
        "UIPadding",
        {
            PaddingLeft = UDim.new(0, 12)
        },
        HubToggle
    )

    local hubEnabled = true

    HubToggle.MouseButton1Click:Connect(function()

        hubEnabled = not hubEnabled

        if hubEnabled then
            HubToggle.Text = "Hub: Enabled"
        else
            HubToggle.Text = "Hub: Disabled"
        end

    end)

    --==================================================
    -- RESET SCROLL
    --==================================================

    local ResetScroll =
        Create(
            "TextButton",
            {
                Position =
                    UDim2.new(0, 15, 0, 102),

                Size =
                    UDim2.new(1, -30, 0, 40),

                BackgroundColor3 =
                    Color3.fromRGB(
                        35,
                        35,
                        43
                    ),

                BorderSizePixel = 0,

                Font =
                    Enum.Font.GothamMedium,

                Text = "Reset Scroll Position",

                TextColor3 =
                    Color3.fromRGB(
                        225,
                        225,
                        230
                    ),

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            General
        )

    Corner(ResetScroll, 7)

    Create(
        "UIPadding",
        {
            PaddingLeft = UDim.new(0, 12)
        },
        ResetScroll
    )

    ResetScroll.MouseButton1Click:Connect(function()

        if state.ContentScroll then

            state.ContentScroll.CanvasPosition =
                Vector2.new(0, 0)

        end

    end)

    --==================================================
    -- ACCESS INFO
    --==================================================

    local Access =
        Create(
            "Frame",
            {
                Name = "Access",

                Position =
                    UDim2.new(0, 15, 0, 270),

                Size =
                    UDim2.new(1, -30, 0, 150),

                BackgroundColor3 =
                    Color3.fromRGB(
                        22,
                        22,
                        28
                    ),

                BorderSizePixel = 0
            },
            Page
        )

    Corner(Access, 10)

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(0, 15, 0, 12),

            Size =
                UDim2.new(1, -30, 0, 25),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.GothamBold,

            Text = "Access",

            TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            TextSize = 15,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        Access
    )

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(0, 15, 0, 48),

            Size =
                UDim2.new(1, -30, 0, 25),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.Gotham,

            Text =
                "Access Type: " ..
                tostring(
                    state.AccessType or "USER"
                ),

            TextColor3 =
                Color3.fromRGB(
                    200,
                    200,
                    205
                ),

            TextSize = 13,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        Access
    )

    Create(
        "TextLabel",
        {
            Position =
                UDim2.new(0, 15, 0, 78),

            Size =
                UDim2.new(1, -30, 0, 25),

            BackgroundTransparency = 1,

            Font =
                Enum.Font.Gotham,

            Text =
                "UserId: " ..
                tostring(
                    LocalPlayer.UserId
                ),

            TextColor3 =
                Color3.fromRGB(
                    160,
                    160,
                    168
                ),

            TextSize = 12,

            TextXAlignment =
                Enum.TextXAlignment.Left
        },
        Access
    )

    --==================================================
    -- ADMIN PANEL
    --==================================================

    local IsAdmin =
        state.IsAdmin == true

    if IsAdmin then

        local AdminPanel =
            Create(
                "Frame",
                {
                    Name = "AdminPanel",

                    Position =
                        UDim2.new(0, 15, 0, 435),

                    Size =
                        UDim2.new(1, -30, 0, 170),

                    BackgroundColor3 =
                        Color3.fromRGB(
                            22,
                            22,
                            28
                        ),

                    BorderSizePixel = 0
                },
                Page
            )

        Corner(AdminPanel, 10)

        Create(
            "TextLabel",
            {
                Position =
                    UDim2.new(0, 15, 0, 12),

                Size =
                    UDim2.new(1, -30, 0, 25),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.GothamBold,

                Text = "Admin Panel",

                TextColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    ),

                TextSize = 15,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            AdminPanel
        )

        Create(
            "TextLabel",
            {
                Position =
                    UDim2.new(0, 15, 0, 48),

                Size =
                    UDim2.new(1, -30, 0, 25),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.Gotham,

                Text =
                    "Online Players: " ..
                    tostring(
                        #Players:GetPlayers()
                    ),

                TextColor3 =
                    Color3.fromRGB(
                        200,
                        200,
                        205
                    ),

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            AdminPanel
        )

        Create(
            "TextLabel",
            {
                Position =
                    UDim2.new(0, 15, 0, 80),

                Size =
                    UDim2.new(1, -30, 0, 25),

                BackgroundTransparency = 1,

                Font =
                    Enum.Font.Gotham,

                Text =
                    "Admin access is enabled.",

                TextColor3 =
                    Color3.fromRGB(
                        170,
                        170,
                        178
                    ),

                TextSize = 12,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            AdminPanel
        )

        local Refresh =
            Create(
                "TextButton",
                {
                    Position =
                        UDim2.new(
                            0,
                            15,
                            0,
                            115
                        ),

                    Size =
                        UDim2.new(
                            0,
                            150,
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
                        Enum.Font.GothamMedium,

                    Text = "Refresh",

                    TextColor3 =
                        Color3.fromRGB(
                            225,
                            225,
                            230
                        ),

                    TextSize = 12
                },
                AdminPanel
            )

        Corner(Refresh, 7)

        Refresh.MouseButton1Click:Connect(function()

            -- Update the player count.

            local count =
                AdminPanel:FindFirstChild(
                    "OnlinePlayers"
                )

            if count then
                count.Text =
                    "Online Players: " ..
                    tostring(
                        #Players:GetPlayers()
                    )
            end

        end)

    end

    return Page
end

return Settings
