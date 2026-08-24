--==================================================
-- ARETEON | Pages/Settings.lua
--==================================================

local SettingsPage = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    HubName = "Areteon Hub",
    Version = "1.0.0",

    -- Admin UserIds
    Admins = {
        [8045408189] = true,
        [7701580616] = true,
    }
}

local State = {
    Notifications = true,
    Animations = true,
    RememberPage = true,

    LogsEnabled = true
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
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, object)
end

local function IsAdmin()
    return CONFIG.Admins[LocalPlayer.UserId] == true
end

--==================================================
-- SECTION
--==================================================

local function CreateSection(parent, title)
    local section = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(24, 24, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    }, parent)

    Corner(section, 9)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    }, section)

    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, section)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1
    }, section)

    return section
end

--==================================================
-- TOGGLE
--==================================================

local function CreateToggle(parent, title, initial, callback)
    local value = initial

    local button = Create("TextButton", {
        BackgroundColor3 = Color3.fromRGB(34, 34, 42),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Text = "",
        AutoButtonColor = true
    }, parent)

    Corner(button, 7)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = title,
        TextColor3 = Color3.fromRGB(225, 225, 230),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, button)

    local status = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 0),
        Size = UDim2.new(0, 50, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = value and "ON" or "OFF",
        TextColor3 = value
            and Color3.fromRGB(100, 220, 140)
            or Color3.fromRGB(150, 150, 160),
        TextSize = 11
    }, button)

    button.MouseButton1Click:Connect(function()
        value = not value

        status.Text = value and "ON" or "OFF"

        status.TextColor3 = value
            and Color3.fromRGB(100, 220, 140)
            or Color3.fromRGB(150, 150, 160)

        callback(value)
    end)

    return button
end

--==================================================
-- BUTTON
--==================================================

local function CreateButton(parent, title, callback)
    local button = Create("TextButton", {
        BackgroundColor3 = Color3.fromRGB(34, 34, 42),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Font = Enum.Font.GothamMedium,
        Text = title,
        TextColor3 = Color3.fromRGB(230, 230, 235),
        TextSize = 12,
        AutoButtonColor = true
    }, parent)

    Corner(button, 7)

    button.MouseButton1Click:Connect(callback)

    return button
end

--==================================================
-- LOGS
--==================================================

local Logs = {}

local function AddLog(message)
    table.insert(Logs, {
        Time = os.date("%H:%M:%S"),
        Message = tostring(message)
    })

    if #Logs > 100 then
        table.remove(Logs, 1)
    end
end

AddLog("Settings initialized")

--==================================================
-- LOG WINDOW
--==================================================

local function OpenLogs()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local old = PlayerGui:FindFirstChild(
        "AreteonLogs"
    )

    if old then
        old:Destroy()
        return
    end

    local Gui = Create("ScreenGui", {
        Name = "AreteonLogs",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    local Window = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 500, 0, 400),
        BackgroundColor3 = Color3.fromRGB(15, 15, 19),
        BorderSizePixel = 0
    }, Gui)

    Corner(Window, 12)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -70, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "Areteon Logs",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Window)

    local Close = Create("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -45, 0, 10),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 22
    }, Window)

    Close.MouseButton1Click:Connect(function()
        Gui:Destroy()
    end)

    local Scroll = Create("ScrollingFrame", {
        Position = UDim2.new(0, 12, 0, 55),
        Size = UDim2.new(1, -24, 1, -67),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, Window)

    Corner(Scroll, 8)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    }, Scroll)

    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Scroll)

    for _, entry in ipairs(Logs) do
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Font = Enum.Font.Code,
            Text =
                "[" ..
                entry.Time ..
                "] " ..
                entry.Message,
            TextColor3 = Color3.fromRGB(190, 190, 200),
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        }, Scroll)
    end
end

--==================================================
-- START
--==================================================

function SettingsPage.Start(state)

    local PlayerGui = LocalPlayer:WaitForChild(
        "PlayerGui"
    )

    local old = PlayerGui:FindFirstChild(
        "AreteonSettings"
    )

    if old then
        old:Destroy()
    end

    local Gui = Create("ScreenGui", {
        Name = "AreteonSettings",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    local Window = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 560, 0, 570),
        BackgroundColor3 = Color3.fromRGB(15, 15, 19),
        BorderSizePixel = 0
    }, Gui)

    Corner(Window, 12)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "Settings",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Window)

    local Scroll = Create("ScrollingFrame", {
        Position = UDim2.new(0, 12, 0, 55),
        Size = UDim2.new(1, -24, 1, -67),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, Window)

    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Scroll)

    --==================================================
    -- ADMIN PANEL
    --==================================================

    local AdminPanel = CreateSection(
        Scroll,
        "Admin Panel"
    )

    if IsAdmin() then

        CreateButton(
            AdminPanel,
            "Open Logs",
            function()
                AddLog("Logs opened")
                OpenLogs()
            end
        )

        CreateToggle(
            AdminPanel,
            "Logging",
            State.LogsEnabled,
            function(value)
                State.LogsEnabled = value

                if value then
                    AddLog("Logging enabled")
                end
            end
        )

    else

        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 34),
            Font = Enum.Font.Gotham,
            Text = "Admin access required.",
            TextColor3 = Color3.fromRGB(145, 145, 155),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        }, AdminPanel)

    end

    --==================================================
    -- GENERAL SETTINGS
    --==================================================

    local General = CreateSection(
        Scroll,
        "General Settings"
    )

    CreateToggle(
        General,
        "Notifications",
        State.Notifications,
        function(value)
            State.Notifications = value
            AddLog(
                "Notifications: " ..
                tostring(value)
            )
        end
    )

    CreateToggle(
        General,
        "Animations",
        State.Animations,
        function(value)
            State.Animations = value
            AddLog(
                "Animations: " ..
                tostring(value)
            )
        end
    )

    CreateToggle(
        General,
        "Remember Page",
        State.RememberPage,
        function(value)
            State.RememberPage = value
            AddLog(
                "Remember Page: " ..
                tostring(value)
            )
        end
    )

    CreateButton(
        General,
        "Reset Settings",
        function()
            State.Notifications = true
            State.Animations = true
            State.RememberPage = true

            AddLog("Settings reset")
        end
    )

    print("[Areteon] Settings page initialized.")

    return Gui
end

return SettingsPage
