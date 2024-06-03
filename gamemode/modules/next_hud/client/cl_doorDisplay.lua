local doorCardAlpha = 0
local doorLastTraceEntity = nil
local doorTargetAlpha = 0
local doorFadeStartTime = 0
local lastDoor = nil
local fixedAngle = nil
local maxDistance = 300 -- Distance maximale à partir de laquelle le panneau sera visible

surface.CreateFont("InterFontDoorSmall", {
    font = "Inter",
    size = 90,
    weight = 500,
    antialias = true
})

surface.CreateFont("InterFontDoorSmall2", {
    font = "Inter",
    size = 60,
    weight = 800,
    antialias = true
})

surface.CreateFont("InterFontDoorBig", {
    font = "Inter",
    size = 120,
    weight = 800,
    antialias = true
})

hook.Add("PostDrawTranslucentRenderables", "Draw3DDoorInfo", function()
    if not NextHUD_config.Show3DDoorInfo then return end

    local player = LocalPlayer()
    local trace = player:GetEyeTrace()
    local door = trace.Entity

    -- Remplacer la vérification DarkRP par une vérification personnalisée
    if IsValid(door) and door:GetClass() == "prop_door_rotating" and player:GetPos():Distance(door:GetPos()) <= maxDistance then
        if door ~= doorLastTraceEntity then
            doorLastTraceEntity = door
            lastDoor = door
            doorCardAlpha = 0
            doorTargetAlpha = 255
            doorFadeStartTime = CurTime()
            fixedAngle = nil
        end
    else
        if doorLastTraceEntity then
            doorLastTraceEntity = nil
            doorTargetAlpha = 0
            doorFadeStartTime = CurTime()
        end
    end

    door = lastDoor

    doorCardAlpha = Lerp(math.Clamp((CurTime() - doorFadeStartTime) / 1, 0, 1), doorCardAlpha, doorTargetAlpha)

    if doorCardAlpha > 0 then
        local pos
        local scale = 0.06

        if IsValid(door) then
            pos = door:GetPos() + (player:GetForward() * -20) + Vector(0, 0, 10)
            local distance = player:GetPos():Distance(door:GetPos())
            scale = math.Clamp(1 / (distance / 500), 0.03, 0.05) -- Ajustez l'échelle en fonction de la distance

            local angle = player:GetAngles()
            fixedAngle = Angle(0, angle.y - 100, 90)
        else
            return
        end

        local doorWidth = door:OBBMaxs().z - door:OBBMins().z
        doorWidth = doorWidth * (0.25 / scale)
        local x_offset = 0

        cam.Start3D2D(pos, fixedAngle, scale)

        local bgColor = Color(27, 40, 56, 255 * (doorCardAlpha / 255))
        local blueColor = Color(59, 130, 246, 255 * (doorCardAlpha / 255))
        local borderColor = Color(0, 122, 204, 0 * (doorCardAlpha / 255))
        local textColor = Color(220, 220, 220, doorCardAlpha)
        local borderThickness = 4
        local cardWidth = 700
        local cardHeight = 250

        x_offset = x_offset - (cardWidth / 2)

        draw.RoundedBox(10, x_offset, -100, cardWidth, cardHeight, bgColor)
        draw.RoundedBox(10, x_offset - 10, -100, 30, cardHeight, blueColor) -- Barre bleue verticale à gauche

        surface.SetDrawColor(borderColor)
        surface.DrawOutlinedRect(x_offset, -100, cardWidth, cardHeight, borderThickness)

        -- Remplacer les informations de DarkRP par des informations personnalisées
        local ownerText = "Buy now"
        local priceText = "$100" -- Définir un prix par défaut

        local doorText = "Door"

        -- Si la porte a un propriétaire, ajuster les informations
        if door:GetNWBool("Owned", false) then
            ownerText = "OWNED BY"
            priceText = door:GetNWString("OwnerName", "Unknown")
            doorText = door:GetNWString("DoorTitle", "Door")
        end

        draw.SimpleTextOutlined(doorText, "InterFontDoorSmall", x_offset + 40, -30, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(100, 100, 100, doorCardAlpha))

        draw.SimpleTextOutlined(ownerText, "InterFontDoorSmall2", -x_offset - 20, -30, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(100, 100, 100, doorCardAlpha))
        draw.SimpleTextOutlined(priceText, "InterFontDoorBig", x_offset + 40, 70, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(100, 100, 100, doorCardAlpha))

        cam.End3D2D()
    end
end)
