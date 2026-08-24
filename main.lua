--==================================================
-- MAIN.LUA
-- Single-file Roblox Studio entry point
--==================================================

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    GetKeyURL = "YOUR_KEY_PAGE",
}

--==================================================
-- STATE
--==================================================

local Verified = false
local AccessType = "NONE"

--==================================================
-- GUI HELPERS
--==================================================

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function CreateButton(parent, text, position)
    local button = Instance.new("TextButton")

    button.Size = UDim2.fromOffset(180, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(60, 90, 200)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.Parent = parent

    Corner(button, 7)

    return button
end

--==================================================
-- HUB
--==================================================

local function StartHub()
    if not Verified then
        return
    end

    local old = PlayerGui:FindFirstChild("ScriptHub")

    if old then
        old:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ScriptHub"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local window = Instance.new("Frame")
    window.Size = UDim2.fromOffset(650, 430)
    window.Position = UDim2.new(0.5, -325, 0.5, -215)
    window.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    window.BorderSizePixel = 0
    window.Parent = gui

    Corner(window, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 45)
    title.Position = UDim2.fromOffset(15, 5)
    title.BackgroundTransparency = 1
    title.Text = "◉ SCRIPT HUB"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 19
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = window

    local access = Instance.new("TextLabel")
    access.Size = UDim2.new(1, -30, 0, 30)
    access.Position = UDim2.fromOffset(15, 55)
    access.BackgroundTransparency = 1
    access.Text = "Access: " .. AccessType
    access.TextColor3 = Color3.fromRGB(170, 170, 180)
    access.Font = Enum.Font.Gotham
    access.TextSize = 12
    access.TextXAlignment = Enum.TextXAlignment.Left
    access.Parent = window

    local scripts = CreateButton(
        window,
        "📜 SCRIPTS",
        UDim2.fromOffset(20, 105)
    )

    scripts.MouseButton1Click:Connect(function()
        print("Scripts page opened")
    end)

    if AccessType == "ADMIN" then

        local admin = CreateButton(
            window,
            "🛡 ADMIN PANEL",
            UDim2.fromOffset(20, 160)
        )

        admin.MouseButton1Click:Connect(function()
            print("Admin panel opened")
        end)

    end
end

--==================================================
-- KEY GUI
--==================================================

local function CreateKeyGui()

    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local window = Instance.new("Frame")
    window.Size = UDim2.fromOffset(420, 230)
    window.Position = UDim2.new(0.5, -210, 0.5, -115)
    window.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    window.BorderSizePixel = 0
    window.Parent = gui

    Corner(window, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 40)
    title.Position = UDim2.fromOffset(15, 10)
    title.BackgroundTransparency = 1
    title.Text = "🔐 KEY SYSTEM"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = window

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -30, 0, 40)
    input.Position = UDim2.fromOffset(15, 65)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    input.BorderSizePixel = 0
    input.PlaceholderText = "Enter key"
    input.Text = ""
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.Parent = window

    Corner(input, 7)

    local getKey = CreateButton(
        window,
        "GET KEY",
        UDim2.fromOffset(15, 120)
    )

    getKey.MouseButton1Click:Connect(function()
        print("Key page:", CONFIG.GetKeyURL)
    end)

    local verify = CreateButton(
        window,
        "VERIFY",
        UDim2.fromOffset(210, 120)
    )

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -30, 0, 35)
    status.Position = UDim2.fromOffset(15, 175)
    status.BackgroundTransparency = 1
    status.Text = "Enter your key."
    status.TextColor3 = Color3.fromRGB(160, 160, 170)
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.Parent = window

    verify.MouseButton1Click:Connect(function()

        if input.Text == "" then
            status.Text = "Enter a key first."
            return
        end

        status.Text = "Verifying..."

        -- Replace this with SERVER-SIDE verification
        -- for your own Roblox experience.

        local valid = true

        if valid then
            Verified = true
            AccessType = "FREE"

            status.Text = "Verified!"

            task.wait(0.3)

            gui:Destroy()
            StartHub()
        else
            status.Text = "Invalid key."
        end
    end)
end

--==================================================
-- START
--==================================================

CreateKeyGui()
