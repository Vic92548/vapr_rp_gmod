if SERVER then
    AddCSLuaFile("init.lua")
    AddCSLuaFile("client/cl_stats.lua")

    -- Shared
    AddCSLuaFile("shared/sh_stats.lua")

    -- Server
    include("server/sv_stats.lua")
    include("server/sv_stats_tools.lua")
    include("server/commands.lua")
else
    include("client/cl_stats.lua")
    include("shared/sh_stats.lua")
end    