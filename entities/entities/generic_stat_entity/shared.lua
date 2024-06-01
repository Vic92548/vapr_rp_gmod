AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Generic Stat Entity"
ENT.Author = "YourName"
ENT.Category = "Custom"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Initialize()
    if SERVER then
        self:SetModel(self.model or "models/props_c17/oildrum001.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Stat")
    self:NetworkVar("Int", 0, "Value")
end

if SERVER then
    function ENT:Use(activator, caller)
        if IsValid(activator) and activator:IsPlayer() then
            local stat = self:GetStat()
            local value = self:GetValue()
            AddStat(activator, stat, value)
            self:Remove()
        end
    end
end
