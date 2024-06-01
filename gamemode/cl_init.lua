-- socialize_roleplay/gamemode/cl_init.lua

include("sh_config.lua")

include("shared/shared.lua")

include("client/cl_hud.lua")

-- MODULES
include("modules/stats/init.lua")
include("modules/character_creator/init.lua")

function GM:Initialize()
    self.BaseClass.Initialize(self)
end



