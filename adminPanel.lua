local AdminPanel = {}

function AdminPanel.Open(Player)
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local old = PlayerGui:FindFirstChild("AdminPanel")

    if old then
        old:Destroy()
    end

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AdminPanel"
    Gui.ResetOnSpawn = false
    Gui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(500, 350)
    Frame.Position = UDim2.new(0.5, -250, 0.5, -175)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 45)
    Title.Position = UDim2.fromOffset(10, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "🛡 ADMIN PANEL"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -30, 0, 100)
    Info.Position = UDim2.fromOffset(15, 60)
    Info.BackgroundTransparency = 1
    Info.Text =
        "Administrator controls\n\n" ..
        "Server-side authorization is required."
    Info.TextColor3 = Color3.fromRGB(200, 200, 210)
    Info.TextSize = 14
    Info.TextWrapped = true
    Info.Parent = Frame

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(120, 38)
    Close.Position = UDim2.new(0.5, -60, 1, -55)
    Close.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Close.BorderSizePixel = 0
    Close.Text = "CLOSE"
    Close.TextColor3 = Color3.new(1, 1, 1)
    Close.TextSize = 14
    Close.Font = Enum.Font.GothamBold
    Close.Parent = Frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = Close

    Close.MouseButton1Click:Connect(function()
        Gui:Destroy()
    end)

    return Gui
end

return AdminPanel
