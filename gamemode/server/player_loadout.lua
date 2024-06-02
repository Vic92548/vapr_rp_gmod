print("Custom loadout initial setup ")

local function SetPlayerLoadout(ply)
    print("Custom loadout function called for player: " .. ply:Nick())

    ply:StripWeapons()
    ply:StripAmmo()

    ply:Give("weapon_pistol")
    ply:Give("weapon_crowbar")
    ply:Give("weapon_rpg")
    --ply:Give("weapon_pocket")

    ply:SetAmmo(50, "Pistol")
    ply:SetAmmo(100, "RPG")


    AddItemToInventory(ply, "health_pack")
    AddItemToInventory(ply, "health_pack")
    AddItemToInventory(ply, "food_item")
    AddItemToInventory(ply, "shotgun")
    AddItemToInventory(ply, "crossbow")
    AddItemToInventory(ply, "armor_item")

    notifyPlayer(ply, "Welcome back to life!", 5)
end

hook.Add("PlayerLoadout", "CustomPlayerLoadout", SetPlayerLoadout)
