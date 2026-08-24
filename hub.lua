```lua
--==================================================
-- ARETEON | hub.lua
-- Page-based hub loader
--==================================================

local Hub = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local BASE_URL =
    "https://raw.githubusercontent.com/" ..
    "jezz-lab/areteon/main/"

--==================================================
-- SETTINGS
--==================================================

local PAGE_PATHS = {
    Home = "Pages/Home.lua",
    Player = "Pages/Player.lua",
    Scripts = "Pages/Scripts.lua",
    Settings = "Pages/Settings.lua"
}

--==================================================
-- REMOTE LOADER
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

local function LoadPage(name, path)
    print("[Areteon] Loading page:", name)

    local source, httpError = Download(path)

    if not source then
        warn(
            "[Areteon] Page " ..
            name ..
            " unavailable: " ..
            tostring(httpError)
        )

        return nil
    end

    local fn, compileError = loadstring(source)

    if not fn then
        warn(
            "[Areteon] Page " ..
            name ..
            " compile error:"
        )

        warn(compileError)

        return nil
    end

    local ok, result = pcall(fn)

    if not ok then
        warn(
            "[Areteon] Page " ..
            name ..
            " runtime error:"
        )

        warn(result)

        return nil
    end

    print(
        "[Areteon] Page loaded:",
        name,
        "return type:",
        type(result)
    )

    return result
end

--==================================================
-- PAGE NORMALIZATION
--==================================================

local function SetupPage(page, name)
    if page == nil then
        return nil
    end

    if type(page) == "function" then
        return {
            Name = name,
            Start = page
        }
    end

    if type(page) == "table" then
        page.Name = page.Name or name
        return page
    end

    return {
        Name = name,
        Value = page
    }
end

--==================================================
-- HUB START
--==================================================

function Hub.Start(options)
    options = options or {}

    local state = {
        Player = options.Player or Player,
        AccessType = options.AccessType or "USER",
        IsAdmin = options.IsAdmin == true,
        IsException = options.IsException == true,
        Pages = {}
    }

    print("[Areteon] Hub starting...")
    print("[Areteon] Access:", state.AccessType)

    --==============================================
    -- LOAD PAGES
    --==============================================

    for name, path in pairs(PAGE_PATHS) do
        local page = LoadPage(name, path)

        if page ~= nil then
            state.Pages[name] = SetupPage(page, name)
        end
    end

    --==============================================
    -- PAGE SUMMARY
    --==============================================

    local count = 0

    for name, page in pairs(state.Pages) do
        count += 1
        print(
            "[Areteon] Available page:",
            name,
            "type:",
            type(page)
        )
    end

    print(
        "[Areteon] Pages loaded:",
        count
    )

    --==============================================
    -- START PAGE MODULES
    --==============================================

    for name, page in pairs(state.Pages) do
        if type(page) == "table" then

            if type(page.Start) == "function" then
                local ok, err = pcall(function()
                    page.Start(state)
                end)

                if not ok then
                    warn(
                        "[Areteon] " ..
                        name ..
                        ".Start failed:"
                    )

                    warn(err)
                end

            elseif type(page.Init) == "function" then
                local ok, err = pcall(function()
                    page.Init(state)
                end)

                if not ok then
                    warn(
                        "[Areteon] " ..
                        name ..
                        ".Init failed:"
                    )

                    warn(err)
                end
            end
        end
    end

    --==============================================
    -- RETURN STATE
    --==============================================

    Hub.State = state

    print("[Areteon] Hub started.")

    return state
end

return Hub
```
