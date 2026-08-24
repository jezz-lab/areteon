--==================================================
-- MAIN.LUA
--==================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    GetKeyURL =
        "https://direct-link.net/8645104/ItnPcaJOPaKa",

    -- Your own server verification endpoint.
    VerifyURL =
        "YOUR_SERVER_VERIFY_URL"
}

--==================================================
-- STATE
--==================================================

local Verified = false
local AccessType = "NONE"

--==================================================
-- LOAD GITHUB MODULE
--==================================================

local function LoadModule(URL)

    local Success, Source = pcall(function()
        return game:HttpGet(URL)
    end)

    if not Success then
        return nil, "Failed to download module."
    end

    local Loaded, Module = pcall(function()
        return loadstring(Source)()
    end)

    if not Loaded then
        return nil, "Failed to load module."
    end

    return Module
end

--==================================================
-- KEY GUI
--==================================================

local KeyGui, KeyGuiError = LoadModule(
    "https://raw.githubusercontent.com/" ..
    "jezz-lab/areteon/main/KeyGui.lua"
)

if not KeyGui then
    warn("[KeyGui] " .. tostring(KeyGuiError))
    return
end

--==================================================
-- HUB
--==================================================

local Hub, HubError = LoadModule(
    "https://raw.githubusercontent.com/" ..
    "jezz-lab/areteon/main/Hub.lua"
)

if not Hub then
    warn("[Hub] " .. tostring(HubError))
    return
end

--==================================================
-- VERIFY
--==================================================

local function VerifyKey(Key)

    if not Key or Key == "" then
        return false, "Enter a key first."
    end

    -- Perform verification on your server.
    --
    -- Do NOT put a lifetime/admin credential
    -- inside this client-side file.

    local Success, Response = pcall(function()

        return game:HttpGet(
            CONFIG.VerifyURL ..
            "?key=" ..
            game:GetService("HttpService"):UrlEncode(Key) ..
            "&userId=" ..
            tostring(Player.UserId)
        )

    end)

    if not Success then
        return false, "Verification request failed."
    end

    if Response ~= "VALID" then
        return false, "Invalid or expired key."
    end

    Verified = true
    AccessType = "NORMAL"

    return true, "Key verified!"
end

--==================================================
-- START HUB
--==================================================

local function StartHub()

    if not Verified then
        return
    end

    Hub.Start({
        Player = Player,
        AccessType = AccessType
    })
end

--==================================================
-- KEY GUI
--==================================================

KeyGui.Create({

    GetKeyURL = CONFIG.GetKeyURL,

    OnVerify = function(Key)

        local Success, Message =
            VerifyKey(Key)

        return Success, Message
    end,

    OnSuccess = function()
        StartHub()
    end
})
