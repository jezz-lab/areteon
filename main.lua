```lua
--==================================================
-- ARETEON | main.lua
-- Delta-compatible loader
--==================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local CONFIG = {
    LifetimeKey = "pandaq75z6fyyhx5sfddcqwup2ku9o6",

    Admins = {
        [8045408189] = true,
        [7701580616] = true,
    },

    Exceptions = {
        [8163962664] = true,
    },

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
        return {
            Type = "ADMIN",
            IsAdmin = true,
            IsException = false,
            RequiresKey = false
        }
    end

    if CONFIG.Exceptions[userId] then
        return {
            Type = "EXCEPTION",
            IsAdmin = false,
            IsException = true,
            RequiresKey = false
        }
    end

    return {
        Type = "USER",
        IsAdmin = false,
        IsException = false,
        RequiresKey = true
    }
end

local Access = GetAccess()

--==================================================
-- HTTP / LOADSTRING
--==================================================

local function Download(path)
    local url = CONFIG.BaseURL .. path

    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        return nil, "HTTP error: " .. tostring(result)
    end

    if type(result) ~= "string" or #result == 0 then
        return nil, "Empty response from " .. path
    end

    return result
end

local function LoadRemote(path)
    local source, downloadError = Download(path)

    if not source then
        return nil, downloadError
    end

    if type(loadstring) ~= "function" then
        return nil, "loadstring is unavailable in this executor"
    end

    local fn, compileError = loadstring(source)

    if not fn then
        return nil,
            "Compile error in " ..
            path ..
            ": " ..
            tostring(compileError)
    end

    local ok, result = pcall(fn)

    if not ok then
        return nil,
            "Runtime error in " ..
            path ..
            ": " ..
            tostring(result)
    end

    return result
end

--==================================================
-- HUB
--==================================================

local function StartHub()
    print("[Areteon] Loading hub.lua")

    local Hub, err = LoadRemote("hub.lua")

    if not Hub then
        warn("[Areteon] " .. tostring(err))
        return false
    end

    if type(Hub) ~= "table" then
        warn("[Areteon] hub.lua returned " .. type(Hub))
        return false
    end

    if type(Hub.Start) ~= "function" then
        warn("[Areteon] hub.lua has no Start() function")
        return false
    end

    local ok, startError = pcall(function()
        Hub.Start({
            Player = Player,
            AccessType = Access.Type,
            IsAdmin = Access.IsAdmin,
            IsException = Access.IsException,
            BaseURL = CONFIG.BaseURL
        })
    end)

    if not ok then
        warn("[Areteon] Hub.Start failed:")
        warn(startError)
        return false
    end

    return true
end

--==================================================
-- KEY GUI
--==================================================

local function StartKeyGui()
    print("[Areteon] Loading keyGui.lua")

    local KeyGui, err = LoadRemote("keyGui.lua")

    if not KeyGui then
        warn("[Areteon] " .. tostring(err))
        return
    end

    if type(KeyGui) ~= "table" then
        warn("[Areteon] keyGui.lua returned " .. type(KeyGui))
        return
    end

    if type(KeyGui.Create) ~= "function" then
        warn("[Areteon] keyGui.Create() missing")
        return
    end

    local ok, guiError = pcall(function()
        KeyGui.Create({
            LifetimeKey = CONFIG.LifetimeKey,

            OnVerify = function(input)
                if input == CONFIG.LifetimeKey then
                    return true, "Lifetime key accepted."
                end

                return false, "Invalid lifetime key."
            end,

            OnSuccess = function()
                StartHub()
            end
        })
    end)

    if not ok then
        warn("[Areteon] Key GUI failed:")
        warn(guiError)
    end
end

--==================================================
-- START
--==================================================

print("==========================================")
print("[Areteon] Starting")
print("[Areteon] UserId:", Player.UserId)
print("[Areteon] Access:", Access.Type)
print("==========================================")

if Access.IsAdmin then
    print("[Areteon] Admin detected.")
    StartHub()
    return
end

if Access.IsException then
    print("[Areteon] Exception detected.")
    StartHub()
    return
end

if Access.RequiresKey then
    StartKeyGui()
    return
end

warn("[Areteon] No valid access state.")
```
