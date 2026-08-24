local Hub = {}

function Hub.Start(Data)
    Data = Data or {}

    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local Player = Data.Player or Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local AccessType = Data.AccessType or "FREE"

    -- Remove previous GUI
    local old = PlayerGui:FindFirstChild("AreteonHub")
    if old then
        old:Destroy()
    end

    --==================================================
    -- GUI
    --==================================================

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AreteonHub"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(650, 420)
    Main.Position = UDim2.new(0.5, -325, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Main.BorderSizePixel = 0
    Main.Parent = Gui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(70, 70, 80)
    Stroke.Parent = Main

    --==================================================
    -- TITLE BAR
    --==================================================

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.fromOffset(15, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "◉  ARETEON"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    --==================================================
    -- DRAG
    --==================================================

    local dragging = false
    local dragStart
    local startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -45)
    Sidebar.Position = UDim2.fromOffset(0, 45)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local function Button(parent, text, position, size)
        local b = Instance.new("TextButton")
        b.Size = size or UDim2.new(1, -20, 0, 40)
        b.Position = position or UDim2.fromOffset(10, 0)
        b.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        b.BorderSizePixel = 0
        b.Text = text
        b.TextColor3 = Color3.fromRGB(235, 235, 235)
        b.TextSize = 14
        b.Font = Enum.Font.Gotham
        b.AutoButtonColor = true
        b.Parent = parent

        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

        return b
    end

    local HomeButton = Button(
        Sidebar,
        "🏠  HOME",
        UDim2.fromOffset(10, 15)
    )

    local ScriptsButton = Button(
        Sidebar,
        "📜  SCRIPTS",
        UDim2.fromOffset(10, 60)
    )

    local SettingsButton = Button(
        Sidebar,
        "⚙  SETTINGS",
        UDim2.fromOffset(10, 105)
    )

    --==================================================
    -- PAGES
    --==================================================

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -155, 1, -60)
    Pages.Position = UDim2.fromOffset(150, 55)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Main

    local function Page()
        local p = Instance.new("ScrollingFrame")
        p.Size = UDim2.fromScale(1, 1)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ScrollBarThickness = 4
        p.CanvasSize = UDim2.fromOffset(0, 0)
        p.Visible = false
        p.Parent = Pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.Parent = p

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = p

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            p.CanvasSize = UDim2.fromOffset(
                0,
                layout.AbsoluteContentSize.Y + 20
            )
        end)

        return p
    end

    local Home = Page()
    local Scripts = Page()
    local Settings = Page()

    local function Show(page)
        Home.Visible = false
        Scripts.Visible = false
        Settings.Visible = false

        page.Visible = true
    end

    HomeButton.MouseButton1Click:Connect(function()
        Show(Home)
    end)

    ScriptsButton.MouseButton1Click:Connect(function()
        Show(Scripts)
    end)

    SettingsButton.MouseButton1Click:Connect(function()
        Show(Settings)
    end)

    --==================================================
    -- LABEL
    --==================================================

    local function Label(parent, text, height)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, height or 35)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.TextSize = 20
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = parent

        return l
    end

    --==================================================
    -- HOME
    --==================================================

    Label(Home, "HOME")

    local Welcome = Instance.new("TextLabel")
    Welcome.Size = UDim2.new(1, 0, 0, 60)
    Welcome.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    Welcome.Text =
        "Welcome, " .. Player.DisplayName ..
        "\nAccess: " .. tostring(AccessType)
    Welcome.TextColor3 = Color3.fromRGB(235, 235, 235)
    Welcome.TextSize = 15
    Welcome.Font = Enum.Font.Gotham
    Welcome.TextWrapped = true
    Welcome.Parent = Home

    Instance.new("UICorner", Welcome).CornerRadius = UDim.new(0, 8)

    --==================================================
    -- SPEED
    --==================================================

    Label(Scripts, "📜  SCRIPTS")

    local SpeedFrame = Instance.new("Frame")
    SpeedFrame.Size = UDim2.new(1, 0, 0, 100)
    SpeedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    SpeedFrame.BorderSizePixel = 0
    SpeedFrame.Parent = Scripts

    Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 8)

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0, 100, 0, 35)
    SpeedLabel.Position = UDim2.fromOffset(10, 10)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "WalkSpeed"
    SpeedLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
    SpeedLabel.TextSize = 14
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.Parent = SpeedFrame

    local SpeedInput = Instance.new("TextBox")
    SpeedInput.Size = UDim2.fromOffset(100, 35)
    SpeedInput.Position = UDim2.fromOffset(115, 10)
    SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SpeedInput.BorderSizePixel = 0
    SpeedInput.Text = "16"
    SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedInput.TextSize = 14
    SpeedInput.Font = Enum.Font.Gotham
    SpeedInput.ClearTextOnFocus = false
    SpeedInput.Parent = SpeedFrame

    Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 6)

    local ApplySpeed = Button(
        SpeedFrame,
        "APPLY",
        UDim2.fromOffset(225, 10),
        UDim2.fromOffset(100, 35)
    )

    local DefaultSpeed = Button(
        SpeedFrame,
        "DEFAULT",
        UDim2.fromOffset(335, 10),
        UDim2.fromOffset(100, 35)
    )

    local function SetSpeed(value)
        local character = Player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end

    ApplySpeed.MouseButton1Click:Connect(function()
        local value = tonumber(SpeedInput.Text)

        if value then
            value = math.clamp(value, 1, 250)
            SpeedInput.Text = tostring(value)
            SetSpeed(value)
        end
    end)

    DefaultSpeed.MouseButton1Click:Connect(function()
        SpeedInput.Text = "16"
        SetSpeed(16)
    end)

    --==================================================
    -- NOCLIP
    --==================================================

    local NoclipButton = Button(
        Scripts,
        "Noclip: OFF",
        nil,
        UDim2.new(1, 0, 0, 42)
    )

    local Noclip = false

    NoclipButton.MouseButton1Click:Connect(function()
        Noclip = not Noclip

        NoclipButton.Text =
            "Noclip: " .. (Noclip and "ON" or "OFF")
    end)

    RunService.Stepped:Connect(function()
        if not Noclip then return end

        local character = Player.Character
        if not character then return end

        for _, object in ipairs(character:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false
            end
        end
    end)

    --==================================================
    -- INFINITE JUMP
    --==================================================

    local InfiniteButton = Button(
        Scripts,
        "Infinite Jump: OFF",
        nil,
        UDim2.new(1, 0, 0, 42)
    )

    local InfiniteJump = false

    InfiniteButton.MouseButton1Click:Connect(function()
        InfiniteJump = not InfiniteJump

        InfiniteButton.Text =
            "Infinite Jump: " ..
            (InfiniteJump and "ON" or "OFF")
    end)

    UIS.JumpRequest:Connect(function()
        if not InfiniteJump then return end

        local character = Player.Character
        if not character then return end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end)

    --==================================================
    -- SETTINGS
    --==================================================

    Label(Settings, "⚙  SETTINGS")

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, 0, 0, 80)
    Info.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    Info.Text =
        "Areteon Script Hub\n" ..
        "Access: " .. tostring(AccessType) ..
        "\nPlayer: " .. Player.Name
    Info.TextColor3 = Color3.fromRGB(235, 235, 235)
    Info.TextSize = 14
    Info.Font = Enum.Font.Gotham
    Info.TextWrapped = true
    Info.Parent = Settings

    Instance.new("UICorner", Info).CornerRadius = UDim.new(0, 8)

    --==================================================
    -- FLOATING TOGGLE
    --==================================================

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.fromOffset(55, 55)
    Toggle.Position = UDim2.fromOffset(20, 200)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    Toggle.BorderSizePixel = 0
    Toggle.Text = "◉"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextSize = 22
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Parent = Gui

    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

    Toggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    Show(Home)

    print("[Areteon] Hub loaded:", AccessType)

    return {
        Gui = Gui,
        Window = Main,
        AccessType = AccessType
    }
end

return Hub
