local KeyGui = {}

function KeyGui.Create(callbacks)
    callbacks = callbacks or {}

    local CoreGui = game:GetService("CoreGui")

    local old = CoreGui:FindFirstChild("AreteonKeySystem")

    if old then
        old:Destroy()
    end

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AreteonKeySystem"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(420, 220)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

    Instance.new("UICorner", Frame).CornerRadius =
        UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -30, 0, 40)
    Title.Position = UDim2.fromOffset(15, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "◉  ARETEON"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -30, 0, 40)
    Input.Position = UDim2.fromOffset(15, 60)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    Input.BorderSizePixel = 0
    Input.PlaceholderText = "Enter key..."
    Input.Text = ""
    Input.TextColor3 = Color3.new(1, 1, 1)
    Input.TextSize = 14
    Input.Font = Enum.Font.Gotham
    Input.ClearTextOnFocus = false
    Input.Parent = Frame

    Instance.new("UICorner", Input).CornerRadius =
        UDim.new(0, 6)

    local Verify = Instance.new("TextButton")
    Verify.Size = UDim2.fromOffset(150, 38)
    Verify.Position = UDim2.fromOffset(15, 115)
    Verify.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    Verify.BorderSizePixel = 0
    Verify.Text = "VERIFY"
    Verify.TextColor3 = Color3.new(1, 1, 1)
    Verify.TextSize = 14
    Verify.Font = Enum.Font.GothamBold
    Verify.Parent = Frame

    Instance.new("UICorner", Verify).CornerRadius =
        UDim.new(0, 6)

    local GetKey = Instance.new("TextButton")
    GetKey.Size = UDim2.fromOffset(150, 38)
    GetKey.Position = UDim2.fromOffset(175, 115)
    GetKey.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    GetKey.BorderSizePixel = 0
    GetKey.Text = "GET KEY"
    GetKey.TextColor3 = Color3.new(1, 1, 1)
    GetKey.TextSize = 14
    GetKey.Font = Enum.Font.GothamBold
    GetKey.Parent = Frame

    Instance.new("UICorner", GetKey).CornerRadius =
        UDim.new(0, 6)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -30, 0, 35)
    Status.Position = UDim2.fromOffset(15, 165)
    Status.BackgroundTransparency = 1
    Status.Text = "Enter your key."
    Status.TextColor3 = Color3.fromRGB(200, 200, 210)
    Status.TextSize = 13
    Status.Font = Enum.Font.Gotham
    Status.Parent = Frame

    Verify.MouseButton1Click:Connect(function()
        if type(callbacks.OnVerify) ~= "function" then
            Status.Text = "Verification callback missing."
            return
        end

        Status.Text = "Checking..."

        local ok, success, message = pcall(
            callbacks.OnVerify,
            Input.Text
        )

        if not ok then
            Status.Text = "Verification error."
            warn("[Areteon] " .. tostring(success))
            return
        end

        Status.Text = message or "Unknown response."

        if success then
            Status.Text = "Verified!"

            if type(callbacks.OnSuccess) == "function" then
                callbacks.OnSuccess(Input.Text)
            end

            task.wait(0.25)
            Gui:Destroy()
        end
    end)

    GetKey.MouseButton1Click:Connect(function()
        local url = callbacks.GetKeyURL

        if url and setclipboard then
            pcall(setclipboard, url)
            Status.Text = "Key link copied."
        elseif url then
            Status.Text = url
        else
            Status.Text = "Key URL not configured."
        end
    end)

    return {
        Destroy = function()
            if Gui then
                Gui:Destroy()
            end
        end
    }
end

return KeyGui
