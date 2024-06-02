surface.CreateFont("InventoryFont", {
    font = "Inter Regular",
    size = 24,
    weight = 500,
})

local inventoryFrame
local itemList
local currentPage = 1
local itemsPerPage = 5
local totalPages = 1
local items = {}

local function RefreshInventory()
    if not IsValid(inventoryFrame) then return end

    itemList:Clear()

    local startIdx = (currentPage - 1) * itemsPerPage + 1
    local endIdx = math.min(currentPage * itemsPerPage, #items)

    for i = startIdx, endIdx do
        local item = items[i]

        local itemPanel = vgui.Create("DPanel")
        itemPanel:SetTall(90)  -- Adjusted height
        itemPanel:Dock(TOP)
        itemPanel:DockPadding(10, 10, 10, 10)
        itemPanel:DockMargin(0, 0, 0, 10) -- Adjusted margin
        itemPanel.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(59, 130, 246, 255))
            draw.SimpleText(item.name .. " (" .. item.quantity .. ")", "InventoryFont", 90, 10, Color(220, 220, 220, 255), TEXT_ALIGN_LEFT)
            draw.SimpleText(item.description, "InventoryFont", 90, 40, Color(220, 220, 220, 255), TEXT_ALIGN_LEFT)
        end

        local icon = vgui.Create("SpawnIcon", itemPanel)
        icon:SetModel(item.model)
        icon:SetSize(64, 64)
        icon:Dock(LEFT)
        icon:DockMargin(10, 10, 10, 10)

        local function CreateStyledButton(parent, text, onClick)
            local button = vgui.Create("DButton", parent)
            button:SetText(text)
            button:SetFont("InventoryFont")
            button:SetTextColor(Color(220, 220, 220, 255))
            button:Dock(RIGHT)
            button:DockMargin(5, 5, 5, 5)
            button.Paint = function(self, w, h)
                local bgColor = self:IsHovered() and Color(45, 102, 183, 255) or Color(59, 130, 246, 255)
                draw.RoundedBox(8, 0, 0, w, h, bgColor)
            end
            button.DoClick = onClick
            return button
        end

        CreateStyledButton(itemPanel, "Use", function()
            net.Start("UseItem")
            net.WriteString(item.key)
            net.SendToServer()
        end)

        CreateStyledButton(itemPanel, "Drop", function()
            net.Start("DropItem")
            net.WriteString(item.key)
            net.SendToServer()
        end)

        itemPanel:SetParent(itemList)
    end

    prevButton:SetVisible(currentPage > 1)
    nextButton:SetVisible(currentPage < totalPages)
end

local function OpenInventory()
    if IsValid(inventoryFrame) then
        inventoryFrame:Remove()
    end

    inventoryFrame = vgui.Create("DFrame")
    inventoryFrame:SetTitle("Inventory")
    inventoryFrame:SetSize(600, 500)
    inventoryFrame:Center()
    inventoryFrame:MakePopup()
    inventoryFrame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(27, 40, 56, 255))
    end

    inventoryFrame.OnClose = function()
        itemList = nil
    end

    itemList = vgui.Create("DScrollPanel", inventoryFrame)
    itemList:Dock(FILL)

    local buttonPanel = vgui.Create("DPanel", inventoryFrame)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(40)
    buttonPanel.Paint = function() end

    prevButton = vgui.Create("DButton", buttonPanel)
    prevButton:SetText("< Previous")
    prevButton:SetFont("InventoryFont")
    prevButton:SetTextColor(Color(220, 220, 220, 255))
    prevButton:Dock(LEFT)
    prevButton:DockMargin(5, 5, 5, 5)
    prevButton.Paint = function(self, w, h)
        local bgColor = self:IsHovered() and Color(45, 102, 183, 255) or Color(59, 130, 246, 255)
        draw.RoundedBox(8, 0, 0, w, h, bgColor)
    end
    prevButton.DoClick = function()
        if currentPage > 1 then
            currentPage = currentPage - 1
            RefreshInventory()
        end
    end

    nextButton = vgui.Create("DButton", buttonPanel)
    nextButton:SetText("Next >")
    nextButton:SetFont("InventoryFont")
    nextButton:SetTextColor(Color(220, 220, 220, 255))
    nextButton:Dock(RIGHT)
    nextButton:DockMargin(5, 5, 5, 5)
    nextButton.Paint = function(self, w, h)
        local bgColor = self:IsHovered() and Color(45, 102, 183, 255) or Color(59, 130, 246, 255)
        draw.RoundedBox(8, 0, 0, w, h, bgColor)
    end
    nextButton.DoClick = function()
        if currentPage < totalPages then
            currentPage = currentPage + 1
            RefreshInventory()
        end
    end

    net.Start("RequestInventory")
    net.SendToServer()

    net.Receive("SendInventory", function()
        items = net.ReadTable()
        currentPage = 1
        RefreshInventory()
    end)
end

net.Receive("UpdateInventory", function()
    net.Start("RequestInventory")
    net.SendToServer()

    net.Receive("SendInventory", function()
        items = net.ReadTable()
        RefreshInventory()
    end)
end)

concommand.Add("open_inventory", OpenInventory)

-- Add the hook to open the inventory when "I" is pressed
hook.Add("Think", "CheckInventoryKeyPress", function()
    if input.IsKeyDown(KEY_I) then
        if not IsValid(inventoryFrame) then
            OpenInventory()
        end
    end
end)
