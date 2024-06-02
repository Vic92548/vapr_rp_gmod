if SERVER then
    AddCSLuaFile("init.lua")
    AddCSLuaFile("client/cl_weapon_selector.lua")

else
    include("client/cl_weapon_selector.lua")
end 