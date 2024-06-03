if SERVER then

    AddCSLuaFile("init.lua")
    AddCSLuaFile("client/cl_hunger_system.lua")

    include("server/sv_hunger_system.lua")

else
    include("client/cl_hunger_system.lua")
end














