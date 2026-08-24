--==================================================
-- ARETEON | main.lua
--==================================================

local Players = game:GetService("Players")

local Player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local CONFIG = {

    LifetimeKey =
        "pandaq75z6fyyhx5sfddcqwup2ku9o6",

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

    local userId =
        Player.UserId

    if CONFIG.Admins[userId] == true then

        return {
            Type = "ADMIN",
            IsAdmin = true,
            IsException = false,
            RequiresKey = false
        }

    end

    if CONFIG.Exceptions[userId] == true then

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
-- MODULE LOADER
--==================================================

local function LoadModule(fileName)

    local url =
        CONFIG.BaseURL .. fileName

    local success, source =
        pcall(function()

            return game:HttpGet(url)

        end)

    if not success then

        return nil,
            "Could not download " ..
            fileName ..
            ": " ..
            tostring(source)

    end

    if type(source) ~= "string" then

        return nil,
            "Invalid response for " ..
            fileName

    end

    local fn, compileError =
        loadstring(source)

    if not fn then

        return nil,
            "Could not compile " ..
            fileName ..
            ": " ..
            tostring(compileError)

    end

    local executed, result =
        pcall(fn)

    if not executed then

        return nil,
            "Could not execute " ..
            fileName ..
            ": " ..
            tostring(result)

    end

    return result
end

--==================================================
-- HUB
--==================================================

local function StartHub()

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
            "[Areteon] hub.lua did not return a table."
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

                -- Pass the access tables
                -- into the hub state.

                Admins =
                    CONFIG.Admins,

                Exceptions =
                    CONFIG.Exceptions

            })

        end)

    if not success then

        warn(
            "[Areteon] Hub failed: " ..
            tostring(result)
        )

        return false
    end

    return true
end

--==================================================
-- KEY GUI
--==================================================

local function StartKeyGui()

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
            "[Areteon] keyGui.lua did not return a table."
        )

        return
    end

    if type(KeyGui.Create) ~= "function" then

        warn(
            "[Areteon] KeyGui.Create() does not exist."
        )

        return
    end

    KeyGui.Create({

        LifetimeKey =
            CONFIG.LifetimeKey,

        OnVerify =
            function(input)

                if input ==
                    CONFIG.LifetimeKey
                then

                    return true,
                        "Lifetime key accepted."

                end

                return false,
                    "Invalid lifetime key."

            end,

        OnSuccess =
            function()

                StartHub()

            end

    })
end

--==================================================
-- START
--==================================================

print("[Areteon] Starting...")

print(
    "[Areteon] UserId:",
    Player.UserId
)

print(
    "[Areteon] Access:",
    Access.Type
)

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

    StartKeyGui()

    return
end

warn(
    "[Areteon] No valid access state."
)
