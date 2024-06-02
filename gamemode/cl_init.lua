-- socialize_roleplay/gamemode/cl_init.lua

include("sh_config.lua")

include("shared/shared.lua")

include("client/cl_hud.lua")

-- MODULES
include("modules/notifications/init.lua")
include("modules/stats/init.lua")
include("modules/inventory/init.lua")
include("modules/character_creator/init.lua")
include("modules/weapon_hud/init.lua")

function GM:Initialize()
    self.BaseClass.Initialize(self)
end



