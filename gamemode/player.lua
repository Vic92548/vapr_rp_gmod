-- player.lua
-- Configuration des modèles de joueurs pour le mode de jeu VAPR_RP

-- Fonction pour définir le modèle de joueur par défaut
local function SetDefaultPlayerModel(ply)
    -- Définir le modèle de joueur par défaut ici
    local defaultModel = "models/player/alyx.mdl" 
    ply:SetModel(defaultModel)
end

-- Hook pour appliquer le modèle lorsque le joueur spawn
hook.Add("PlayerSpawn", "SetDefaultPlayerModelOnSpawn", function(ply)
    SetDefaultPlayerModel(ply)
end)

-- Optionnel : Hook pour définir le modèle de joueur lors de l'initialisation du joueur
hook.Add("PlayerInitialSpawn", "SetDefaultPlayerModelOnInitialSpawn", function(ply)
    SetDefaultPlayerModel(ply)
end)


