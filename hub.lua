```lua
--==================================================
-- SCRIPT HUB - HUB.LUA
--==================================================

local Hub = {}

--==================================================
-- START
--==================================================

function Hub.Start(Data)

    Data = Data or {}

    local AccessType =
        Data.AccessType or "FREE"

    local Players =
        game:GetService("Players")

    local Player =
        Data.Player or Players.LocalPlayer

    local PlayerGui =
        Player:WaitForChild("PlayerGui")

    --==================================================
    -- MODULES
    --==================================================

    local Root = script.Parent

    local Components =
        require(Root.UI.Components)

    local Drag =
        require(Root.UI.Drag)

    local Panel =
        require(Root.UI.Panel)

    local Speed =
        require(Root.Scripts.Speed)

    local Fly =
        require(Root.Scripts.Fly)

    local Noclip =
        require(Root.Scripts.Noclip)

    local UnlimitedJump =
        require(Root.Scripts.UnlimitedJump)

    local ClickTeleport =
        require(Root.Scripts.ClickTeleport)

    local ESP =
        require(Root.Scripts.ESP)

    --==================================================
    -- SCREEN GUI
    --==================================================

    local ScreenGui =
        Instance.new("ScreenGui")

    ScreenGui.Name =
        "ScriptHub"

    ScreenGui.ResetOnSpawn =
        false

    ScreenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    ScreenGui.Parent =
        PlayerGui

    --==================================================
    -- MAIN WINDOW
    --==================================================

    local HubWindow =
        Panel.Create(
            ScreenGui,
            "◉  SCRIPT HUB",
            UDim2.fromOffset(850, 550)
        )

    Drag.MakeDraggable(
        HubWindow.Window,
        HubWindow.TitleBar
    )

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar =
        Instance.new("Frame")

    Sidebar.Name =
        "Sidebar"

    Sidebar.Size =
        UDim2.new(
            0,
            150,
            1,
            -48
        )

    Sidebar.Position =
        UDim2.fromOffset(0, 48)

    Sidebar.BackgroundColor3 =
        Components.Theme.Background

    Sidebar.BorderSizePixel =
        0

    Sidebar.Parent =
        HubWindow.Window

    local SidebarLayout =
        Instance.new("UIListLayout")

    SidebarLayout.Padding =
        UDim.new(0, 5)

    SidebarLayout.HorizontalAlignment =
        Enum.HorizontalAlignment.Center

    SidebarLayout.SortOrder =
        Enum.SortOrder.LayoutOrder

    SidebarLayout.Parent =
        Sidebar

    local SidebarPadding =
        Instance.new("UIPadding")

    SidebarPadding.PaddingTop =
        UDim.new(0, 15)

    SidebarPadding.PaddingLeft =
        UDim.new(0, 8)

    SidebarPadding.PaddingRight =
        UDim.new(0, 8)

    SidebarPadding.Parent =
        Sidebar

    --==================================================
    -- PAGE CONTAINER
    --==================================================

    local Pages =
        Instance.new("Frame")

    Pages.Name =
        "Pages"

    Pages.Size =
        UDim2.new(
            1,
            -170,
            1,
            -68
        )

    Pages.Position =
        UDim2.fromOffset(160, 58)

    Pages.BackgroundTransparency =
        1

    Pages.Parent =
        HubWindow.Window

    --==================================================
    -- PAGE CREATOR
    --==================================================

    local pageObjects = {}

    local function CreatePage(Name)

        local Page =
            Instance.new("ScrollingFrame")

        Page.Name =
            Name

        Page.Size =
            UDim2.fromScale(1, 1)

        Page.BackgroundTransparency =
            1

        Page.BorderSizePixel =
            0

        Page.ScrollBarThickness =
            4

        Page.CanvasSize =
            UDim2.new(0, 0, 0, 0)

        Page.Visible =
            false

        Page.Parent =
            Pages

        local Layout =
            Instance.new("UIListLayout")

        Layout.Padding =
            UDim.new(0, 10)

        Layout.SortOrder =
            Enum.SortOrder.LayoutOrder

        Layout.Parent =
            Page

        local Padding =
            Instance.new("UIPadding")

        Padding.PaddingRight =
            UDim.new(0, 10)

        Padding.PaddingBottom =
            UDim.new(0, 10)

        Padding.Parent =
            Page

        Layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function()

            Page.CanvasSize =
                UDim2.fromOffset(
                    0,
                    Layout.AbsoluteContentSize.Y + 20
                )

        end)

        pageObjects[Name] =
            Page

        return Page
    end

    --==================================================
    -- NAVIGATION
    --==================================================

    local function ShowPage(Name)

        for _, Page in pairs(pageObjects) do
            Page.Visible = false
        end

        if pageObjects[Name] then
            pageObjects[Name].Visible = true
        end
    end

    local function CreateNavButton(
        Text,
        PageName
    )

        local Button =
            Components.Button(
                Sidebar,
                Text,
                UDim2.new(
                    1,
                    -16,
                    0,
                    42
                )
            )

        Button.MouseButton1Click:Connect(
            function()
                ShowPage(PageName)
            end
        )

        return Button
    end

    --==================================================
    -- HOME
    --==================================================

    local Home =
        CreatePage("Home")

    local HomeTitle =
        Components.Label(
            Home,
            "HOME",
            UDim2.new(1, 0, 0, 35)
        )

    HomeTitle.TextSize = 20
    HomeTitle.Font =
        Enum.Font.GothamBold

    --==================================================
    -- PROFILE
    --==================================================

    local Profile =
        Components.Card(
            Home,
            UDim2.new(1, 0, 0, 100)
        )

    local Avatar =
        Instance.new("ImageLabel")

    Avatar.Size =
        UDim2.fromOffset(70, 70)

    Avatar.Position =
        UDim2.fromOffset(15, 15)

    Avatar.BackgroundTransparency =
        1

    local Image =
        Players:GetUserThumbnailAsync(
            Player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )

    Avatar.Image =
        Image

    Avatar.Parent =
        Profile

    Components.Label(
        Profile,
        Player.DisplayName,
        UDim2.new(1, -110, 0, 30),
        UDim2.fromOffset(100, 20)
    )

    Components.Label(
        Profile,
        "@" .. Player.Name,
        UDim2.new(1, -110, 0, 25),
        UDim2.fromOffset(100, 50)
    )

    Components.Label(
        Profile,
        "ID: " .. Player.UserId,
        UDim2.new(1, -110, 0, 20),
        UDim2.fromOffset(100, 75)
    )

    --==================================================
    -- ACCESS STATUS
    --==================================================

    local KeyDropdown =
        Components.Dropdown(
            Home,
            "⏱  KEY STATUS"
        )

    Components.Label(
        KeyDropdown,
        "Access: " .. tostring(AccessType),
        UDim2.new(1, -20, 0, 25),
        UDim2.fromOffset(10, 10)
    )

    --==================================================
    -- OTHER HOME SECTIONS
    --==================================================

    Components.Dropdown(
        Home,
        "💬  DISCORD"
    )

    Components.Dropdown(
        Home,
        "ℹ  DETAILS"
    )

    Components.Dropdown(
        Home,
        "📖  INFO"
    )

    --==================================================
    -- SCRIPTS PAGE
    --==================================================

    local ScriptsPage =
        CreatePage("Scripts")

    local ScriptsTitle =
        Components.Label(
            ScriptsPage,
            "📜  SCRIPTS",
            UDim2.new(1, 0, 0, 35)
        )

    ScriptsTitle.TextSize = 20
    ScriptsTitle.Font =
        Enum.Font.GothamBold

    Components.Dropdown(
        ScriptsPage,
        "⚡  MOVEMENT"
    )

    --==================================================
    -- SPEED
    --==================================================

    local SpeedCard =
        Components.Card(
            ScriptsPage,
            UDim2.new(1, 0, 0, 125)
        )

    Components.Label(
        SpeedCard,
        "Speed",
        UDim2.new(1, -30, 0, 25),
        UDim2.fromOffset(15, 5)
    )

    local SpeedInput =
        Components.Input(
            SpeedCard,
            "Speed",
            "16"
        )

    SpeedInput.Size =
        UDim2.fromOffset(100, 35)

    SpeedInput.Position =
        UDim2.fromOffset(15, 35)

    local SpeedSlider =
        Components.Slider(
            SpeedCard,
            1,
            250,
            16,
            function(Value)

                SpeedInput.Text =
                    tostring(Value)

                Speed.SetSpeed(Value)

            end
        )

    SpeedSlider.Container.Size =
        UDim2.new(1, -140, 0, 75)

    SpeedSlider.Container.Position =
        UDim2.fromOffset(125, 25)

    local SpeedDefault =
        Components.DefaultButton(
            SpeedCard,
            function()

                SpeedInput.Text = "16"

                SpeedSlider.Set(16)

                Speed.SetSpeed(16)

            end
        )

    SpeedDefault.Position =
        UDim2.new(1, -115, 1, -42)

    --==================================================
    -- NOCLIP
    --==================================================

    Components.Checkbox(
        ScriptsPage,
        "Noclip",
        false,
        function(Enabled)

            if Enabled then
                Noclip.Enable(Player)
            else
                Noclip.Disable(Player)
            end

        end
    )

    --==================================================
    -- FLY
    --==================================================

    Components.Checkbox(
        ScriptsPage,
        "Fly",
        false,
        function(Enabled)

            if Enabled then
                Fly.Enable(Player)
            else
                Fly.Disable(Player)
            end

        end
    )

    --==================================================
    -- UNLIMITED JUMP
    --==================================================

    Components.Checkbox(
        ScriptsPage,
        "Unlimited Jump",
        false,
        function(Enabled)

            if Enabled then
                UnlimitedJump.Enable(Player)
            else
                UnlimitedJump.Disable(Player)
            end

        end
    )

    --==================================================
    -- CLICK TELEPORT
    --==================================================

    Components.Checkbox(
        ScriptsPage,
        "Click Teleport",
        false,
        function(Enabled)

            if Enabled then
                ClickTeleport.Enable()
            else
                ClickTeleport.Disable()
            end

        end
    )

    --==================================================
    -- ESP
    --==================================================

    Components.Dropdown(
        ScriptsPage,
        "👁  VISUALS"
    )

    Components.Checkbox(
        ScriptsPage,
        "ESP",
        false,
        function(Enabled)

            if Enabled then
                ESP.Enable()
            else
                ESP.Disable()
            end

        end
    )

    Components.Checkbox(
        ScriptsPage,
        "ESP Name",
        true,
        function(Enabled)
            ESP.SetName(Enabled)
        end
    )

    Components.Checkbox(
        ScriptsPage,
        "ESP Distance",
        true,
        function(Enabled)
            ESP.SetDistance(Enabled)
        end
    )

    Components.Checkbox(
        ScriptsPage,
        "ESP Health",
        true,
        function(Enabled)
            ESP.SetHealth(Enabled)
        end
    )

    --==================================================
    -- SETTINGS
    --==================================================

    local Settings =
        CreatePage("Settings")

    local SettingsTitle =
        Components.Label(
            Settings,
            "⚙  SETTINGS",
            UDim2.new(1, 0, 0, 35)
        )

    SettingsTitle.TextSize = 20
    SettingsTitle.Font =
        Enum.Font.GothamBold

    Components.Dropdown(
        Settings,
        "🎨  APPEARANCE"
    )

    Components.Dropdown(
        Settings,
        "🖥  INTERFACE"
    )

    --==================================================
    -- ADMIN PANEL
    --==================================================

    if AccessType == "ADMIN" then

        Components.Dropdown(
            Settings,
            "🛡  ADMIN"
        )

        local AdminButton =
            Components.Button(
                Settings,
                "🛡  ADMIN PANEL",
                UDim2.new(1, 0, 0, 42)
            )

        AdminButton.MouseButton1Click:Connect(
            function()

                print(
                    "[Admin] Admin Panel opened."
                )

                -- Connect your authorized
                -- AdminPanel module here.

            end
        )

    end

    --==================================================
    -- NAVIGATION BUTTONS
    --==================================================

    CreateNavButton(
        "🏠  HOME",
        "Home"
    )

    CreateNavButton(
        "📜  SCRIPTS",
        "Scripts"
    )

    CreateNavButton(
        "⚙  SETTINGS",
        "Settings"
    )

    --==================================================
    -- DEFAULT PAGE
    --==================================================

    Home.Visible = true

    --==================================================
    -- FLOATING TOGGLE
    --==================================================

    local ToggleButton =
        Instance.new("TextButton")

    ToggleButton.Name =
        "HubToggle"

    ToggleButton.Size =
        UDim2.fromOffset(55, 55)

    ToggleButton.Position =
        UDim2.fromOffset(20, 200)

    ToggleButton.BackgroundColor3 =
        Components.Theme.Card

    ToggleButton.BorderSizePixel = 0

    ToggleButton.Text = "◉"

    ToggleButton.TextColor3 =
        Components.Theme.Text

    ToggleButton.TextSize = 22

    ToggleButton.Font =
        Enum.Font.GothamBold

    ToggleButton.Parent =
        ScreenGui

    Components.Corner(
        ToggleButton,
        28
    )

    Components.Stroke(
        ToggleButton
    )

    Drag.MakeDraggable(
        ToggleButton
    )

    ToggleButton.MouseButton1Click:Connect(
        function()

            HubWindow.Window.Visible =
                not HubWindow.Window.Visible

        end
    )

    print(
        "[ScriptHub] Loaded:",
        AccessType
    )

    return {
        Gui = ScreenGui,
        Window = HubWindow,
        AccessType = AccessType
    }

end

return Hub
```

