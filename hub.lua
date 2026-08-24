local Hub = {}

function Hub.Start(Data)

    local Player = Data.Player
    local AccessType = Data.AccessType

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "ScriptHub"
    Gui.ResetOnSpawn = false
    Gui.Parent = Player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(650, 450)
    Frame.Position = UDim2.new(0.5, -325, 0.5, -225)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 45)
    Title.Position = UDim2.fromOffset(10, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "◉ SCRIPT HUB"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -20, 0, 30)
    Status.Position = UDim2.fromOffset(10, 55)
    Status.BackgroundTransparency = 1
    Status.Text = "Access: " .. tostring(AccessType)
    Status.TextColor3 = Color3.fromRGB(180, 180, 190)
    Status.Parent = Frame

    if AccessType == "ADMIN" then

        local AdminButton = Instance.new("TextButton")

        AdminButton.Size =
            UDim2.fromOffset(200, 40)

        AdminButton.Position =
            UDim2.fromOffset(20, 100)

        AdminButton.Text =
            "🛡 ADMIN PANEL"

        AdminButton.TextColor3 =
            Color3.new(1, 1, 1)

        AdminButton.BackgroundColor3 =
            Color3.fromRGB(70, 100, 220)

        AdminButton.Parent =
            Frame

        AdminButton.MouseButton1Click:Connect(
            function()

                local AdminPanel =
                    require(script.Parent.AdminPanel)

                AdminPanel.Open(Player)

            end
        )
    end

    return Gui
end

return Hub
