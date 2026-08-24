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

local SCRIPT_PATH = "Pages/Scripts.lua"

local Connections = {}

--==================================================
-- HELPERS
--==================================================

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

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
end

--==================================================
-- HTTP
--==================================================

local function Download(path)
    local success, result = pcall(function()
        return game:HttpGet(BASE_URL .. path)
    end)

    if not success then
        return nil, tostring(result)
    end

    if type(result) ~= "string" or #result == 0 then
        return nil, "Empty response"
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
-- DRAG
--==================================================

local function MakeDraggable(frame, handle)

    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)

        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or
            input.UserInputType == Enum.UserInputType.Touch
        then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            local changed

            changed = input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false

                    if changed then
                        changed:Disconnect()
                    end
                end

            end)
        end

    end)

    local connection =
        UserInputService.InputChanged:Connect(function(input)

            if not dragging then
                return
            end

            if
                input.UserInputType ~= Enum.UserInputType.MouseMovement
                and
                input.UserInputType ~= Enum.UserInputType.Touch
            then
                return
            end

            local delta =
                input.Position - dragStart

            frame.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,

                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )

        end)

    table.insert(Connections, connection)
end

--==================================================
-- PAGE BUTTON
--==================================================

local function CreatePageButton(parent, name)

    local button =
        Create("TextButton", {

            Name = name .. "Button",

            Size =
                UDim2.new(
                    1,
                    -16,
                    0,
                    40
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    30,
                    30,
                    38
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.GothamMedium,

            Text = name,

            TextColor3 =
                Color3.fromRGB(
                    215,
                    215,
                    220
                ),

            TextSize = 13,

            AutoButtonColor = true

        }, parent)

    Corner(button, 7)

    return button
end

--==================================================
-- GUI
--==================================================

local function CreateGui()

    local PlayerGui =
        LocalPlayer:WaitForChild("PlayerGui")

    local old =
        PlayerGui:FindFirstChild("Areteon")

    if old then
        old:Destroy()
    end

    local Gui =
        Create("ScreenGui", {

            Name = "Areteon",

            ResetOnSpawn = false,

            ZIndexBehavior =
                Enum.ZIndexBehavior.Sibling

        }, PlayerGui)

    --==================================================
    -- MAIN
    --==================================================

    local Main =
        Create("Frame", {

            Name = "Main",

            AnchorPoint =
                Vector2.new(0.5, 0.5),

            Position =
                UDim2.new(
                    0.5,
                    0,
                    0.5,
                    0
                ),

            Size =
                UDim2.new(
                    0,
                    760,
                    0,
                    500
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    15,
                    15,
                    19
                ),

            BorderSizePixel = 0

        }, Gui)

    Corner(Main, 12)

    --==================================================
    -- TOP BAR
    --==================================================

    local TopBar =
        Create("Frame", {

            Name = "TopBar",

            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    48
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    20,
                    20,
                    25
                ),

            BorderSizePixel = 0

        }, Main)

    Corner(TopBar, 12)

    Create("TextLabel", {

        BackgroundTransparency = 1,

        Position =
            UDim2.new(
                0,
                15,
                0,
                0
            ),

        Size =
            UDim2.new(
                1,
                -65,
                1,
                0
            ),

        Font =
            Enum.Font.GothamBold,

        Text = "ARETEON",

        TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        TextSize = 17,

        TextXAlignment =
            Enum.TextXAlignment.Left

    }, TopBar)

    --==================================================
    -- CLOSE
    --==================================================

    local Close =
        Create("TextButton", {

            Name = "Close",

            BackgroundTransparency = 1,

            Position =
                UDim2.new(
                    1,
                    -45,
                    0,
                    7
                ),

            Size =
                UDim2.new(
                    0,
                    35,
                    0,
                    34
                ),

            Font =
                Enum.Font.GothamBold,

            Text = "×",

            TextColor3 =
                Color3.fromRGB(
                    230,
                    230,
                    235
                ),

            TextSize = 23

        }, TopBar)

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar =
        Create("Frame", {

            Name = "Sidebar",

            Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    48
                ),

            Size =
                UDim2.new(
                    0,
                    155,
                    1,
                    -48
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    19,
                    19,
                    24
                ),

            BorderSizePixel = 0

        }, Main)

    Create("UIPadding", {

        PaddingTop =
            UDim.new(0, 12),

        PaddingBottom =
            UDim.new(0, 12),

        PaddingLeft =
            UDim.new(0, 8),

        PaddingRight =
            UDim.new(0, 8)

    }, Sidebar)

    Create("UIListLayout", {

        Padding =
            UDim.new(0, 7),

        SortOrder =
            Enum.SortOrder.LayoutOrder

    }, Sidebar)

    --==================================================
    -- SCROLLABLE CONTENT
    --==================================================

    local ContentScroll =
        Create("ScrollingFrame", {

            Name = "ContentScroll",

            Position =
                UDim2.new(
                    0,
                    155,
                    0,
                    48
                ),

            Size =
                UDim2.new(
                    1,
                    -155,
                    1,
                    -48
                ),

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            ClipsDescendants = true,

            CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                ),

            AutomaticCanvasSize =
                Enum.AutomaticSize.Y,

            ScrollingDirection =
                Enum.ScrollingDirection.Y,

            ScrollBarThickness = 6,

            ScrollBarImageTransparency = 0.15,

            VerticalScrollBarInset =
                Enum.ScrollBarInset.ScrollBar,

            ScrollingEnabled = true,

            ElasticBehavior =
                Enum.ElasticBehavior.Always

        }, Main)

    --==================================================
    -- PAGE CONTAINER
    --==================================================

    local Content =
        Create("Frame", {

            Name = "Content",

            Size =
                UDim2.new(
                    1,
                    -8,
                    0,
                    0
                ),

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            AutomaticSize =
                Enum.AutomaticSize.Y

        }, ContentScroll)

    --==================================================
    -- FLOATING ICON
    --==================================================

    local Icon =
        Create("TextButton", {

            Name = "ToggleIcon",

            AnchorPoint =
                Vector2.new(
                    0.5,
                    0.5
                ),

            Position =
                UDim2.new(
                    0,
                    70,
                    0.5,
                    0
                ),

            Size =
                UDim2.new(
                    0,
                    56,
                    0,
                    56
                ),

            BackgroundColor3 =
                Color3.fromRGB(
                    25,
                    25,
                    32
                ),

            BorderSizePixel = 0,

            Font =
                Enum.Font.GothamBold,

            Text = "A",

            TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            TextSize = 20,

            ZIndex = 100,

            AutoButtonColor = true

        }, Gui)

    Corner(Icon, 28)

    local stroke =
        Instance.new("UIStroke")

    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Parent = Icon

    return
        Gui,
        Main,
        TopBar,
        Sidebar,
        Content,
        ContentScroll,
        Icon,
        Close
end

--==================================================
-- DESTROY
--==================================================

local function DestroyHub(state)

    if not state or state.Destroyed then
        return
    end

    state.Destroyed = true

    for _, connection in
        ipairs(Connections)
    do

        pcall(function()
            connection:Disconnect()
        end)

    end

    table.clear(Connections)

    if state.Gui then

        pcall(function()
            state.Gui:Destroy()
        end)

    end

    Hub.Gui = nil
    Hub.State = nil

    print(
        "[Areteon] Hub terminated."
    )
end

--==================================================
-- LOAD PAGE
--==================================================

local function LoadPage(
    name,
    path,
    state
)

    local module, errorMessage =
        LoadModule(path)

    if not module then

        warn(
            "[Areteon] " ..
            name ..
            " failed:"
        )

        warn(errorMessage)

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
            ".Start() is missing."
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
            " error:"
        )

        warn(page)

        return nil
    end

    if not page then

        warn(
            "[Areteon] " ..
            name ..
            " returned nil."
        )

        return nil
    end

    if not page:IsA("GuiObject") then

        warn(
            "[Areteon] " ..
            name ..
            " must return a GuiObject."
        )

        return nil
    end

    page.Visible = false

    return page
end

--==================================================
-- START
--==================================================

function Hub.Start(options)

    options = options or {}

    local
        Gui,
        Main,
        TopBar,
        Sidebar,
        Content,
        ContentScroll,
        Icon,
        Close =
        CreateGui()

    local state = {

        Player =
            options.Player or
            LocalPlayer,

        AccessType =
            options.AccessType or
            "USER",

        IsAdmin =
            options.IsAdmin == true,

        IsException =
            options.IsException == true,

        Gui = Gui,

        Main = Main,

        TopBar = TopBar,

        Sidebar = Sidebar,

        Content = Content,

        ContentScroll =
            ContentScroll,

        Icon = Icon,

        Pages = {},

        Buttons = {},

        CurrentPage = nil,

        Destroyed = false
    }

    --==================================================
    -- MAIN DRAG
    --==================================================

    MakeDraggable(
        Main,
        TopBar
    )

    --==================================================
    -- ICON DRAG
    --==================================================

    MakeDraggable(
        Icon,
        Icon
    )

    --==================================================
    -- ICON TOGGLE
    --==================================================

    Icon.MouseButton1Click:Connect(
        function()

            if state.Destroyed then
                return
            end

            Main.Visible =
                not Main.Visible

        end
    )

    --==================================================
    -- CLOSE
    --==================================================

    Close.MouseButton1Click:Connect(
        function()

            DestroyHub(state)

        end
    )

    --==================================================
    -- LOAD PAGES
    --==================================================

    for name, path in
        pairs(PAGE_PATHS)
    do

        local page =
            LoadPage(
                name,
                path,
                state
            )

        if page then

            state.Pages[name] =
                page

        end

    end

    --==================================================
    -- OPTIONAL SCRIPTS
    --==================================================

    local scriptSource =
        Download(SCRIPT_PATH)

    if scriptSource then

        local fn, compileError =
            loadstring(scriptSource)

        if fn then

            local success, module =
                pcall(fn)

            if
                success
                and
                type(module) == "table"
                and
                type(module.Start) == "function"
            then

                local ok, page =
                    pcall(function()

                        return module.Start(state)

                    end)

                if
                    ok
                    and
                    page
                    and
                    page:IsA("GuiObject")
                then

                    page.Name = "Scripts"

                    page.Visible = false

                    state.Pages.Scripts =
                        page

                    print(
                        "[Areteon] Scripts loaded."
                    )

                end

            end

        else

            warn(
                "[Areteon] Scripts compile error:"
            )

            warn(compileError)

        end

    else

        print(
            "[Areteon] Scripts.lua not found. Skipping."
        )

    end

    --==================================================
    -- SIDEBAR BUTTONS
    --==================================================

    local pageOrder = {
        "Home",
        "Player",
        "Scripts",
        "Settings"
    }

    for _, name in
        ipairs(pageOrder)
    do

        local page =
            state.Pages[name]

        if page then

            local button =
                CreatePageButton(
                    Sidebar,
                    name
                )

            state.Buttons[name] =
                button

            button.MouseButton1Click:Connect(
                function()

                    if state.Destroyed then
                        return
                    end

                    for _, otherPage in
                        pairs(state.Pages)
                    do

                        otherPage.Visible =
                            false

                    end

                    for _, otherButton in
                        pairs(state.Buttons)
                    do

                        otherButton.BackgroundColor3 =
                            Color3.fromRGB(
                                30,
                                30,
                                38
                            )

                    end

                    page.Visible = true

                    ContentScroll.CanvasPosition =
                        Vector2.new(
                            0,
                            0
                        )

                    button.BackgroundColor3 =
                        Color3.fromRGB(
                            45,
                            45,
                            58
                        )

                    state.CurrentPage =
                        name

                end
            )

        end

    end

    --==================================================
    -- DEFAULT HOME
    --==================================================

    if state.Pages.Home then

        for _, page in
            pairs(state.Pages)
        do

            page.Visible = false

        end

        state.Pages.Home.Visible = true

        state.CurrentPage = "Home"

        if state.Buttons.Home then

            state.Buttons.Home.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    58
                )

        end

    end

    Hub.Gui = Gui
    Hub.State = state

    print(
        "[Areteon] Hub started."
    )

    return state
end

return Hub
