local LifeMat = Material("materials/icons/life.png", "noclamp smooth")
local HungerMat = Material("materials/icons/hunger.png", "noclamp smooth") -- Nouvelle icône pour la faim

surface.CreateFont("InterFontSmall", {
    font = "Inter",
    size = 20,
    weight = 500,
    antialias = true,
    extended = true,
})

surface.CreateFont("InterFontLarge", {
    font = "Inter",
    size = 24,
    weight = 500,
    antialias = true,
    extended = true,
})

surface.CreateFont("Inter", {
    font = "Inter",
    size = 24,
    weight = 800,
    antialias = true,
    extended = true,
})

local borderColor = Color(59, 130, 246, 255)

local function drawBorderedBox(x, y, width, height, bgColor, bColor)
    draw.RoundedBox(6, x, y, width, height, bgColor)
    surface.SetDrawColor(bColor)
    surface.DrawOutlinedRect(x, y, width, height, 2)
end

hook.Add("HUDPaint", "DrawPlayerInfoHUD", function()
    local player = LocalPlayer()
    local trace = player:GetEyeTrace()
    local target = trace.Entity

    local cardAlpha = 0
    local cardTargetAlpha = 0
    local cardAnimationSpeed = 5

    if IsValid(target) and target:IsPlayer() and target:Alive() then
        cardTargetAlpha = 200
    else
        cardTargetAlpha = 0
    end

    cardAlpha = Lerp(FrameTime() * cardAnimationSpeed, cardAlpha, cardTargetAlpha)

    if cardAlpha > 0 then
        local targetName = target:Nick()
        local targetHealth = target:Health()

        local pos = target:GetPos() + Vector(0, 0, 85)
        local screenPos = pos:ToScreen()

        local cardWidth = 250
        local cardHeight = 70
        local cornerRadius = 8

        local backgroundColor = Color(30, 30, 30, cardAlpha)
        local textColor = Color(255, 255, 255, cardAlpha)

        draw.RoundedBox(cornerRadius, screenPos.x - cardWidth / 2, screenPos.y - cardHeight / 2, cardWidth, cardHeight, backgroundColor)

        surface.SetDrawColor(borderColor)
        surface.DrawOutlinedRect(screenPos.x - cardWidth / 2, screenPos.y - cardHeight / 2, cardWidth, cardHeight, 2)

        draw.SimpleText(targetName, "InterFontLarge", screenPos.x, screenPos.y - 10, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Health: " .. targetHealth, "InterFontSmall", screenPos.x, screenPos.y + 15, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)

local function DrawTopCenterHUD()
    local screenW, screenH = ScrW(), ScrH()

    local boxWidth = 300
    local boxHeight = 50
    local boxX = (screenW - boxWidth) / 2
    local boxY = 5

    local bgColor = Color(27, 40, 56, 255)
    local textColor = Color(220, 220, 220, 255)

    draw.RoundedBox(8, boxX, boxY, boxWidth, boxHeight, bgColor)
end

hook.Add("HUDPaint", "DrawCustomHUD", function()
    local player = LocalPlayer()
    if not player:Alive() then return end

    local screenW, screenH = ScrW(), ScrH()

    hook.Add("HUDPaint", "DrawHealthBar", function()
        if NextHUD_config.ShowHealthBar then
            local health = player:Health()
            local roundedBoxRadius = 15
            local barWidth = math.Clamp(health, 0, 100) * 2
            local barHeight = 20
            local backgroundWidth = 210
            local backgroundHeight = 30
            local barX = 55
            local barY = ScrH() - 135
            local backgroundY = ScrH() - 140
            local iconSize = 30
            local iconX = 50
            local iconY = ScrH() - 142

            draw.RoundedBox(roundedBoxRadius, 50, backgroundY, backgroundWidth, backgroundHeight, Color(27, 40, 56, 255))
            draw.RoundedBox(roundedBoxRadius, barX, barY, barWidth, barHeight, Color(59, 130, 246, 255))
    
            surface.SetMaterial(LifeMat)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
        end
    end)

    -- cl_hunger.lua
    net.Receive("UpdateHunger", function()
        local hunger = net.ReadInt(32)
        LocalPlayer():SetNWInt("Hunger", hunger)
    end)
    
    hook.Add("HUDPaint", "DrawHungerBar", function()
        if NextHUD_config and NextHUD_config.ShowHungerBar then
            local hunger = LocalPlayer():GetNWInt("Hunger", 100) 
            local roundedBoxRadius = 15
            local barWidth = math.Clamp(hunger, 0, 100) * 2
            local barHeight = 20
            local backgroundWidth = 210
            local backgroundHeight = 30
            local barX = 55
            local barY = ScrH() - 95
            local backgroundY = ScrH() - 100
            local iconSize = 30
            local iconX = 50
            local iconY = ScrH() - 102
       
            draw.RoundedBox(roundedBoxRadius, 50, backgroundY, backgroundWidth, backgroundHeight, Color(27, 40, 56, 255))
            
            draw.RoundedBox(roundedBoxRadius, barX, barY, barWidth, barHeight, Color(59, 130, 246, 255))
    
            if HungerMat then
                surface.SetMaterial(HungerMat)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
            end
        end
    end)
        
    if NextHUD_config.ShowArmorBar then
        local armor = player:Armor()
        local roundedBoxRadius = 15
        local barWidth = math.Clamp(armor, 0, 100) * 2
        local barHeight = 20
        local backgroundWidth = 210
        local backgroundHeight = 30
        local barX = 55
        local barY = screenH - 55
        local backgroundY = screenH - 60

        draw.RoundedBox(roundedBoxRadius, 50, backgroundY, backgroundWidth, backgroundHeight, Color(27, 40, 56, 255))
        draw.RoundedBox(roundedBoxRadius, barX, barY, barWidth, barHeight, Color(59, 130, 246, 255))
    end

    if NextHUD_config.ShowAmmo then
        local weapon = player:GetActiveWeapon()
        if IsValid(weapon) and weapon:Clip1() >= 0 and weapon:GetClass() ~= "weapon_physcannon" then
            local ammoCount = weapon:Clip1()
            local maxAmmo = weapon:GetMaxClip1()
            local reserveAmmo = player:GetAmmoCount(weapon:GetPrimaryAmmoType())
    
            local ammoBoxWidth = 140
            local ammoBoxHeight = 40
            local cornerRadius = 6
    
            local backgroundColor = Color(27, 40, 56, 255)
            local lineColor = Color(59, 130, 246, 255)
            local textColor = Color(255, 255, 255, 255)
    
            local ammoBoxX = screenW - ammoBoxWidth - 20
            local ammoBoxY = screenH - ammoBoxHeight - 20
    
            local lineWidth = (ammoCount / maxAmmo) * ammoBoxWidth 
            local lineHeight = ammoBoxHeight - 10
    
            local lineY = ammoBoxY + (ammoBoxHeight - lineHeight) / 2
    
            draw.RoundedBox(cornerRadius, ammoBoxX, ammoBoxY, ammoBoxWidth, ammoBoxHeight, backgroundColor)
            draw.RoundedBox(0, ammoBoxX, lineY, lineWidth, lineHeight, lineColor)
    
            draw.SimpleText(ammoCount .. " / " .. reserveAmmo, "Inter", ammoBoxX + ammoBoxWidth / 2, ammoBoxY + ammoBoxHeight / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    DrawTopCenterHUD()
end)

hook.Add("PlayerBindPress", "DoorOptions", function(player, bind, pressed)
    if bind == "gm_showspare2" and pressed then
        local trace = player:GetEyeTrace()
        if IsValid(trace.Entity) and trace.Entity:GetClass() == "prop_door_rotating" then
            -- Open door menu
        end
    end
end)

local function CustomNotification(text)
    notification.AddLegacy(text, NOTIFY_GENERIC, 5)
    surface.PlaySound("buttons/button15.wav")
end

net.Receive("CustomNotify", function()
    local text = net.ReadString()
    CustomNotification(text)
end)
