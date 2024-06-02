if SERVER then
    AddCSLuaFile("init.lua")
    AddCSLuaFile("client/cl_inventory.lua")

    -- Server
    include("server/sv_inventory.lua")
else
    include("client/cl_inventory.lua")
end
