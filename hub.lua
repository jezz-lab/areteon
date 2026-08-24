--==================================================
-- ARETEON | hub.lua
--==================================================

local Hub = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local BASE_URL =
    "https://raw.githubusercontent.com/" ..
    "jezz-lab/areteon/main/"

--==================================================
-- REQUIRED PAGES
--==================================================

local PAGE_PATHS = {
    Home = "Pages/Home.lua",
    Player = "Pages/Player.lua",
    Settings = "Pages/Settings.lua",
}

-- Scripts.lua is OPTIONAL.
local OPTIONAL_SCRIPT_PAGE = "Pages/Scripts.lua"

--==================================================
-- DOWNLOAD
--==================================================

local function Download(path)
    local url = BASE_URL .. path

    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        return nil, tostring(result)
    end

    if type(result) ~= "string" or #result == 0 then
        return nil, "empty response"
    end

    return result
end

--==================================================
-- LOAD MODULE
--==================================================

local function LoadModule(path)
    local source, errorMessage = Download(path)

    if not source then
        return nil, errorMessage
    end

    if type(loadstring) ~= "function" then
        return nil, "loadstring is unavailable"
    end

    local fn, compileError = loadstring(source)

    if not fn then
        return nil, "compile error: " .. tostring(compileError)
    end

    local ok, result = pcall(fn)

    if not ok then
        return nil, "runtime error: " .. tostring(result)
    end

    return result
end

--==================================================
-- LOAD REQUIRED PAGE
--==================================================

local function LoadRequiredPage(name, path)
    print("[Areteon] Loading:", name)

    local page, errorMessage = LoadModule(path)

    if not page then
        warn(
            "[Areteon] " ..
            name ..
            " failed: " ..
            tostring(errorMessage)
        )

        return nil
    end

    if type(page) ~= "table" then
        warn(
            "[Areteon] " ..
            name ..
            " did not return a table."
        )

        return nil
    end

    page.Name = page.Name or name

    print("[Areteon] Loaded:", name)

    return page
end

--==================================================
-- LOAD OPTIONAL SCRIPTS PAGE
--==================================================

local function LoadOptionalScripts()
    print("[Areteon] Checking optional Scripts page...")

    local source = Download(OPTIONAL_SCRIPT_PAGE)

    -- IMPORTANT:
    -- If Scripts.lua does not exist, forget it.
    if not source then
        print(
            "[Areteon] Scripts page not found. " ..
            "Skipping."
        )

        return nil
    end

    local fn, compileError = loadstring(source)

    if not fn then
        warn(
            "[Areteon] Scripts page exists but " ..
            "could not compile."
        )

        warn(compileError)

        return nil
    end

    local ok, result = pcall(fn)

    if not ok then
        warn(
            "[Areteon] Scripts page failed to execute."
        )

        warn(result)

        return nil
    end

    if type(result) ~= "table" then
        warn(
            "[Areteon] Scripts page did not return a table."
        )

        return nil
    end

    result.Name = result.Name or "Scripts"

    print("[Areteon] Optional Scripts page loaded.")

    return result
end

--==================================================
-- START PAGE
--==================================================

local function StartPage(page, state)
    if type(page.Start) ~= "function" then
        return true
    end

    local ok, errorMessage = pcall(function()
        page.Start(state)
    end)

    if not ok then
        warn(
            "[Areteon] " ..
            tostring(page.Name) ..
            ".Start failed:"
        )

        warn(errorMessage)

        return false
    end

    return true
end

--==================================================
-- HUB START
--==================================================

function Hub.Start(options)
    options = options or {}

    local state = {
        Player = options.Player or Player,

        AccessType =
            options.AccessType or "USER",

        IsAdmin =
            options.IsAdmin == true,

        IsException =
            options.IsException == true,

        Pages = {},

        Scripts = nil
    }

    print("==========================================")
    print("[Areteon] Hub starting")
    print("[Areteon] Access:", state.AccessType)
    print("==========================================")

    --==================================================
    -- REQUIRED PAGES
    --==================================================

    for name, path in pairs(PAGE_PATHS) do
        local page = LoadRequiredPage(name, path)

        if page then
            state.Pages[name] = page
        end
    end

    --==================================================
    -- OPTIONAL SCRIPTS
    --==================================================

    state.Scripts = LoadOptionalScripts()

    if state.Scripts then
        state.Pages.Scripts = state.Scripts
    end

    --==================================================
    -- START PAGES
    --==================================================

    for name, page in pairs(state.Pages) do

        -- Scripts is optional, but if it exists,
        -- it is started normally.
        local ok = StartPage(page, state)

        if ok then
            print(
                "[Areteon] Page started:",
                name
            )
        end
    end

    --==================================================
    -- STATE
    --==================================================

    Hub.State = state

    print("==========================================")
    print("[Areteon] Hub started")
    print("[Areteon] Pages:")

    for name in pairs(state.Pages) do
        print("  -", name)
    end

    if state.Scripts then
        print("[Areteon] Scripts: available")
    else
        print("[Areteon] Scripts: not installed")
    end

    print("==========================================")

    return state
end

return Hub
