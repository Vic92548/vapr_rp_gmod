util.AddNetworkString("RequestInventory")
util.AddNetworkString("SendInventory")
util.AddNetworkString("UseItem")
util.AddNetworkString("DropItem")
util.AddNetworkString("UpdateInventory")

local playerInventories = {}

function GetPlayerInventory(ply)
    if not playerInventories[ply:SteamID()] then
        playerInventories[ply:SteamID()] = {}
    end
    return playerInventories[ply:SteamID()]
end

function AddItemToInventory(ply, itemKey)
    local inventory = GetPlayerInventory(ply)
    local itemConfig = VAPR_ITEMS_CONFIG[itemKey]
    if not itemConfig then return end

    local weight = GetStat(ply, "weight")

    if weight then
        if itemConfig.weight then
            if not CanAddStat(ply, "weight", itemConfig.weight) then
                notifyPlayer(ply, "You are full, you can't collect one ".. itemConfig.name)
                return false
            end
        end    
    end

    for _, item in ipairs(inventory) do
        if item.key == itemKey then
            item.quantity = item.quantity + 1

            if weight then
                if itemConfig.weight then
                    AddStat(ply, "weight", itemConfig.weight)
                end    
            end

            notifyPlayer(ply, "You collected one ".. item.name.. " you now have ".. item.quantity)
            SendUpdateInventory(ply)
            return true
        end
    end

    table.insert(inventory, {
        key = itemKey,
        name = itemConfig.name,
        stat = itemConfig.stat,
        weight = itemConfig.weight,
        description = itemConfig.description,
        model = itemConfig.model,
        function_type = itemConfig.function_type,
        value = itemConfig.value,
        quantity = 1
    })

    if weight then
        if itemConfig.weight then
            AddStat(ply, "weight", itemConfig.weight)
        end    
    end

    notifyPlayer(ply, "You collected one ".. itemConfig.name)
    SendUpdateInventory(ply)
    return true
end

function RemoveItemFromInventory(ply, itemKey, quantity)
    local inventory = GetPlayerInventory(ply)

    for i, item in ipairs(inventory) do
        if item.key == itemKey then
            item.quantity = item.quantity - (quantity or 1)
            if item.quantity <= 0 then

                if item.weight then
                    RemoveStat(ply, "weight", item.weight)
                end

                table.remove(inventory, i)
            end
            break
        end
    end

    SendUpdateInventory(ply)
end

function UseItem(ply, itemKey)
    local inventory = GetPlayerInventory(ply)
    for _, item in ipairs(inventory) do
        if item.key == itemKey then

            if item.stat != nil then
                AddStat(ply, item.stat, item.value)
            end    

            if item.function_type == "health" then
                ply:SetHealth(math.min(ply:Health() + item.value, ply:GetMaxHealth()))
            elseif item.function_type == "armor" then
                ply:SetArmor(math.min(ply:Armor() + item.value, 100))
            elseif item.function_type == "entity" then
                -- Spawn an entity or some other functionality
            elseif item.function_type == "weapon" then
                ply:Give(item.value)  -- Assuming the item key is also the weapon class name
            end
            RemoveItemFromInventory(ply, itemKey)
            break
        end
    end
end

function DropItem(ply, itemKey)
    local inventory = GetPlayerInventory(ply)
    for _, item in ipairs(inventory) do
        if item.key == itemKey then
            local itemEntity = ents.Create("vapr_item_entity")
            itemEntity:SetModel(item.model)
            itemEntity:SetItemKey(itemKey)
            itemEntity:SetPos(ply:GetPos() + ply:GetForward() * 50)
            itemEntity:Spawn()
            RemoveItemFromInventory(ply, itemKey)
            break
        end
    end
end

util.AddNetworkString("AddVAPRItemToInventory")

net.Receive("AddVAPRItemToInventory", function(len, ply)
    local entity = net.ReadEntity()
    if IsValid(entity) and entity:GetClass() == "vapr_item_entity" then
        local itemKey = entity:GetItemKey()
        if itemKey then
            AddItemToInventory(ply, itemKey)
            entity:Remove()
        end
    end
end)

hook.Add("PlayerInitialSpawn", "InitializePlayerInventory", function(ply)
    playerInventories[ply:SteamID()] = playerInventories[ply:SteamID()] or {}
end)

net.Receive("RequestInventory", function(len, ply)
    local inventory = GetPlayerInventory(ply)
    net.Start("SendInventory")
    net.WriteTable(inventory)
    net.Send(ply)
end)

net.Receive("UseItem", function(len, ply)
    local itemKey = net.ReadString()
    UseItem(ply, itemKey)
end)

net.Receive("DropItem", function(len, ply)
    local itemKey = net.ReadString()
    DropItem(ply, itemKey)
end)

function SendUpdateInventory(ply)
    net.Start("UpdateInventory")
    net.WriteTable(GetPlayerInventory(ply))
    net.Send(ply)
end

-- Example of how to add items to a player's inventory
concommand.Add("give_health_pack", function(ply)
    AddItemToInventory(ply, "health_pack")
end)

concommand.Add("give_food_item", function(ply)
    AddItemToInventory(ply, "food_item")
end)

concommand.Add("give_entity_item", function(ply)
    AddItemToInventory(ply, "entity_item")
end)

concommand.Add("give_weapon_item", function(ply)
    AddItemToInventory(ply, "weapon_item")
end)

concommand.Add("give_armor_item", function(ply)
    AddItemToInventory(ply, "armor_item")
end)
