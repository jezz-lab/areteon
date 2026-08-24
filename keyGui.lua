local KeyGui = {}

function KeyGui.Start(Data)

    local Player = Data.Player
    local OnVerified = Data.OnVerified

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "KeySystem"
    Gui.ResetOnSpawn = false
    Gui.Parent = Player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(420, 230)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -115)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -30, 0, 40)
    Title.Position = UDim2.fromOffset(15, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "KEY SYSTEM"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -30, 0, 40)
    Input.Position = UDim2.fromOffset(15, 60)
    Input.PlaceholderText = "Enter key"
    Input.Text = ""
    Input.TextColor3 = Color3.new(1, 1, 1)
    Input.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Input.BorderSizePixel = 0
    Input.Parent = Frame

    local Verify = Instance.new("TextButton")
    Verify.Size = UDim2.new(1, -30, 0, 40)
    Verify.Position = UDim2.fromOffset(15, 115)
    Verify.Text = "VERIFY"
    Verify.TextColor3 = Color3.new(1, 1, 1)
    Verify.BackgroundColor3 = Color3.fromRGB(70, 100, 220)
    Verify.BorderSizePixel = 0
    Verify.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -30, 0, 30)
    Status.Position = UDim2.fromOffset(15, 170)
    Status.BackgroundTransparency = 1
    Status.Text = "Enter your key."
    Status.TextColor3 = Color3.fromRGB(170, 170, 180)
    Status.Parent = Frame

    Verify.MouseButton1Click:Connect(function()

        local Key = Input.Text

        if Key == "" then
            Status.Text = "Enter a key first."
            return
        end

        Status.Text = "Verifying..."

        -- Perform your server-side/Panda Auth
        -- verification here.

        -- Example successful result:
        local Success = true
        local AccessType = "FREE"

        if Success then

            Status.Text = "Verified."

            task.wait(0.3)

            Gui:Destroy()

            OnVerified(AccessType)

        else
            Status.Text = "Invalid key."
        end
    end)
end

return KeyGui
