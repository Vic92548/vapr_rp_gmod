-- admin.lua

-- Fonction pour vérifier si le joueur est admin
local function IsAdmin(ply)
    local steamID = ply:SteamID()
    for _, id in ipairs(adminSteamIDs) do
        if steamID == id then
            return true
        end
    end
    return false
end

-- Fonction pour basculer le noclip pour le joueur
local function ToggleNoclip(ply)
    local steamID = ply:SteamID()
    print(adminSteamIDs)
    print("[DEBUG] Attempted noclip by player with SteamID: " .. steamID) -- Message de débogage

    if not IsAdmin(ply) then 
        ply:ChatPrint("You do not have permission to use noclip.") -- Message pour les joueurs sans permission
        print("[DEBUG] Player " .. steamID .. " does not have permission to use noclip.")
        return 
    end

    if ply:GetMoveType() == MOVETYPE_NOCLIP then
        ply:SetMoveType(MOVETYPE_WALK)
        ply:ChatPrint("Noclip disabled")
        print("[DEBUG] Noclip disabled for player " .. steamID)
    else
        ply:SetMoveType(MOVETYPE_NOCLIP)
        ply:ChatPrint("Noclip enabled")
        print("[DEBUG] Noclip enabled for player " .. steamID)
    end
end

-- Commande de console pour activer/désactiver le noclip
concommand.Add("toggle_noclip", function(ply)
    print("[DEBUG] Console command 'toggle_noclip' executed by player with SteamID: " .. ply:SteamID())
    ToggleNoclip(ply)
end)

-- Lier la touche 'V' à la commande de basculement du noclip
hook.Add("PlayerButtonDown", "ToggleNoclipOnV", function(ply, button)
    if button == KEY_V then
        print("[DEBUG] Player with SteamID: " .. ply:SteamID() .. " pressed 'V' key.")
        ply:ConCommand("toggle_noclip")
    end
end)
