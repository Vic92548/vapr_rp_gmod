local vehicleMaxSpeed = {}

net.Receive("SendVehicleMaxSpeed", function()
    local vehicle = net.ReadEntity()
    local maxSpeed = net.ReadInt(32)
    vehicleMaxSpeed[vehicle:EntIndex()] = maxSpeed
end)

-- Fonction pour interpoler entre deux couleurs
local function LerpColor(t, col1, col2)
    return Color(
        Lerp(t, col1.r, col2.r),
        Lerp(t, col1.g, col2.g),
        Lerp(t, col1.b, col2.b),
        Lerp(t, col1.a, col2.a)
    )
end

hook.Add("HUDPaint", "CustomVehicleHUD", function()
    if NextHUD_config.ShowVehicleHUD and LocalPlayer():InVehicle() then
        local vehicle = LocalPlayer():GetVehicle()
        local entIndex = vehicle:EntIndex()
        
        local speed = math.floor(vehicle:GetVelocity():Length() * 0.0568182)
        
        -- Récupération de la vitesse maximale envoyée par le serveur
        local maxSpeed = vehicleMaxSpeed[entIndex] or 200
        
        local screenW, screenH = ScrW(), ScrH()
        local barWidth, barHeight = 300, 20
        local barX, barY = screenW / 2 - barWidth / 2, screenH - 100
        
        local speedRatio = math.Clamp(speed / maxSpeed, 0, 1)
        local fillWidth = barWidth * speedRatio
        
        -- Définir les couleurs de base pour le dégradé
        local colorStart = Color(76, 175, 80, 255) -- Vert pour vitesse basse
        local colorEnd = Color(244, 67, 54, 255) -- Rouge pour vitesse haute
        local currentColor = LerpColor(speedRatio, colorStart, colorEnd)
        
        -- Dessiner la bordure de la barre avec la nouvelle couleur
        draw.RoundedBox(10, barX - 2, barY - 2, barWidth + 4, barHeight + 4, Color(27, 40, 56, 255)) -- Bordure avec la nouvelle couleur
        
        -- Restaurer la couleur de fond de la barre
        draw.RoundedBox(10, barX, barY, barWidth, barHeight, Color(33, 33, 33, 200)) -- Barre de fond
        
        -- Dessiner la barre de progression avec le dégradé et des bords arrondis
        draw.RoundedBox(10, barX, barY, fillWidth, barHeight, currentColor)
        
        -- Ajouter un léger dégradé sur la barre de progression
        local gradient = Material("vgui/gradient-r")
        surface.SetMaterial(gradient)
        surface.SetDrawColor(Color(255, 255, 255, 50)) -- Dégradé blanc transparent
        surface.DrawTexturedRect(barX, barY, fillWidth, barHeight)
        
        -- Ajouter une ombre au texte
        draw.SimpleText(speed .. " km/h", "InterFont", screenW / 2 + 1, barY + barHeight / 2 + 1, Color(0, 0, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Ombre
        draw.SimpleText(speed .. " km/h", "InterFont", screenW / 2, barY + barHeight / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Texte principal
    end
end)
