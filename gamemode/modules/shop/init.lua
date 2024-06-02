if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("client/cl_shop.lua")

    include("server/sv_shop.lua")
else
    include("client/cl_shop.lua")
end