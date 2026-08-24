--==================================================
-- ARETEON | main.lua
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
-- ACCESS CHECK
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
-- DOWNLOAD
--==================================================

local function Download(path)
    local url = CONFIG.BaseURL .. path

    local success, result = pcall(function()
        return game:HttpGet(url)
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
-- LOAD MODULE
--==================================================

local function LoadModule(path)
    print("[Areteon] Loading:", path)

    local source, downloadError = Download(path)

    if not source then
        return nil,
            "Download failed: " ..
            tostring(downloadError)
    end

    if type(loadstring) ~= "function" then
        return nil,
            "loadstring is unavailable"
    end

    local fn, compileError =
        loadstring(source)

    if not fn then
        return nil,
            "Compile error: " ..
            tostring(compileError)
    end

    local success, result =
        pcall(fn)

    if not success then
        return nil,
            "Runtime error: " ..
            tostring(result)
    end

    return result
end

--==================================================
-- START HUB
--==================================================

local function StartHub()
    print("[Areteon] Loading hub.lua")

    local Hub, Error =
        LoadModule("hub.lua")

    if not Hub then
        warn(
            "[Areteon] Hub error: " ..
            tostring(Error)
        )

        return false
    end

    if type(Hub) ~= "table" then
        warn(
            "[Areteon] hub.lua returned " ..
            tostring(type(Hub))
        )

        return false
    end

    if type(Hub.Start) ~= "function" then
        warn(
            "[Areteon] Hub.Start() does not exist."
        )

        return false
    end

    local success, result =
        pcall(function()
            return Hub.Start({
                Player = Player,

                AccessType =
                    Access.Type,

                IsAdmin =
                    Access.IsAdmin,

                IsException =
                    Access.IsException,

                BaseURL =
                    CONFIG.BaseURL
            })
        end)

    if not success then
        warn(
            "[Areteon] Hub failed:"
        )

        warn(result)

        return false
    end

    print("[Areteon] Hub started.")

    return true
end

--==================================================
-- KEY GUI
--==================================================

local function StartKeyGui()
    print("[Areteon] Loading keyGui.lua")

    local KeyGui, Error =
        LoadModule("keyGui.lua")

    if not KeyGui then
        warn(
            "[Areteon] KeyGui error: " ..
            tostring(Error)
        )

        return
    end

    if type(KeyGui) ~= "table" then
        warn(
            "[Areteon] keyGui.lua returned " ..
            tostring(type(KeyGui))
        )

        return
    end

    if type(KeyGui.Create) ~= "function" then
        warn(
            "[Areteon] KeyGui.Create() does not exist."
        )

        return
    end

    local success, result =
        pcall(function()

            KeyGui.Create({

                LifetimeKey =
                    CONFIG.LifetimeKey,

                OnVerify = function(input)

                    if tostring(input) ==
                        CONFIG.LifetimeKey then

                        return true,
                            "Lifetime key accepted."

                    end

                    return false,
                        "Invalid lifetime key."
                end,

                OnSuccess = function()

                    print(
                        "[Areteon] Key accepted."
                    )

                    StartHub()

                end

            })

        end)

    if not success then
        warn(
            "[Areteon] Key GUI failed:"
        )

        warn(result)
    end
end

--==================================================
-- START
--==================================================

print("==========================================")
print("[Areteon] Starting...")
print("[Areteon] UserId:", Player.UserId)
print("[Areteon] Access:", Access.Type)
print("==========================================")

--==================================================
-- ADMIN
--==================================================

if Access.IsAdmin then

    print(
        "[Areteon] Admin detected."
    )

    StartHub()

    return
end

--==================================================
-- EXCEPTION
--==================================================

if Access.IsException then

    print(
        "[Areteon] Exception detected."
    )

    StartHub()

    return
end

--==================================================
-- NORMAL USER
--==================================================

if Access.RequiresKey then

    print(
        "[Areteon] Key required."
    )

    StartKeyGui()

    return
end

warn(
    "[Areteon] No valid access state."
)
