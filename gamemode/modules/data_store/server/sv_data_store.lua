DataStore = {}
DataStore.__index = DataStore

function DataStore:new()
    local obj = setmetatable({}, self)
    return obj
end

function DataStore:init(config)
    error("Init method not implemented")
end

function DataStore:save(tableName, data)
    error("Save method not implemented")
end

function DataStore:load(tableName, identifier)
    error("Load method not implemented")
end

function DataStore:query(tableName, queryTable)
    error("Query method not implemented")
end

return DataStore