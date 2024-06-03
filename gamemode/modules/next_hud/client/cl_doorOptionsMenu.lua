-- CLIENT-SIDE CODE

-- Création de la police Inter
surface.CreateFont("InterFont", {
    font = "Inter",
    size = 20,
    weight = 500,
    antialias = true
})

-- Couleurs définies
local colorBlack = Color(27, 40, 56, 255)
local colorBlue = Color(59, 130, 246, 255)
local colorWhite = Color(220, 220, 220, 255)
local colorHover = Color(75, 150, 255, 255)  -- Couleur pour le survol

-- Fonction pour styliser les boutons
local function styleButton(button)
    button:SetTextColor(colorWhite)
    button.Paint = function(self, w, h)
        local bgColor = self:IsHovered() and colorHover or colorBlue
        draw.RoundedBox(4, 0, 0, w, h, bgColor)
        draw.SimpleText(self:GetText(), "InterFont", w / 2, h / 2, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

-- Fonction pour créer le menu Door Options
local function OpenDoorOptionsMenu(door)
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Door Options")
    frame:SetSize(400, 300)
    frame:Center()
    frame:MakePopup()
    frame:SetFontInternal("InterFont")
    frame.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, colorBlack)
        draw.RoundedBox(0, 0, 0, w, 25, colorBlue) -- Bande supérieure pour le titre
    end

    local sellButton = vgui.Create("DButton", frame)
    sellButton:SetText("Sell Door")
    sellButton:SetFont("InterFont")
    sellButton:SetSize(360, 40)
    sellButton:SetPos(20, 50)
    sellButton.DoClick = function()
        net.Start("SellDoor")
        net.WriteEntity(door)
        net.SendToServer()
        frame:Close()
    end
    styleButton(sellButton)

    local addCoOwnerButton = vgui.Create("DButton", frame)
    addCoOwnerButton:SetText("Add Co-Owner")
    addCoOwnerButton:SetFont("InterFont")
    addCoOwnerButton:SetSize(360, 40)
    addCoOwnerButton:SetPos(20, 100)
    addCoOwnerButton.DoClick = function()
        -- Ouvrir un menu pour sélectionner un joueur
        local playerList = vgui.Create("DFrame")
        playerList:SetTitle("Select Player")
        playerList:SetSize(300, 400)
        playerList:Center()
        playerList:MakePopup()
        playerList.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, colorBlack)
            draw.RoundedBox(0, 0, 0, w, 25, colorBlue) -- Bande supérieure pour le titre
        end

        local playerScroll = vgui.Create("DScrollPanel", playerList)
        playerScroll:Dock(FILL)

        for _, ply in pairs(player.GetAll()) do
            local plyButton = playerScroll:Add("DButton")
            plyButton:Dock(TOP)
            plyButton:DockMargin(0, 0, 0, 5)
            plyButton:SetText(ply:Nick())
            plyButton:SetFont("InterFont")
            plyButton.DoClick = function()
                net.Start("AddCoOwner")
                net.WriteEntity(door)
                net.WriteEntity(ply)
                net.SendToServer()
                playerList:Close()
            end
            styleButton(plyButton)
        end
    end
    styleButton(addCoOwnerButton)

    local removeCoOwnerButton = vgui.Create("DButton", frame)
    removeCoOwnerButton:SetText("Remove Co-Owner")
    removeCoOwnerButton:SetFont("InterFont")
    removeCoOwnerButton:SetSize(360, 40)
    removeCoOwnerButton:SetPos(20, 150)
    removeCoOwnerButton.DoClick = function()
        -- Ouvrir un menu pour sélectionner un copropriétaire à retirer
        local coOwnerList = vgui.Create("DFrame")
        coOwnerList:SetTitle("Select Co-Owner to Remove")
        coOwnerList:SetSize(300, 400)
        coOwnerList:Center()
        coOwnerList:MakePopup()
        coOwnerList.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, colorBlack)
            draw.RoundedBox(0, 0, 0, w, 25, colorBlue) -- Bande supérieure pour le titre
        end

        local coOwnerScroll = vgui.Create("DScrollPanel", coOwnerList)
        coOwnerScroll:Dock(FILL)

        local coOwners = door:getDoorData().coOwners or {}
        for coOwner, _ in pairs(coOwners) do
            local plyButton = coOwnerScroll:Add("DButton")
            plyButton:Dock(TOP)
            plyButton:DockMargin(0, 0, 0, 5)
            plyButton:SetText(coOwner:Nick())
            plyButton:SetFont("InterFont")
            plyButton.DoClick = function()
                net.Start("RemoveCoOwner")
                net.WriteEntity(door)
                net.WriteEntity(coOwner)
                net.SendToServer()
                coOwnerList:Close()
            end
            styleButton(plyButton)
        end
    end
    styleButton(removeCoOwnerButton)

    local setTitleButton = vgui.Create("DButton", frame)
    setTitleButton:SetText("Set Door Title")
    setTitleButton:SetFont("InterFont")
    setTitleButton:SetSize(360, 40)
    setTitleButton:SetPos(20, 200)
    setTitleButton.DoClick = function()
        -- Ouvrir un menu pour entrer le titre de la porte
        local titleFrame = vgui.Create("DFrame")
        titleFrame:SetTitle("Set Door Title")
        titleFrame:SetSize(300, 150)
        titleFrame:Center()
        titleFrame:MakePopup()
        titleFrame.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, colorBlack)
            draw.RoundedBox(0, 0, 0, w, 25, colorBlue) -- Bande supérieure pour le titre
        end

        local textEntry = vgui.Create("DTextEntry", titleFrame)
        textEntry:SetSize(280, 30)
        textEntry:SetPos(10, 50)
        textEntry:SetFont("InterFont")
        textEntry:SetText(door:getDoorData().title or "")
        textEntry:SetTextColor(colorWhite)
        textEntry:SetDrawBackground(false)
        textEntry.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, colorBlue)
            self:DrawTextEntryText(colorWhite, colorBlue, colorWhite)
        end

        local saveButton = vgui.Create("DButton", titleFrame)
        saveButton:SetText("Save")
        saveButton:SetFont("InterFont")
        saveButton:SetSize(280, 30)
        saveButton:SetPos(10, 90)
        saveButton.DoClick = function()
            net.Start("SetDoorTitle")
            net.WriteEntity(door)
            net.WriteString(textEntry:GetValue())
            net.SendToServer()
            titleFrame:Close()
        end
        styleButton(saveButton)
    end
    styleButton(setTitleButton)
end

-- Hook pour intercepter l'ouverture du menu des clés
hook.Add("onKeysMenuOpened", "OpenCustomDoorOptionsMenu", function(ent, frame)
    if not IsValid(ent) or not ent:isKeysOwnable() then return end
    OpenDoorOptionsMenu(ent)
    frame:Close()  -- Fermer le menu par défaut
end)
