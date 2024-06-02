AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "VAPR Item"
ENT.Author = "VAPR"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ItemKey")
end
