-- init.lua
resource.AddFile("resource/fonts/Inter-Regular.ttf")
resource.AddFile("resource/fonts/Inter-Bold.ttf")

-- socialize_roleplay/gamemode/init.lua
AddCSLuaFile("sh_config.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("client/cl_hud.lua")
AddCSLuaFile("shared/shared.lua")

include("sh_config.lua")
include("sv_config.lua")
include("player.lua")


-- MODULES
include("modules/stats/init.lua")

include("modules/inventory/init.lua")

-- character_creator
include("modules/character_creator/init.lua")

include("shared/shared.lua")

-- Include the player loadout script
include("server/player_loadout.lua")

-- Other initialization code
include("admin.lua")