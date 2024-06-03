surface.CreateFont("InterFont", {
    font = "Inter Regular",
    size = 19,
    weight = 800,
    antialias = true
})

local blackColor = Color(27, 40, 56, 255)
local blueColor = Color(59, 130, 246, 255)
local whiteColor = Color(220, 220, 220, 255)

local defaultModel = "models/player/kleiner.mdl" -- Default model path

local steps = {}
local currentStep = 1
local frame
local modelPreview
local fieldEntries = {}
local modelSelector

local function ShowStep(step)
    for i, panel in ipairs(steps) do
        panel:SetVisible(i == step)
    end
end



local function PreviousStep()
    if currentStep > 1 then
        currentStep = currentStep - 1
        ShowStep(currentStep)
    end
end

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
        notification.AddLegacy("No models available for the selected criteria. Displaying default model.", NOTIFY_ERROR, 5)
        models = {defaultModel} -- Use default model if no models match the criteria
    end

    local panelWidth = modelSelector:GetWide()
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

local function NextStep()
    if currentStep < #steps then
        currentStep = currentStep + 1
        ShowStep(currentStep)

        if currentStep == #steps then
            UpdateModelSelector()
        end
    end
end

local function CreateStep(labelText, fields)
    local panel = vgui.Create("DPanel", frame)
    panel:SetSize(frame:GetWide(), frame:GetTall())
    panel:SetVisible(false)
    panel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, blackColor)
    end

    local label = vgui.Create("DLabel", panel)
    label:SetPos(50, 50)
    label:SetText(labelText)
    label:SetTextColor(whiteColor)
    label:SetFont("InterFont")
    label:SizeToContents()

    local yPos = 100
    for _, field in ipairs(fields) do
        local fieldLabel = vgui.Create("DLabel", panel)
        fieldLabel:SetPos(50, yPos)
        fieldLabel:SetText(field.name .. ":")
        fieldLabel:SetTextColor(whiteColor)
        fieldLabel:SetFont("InterFont")
        fieldLabel:SizeToContents()
        yPos = yPos + 25

        if field.type == "ComboBox" then
            local comboBox = vgui.Create("DComboBox", panel)
            comboBox:SetPos(50, yPos)
            comboBox:SetSize(450, 35)
            comboBox:SetTextColor(whiteColor)
            comboBox:SetFont("InterFont")
            comboBox.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, blueColor)
            end
            for _, option in ipairs(field.options) do
                comboBox:AddChoice(option)
            end
            fieldEntries[field.name] = comboBox
        elseif field.type == "TextEntry" then
            local textEntry = vgui.Create("DTextEntry", panel)
            textEntry:SetPos(50, yPos)
            textEntry:SetSize(450, 35)
            textEntry:SetTextColor(whiteColor)
            textEntry:SetFont("InterFont")
            textEntry.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, blueColor)
                self:DrawTextEntryText(whiteColor, self:GetHighlightColor(), self:GetCursorColor())
            end
            fieldEntries[field.name] = textEntry
        elseif field.type == "NumberWang" then
            local numberWang = vgui.Create("DNumberWang", panel)
            numberWang:SetPos(50, yPos)
            numberWang:SetSize(450, 35)
            numberWang:SetTextColor(whiteColor)
            numberWang:SetFont("InterFont")
            numberWang.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, blueColor)
                self:DrawTextEntryText(whiteColor, self:GetHighlightColor(), self:GetCursorColor())
            end
            fieldEntries[field.name] = numberWang
        end

        yPos = yPos + 50
    end

    local prevButton = vgui.Create("DButton", panel)
    prevButton:SetPos(50, frame:GetTall() - 100)
    prevButton:SetSize(150, 40)
    prevButton:SetText("Previous")
    prevButton:SetTextColor(whiteColor)
    prevButton:SetFont("InterFont")
    prevButton.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, blueColor)
    end
    prevButton.DoClick = function()
        PreviousStep()
    end

    local nextButton = vgui.Create("DButton", panel)
    nextButton:SetPos(frame:GetWide() - 200, frame:GetTall() - 100)
    nextButton:SetSize(150, 40)
    nextButton:SetText("Next")
    nextButton:SetTextColor(whiteColor)
    nextButton:SetFont("InterFont")
    nextButton.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, blueColor)
    end
    nextButton.DoClick = function()
        NextStep()
    end

    table.insert(steps, panel)
end

local function CreateModelSelectionStep()
    local panel = vgui.Create("DPanel", frame)
    panel:SetSize(frame:GetWide(), frame:GetTall())
    panel:SetVisible(false)
    panel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, blackColor)
    end

    local label = vgui.Create("DLabel", panel)
    label:SetPos(50, 50)
    label:SetText("Select your character model:")
    label:SetSize(450, 35)
    label:SetTextColor(whiteColor)
    label:SetFont("InterFont")

    modelSelector = vgui.Create("DScrollPanel", panel)
    modelSelector:SetPos(50, 100)
    modelSelector:SetSize(450, 400)
    modelSelector.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, blueColor)
    end

    modelPreview = vgui.Create("DModelPanel", panel) -- Create modelPreview here
    modelPreview:SetPos(550, 100)
    modelPreview:SetSize(450, 400)
    modelPreview:SetFOV(60)
    modelPreview:SetCamPos(Vector(35, 0, 55))
    modelPreview:SetLookAt(Vector(0, 0, 55))
    modelPreview:SetModel(defaultModel) -- Set default model initially

    -- Prevent model rotation
    function modelPreview:LayoutEntity(ent)
        -- Disable rotation
    end

    local prevButton = vgui.Create("DButton", panel)
    prevButton:SetPos(50, frame:GetTall() - 100)
    prevButton:SetSize(150, 40)
    prevButton:SetText("Previous")
    prevButton:SetTextColor(whiteColor)
    prevButton:SetFont("InterFont")
    prevButton.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, blueColor)
    end
    prevButton.DoClick = function()
        PreviousStep()
    end

    local nextButton = vgui.Create("DButton", panel)
    nextButton:SetPos(frame:GetWide() - 200, frame:GetTall() - 100)
    nextButton:SetSize(150, 40)
    nextButton:SetText("Create Character")
    nextButton:SetTextColor(whiteColor)
    nextButton:SetFont("InterFont")
    nextButton.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, blueColor)
    end
    nextButton.DoClick = function()
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

    table.insert(steps, panel)
end

local function OpenCharacterCreator()
    frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, blackColor)
    end

    local fields = VAPR_CHARACTER_CREATOR_CONFIG.fields
    for i, field in ipairs(fields) do
        CreateStep("Step " .. i .. ": " .. field.name, {field})
    end

    CreateModelSelectionStep()

    ShowStep(1)
end

concommand.Add("open_character_creator", function()
    OpenCharacterCreator()
end)

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
