local damagePerSecond = VAPR_HungerConfig.damagePerSecond
local decayInterval = VAPR_HungerConfig.decayInterval
local hungerDecrease = VAPR_HungerConfig.hungerDecrease

local function InitializeHunger(ply)
    ply:SetNWInt("Hunger", 100)
end

local function DecayHunger()
    for _, ply in pairs(player.GetAll()) do
        if ply:Alive() then
            local hunger = ply:GetNWInt("Hunger", 100) - hungerDecrease 
            ply:SetNWInt("Hunger", hunger)
            
            if hunger <= 0 then
                ply:TakeDamage(damagePerSecond)
            end
        end
    end
end

hook.Add("PlayerSpawn", "InitializeHunger", InitializeHunger)
timer.Create("DecayHungerTimer", decayInterval, 0, DecayHunger)