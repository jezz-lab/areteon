--==================================================
-- ARETEON | Home.lua
--==================================================

local Page = {}

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

local function CreateCard(parent, title, y, height)
    local card = Create("Frame", {
        Name = title .. "Card",

        Position =
            UDim2.new(0, 15, 0, y),

        Size =
            UDim2.new(1, -30, 0, height),

        BackgroundColor3 =
            Color3.fromRGB(23, 23, 29),

        BorderSizePixel = 0
    }, parent)

    Corner(card, 9)

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 10),

        Size =
            UDim2.new(1, -30, 0, 24),

        Font =
            Enum.Font.GothamBold,

        Text = title,

        TextColor3 =
            Color3.fromRGB(245, 245, 250),

        TextSize = 14,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, card)

    return card
end

--==================================================
-- START
--==================================================

function Page.Start(state)

    local PageFrame = Create("Frame", {
        Name = "Home",

        Size =
            UDim2.new(1, 0, 1, 0),

        Position =
            UDim2.new(0, 0, 0, 0),

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
            UDim2.new(0, 15, 0, 15),

        Size =
            UDim2.new(1, -30, 0, 35),

        Font =
            Enum.Font.GothamBold,

        Text = "Home",

        TextColor3 =
            Color3.fromRGB(255, 255, 255),

        TextSize = 22,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, PageFrame)

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 48),

        Size =
            UDim2.new(1, -30, 0, 25),

        Font =
            Enum.Font.Gotham,

        Text = "Welcome to Areteon Hub.",

        TextColor3 =
            Color3.fromRGB(160, 160, 170),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, PageFrame)

    --==================================================
    -- PROFILE
    --==================================================

    local Profile =
        CreateCard(
            PageFrame,
            "Profile",
            85,
            105
        )

    local username =
        LocalPlayer.Name

    local displayName =
        LocalPlayer.DisplayName

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 38),

        Size =
            UDim2.new(1, -30, 0, 22),

        Font =
            Enum.Font.Gotham,

        Text =
            "Display Name: " ..
            displayName,

        TextColor3 =
            Color3.fromRGB(205, 205, 212),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, Profile)

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 64),

        Size =
            UDim2.new(1, -30, 0, 22),

        Font =
            Enum.Font.Gotham,

        Text =
            "Username: @" ..
            username,

        TextColor3 =
            Color3.fromRGB(165, 165, 175),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, Profile)

    --==================================================
    -- KEY STATUS
    --==================================================

    local KeyStatus =
        CreateCard(
            PageFrame,
            "Key Status",
            200,
            105
        )

    local keyText =
        "Key System"

    if state.IsAdmin then
        keyText = "Admin / Keyless"
    elseif state.IsException then
        keyText = "Exception / Keyless"
    end

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 38),

        Size =
            UDim2.new(1, -30, 0, 22),

        Font =
            Enum.Font.Gotham,

        Text =
            "Access: " ..
            keyText,

        TextColor3 =
            Color3.fromRGB(205, 205, 212),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, KeyStatus)

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 64),

        Size =
            UDim2.new(1, -30, 0, 22),

        Font =
            Enum.Font.Gotham,

        Text =
            "Access Type: " ..
            tostring(state.AccessType),

        TextColor3 =
            Color3.fromRGB(165, 165, 175),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, KeyStatus)

    --==================================================
    -- DETAILS
    --==================================================

    local Details =
        CreateCard(
            PageFrame,
            "Details",
            315,
            85
        )

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 38),

        Size =
            UDim2.new(1, -30, 0, 22),

        Font =
            Enum.Font.Gotham,

        Text = "Areteon Hub",

        TextColor3 =
            Color3.fromRGB(205, 205, 212),

        TextSize = 13,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, Details)

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 60),

        Size =
            UDim2.new(1, -30, 0, 20),

        Font =
            Enum.Font.Gotham,

        Text = "Main control panel",

        TextColor3 =
            Color3.fromRGB(150, 150, 160),

        TextSize = 12,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, Details)

    --==================================================
    -- INFO
    --==================================================

    local Info =
        CreateCard(
            PageFrame,
            "Info",
            410,
            60
        )

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 34),

        Size =
            UDim2.new(1, -30, 0, 20),

        Font =
            Enum.Font.Gotham,

        Text = "Use the sidebar to navigate pages.",

        TextColor3 =
            Color3.fromRGB(155, 155, 165),

        TextSize = 12,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, Info)

    return PageFrame
end

return Page
