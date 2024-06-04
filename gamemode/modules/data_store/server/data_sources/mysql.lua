require("mysqloo")
local MySQLStore = setmetatable({}, {__index = DataStore})

function MySQLStore:init(config)
    self.db = mysqloo.connect(config.host, config.username, config.password, config.database, config.port)
    self.db:connect()
end

function MySQLStore:save(tableName, data)
    local query = self.db:prepare("INSERT INTO " .. tableName .. " (identifier, json_data) VALUES (?, ?) ON DUPLICATE KEY UPDATE json_data = VALUES(json_data)")
    query:setString(1, data.identifier)
    query:setString(2, util.TableToJSON(data))
    query:start()
end

function MySQLStore:load(tableName, identifier, callback)
    local query = self.db:prepare("SELECT json_data FROM " .. tableName .. " WHERE identifier = ?")
    query:setString(1, identifier)
    query.onSuccess = function(q)
        local data = q:getData()[1]
        callback(data and util.JSONToTable(data.json_data) or nil)
    end
    query.onError = function(q, err)
        print("MySQL Query Error: " .. err)
        callback(nil)
    end
    query:start()
end

function MySQLStore:query(tableName, queryTable, callback)
    local queryString = "SELECT * FROM " .. tableName .. " WHERE "
    local conditions = {}
    for key, value in pairs(queryTable) do
        table.insert(conditions, key .. " = '" .. value .. "'")
    end
    queryString = queryString .. table.concat(conditions, " AND ")

    local query = self.db:query(queryString)
    query.onSuccess = function(q)
        callback(q:getData())
    end
    query.onError = function(q, err)
        print("MySQL Query Error: " .. err)
        callback(nil)
    end
    query:start()
end

return MySQLStore