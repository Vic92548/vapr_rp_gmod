VAPR_DATA_STORE_CONFIG = {
    data_source = "sqlite",
    db =  { db_path = "data.db" }
}

Admins = {
    -- Format: ["SteamID"] = true
    ["STEAM_0:0:135412608"] = true,
    ["STEAM_0:1:48031961"] = true,
}

-- Fonction pour vérifier si un joueur est admin
function IsAdmin(ply)
    return Admins[ply:SteamID()] == true
end