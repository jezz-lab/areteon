local Logs = {}

local Entries = {}
local MAX_ENTRIES = 200

function Logs:Add(action, player, details)

    local Entry = {
        Time = os.date("%Y-%m-%d %H:%M:%S"),
        Action = tostring(action),
        UserId = player and player.UserId or 0,
        Username = player and player.Name or "Unknown",
        Details = tostring(details or "")
    }

    table.insert(Entries, 1, Entry)

    while #Entries > MAX_ENTRIES do
        table.remove(Entries)
    end

    print(
        string.format(
            "[%s] %s | %s | %s",
            Entry.Time,
            Entry.Action,
            Entry.Username,
            Entry.Details
        )
    )

    return Entry
end

function Logs:GetAll()
    return Entries
end

function Logs:GetLatest(amount)

    amount = tonumber(amount) or 20

    local Result = {}

    for i = 1, math.min(amount, #Entries) do
        Result[i] = Entries[i]
    end

    return Result
end

function Logs:Clear()
    table.clear(Entries)
end

return Logs
