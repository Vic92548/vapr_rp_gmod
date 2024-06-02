util.AddNetworkString("VAPR_BuyItem")
util.AddNetworkString("VAPR_SellItem")

-- Fonction pour vérifier si le joueur possède un article
local function PlayerHasItem(ply, itemKey)
    local inventory = GetPlayerInventory(ply)
    for _, item in ipairs(inventory) do
        if item.key == itemKey then
            return true
        end
    end
    return false
end

-- Fonction pour acheter un article
net.Receive("VAPR_BuyItem", function(len, ply)
    local itemKey = net.ReadString()
    local shopName = net.ReadString()
    local currency = net.ReadString()
    local cost = net.ReadInt(32)
    
    if PurchaseItem(ply, itemKey, currency, cost) then
        ply:ChatPrint("You have purchased " .. itemKey .. " for " .. cost .. " " .. currency .. ".")
    else
        ply:ChatPrint("You do not have enough " .. currency .. " to purchase this item.")
    end
end)

-- Fonction pour vendre un article
net.Receive("VAPR_SellItem", function(len, ply)
    local itemKey = net.ReadString()
    local shopName = net.ReadString()
    local currency = net.ReadString()
    local cost = net.ReadInt(32)
    
    if PlayerHasItem(ply, itemKey) then
        RemoveItemFromInventory(ply, itemKey)
        AddStat(ply, currency, cost)
        ply:ChatPrint("You have sold " .. itemKey .. " for " .. cost .. " " .. currency .. ".")
    else
        ply:ChatPrint("You do not have this item to sell.")
    end
end)
