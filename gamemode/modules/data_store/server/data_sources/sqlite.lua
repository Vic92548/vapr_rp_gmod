local sqlite = require("lsqlite3")
local DataStore = include("data_store.lua")
local SQLiteStore = setmetatable({}, {__index = DataStore})

function SQLiteStore:init(config)
    self.db = sqlite.open(config.db_path)
end

function SQLiteStore:save(tableName, data)
    local stmt = self.db:prepare("INSERT OR REPLACE INTO " .. tableName .. " (identifier, json_data) VALUES (?, ?)")
    stmt:bind_values(data.identifier, util.TableToJSON(data))
    stmt:step()
    stmt:finalize()
end

function SQLiteStore:load(tableName, identifier, callback)
    local query = "SELECT json_data FROM " .. tableName .. " WHERE identifier = ?"
    local stmt = self.db:prepare(query)
    stmt:bind_values(identifier)
    local result = nil
    for row in stmt:nrows() do
        result = util.JSONToTable(row.json_data)
    end
    stmt:finalize()
    callback(result)
end

function SQLiteStore:query(tableName, queryTable, callback)
    local queryString = "SELECT * FROM " .. tableName .. " WHERE "
    local conditions = {}
    for key, value in pairs(queryTable) do
        table.insert(conditions, key .. " = '" .. value .. "'")
    end
    queryString = queryString .. table.concat(conditions, " AND ")

    local results = {}
    for row in self.db:nrows(queryString) do
        table.insert(results, row)
    end
    callback(results)
end

return SQLiteStore