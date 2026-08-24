local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Logs = require(script.Parent.Logs)
local KeyGui = require(script.Parent.KeyGui)
local Hub = require(script.Parent.Hub)

local function StartHub(accessType)

    Logs:Add(
        "HUB_STARTED",
        Player,
        "Access: " .. tostring(accessType)
    )

    Hub.Start({
        Player = Player,
        AccessType = accessType
    })
end

KeyGui.Start({
    Player = Player,

    OnVerified = function(accessType)

        Logs:Add(
            "KEY_VERIFIED",
            Player,
            "Access: " .. tostring(accessType)
        )

        StartHub(accessType)
    end
})
