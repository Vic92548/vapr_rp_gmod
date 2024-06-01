playerStats = {}
statLimits = {}

net.Receive("UpdateStatLimits", function()
    statLimits = net.ReadTable()
    PrintTable(statLimits)  -- You can replace this with your own code to handle the stat limits
end)

net.Receive("UpdateStats", function()
    playerStats = net.ReadTable()
    PrintTable(playerStats)  -- You can replace this with your own code to handle the player stats
end)
