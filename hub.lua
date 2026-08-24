--==================================================
-- ARETEON | hub.lua
--==================================================

local Hub = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local BASE_URL =
    "https://raw.githubusercontent.com/" ..
    "jezz-lab/areteon/main/"

local PAGE_PATHS = {
    Home = "Pages/Home.lua",
    Player = "Pages/Player.lua",
    Settings = "Pages/Settings.lua",
}

local OPTIONAL_SCRIPTS =
    "Pages/Scripts.lua"

--==================================================
-- DOWNLOAD
--==================================================

local function Download(path)
    local success, result = pcall(function()
        return game:HttpGet(BASE_URL .. path)
    end)

    if not success then
        return nil, tostring(result)
    end

    if type(result) ~= "string" or #result == 0 then
        return nil, "empty response"
    end

    return result
end

--==================================================
-- MODULE LOADER
--==================================================

local function LoadModule(path)
    local source, errorMessage = Download(path)

    if not source then
        return nil, errorMessage
    end

    local fn, compileError = loadstring(source)

    if not fn then
        return nil, compileError
    end

    local success, result = pcall(fn)

    if not success then
        return nil, result
    end

    return result
end

--==================================================
-- GUI HELPERS
--==================================================

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
end

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

--==================================================
-- PAGE BUTTON
--==================================================

local function CreatePageButton(parent, name)
    local button = Create("TextButton", {
        Name = name .. "Button",
        BackgroundColor3 =
            Color3.fromRGB(30, 30, 38),

        BorderSizePixel = 0,

        Size = UDim2.new(1, -16, 0, 42),

        Font = Enum.Font.GothamMedium,

        Text = name,

        TextColor3 =
            Color3.fromRGB(210, 210, 215),

        TextSize = 13,

        AutoButtonColor = true
    }, parent)

    Corner(button, 7)

    return button
end

--==================================================
-- CREATE HUB
--==================================================

local function CreateHubGui()
    local PlayerGui =
        LocalPlayer:WaitForChild("PlayerGui")

    local old =
        PlayerGui:FindFirstChild("Areteon")

    if old then
        old:Destroy()
    end

    local Gui = Create("ScreenGui", {
        Name = "Areteon",
        ResetOnSpawn = false,
        ZIndexBehavior =
            Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    --==================================================
    -- MAIN
    --==================================================

    local Main = Create("Frame", {
        Name = "Main",

        AnchorPoint =
            Vector2.new(0.5, 0.5),

        Position =
            UDim2.new(0.5, 0, 0.5, 0),

        Size =
            UDim2.new(0, 760, 0, 500),

        BackgroundColor3 =
            Color3.fromRGB(15, 15, 19),

        BorderSizePixel = 0
    }, Gui)

    Corner(Main, 12)

    --==================================================
    -- TOP BAR
    --==================================================

    local TopBar = Create("Frame", {
        Name = "TopBar",

        Size =
            UDim2.new(1, 0, 0, 48),

        BackgroundColor3 =
            Color3.fromRGB(20, 20, 25),

        BorderSizePixel = 0
    }, Main)

    Corner(TopBar, 12)

    Create("TextLabel", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(0, 15, 0, 0),

        Size =
            UDim2.new(1, -70, 1, 0),

        Font =
            Enum.Font.GothamBold,

        Text = "ARETEON",

        TextColor3 =
            Color3.fromRGB(255, 255, 255),

        TextSize = 17,

        TextXAlignment =
            Enum.TextXAlignment.Left
    }, TopBar)

    local Close = Create("TextButton", {
        BackgroundTransparency = 1,

        Position =
            UDim2.new(1, -45, 0, 8),

        Size =
            UDim2.new(0, 35, 0, 32),

        Font =
            Enum.Font.GothamBold,

        Text = "×",

        TextColor3 =
            Color3.fromRGB(220, 220, 225),

        TextSize = 23
    }, TopBar)

    Close.MouseButton1Click:Connect(function()
        Gui.Enabled = false
    end)

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar = Create("Frame", {
        Name = "Sidebar",

        Position =
            UDim2.new(0, 0, 0, 48),

        Size =
            UDim2.new(0, 155, 1, -48),

        BackgroundColor3 =
            Color3.fromRGB(19, 19, 24),

        BorderSizePixel = 0
    }, Main)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    }, Sidebar)

    Create("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Sidebar)

    --==================================================
    -- CONTENT
    --==================================================

    local Content = Create("Frame", {
        Name = "Content",

        Position =
            UDim2.new(0, 155, 0, 48),

        Size =
            UDim2.new(1, -155, 1, -48),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ClipsDescendants = true
    }, Main)

    return Gui, Sidebar, Content
end

--==================================================
-- LOAD PAGE
--==================================================

local function LoadPage(name, path, state)
    print("[Areteon] Loading page:", name)

    local module, errorMessage =
        LoadModule(path)

    if not module then
        warn(
            "[Areteon] " ..
            name ..
            " failed: " ..
            tostring(errorMessage)
        )

        return nil
    end

    if type(module) ~= "table" then
        warn(
            "[Areteon] " ..
            name ..
            " did not return a table."
        )

        return nil
    end

    if type(module.Start) ~= "function" then
        warn(
            "[Areteon] " ..
            name ..
            ".Start does not exist."
        )

        return nil
    end

    local success, page =
        pcall(function()
            return module.Start(state)
        end)

    if not success then
        warn(
            "[Areteon] " ..
            name ..
            " failed:"
        )

        warn(page)

        return nil
    end

    if not page then
        warn(
            "[Areteon] " ..
            name ..
            " did not return a Frame."
        )

        return nil
    end

    page.Name = name
    page.Visible = false

    return page
end

--==================================================
-- START
--==================================================

function Hub.Start(options)

    options = options or {}

    local Gui, Sidebar, Content =
        CreateHubGui()

    local state = {
        Player =
            options.Player or LocalPlayer,

        AccessType =
            options.AccessType or "USER",

        IsAdmin =
            options.IsAdmin == true,

        IsException =
            options.IsException == true,

        Gui = Gui,

        Main = Gui.Main,

        Sidebar = Sidebar,

        Content = Content,

        Pages = {},

        CurrentPage = nil
    }

    --==================================================
    -- LOAD REQUIRED PAGES
    --==================================================

    for name, path in pairs(PAGE_PATHS) do

        local page =
            LoadPage(
                name,
                path,
                state
            )

        if page then
            state.Pages[name] = page
        end
    end

    --==================================================
    -- OPTIONAL SCRIPTS
    --==================================================

    local scriptSource =
        Download(OPTIONAL_SCRIPTS)

    if scriptSource then

        local fn =
            loadstring(scriptSource)

        if fn then

            local success, module =
                pcall(fn)

            if success and
                type(module) == "table" and
                type(module.Start) == "function" then

                local ok, page =
                    pcall(function()
                        return module.Start(state)
                    end)

                if ok and page then
                    page.Name = "Scripts"
                    page.Visible = false

                    state.Pages.Scripts = page

                    print(
                        "[Areteon] Scripts page loaded."
                    )
                end
            end
        end

    else

        print(
            "[Areteon] Scripts page not found. Skipping."
        )

    end

    --==================================================
    -- PAGE BUTTONS
    --==================================================

    local Buttons = {}

    for name, page in pairs(state.Pages) do

        local button =
            CreatePageButton(
                Sidebar,
                name
            )

        Buttons[name] = button

        button.MouseButton1Click:Connect(
            function()

                for _, otherPage in
                    pairs(state.Pages) do

                    otherPage.Visible = false
                end

                page.Visible = true

                state.CurrentPage = name

            end
        )
    end

    --==================================================
    -- DEFAULT PAGE
    --==================================================

    if state.Pages.Home then

        for _, page in
            pairs(state.Pages) do

            page.Visible = false

        end

        state.Pages.Home.Visible = true
        state.CurrentPage = "Home"

    else

        for name, page in
            pairs(state.Pages) do

            page.Visible = true
            state.CurrentPage = name

            break
        end
    end

    --==================================================
    -- DRAG
    --==================================================

    local dragging = false
    local dragStart
    local startPosition

    TopBar = Gui.Main.TopBar

    TopBar.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            dragging = true
            dragStart = input.Position
            startPosition = MainPosition(
                Gui.Main
            )
        end
    end)

    TopBar.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(
        function(input)

            if not dragging then
                return
            end

            if input.UserInputType ~=
                Enum.UserInputType.MouseMovement then

                return
            end

            local delta =
                input.Position - dragStart

            Gui.Main.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset +
                        delta.X,

                    startPosition.Y.Scale,
                    startPosition.Y.Offset +
                        delta.Y
                )
        end
    )

    Hub.Gui = Gui
    Hub.State = state

    print("[Areteon] Hub started.")

    return state
end

--==================================================
-- POSITION HELPER
--==================================================

function MainPosition(frame)
    return frame.Position
end

return Hub
