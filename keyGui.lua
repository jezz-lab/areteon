local KeyGui = {}

function KeyGui.Create(callbacks)

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "KeySystem"
    Gui.ResetOnSpawn = false
    Gui.Parent = game:GetService("CoreGui")

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.fromOffset(350, 40)
    Input.Position = UDim2.new(
        0.5, -175,
        0.5, -50
    )
    Input.PlaceholderText = "Enter Panda key..."
    Input.Text = ""
    Input.Parent = Gui

    local Verify = Instance.new("TextButton")
    Verify.Size = UDim2.fromOffset(160, 40)
    Verify.Position = UDim2.new(
        0.5, -165,
        0.5, 5
    )
    Verify.Text = "VERIFY"
    Verify.Parent = Gui

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.fromOffset(350, 40)
    Status.Position = UDim2.new(
        0.5, -175,
        0.5, 55
    )
    Status.BackgroundTransparency = 1
    Status.Text = "Enter your key."
    Status.Parent = Gui

    Verify.MouseButton1Click:Connect(function()

        local success, message =
            callbacks.OnVerify(Input.Text)

        Status.Text = message or "Unknown response."

        if success then
            Status.Text = "Verified!"

            if callbacks.OnSuccess then
                callbacks.OnSuccess(Input.Text)
            end
        end
    end)

    return {
        Destroy = function()
            Gui:Destroy()
        end
    }
end

return KeyGui
