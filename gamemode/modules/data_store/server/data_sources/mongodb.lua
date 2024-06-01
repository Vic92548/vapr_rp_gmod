local mongo = require("gmod-mongodb")
local DataStore = include("data_store.lua")
local MongoDBStore = setmetatable({}, {__index = DataStore})

function MongoDBStore:init(config)
    self.client = mongo.Client(config.connectionString)
    self.db = self.client:getDatabase(config.databaseName)
end

function MongoDBStore:save(tableName, data)
    local collection = self.db:getCollection(tableName)
    local query = { identifier = data.identifier }
    local update = { ["$set"] = { json_data = util.TableToJSON(data) } }
    collection:updateOne(query, update, { upsert = true })
end

function MongoDBStore:load(tableName, identifier, callback)
    local collection = self.db:getCollection(tableName)
    local query = { identifier = identifier }
    local document = collection:findOne(query)
    callback(document and util.JSONToTable(document.json_data) or nil)
end

function MongoDBStore:query(tableName, queryTable, callback)
    local collection = self.db:getCollection(tableName)
    local cursor = collection:find(queryTable)
    local results = {}
    for doc in cursor:iterator() do
        table.insert(results, doc)
    end
    callback(results)
end

return MongoDBStore