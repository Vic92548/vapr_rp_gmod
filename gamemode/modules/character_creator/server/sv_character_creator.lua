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

    -- Verify the model belongs to the selected sex and age category
    local sex = characterData.fields["Sex"]
    local age = tonumber(characterData.fields["Age"])
    local validModels = FilterModels(sex, age)

    if table.HasValue(validModels, model) then
        ply:SetModel(model)
        playersWithCharacters[ply:SteamID()] = characterData.fields
        -- Add any additional character setup here, like setting up default equipment, position, etc.
        net.Start("VAPR_CharacterCreated")
        net.WriteBool(true)
        net.Send(ply)
    else
        net.Start("VAPR_CharacterCreated")
        net.WriteBool(false)
        net.Send(ply)
    end
end)

-- Handle client ready notification
net.Receive("VAPR_ClientReady", function(len, ply)
    if not playersWithCharacters[ply:SteamID()] then
        net.Start("VAPR_OpenCharacterCreator")
        net.Send(ply)
    end
end)

-- Filter models based on sex and age
function FilterModels(sex, age)
    local ageCategory = age < 18 and "Child" or "Adult"
    return VAPR_CHARACTER_CREATOR_CONFIG.models[sex][ageCategory] or {}
end
