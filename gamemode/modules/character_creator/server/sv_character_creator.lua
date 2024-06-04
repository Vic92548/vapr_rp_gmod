-- Table to keep track of players who have created characters
local playersWithCharacters = {}

-- Register network messages
util.AddNetworkString("VAPR_CreateCharacter")
util.AddNetworkString("VAPR_CharacterCreated")
util.AddNetworkString("VAPR_OpenCharacterCreator")
util.AddNetworkString("VAPR_ClientReady")

-- Handle character creation request from client
net.Receive("VAPR_CreateCharacter", function(len, ply)
    local characterData = net.ReadTable()
    local model = characterData.model

    -- Verify the presence of essential data
    if not model or not characterData.fields then
        net.Start("VAPR_CharacterCreated")
        net.WriteBool(false)
        net.Send(ply)
        return
    end

    local save_result = VAPR_DataManager:save("playersWithCharacters", { identifier = ply:SteamID(), model = model, fields = characterData.fields })
    print("Saving character model to database:")
    print(save_result)
    --sqliteManager:load("players", "player_1", function(data) PrintTable(data) end)
    --sqliteManager:query("players", { some_data = "value" }, function(results) PrintTable(results) end)

    ply:SetModel(model)
    ply:SetupHands()
    playersWithCharacters[ply:SteamID()] = {
        fields = characterData.fields,
        model = model
    }
    net.Start("VAPR_CharacterCreated")
    net.WriteBool(true)
    net.Send(ply)
end)

-- Handle client ready notification
net.Receive("VAPR_ClientReady", function(len, ply)
    if not playersWithCharacters[ply:SteamID()] then
        net.Start("VAPR_OpenCharacterCreator")
        net.Send(ply)
    end
end)

-- Fonction pour définir le modèle de joueur par défaut
local function SetDefaultPlayerModel(ply)
    -- Définir le modèle de joueur par défaut ici
    local defaultModel = "models/player/alyx.mdl" 
    ply:SetModel(defaultModel)
end

-- Hook pour appliquer le modèle lorsque le joueur spawn
hook.Add("PlayerSpawn", "SetDefaultPlayerModelOnSpawn", function(ply)
    local playerChar = playersWithCharacters[ply:SteamID()]
    if playerChar then
        ply:SetModel(playerChar.model)
    else
        SetDefaultPlayerModel(ply)
    end
end)

-- Optionnel : Hook pour définir le modèle de joueur lors de l'initialisation du joueur
hook.Add("PlayerInitialSpawn", "SetDefaultPlayerModelOnInitialSpawn", function(ply)
    SetDefaultPlayerModel(ply)
    VAPR_DataManager:load("playersWithCharacters", ply:SteamID(), function(data)
        playersWithCharacters[ply:SteamID()] = {
            model = data.model,
            fields = data.fields
        }
        PrintTable(data)
        --ply:SetModel(data.model)
    end)
end)
