local frame
local modelSelector
local modelPreview
local fieldEntries = {}

surface.CreateFont("InterFont", {
    font = "Inter",
    size = 19,
    weight = 800,
    antialias = true
})

local function FilterModels(sex, age)
    local ageCategory = age < 18 and "Child" or "Adult"
    return VAPR_CHARACTER_CREATOR_CONFIG.models[sex][ageCategory] or {}
end

local function UpdateModelSelector()
    local sex = fieldEntries["Sex"] and fieldEntries["Sex"]:GetSelected()
    local age = tonumber(fieldEntries["Age"] and fieldEntries["Age"]:GetValue())

    if sex and age then
        modelSelector:Clear()
        for _, model in ipairs(FilterModels(sex, age)) do
            modelSelector:AddChoice(model)
        end
    end
end

local function UpdateModelPreview(modelPath)
    if modelPreview then
        modelPreview:SetModel(modelPath)
    end
end

local function OpenCharacterCreator()
    frame = vgui.Create("DFrame")
    frame:SetTitle("Character Creator")
    frame:SetSize(1200, 600) 
    frame:Center()
    frame:MakePopup()

    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(27, 40, 56, 255))
        draw.RoundedBox(0, 0, 0, w, 30, Color(59, 130, 246, 255))
    end

    modelPreview = vgui.Create("DModelPanel", frame)
    modelPreview:SetPos(50, 50)
    modelPreview:SetSize(400, 500)  
    modelPreview:SetFOV(45)
    modelPreview:SetCamPos(Vector(50, 50, 50))
    modelPreview:SetLookAt(Vector(0, 0, 35))

    local label = vgui.Create("DLabel", frame)
    label:SetPos(500, 50)
    label:SetText("Select your character model:")
    label:SizeToContents()
    label:SetTextColor(Color(220, 220, 220, 255))
    label:SetFont("InterFont")

    modelSelector = vgui.Create("DComboBox", frame)
    modelSelector:SetPos(500, 80)
    modelSelector:SetSize(650, 35)  
    modelSelector:SetTextColor(Color(220, 220, 220, 255))
    modelSelector:SetFont("InterFont")
    modelSelector.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(59, 130, 246, 255))
    end
    modelSelector.OnSelect = function(index, value, data)
        UpdateModelPreview(data)
    end

    local yPos = 120
    for _, field in ipairs(VAPR_CHARACTER_CREATOR_CONFIG.fields) do
        local fieldLabel = vgui.Create("DLabel", frame)
        fieldLabel:SetPos(500, yPos)
        fieldLabel:SetText(field.name .. ":")
        fieldLabel:SizeToContents()
        fieldLabel:SetTextColor(Color(220, 220, 220, 255))
        fieldLabel:SetFont("InterFont")

        yPos = yPos + 25

        if field.type == "ComboBox" then
            local comboBox = vgui.Create("DComboBox", frame)
            comboBox:SetPos(500, yPos)
            comboBox:SetSize(650, 35) 
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
            textEntry:SetPos(500, yPos)
            textEntry:SetSize(650, 35)  
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
            numberWang:SetPos(500, yPos)
            numberWang:SetSize(650, 35) 
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
    submitButton:SetPos(775, yPos + 20) 
    submitButton:SetSize(150, 40)
    submitButton:SetText("Create Character")
    submitButton:SetTextColor(Color(220, 220, 220, 255))
    submitButton:SetFont("InterFont")
    submitButton.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(59, 130, 246, 255))
    end
    submitButton.DoClick = function()
        local selectedModel = modelSelector:GetSelected()
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