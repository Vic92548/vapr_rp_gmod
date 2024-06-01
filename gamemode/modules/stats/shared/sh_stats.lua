-- sh_stats.lua
-- If there are any shared functions or variables, define them here

-- Define a hook for when a stat changes
hook.Add("OnStatChanged", "HandleStatChange", function(ply, stat, oldValue, newValue)
    print(ply:Nick() .. "'s " .. stat .. " changed from " .. oldValue .. " to " .. newValue)
end)
