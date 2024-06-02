if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("client/cl_notifications.lua")
    include("server/sv_notifications.lua")
else
    include("client/cl_notifications.lua")
end