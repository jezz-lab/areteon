local BaseURL =
    "https://raw.githubusercontent.com/jezz-lab/areteon/main/"

local function LoadPage(name)
    local source = game:HttpGet(
        BaseURL .. "Pages/" .. name .. ".lua"
    )

    local fn, err = loadstring(source)

    if not fn then
        error(err)
    end

    return fn()
end

local Home = LoadPage("Home")
local Player = LoadPage("Player")
local Scripts = LoadPage("Scripts")
local Settings = LoadPage("Settings")
