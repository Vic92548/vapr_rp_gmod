-- cl_hunger.lua
net.Receive("UpdateHunger", function()
    local hunger = net.ReadInt(32)
    
    if IsValid(LocalPlayer()) then
        LocalPlayer():SetNWInt("Hunger", hunger)
    else

        hook.Add("InitPostEntity", "UpdateHungerOnInit", function()
            LocalPlayer():SetNWInt("Hunger", hunger)
            hook.Remove("InitPostEntity", "UpdateHungerOnInit")
        end)
    end
end)
