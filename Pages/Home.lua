--==================================================
-- ARETEON | Pages/Home.lua
--==================================================

local Home = {}

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    DiscordInvite = "https://discord.gg/YOUR_INVITE",

    HubName = "Areteon Hub",
    Version = "1.0.0",

    -- Change this if your key system has a real expiry.
    Keyless = false,
    RemainingTime = "Lifetime"
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

local function AddCorner(object, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, object)
end

local function AddPadding(object, amount)
    Create("UIPadding", {
        PaddingTop = UDim.new(0, amount),
        PaddingBottom = UDim.new(0, amount),
        PaddingLeft = UDim.new(0, amount),
        PaddingRight = UDim.new(0, amount)
    }, object)
end

local function CreateSection(parent, title)
    local section = Create("Frame", {
        Name = title:gsub("%s+", ""),
        BackgroundColor3 = Color3.fromRGB(24, 24, 29),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    }, parent)

    AddCorner(section, 10)
    AddPadding(section, 12)

    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, section)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1
    }, section)

    return section
end

local function CreateInfo(parent, name, value, order)
    local row = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        LayoutOrder = order or 2
    }, parent)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.42, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(155, 155, 165),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.42, 0, 0, 0),
        Size = UDim2.new(0.58, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = tostring(value),
        TextColor3 = Color3.fromRGB(235, 235, 240),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right
    }, row)

    return row
end

--==================================================
-- EXECUTOR
--==================================================

local function GetExecutor()
    local executorName = "Unknown"

    pcall(function()
        if identifyexecutor then
            local name, version = identifyexecutor()

            if name then
                executorName = tostring(name)

                if version then
                    executorName =
                        executorName ..
                        " " ..
                        tostring(version)
                end
            end
        end
    end)

    return executorName
end

--==================================================
-- AVATAR
--==================================================

local function GetAvatar()
    local image = ""

    pcall(function()
        image = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)

    return image
end

--==================================================
-- PAGE
--==================================================

function Home.Start(state)

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- Avoid creating the page twice.
    local existing = PlayerGui:FindFirstChild("AreteonHome")

    if existing then
        existing:Destroy()
    end

    --==================================================
    -- MAIN
    --==================================================

    local ScreenGui = Create("ScreenGui", {
        Name = "AreteonHome",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    local Main = Create("Frame", {
        Name = "Home",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 560, 0, 620),
        BackgroundColor3 = Color3.fromRGB(15, 15, 19),
        BorderSizePixel = 0
    }, ScreenGui)

    AddCorner(Main, 14)

    --==================================================
    -- HEADER
    --==================================================

    local Header = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 60),
        Position = UDim2.new(0, 12, 0, 10)
    }, Main)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 3),
        Size = UDim2.new(1, 0, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = "Areteon Hub",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 21,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Header)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 31),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "Welcome back, " .. LocalPlayer.DisplayName,
        TextColor3 = Color3.fromRGB(145, 145, 155),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Header)

    --==================================================
    -- SCROLL
    --==================================================

    local Scroll = Create("ScrollingFrame", {
        Name = "Content",
        Position = UDim2.new(0, 12, 0, 80),
        Size = UDim2.new(1, -24, 1, -92),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, Main)

    Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Scroll)

    --==================================================
    -- PROFILE
    --==================================================

    local Profile = CreateSection(
        Scroll,
        "Profile"
    )

    local ProfileBody = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 75),
        LayoutOrder = 2
    }, Profile)

    local Avatar = Create("ImageLabel", {
        BackgroundColor3 = Color3.fromRGB(35, 35, 42),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 65, 0, 65),
        Image = GetAvatar()
    }, ProfileBody)

    AddCorner(Avatar, 32)

    local ProfileInfo = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 80, 0, 0),
        Size = UDim2.new(1, -80, 1, 0)
    }, ProfileBody)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = LocalPlayer.DisplayName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    }, ProfileInfo)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "@" .. LocalPlayer.Name,
        TextColor3 = Color3.fromRGB(150, 150, 160),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }, ProfileInfo)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(1, 0, 0, 18),
        Font = Enum.Font.Gotham,
        Text = "User ID: " .. tostring(LocalPlayer.UserId),
        TextColor3 = Color3.fromRGB(110, 110, 120),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, ProfileInfo)

    --==================================================
    -- KEY STATUS
    --==================================================

    local KeyStatus = CreateSection(
        Scroll,
        "Key Status"
    )

    CreateInfo(
        KeyStatus,
        "System",
        CONFIG.Keyless and "Keyless" or "Key System",
        2
    )

    CreateInfo(
        KeyStatus,
        "Remaining Time",
        CONFIG.RemainingTime,
        3
    )

    CreateInfo(
        KeyStatus,
        "Executor",
        GetExecutor(),
        4
    )

    --==================================================
    -- DISCORD
    --==================================================

    local Discord = CreateSection(
        Scroll,
        "Discord"
    )

    local DiscordButton = Create("TextButton", {
        BackgroundColor3 = Color3.fromRGB(35, 35, 43),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 38),
        Font = Enum.Font.GothamMedium,
        Text = "Join Discord",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        AutoButtonColor = true,
        LayoutOrder = 2
    }, Discord)

    AddCorner(DiscordButton, 8)

    DiscordButton.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(function()
                setclipboard(CONFIG.DiscordInvite)
            end)
        end

        print(
            "[Areteon] Discord:",
            CONFIG.DiscordInvite
        )
    end)

    --==================================================
    -- DETAILS
    --==================================================

    local Details = CreateSection(
        Scroll,
        "Details"
    )

    CreateInfo(
        Details,
        "Hub",
        CONFIG.HubName,
        2
    )

    CreateInfo(
        Details,
        "Version",
        CONFIG.Version,
        3
    )

    CreateInfo(
        Details,
        "Access",
        state.AccessType or "USER",
        4
    )

    --==================================================
    -- INFO
    --==================================================

    local Info = CreateSection(
        Scroll,
        "Info"
    )

    local InfoText = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 65),
        Font = Enum.Font.Gotham,
        Text = "Areteon Hub\nA modular Roblox interface built around separate pages and utilities.",
        TextColor3 = Color3.fromRGB(170, 170, 180),
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 2
    }, Info)

    print("[Areteon] Home page initialized.")

    return ScreenGui
end

return Home
