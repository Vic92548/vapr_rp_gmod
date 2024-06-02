-- admin.lua

-- Fonction pour basculer le noclip pour le joueur
local function ToggleNoclip(ply)
    local steamID = ply:SteamID()
    print("Attempted noclip by player with SteamID: " .. steamID) -- Message de débogage

    if not IsAdmin(ply) then 
        ply:ChatPrint("You do not have permission to use noclip.") -- Message pour les joueurs sans permission
        return 
    end

    if ply:GetMoveType() == MOVETYPE_NOCLIP then
        ply:SetMoveType(MOVETYPE_WALK)
        ply:ChatPrint("Noclip disabled")
    else
        ply:SetMoveType(MOVETYPE_NOCLIP)
        ply:ChatPrint("Noclip enabled")
    end
end

-- Commande de console pour activer/désactiver le noclip
concommand.Add("toggle_noclip", function(ply)
    ToggleNoclip(ply)
end)

-- Lier la touche 'V' à la commande de basculement du noclip
hook.Add("PlayerButtonDown", "ToggleNoclipOnV", function(ply, button)
    if button == KEY_V then
        ply:ConCommand("toggle_noclip")
    end
end)
