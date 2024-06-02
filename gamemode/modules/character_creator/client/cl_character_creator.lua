surface.CreateFont("InterFont", {
    font = "Inter Regular",
    size = 19,
    weight = 800,
    antialias = true
})

local frame
local modelSelector
local modelPreview
local fieldEntries = {}

local function FilterModels()
    local filteredModels = {}

    for _, model in ipairs(VAPR_CHARACTER_CREATOR_CONFIG.models) do
        local match = true
        for fieldName, entry in pairs(fieldEntries) do
            local value = entry:GetValue()
            local modelValue = model[fieldName:lower()]
            
            if value and value ~= "" and modelValue and tostring(modelValue) ~= tostring(value) then
                match = false
                break
            end
        end

        if match then
            table.insert(filteredModels, model.path)
        end
    end

    print("Filtering models with the selected criteria")
    PrintTable(filteredModels)

    return filteredModels
end

local function UpdateModelPreview(modelPath)
    if modelPreview then
        modelPreview:SetModel(modelPath)
    end
end

local function UpdateModelSelector()
    print("Updating model selector with current selections")

    modelSelector:Clear()
    local models = FilterModels()
    if #models == 0 then
        notification.AddLegacy("No models available for the selected criteria.", NOTIFY_ERROR, 5)
        return
    end

    local panelWidth = modelSelector:GetWide()
    local panelHeight = modelSelector:GetTall()
    local spacing = 10

    -- Calculate number of columns dynamically based on panel width and icon size
    local columns = math.floor(panelWidth / (75 + spacing))
    if columns < 1 then columns = 1 end -- Ensure at least one column

    local iconSize = (panelWidth - (columns + 1) * spacing) / columns

    local xPos, yPos = spacing, spacing

    for index, modelPath in ipairs(models) do
        local icon = vgui.Create("DModelPanel", modelSelector)
        icon:SetSize(iconSize, iconSize)
        icon:SetModel(modelPath)
        icon:SetFOV(60)
        icon:SetCamPos(Vector(35, 0, 55))
        icon:SetLookAt(Vector(0, 0, 55))

        -- Prevent model rotation
        function icon:LayoutEntity(ent)
            -- Disable rotation
        end

        icon:SetPos(xPos, yPos)

        icon.DoClick = function()
            UpdateModelPreview(modelPath)
        end

        xPos = xPos + iconSize + spacing
        if (index % columns) == 0 then
            xPos = spacing
            yPos = yPos + iconSize + spacing
        end
    end
end




local function OpenCharacterCreator()
    frame = vgui.Create("DFrame")
    frame:SetTitle("Character Creator")
    frame:SetSize(ScrW(), ScrH()) -- Set the frame to be fullscreen
    frame:Center()
    frame:MakePopup()

    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(27, 40, 56, 255))
    end

    modelPreview = vgui.Create("DModelPanel", frame)
    modelPreview:SetPos(50, 50)
    modelPreview:SetSize(400, ScrH() - 100) -- Adjust the height to fit fullscreen
    modelPreview:SetFOV(45)
    modelPreview:SetCamPos(Vector(50, 50, 50))
    modelPreview:SetLookAt(Vector(0, 0, 35))
    modelPreview:SetModel("models/player/kleiner.mdl")

    local label = vgui.Create("DLabel", frame)
    label:SetPos(ScrW() - 500, 50)
    label:SetText("Select your character model:")
    label:SetSize(450, 35) -- Adjust the width
    label:SetTextColor(Color(220, 220, 220, 255))
    label:SetFont("InterFont")

    modelSelector = vgui.Create("DScrollPanel", frame)
    modelSelector:SetPos(ScrW() - 500, 90)
    modelSelector:SetSize(450, 200) -- Adjust the width
    modelSelector.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(59, 130, 246, 255))
    end

    local yPos = 300
    for _, field in ipairs(VAPR_CHARACTER_CREATOR_CONFIG.fields) do
        local fieldLabel = vgui.Create("DLabel", frame)
        fieldLabel:SetPos(ScrW() - 500, yPos)
        fieldLabel:SetText(field.name .. ":")
        fieldLabel:SetTextColor(Color(220, 220, 220, 255))
        fieldLabel:SetFont("InterFont")
        fieldLabel:SizeToContents()
        fieldLabel:SetWide(math.min(fieldLabel:GetWide(), 200))
        fieldLabel:SetContentAlignment(5)

        yPos = yPos + 25

        if field.type == "ComboBox" then
            local comboBox = vgui.Create("DComboBox", frame)
            comboBox:SetPos(ScrW() - 500, yPos)
            comboBox:SetSize(450, 35) -- Adjust the width
            comboBox:SetTextColor(Color(220, 220, 220, 255))
            comboBox:SetFont("InterFont")
            comboBox.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(59, 130, 246, 255))
            end
            for _, option in ipairs(field.options) do
                comboBox:AddChoice(option)
            end
            comboBox.OnSelect = function()
                UpdateModelSelector()
            end
            fieldEntries[field.name] = comboBox
        elseif field.type == "TextEntry" then
            local textEntry = vgui.Create("DTextEntry", frame)
            textEntry:SetPos(ScrW() - 500, yPos)
            textEntry:SetSize(450, 35) -- Adjust the width
            textEntry:SetTextColor(Color(220, 220, 220, 255))
            textEntry:SetFont("InterFont")
            textEntry.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(59, 130, 246, 255))
                self:DrawTextEntryText(Color(220, 220, 220, 255), self:GetHighlightColor(), self:GetCursorColor())
            end
            textEntry.OnChange = function()
                UpdateModelSelector()
            end
            fieldEntries[field.name] = textEntry
        elseif field.type == "NumberWang" then
            local numberWang = vgui.Create("DNumberWang", frame)
            numberWang:SetPos(ScrW() - 500, yPos)
            numberWang:SetSize(450, 35) -- Adjust the width
            numberWang:SetTextColor(Color(220, 220, 220, 255))
            numberWang:SetFont("InterFont")
            numberWang.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(59, 130, 246, 255))
                self:DrawTextEntryText(Color(220, 220, 220, 255), self:GetHighlightColor(), self:GetCursorColor())
            end
            numberWang.OnValueChange = function()
                UpdateModelSelector()
            end
            fieldEntries[field.name] = numberWang
        end

        yPos = yPos + 50
    end

    local submitButton = vgui.Create("DButton", frame)
    submitButton:SetPos(ScrW() / 2 - 75, ScrH() - 100)
    submitButton:SetSize(150, 40)
    submitButton:SetText("Create Character")
    submitButton:SetTextColor(Color(220, 220, 220, 255))
    submitButton:SetFont("InterFont")
    submitButton.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(59, 130, 246, 255))
    end
    submitButton.DoClick = function()
        local selectedModel = modelPreview:GetModel()
        if selectedModel then
            local characterData = {
                model = selectedModel,
                fields = {}
            }
            for name, entry in pairs(fieldEntries) do
                characterData.fields[name] = entry:GetValue()
            end

            net.Start("VAPR_CreateCharacter")
            net.WriteTable(characterData)
            net.SendToServer()
        else
            notification.AddLegacy("Please select a model.", NOTIFY_ERROR, 5)
        end
    end
end

net.Receive("VAPR_CharacterCreated", function()
    if frame then
        frame:Close()
    end
    local success = net.ReadBool()
    if success then
        notification.AddLegacy("Character created successfully!", NOTIFY_GENERIC, 5)
    else
        notification.AddLegacy("Failed to create character. Try again.", NOTIFY_ERROR, 5)
    end
end)

net.Receive("VAPR_OpenCharacterCreator", function()
    OpenCharacterCreator()
end)

hook.Add("InitPostEntity", "VAPR_ClientReady", function()
    net.Start("VAPR_ClientReady")
    net.SendToServer()
end)

-- Register the console command to open the character creator
concommand.Add("open_character_creator", function()
    OpenCharacterCreator()
end)
