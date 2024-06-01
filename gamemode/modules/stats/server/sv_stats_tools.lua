-- Function to spawn a generic stat entity
function SpawnGenericStatEntity(pos, ang, model, stat, value)
    local ent = ents.Create("generic_stat_entity")
    if not IsValid(ent) then return end
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetModel(model)
    ent:SetStat(stat)
    ent:SetValue(value)
    ent:Spawn()
    ent:Activate()
    return ent
end
