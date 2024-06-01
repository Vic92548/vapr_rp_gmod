-- Example usage
local DataManager = include("data_manager.lua")

-- Pour SQLite
local sqliteManager = DataManager:new("sqlite", { db_path = "data.db" })
sqliteManager:save("players", { identifier = "player_1", some_data = "value" })
sqliteManager:load("players", "player_1", function(data) PrintTable(data) end)
sqliteManager:query("players", { some_data = "value" }, function(results) PrintTable(results) end)

-- Pour MySQL
local mysqlManager = DataManager:new("mysql", { host = "localhost", username = "username", password = "password", database = "database", port = 3306 })
mysqlManager:save("players", { identifier = "player_2", some_data = "value" })
mysqlManager:load("players", "player_2", function(data) PrintTable(data) end)
mysqlManager:query("players", { some_data = "value" }, function(results) PrintTable(results) end)

-- Pour MongoDB
local mongoManager = DataManager:new("mongodb", { connectionString = "mongodb://localhost:27017", databaseName = "mydatabase" })
mongoManager:save("players", { identifier = "player_3", some_data = "value" })
mongoManager:load("players", "player_3", function(data) PrintTable(data) end)
mongoManager:query("players", { some_data = "value" }, function(results) PrintTable(results) end)
