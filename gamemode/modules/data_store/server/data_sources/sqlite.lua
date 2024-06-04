local SQLiteStore = setmetatable({}, {__index = DataStore})

function SQLiteStore:init(config)
    self.config = config
end

function SQLiteStore:createTable(tableName)
    local query = "CREATE TABLE IF NOT EXISTS " .. tableName .. " (identifier TEXT PRIMARY KEY, json_data TEXT)"
    local result = sql.Query(query)
    if result == false or result == nil then
        print("Failed to create table " .. tableName .. ": " .. sql.LastError())
    else
        print("Table " .. tableName .. " created successfully.")
    end
end

function SQLiteStore:save(tableName, data)
    local function attemptSave()
        local query = "INSERT OR REPLACE INTO " .. tableName .. " (identifier, json_data) VALUES (%s, %s)"
        query = string.format(query, sql.SQLStr(data.identifier), sql.SQLStr(util.TableToJSON(data)))
        local result = sql.Query(query)
        return result
    end

    local result = attemptSave()
    print("RESULT:")
    print(result)
    if result == false then
        local lastError = sql.LastError()
        if string.find(lastError, "no such table") then
            print("Table " .. tableName .. " does not exist. Creating table...")
            self:createTable(tableName)
            result = attemptSave()
            if result == false or result == nil then
                print("Failed to save data after creating table: " .. sql.LastError())
                return false
            else
                print("Data saved successfully after creating table " .. tableName .. ".")
                return true
            end
        else
            print("Failed to save data: " .. lastError)
            return false
        end
    else
        print("Data saved successfully.")
        return true
    end
end

function SQLiteStore:load(tableName, identifier, callback)
    local query = string.format("SELECT json_data FROM %s WHERE identifier = %s", tableName, sql.SQLStr(identifier))
    local result = sql.QueryRow(query)
    if result then
        callback(util.JSONToTable(result.json_data))
    else
        callback(nil)
    end
end

function SQLiteStore:query(tableName, queryTable, callback)
    local conditions = {}
    for key, value in pairs(queryTable) do
        table.insert(conditions, string.format("%s = %s", key, sql.SQLStr(value)))
    end
    local queryString = string.format("SELECT * FROM %s WHERE %s", tableName, table.concat(conditions, " AND "))
    
    local results = sql.Query(queryString)
    callback(results or {})
end

return SQLiteStore
