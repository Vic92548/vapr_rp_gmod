-- data_manager.lua
DataManager = {}
DataManager.__index = DataManager

local sqlite = include("data_sources/sqlite.lua")

local function getStore(storeType)
    if storeType == "sqlite" then
        return sqlite
    elseif storeType == "mysql" then
        return include("data_sources/mysql.lua")
    elseif storeType == "mongodb" then
        return include("data_sources/mongodb.lua")
    else
        error("Unsupported store type")
    end
end

function DataManager:new(storeType, config)
    local Store = getStore(storeType)
    PrintTable(Store)
    Store:init(config)
    setmetatable(Store, self)
    return Store
end

function DataManager:save(tableName, data)
    self.store:save(tableName, data)
end

function DataManager:load(tableName, identifier, callback)
    self.store:load(tableName, identifier, callback)
end

function DataManager:query(tableName, queryTable, callback)
    self.store:query(tableName, queryTable, callback)
end

return DataManager