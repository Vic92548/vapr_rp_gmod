surface.CreateFont("InterFont", {
    font = "Inter Regular",
    size = 18,
    weight = 500,
    antialias = true
})

surface.CreateFont("InterFontLarge", {
    font = "Inter Regular",
    size = 24,
    weight = 600,
    antialias = true
})

local blackColor = Color(27, 40, 56, 255)
local blueColor = Color(59, 130, 246, 255)
local whiteColor = Color(220, 220, 220, 255)
local blackColorTransparent = Color(27, 40, 56, 180) -- Couleur noire avec opacité réduite

local weapons = {}
local selectedWeaponIndex = 1
local displayTime = 5
local lastSwitchTime = 0
local selectorOpen = false -- Variable pour suivre l'état d'affichage du sélecteur d'arme

local function DrawWeaponSelector()
    if (CurTime() - lastSwitchTime) > displayTime then
        selectorOpen = false
        return
    end
    
    selectorOpen = true
    
    local screenWidth, screenHeight = ScrW(), ScrH()
    local x, y = 50, (screenHeight * 0.5) - (#weapons * 25 * 0.5) -- Positionne au milieu verticalement
    local width, height = 200, 25
    local selectedWidth, selectedHeight = 220, 35
    local padding = 2
    local currentY = y

    for i, weapon in ipairs(weapons) do
        if not IsValid(weapon) then
            continue
        end

        local boxColor = blackColorTransparent
        local font = "InterFont"
        local boxWidth, boxHeight = width, height
        local barWidth = 4

        if i == selectedWeaponIndex then
            boxColor = blueColor
            font = "InterFontLarge"
            boxWidth, boxHeight = selectedWidth, selectedHeight
        else
            -- Barre bleue à gauche
            draw.RoundedBox(0, x, currentY, barWidth, boxHeight, blueColor)
        end

        draw.RoundedBox(0, x + barWidth, currentY, boxWidth - barWidth, boxHeight, boxColor)
        draw.SimpleText(weapon:GetPrintName(), font, x + (boxWidth / 2), currentY + boxHeight / 2, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        currentY = currentY + boxHeight + padding
    end
end

hook.Add("HUDPaint", "DrawWeaponSelector", DrawWeaponSelector)

local function SelectNextWeapon()
    selectedWeaponIndex = selectedWeaponIndex + 1
    if selectedWeaponIndex > #weapons then
        selectedWeaponIndex = 1
    end
    lastSwitchTime = CurTime()
end

local function SelectPreviousWeapon()
    selectedWeaponIndex = selectedWeaponIndex - 1
    if selectedWeaponIndex < 1 then
        selectedWeaponIndex = #weapons
    end
    lastSwitchTime = CurTime()
end

hook.Add("PlayerBindPress", "WeaponSelectorBindings", function(ply, bind, pressed)
    if bind == "invnext" and pressed then
        SelectNextWeapon()
        return true
    elseif bind == "invprev" and pressed then
        SelectPreviousWeapon()
        return true
    elseif bind == "+attack" and selectorOpen then
        return true
    end
end)

local function UpdateWeapons()
    local player = LocalPlayer()
    if IsValid(player) then
        weapons = player:GetWeapons()
    end
end

hook.Add("PlayerSwitchWeapon", "UpdateWeaponsOnSwitch", UpdateWeapons)
hook.Add("InitPostEntity", "UpdateWeaponsOnInit", UpdateWeapons)

local function HideDefaultHUD(name)
    if name == "CHudWeaponSelection" then
        return false
    end
end

hook.Add("HUDShouldDraw", "HideDefaultWeaponSelector", HideDefaultHUD)

-- Mettre à jour la liste des armes chaque seconde pour s'assurer qu'elle est toujours actuelle
timer.Create("UpdateWeaponsTimer", 1, 0, UpdateWeapons)

-- Fonction pour équiper l'arme sélectionnée
local function EquipSelectedWeapon()
    local selectedWeapon = weapons[selectedWeaponIndex]
    if IsValid(selectedWeapon) and LocalPlayer():HasWeapon(selectedWeapon:GetClass()) then
        input.SelectWeapon(selectedWeapon)
        lastSwitchTime = 0 -- Réinitialise le temps pour fermer le sélecteur
        selectorOpen = false -- Ferme le sélecteur
    end
end

-- Détecter le clic gauche de la souris
hook.Add("Think", "DetectLeftMouseClick", function()
    if input.IsMouseDown(MOUSE_LEFT) and selectorOpen then
        EquipSelectedWeapon()
    end
end)
