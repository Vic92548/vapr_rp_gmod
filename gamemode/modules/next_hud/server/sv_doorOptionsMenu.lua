-- Réseau pour les interactions serveur-client
util.AddNetworkString("SellDoor")
util.AddNetworkString("AddCoOwner")
util.AddNetworkString("RemoveCoOwner")
util.AddNetworkString("SetDoorTitle")


-- Réception des commandes du client pour vendre, ajouter, retirer un copropriétaire et définir un titre
net.Receive("SellDoor", function(len, ply)
    local door = net.ReadEntity()
    if IsValid(door) and door:getDoorOwner() == ply then
        door:keysUnOwn()
    end
end)

net.Receive("AddCoOwner", function(len, ply)
    local door = net.ReadEntity()
    local coOwner = net.ReadEntity()
    if IsValid(door) and door:getDoorOwner() == ply then
        door:addDoorOwner(coOwner)
    end
end)

net.Receive("RemoveCoOwner", function(len, ply)
    local door = net.ReadEntity()
    local coOwner = net.ReadEntity()
    if IsValid(door) and door:getDoorOwner() == ply then
        door:removeDoorOwner(coOwner)
    end
end)

net.Receive("SetDoorTitle", function(len, ply)
    local door = net.ReadEntity()
    local title = net.ReadString()
    if IsValid(door) and door:getDoorOwner() == ply then
        door:setDoorTitle(title)
    end
end)
