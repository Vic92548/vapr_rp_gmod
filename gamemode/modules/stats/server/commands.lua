concommand.Add("spawn_generic_stat_entity", function(ply, cmd, args)
    --if not ply:IsAdmin() then return end  -- Only admins can use this command
    if #args < 4 then
        ply:ChatPrint("Usage: spawn_generic_stat_entity <model> <stat> <value>")
        return
    end

    local model = args[1]
    local stat = args[2]
    local value = tonumber(args[3])
    local pos = ply:GetEyeTrace().HitPos + Vector(0, 0, 50)
    local ang = ply:EyeAngles()

    SpawnGenericStatEntity(pos, ang, model, stat, value)
end)

--models/props/cs_assault/money.mdl