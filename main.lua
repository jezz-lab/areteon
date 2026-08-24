--==================================================
-- ARETEON MAIN
--==================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local CONFIG = {

    LifetimeKey = "pandaq75z6fyyhx5sfddcqwup2ku9o",

    -- [UserId] = true
    Admins = {
        -- [123456789] = true,
        [8045408189] = true,
    },

    -- Manual exceptions
    -- [UserId] = "Label/Name"
    Exceptions = {
        -- [123456789] = "Tester",
    },

    -- Repository
    BaseURL =
        "https://raw.githubusercontent.com/" ..
        "jezz-lab/areteon/main/"
}

--==================================================
-- ACCESS
--==================================================

local function GetAccess()
    local userId = Player.UserId

    if CONFIG.Admins[userId] then
        return "ADMIN", true, false
    end

    if CONFIG.Exceptions[userId] then
        return "EXCEPTION", false, true
    end

    return "USER", false, false
end

local AccessType, IsAdmin, IsException =
    GetAccess()

--==================================================
-- LOAD MODULE
--==================================================

local function LoadModule(file)
    local url = CONFIG.BaseURL .. file

    local success, source = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        return nil,
            "Failed downloading " ..
            file .. ": " ..
            tostring(source)
    end

    local fn, compileError =
        loadstring(source)

    if not fn then
        return nil,
            "Failed compiling " ..
            file .. ": " ..
            tostring(compileError)
    end

    local executed, result =
        pcall(fn)

    if not executed then
        return nil,
            "Failed executing " ..
            file .. ": " ..
            tostring(result)
    end

    return result
end

--==================================================
-- KEY GUI
--==================================================

local function CreateKeyGUI()
    local old =
        CoreGui:FindFirstChild(
            "AreteonKeySystem"
        )

    if old then
        old:Destroy()
    end

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AreteonKeySystem"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling
    Gui.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size =
        UDim2.fromOffset(430, 240)

    Frame.Position =
        UDim2.new(
            0.5,
            -215,
            0.5,
            -120
        )

    Frame.BackgroundColor3 =
        Color3.fromRGB(25, 25, 30)

    Frame.BorderSizePixel = 0
    Frame.Parent = Gui

    local Corner = Instance.new(
        "UICorner"
    )

    Corner.CornerRadius =
        UDim.new(0, 10)

    Corner.Parent = Frame

    local Title = Instance.new(
        "TextLabel"
    )

    Title.Size =
        UDim2.new(1, -30, 0, 45)

    Title.Position =
        UDim2.fromOffset(15, 10)

    Title.BackgroundTransparency = 1

    Title.Text =
        "◉  ARETEON KEY SYSTEM"

    Title.TextColor3 =
        Color3.new(1, 1, 1)

    Title.TextSize = 18
    Title.Font =
        Enum.Font.GothamBold

    Title.TextXAlignment =
        Enum.TextXAlignment.Left

    Title.Parent = Frame

    local Input = Instance.new(
        "TextBox"
    )

    Input.Size =
        UDim2.new(1, -30, 0, 42)

    Input.Position =
        UDim2.fromOffset(15, 65)

    Input.BackgroundColor3 =
        Color3.fromRGB(40, 40, 48)

    Input.BorderSizePixel = 0

    Input.PlaceholderText =
        "Enter lifetime key..."

    Input.Text = ""

    Input.TextColor3 =
        Color3.new(1, 1, 1)

    Input.TextSize = 14

    Input.Font =
        Enum.Font.Gotham

    Input.ClearTextOnFocus = false

    Input.Parent = Frame

    local InputCorner =
        Instance.new("UICorner")

    InputCorner.CornerRadius =
        UDim.new(0, 6)

    InputCorner.Parent = Input

    local Verify =
        Instance.new("TextButton")

    Verify.Size =
        UDim2.fromOffset(180, 42)

    Verify.Position =
        UDim2.fromOffset(15, 120)

    Verify.BackgroundColor3 =
        Color3.fromRGB(55, 55, 65)

    Verify.BorderSizePixel = 0

    Verify.Text = "VERIFY"

    Verify.TextColor3 =
        Color3.new(1, 1, 1)

    Verify.TextSize = 14

    Verify.Font =
        Enum.Font.GothamBold

    Verify.Parent = Frame

    local VerifyCorner =
        Instance.new("UICorner")

    VerifyCorner.CornerRadius =
        UDim.new(0, 6)

    VerifyCorner.Parent =
        Verify

    local Status =
        Instance.new("TextLabel")

    Status.Size =
        UDim2.new(1, -30, 0, 55)

    Status.Position =
        UDim2.fromOffset(15, 170)

    Status.BackgroundTransparency = 1

    Status.Text =
        "Enter your lifetime key."

    Status.TextColor3 =
        Color3.fromRGB(200, 200, 210)

    Status.TextSize = 13

    Status.Font =
        Enum.Font.Gotham

    Status.TextWrapped = true

    Status.TextXAlignment =
        Enum.TextXAlignment.Left

    Status.Parent = Frame

    local function VerifyKey()
        local entered =
            Input.Text

        if entered == "" then
            Status.Text =
                "Please enter a key."

            return false
        end

        if entered ==
            CONFIG.LifetimeKey then

            Status.Text =
                "Lifetime key accepted!"

            return true
        end

        Status.Text =
            "Invalid lifetime key."

        return false
    end

    Verify.MouseButton1Click:Connect(
        function()

            if not VerifyKey() then
                return
            end

            task.wait(0.25)

            Gui:Destroy()

            LoadHub()
        end
    )

    return Gui
end

--==================================================
-- HUB
--==================================================

function LoadHub()

    local Hub, Error =
        LoadModule("hub.lua")

    if not Hub then

        warn(
            "[Areteon] Hub error: " ..
            tostring(Error)
        )

        return
    end

    if type(Hub.Start) ~=
        "function" then

        warn(
            "[Areteon] Hub.Start() missing."
        )

        return
    end

    Hub.Start({

        Player = Player,

        AccessType =
            AccessType,

        IsAdmin =
            IsAdmin,

        IsException =
            IsException,

        ExceptionName =
            CONFIG.Exceptions[
                Player.UserId
            ]

    })

end

--==================================================
-- AUTOMATIC ACCESS
--==================================================

if IsAdmin then

    print(
        "[Areteon] Admin detected."
    )

    LoadHub()

elseif IsException then

    print(
        "[Areteon] Exception detected: " ..
        tostring(
            CONFIG.Exceptions[
                Player.UserId
            ]
        )
    )

    LoadHub()

else

    CreateKeyGUI()

end
