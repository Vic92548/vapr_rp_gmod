net.Receive("UpdateHunger", function()
    local hunger = net.ReadInt(32)
    LocalPlayer():SetNWInt("Hunger", hunger)
end)