local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local CONFIG = {
    VerifyURL = "YOUR_SERVER_VERIFY_URL"
}

local function LoadModule(url)
    local ok, source = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        return nil, "Download failed: " .. tostring(source)
    end

    local fn, err = loadstring(source)

    if not fn then
        return nil, "Compile failed: " .. tostring(err)
    end

    local success, result = pcall(fn)

    if not success then
        return nil, "Execution failed: " .. tostring(result)
    end

    return result
end

local KeyGui, err = LoadModule(
    "https://raw.githubusercontent.com/jezz-lab/areteon/main/keyGui.lua"
)

if not KeyGui then
    warn("[Areteon] KeyGui: " .. tostring(err))
    return
end

local Hub, hubErr = LoadModule(
    "https://raw.githubusercontent.com/jezz-lab/areteon/main/hub.lua"
)

if not Hub then
    warn("[Areteon] Hub: " .. tostring(hubErr))
    return
end

local function VerifyKey(key)
    if key == "" then
        return false, "Enter a key first."
    end

    if CONFIG.VerifyURL == "YOUR_SERVER_VERIFY_URL" then
        return false, "Verification URL is not configured."
    end

    local HttpService = game:GetService("HttpService")

    local ok, response = pcall(function()
        return game:HttpGet(
            CONFIG.VerifyURL ..
            "?key=" .. HttpService:UrlEncode(key) ..
            "&userId=" .. tostring(Player.UserId)
        )
    end)

    if not ok then
        return false, "Verification request failed."
    end

    if response ~= "VALID" then
        return false, "Invalid or expired key."
    end

    return true, "Key verified!"
end

KeyGui.Create({
    OnVerify = VerifyKey,

    OnSuccess = function()
        Hub.Start({
            Player = Player,
            AccessType = "NORMAL"
        })
    end
})
