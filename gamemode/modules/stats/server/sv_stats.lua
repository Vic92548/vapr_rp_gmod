util.AddNetworkString("UpdateStats")
util.AddNetworkString("UpdateStatLimits")

playerStats = {}
statLimits = VAPR_STATS_CONFIG.limits

local function log(message)
    print("[StatsSystem] " .. message)
end

-- Initialize player stats when they join
hook.Add("PlayerInitialSpawn", "InitializePlayerStats", function(ply)
    local steamID = ply:SteamID()
    playerStats[steamID] = {}
    for stat, limits in pairs(statLimits) do
        playerStats[steamID][stat] = limits.default
    end
    log("Initialized stats for player: " .. steamID)
    UpdateClientStats(ply)
    SendStatLimitsToClient(ply)
end)

-- Function to send stat limits to the client
function SendStatLimitsToClient(ply)
    net.Start("UpdateStatLimits")
    net.WriteTable(statLimits)
    net.Send(ply)
end

-- Function to add value to a stat
function AddStat(ply, stat, amount)
    local steamID = ply:SteamID()
    if not playerStats[steamID] or not playerStats[steamID][stat] then return end

    local limits = statLimits[stat]
    local oldValue = playerStats[steamID][stat]
    local newValue = oldValue + amount

    if limits.max > 0 then
        newValue = math.min(newValue, limits.max)
    end

    newValue = math.max(newValue, limits.min)

    playerStats[steamID][stat] = newValue
    log("Added " .. amount .. " to " .. stat .. " for player: " .. steamID .. ". Old value: " .. oldValue .. ", New value: " .. newValue)
    TriggerStatChangeEvent(ply, stat, oldValue, newValue)
    UpdateClientStats(ply)
end

-- Function to remove value from a stat
function RemoveStat(ply, stat, amount)
    local steamID = ply:SteamID()
    if not playerStats[steamID] or not playerStats[steamID][stat] then return end

    local limits = statLimits[stat]
    local oldValue = playerStats[steamID][stat]
    local newValue = oldValue - amount

    if limits.max > 0 then
        newValue = math.min(newValue, limits.max)
    end

    newValue = math.max(newValue, limits.min)

    playerStats[steamID][stat] = newValue
    log("Removed " .. amount .. " from " .. stat .. " for player: " .. steamID .. ". Old value: " .. oldValue .. ", New value: " .. newValue)
    TriggerStatChangeEvent(ply, stat, oldValue, newValue)
    UpdateClientStats(ply)
end

-- Function to get the value of a stat
function GetStat(ply, stat)
    local steamID = ply:SteamID()
    if playerStats[steamID] and playerStats[steamID][stat] then
        log("Retrieved " .. stat .. " for player: " .. steamID .. " with value: " .. playerStats[steamID][stat])
        return playerStats[steamID][stat]
    else
        log("Stat " .. stat .. " not found for player: " .. steamID)
        return nil -- or you could return an appropriate default value
    end
end

-- Function to trigger stat change event
function TriggerStatChangeEvent(ply, stat, oldValue, newValue)
    log("Triggering stat change event for player: " .. ply:SteamID() .. ", Stat: " .. stat .. ", Old value: " .. oldValue .. ", New value: " .. newValue)
    hook.Run("OnStatChanged", ply, stat, oldValue, newValue)
end

-- Update the client's stats
function UpdateClientStats(ply)
    local steamID = ply:SteamID()
    if not playerStats[steamID] then return end

    log("Updating client stats for player: " .. steamID)
    net.Start("UpdateStats")
    net.WriteTable(playerStats[steamID])
    net.Send(ply)
end

-- Apply change over time for each stat
local function ApplyChangeOverTime()
    for _, ply in ipairs(player.GetAll()) do
        local steamID = ply:SteamID()
        if playerStats[steamID] then
            for stat, limits in pairs(statLimits) do
                if limits.changeOverTime ~= 0 then
                    AddStat(ply, stat, limits.changeOverTime)
                    log("Applied change over time for " .. stat .. " for player: " .. steamID .. ", Amount: " .. limits.changeOverTime)
                end
            end
        end
    end
end

-- Function to purchase an item using a specified stat as currency
function PurchaseItem(ply, item, stat, cost)
    local steamID = ply:SteamID()
    if not playerStats[steamID] or not playerStats[steamID][stat] then
        ply:ChatPrint("Stat " .. stat .. " not found.")
        return false
    end

    local currentStatValue = playerStats[steamID][stat]
    if currentStatValue < cost then
        ply:ChatPrint("Not enough " .. stat .. " to purchase " .. item .. ".")
        return false
    end

    RemoveStat(ply, stat, cost)
    ply:ChatPrint("You have purchased " .. item .. " for " .. cost .. " " .. stat .. ".")
    log("Player " .. steamID .. " purchased " .. item .. " for " .. cost .. " " .. stat .. ".")
    return true
end

-- Command to purchase an item for testing
concommand.Add("purchaseitem", function(ply, cmd, args)
    if not args[1] or not args[2] or not args[3] then return end
    local item = args[1]
    local stat = args[2]
    local cost = tonumber(args[3])
    PurchaseItem(ply, item, stat, cost)
    log("Command 'purchaseitem' executed by player: " .. ply:SteamID() .. ", Item: " .. item .. ", Stat: " .. stat .. ", Cost: " .. cost)
end)


-- Apply change over time every 10 seconds
timer.Create("StatChangeOverTime", 10, 0, ApplyChangeOverTime)

-- Command to add value to a stat for testing
concommand.Add("addstat", function(ply, cmd, args)
    if not args[1] or not args[2] then return end
    AddStat(ply, args[1], tonumber(args[2]))
    log("Command 'addstat' executed by player: " .. ply:SteamID() .. ", Stat: " .. args[1] .. ", Amount: " .. args[2])
end)

-- Command to remove value from a stat for testing
concommand.Add("removestat", function(ply, cmd, args)
    if not args[1] or not args[2] then return end
    RemoveStat(ply, args[1], tonumber(args[2]))
    log("Command 'removestat' executed by player: " .. ply:SteamID() .. ", Stat: " .. args[1] .. ", Amount: " .. args[2])
end)

-- Command to get value of a stat for testing
concommand.Add("getstat", function(ply, cmd, args)
    if not args[1] then return end
    local value = GetStat(ply, args[1])
    if value then
        ply:ChatPrint("Value of " .. args[1] .. " is: " .. value)
    else
        ply:ChatPrint("Stat " .. args[1] .. " not found.")
    end
    log("Command 'getstat' executed by player: " .. ply:SteamID() .. ", Stat: " .. args[1])
end)
