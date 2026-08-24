local AdminPanel = {}

function AdminPanel.Open(Player)

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AdminPanel"
    Gui.ResetOnSpawn = false
    Gui.Parent = Player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(500, 350)
    Frame.Position = UDim2.new(0.5, -250, 0.5, -175)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

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
        "Administrator controls belong here.\n\n" ..
        "Perform authorization checks on the server."
    Info.TextColor3 = Color3.fromRGB(200, 200, 210)
    Info.TextWrapped = true
    Info.Parent = Frame

    return Gui
end

return AdminPanel
