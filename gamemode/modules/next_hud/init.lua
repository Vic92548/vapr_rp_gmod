-- cl_init.lua
if SERVER then
    AddCSLuaFile("init.lua")

    resource.AddFile("materials/icons/armor.png")
    resource.AddFile("materials/icons/life.png")
    resource.AddFile("materials/icons/hunger.png")

    AddCSLuaFile("client/cl_customNotification.lua")
    AddCSLuaFile("client/cl_doorDisplay.lua")
    AddCSLuaFile("client/cl_doorOptionsMenu.lua")
    AddCSLuaFile("client/cl_vehiclespeed.lua")
    AddCSLuaFile("client/cl_hud.lua")

    include("server/sv_doorOptionsMenu.lua")
    include("server/sv_customVote.lua")
    include("server/sv_vehiclespeed.lua")
else
    include("client/cl_customNotification.lua")
    include("client/cl_doorDisplay.lua")
    include("client/cl_doorOptionsMenu.lua")
    include("client/cl_vehiclespeed.lua")
    include("client/cl_hud.lua")
end