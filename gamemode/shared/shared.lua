-- socialize_roleplay/gamemode/shared.lua
GM.Name = "VAPR RolePlay"
GM.Author = "VAPR.GG"
GM.Email = "vapr.gg"
GM.Website = "https://vapr.gg"

DeriveGamemode("base")

function GM:Initialize()
    self.BaseClass.Initialize(self)
end
