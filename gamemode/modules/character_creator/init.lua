if SERVER then
    AddCSLuaFile("init.lua")
    AddCSLuaFile("client/cl_character_creator.lua")

    -- Shared
    AddCSLuaFile("shared/sh_character_creator.lua")

    -- Server
    include("server/sv_character_creator.lua")
    include("shared/sh_character_creator.lua")
else
    include("client/cl_character_creator.lua")
    include("shared/sh_character_creator.lua")
end  