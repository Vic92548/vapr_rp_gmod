-- Include your VAPR_ITEMS_CONFIG and VAPR_SHOPS_CONFIG here

local function CreateShopUI(shopConfig)
    local frame = vgui.Create("DFrame")
    frame:SetTitle(shopConfig.name)
    frame:SetSize(800, 600)
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)
    frame:SetDraggable(true)
    frame:SetSizable(false)
    frame:SetDeleteOnClose(true)

    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, shopConfig.color or Color(59, 130, 246, 255))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(27, 40, 56, 255))
    end

    local propertySheet = vgui.Create("DPropertySheet", frame)
    propertySheet:Dock(FILL)

    for categoryName, categoryData in pairs(shopConfig.categories) do
        local categoryPanel = vgui.Create("DPanel", propertySheet)
        categoryPanel:Dock(FILL)

        local scrollPanel = vgui.Create("DScrollPanel", categoryPanel)
        scrollPanel:Dock(FILL)

        local itemList = vgui.Create("DIconLayout", scrollPanel)
        itemList:Dock(FILL)
        itemList:SetSpaceY(5)
        itemList:SetSpaceX(5)

        for itemKey, itemData in pairs(categoryData.items) do
            local itemConfig = VAPR_ITEMS_CONFIG[itemKey]

            if itemConfig then
                local itemPanel = itemList:Add("DPanel")
                itemPanel:SetSize(100, 150)
                itemPanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(220, 220, 220, 255))
                end

                local modelPanel = vgui.Create("DModelPanel", itemPanel)
                modelPanel:SetSize(100, 100)
                modelPanel:SetModel(itemConfig.model)
                modelPanel:Dock(TOP)

                local nameLabel = vgui.Create("DLabel", itemPanel)
                nameLabel:SetText(itemConfig.name)
                nameLabel:Dock(TOP)
                nameLabel:SetContentAlignment(5)
                nameLabel:SetColor(Color(0, 0, 0, 255))

                local priceLabel = vgui.Create("DLabel", itemPanel)
                local currency = itemConfig.stat or "money"
                local currency_display = VAPR_CURRENCIES_CONFIG[currency]
                if currency_display then
                    currency_display = currency_display.symbol
                else
                    currency_display = "€"
                end
                priceLabel:SetText("Buy: " .. itemData.buy_price .. " " .. currency_display .. (itemData.sell_price and "\nSell: " .. itemData.sell_price .. " " .. currency_display or ""))
                priceLabel:Dock(TOP)
                priceLabel:SetContentAlignment(5)
                priceLabel:SetColor(Color(0, 0, 0, 255))

                local buyButton = vgui.Create("DButton", itemPanel)
                buyButton:SetText("Buy")
                buyButton:Dock(BOTTOM)
                buyButton.DoClick = function()
                    net.Start("VAPR_BuyItem")
                    net.WriteString(itemKey)
                    net.WriteString(shopConfig.name)
                    net.WriteString(currency)
                    net.WriteInt(itemData.buy_price, 32)
                    net.SendToServer()
                end

                if itemData.sell_price then
                    local sellButton = vgui.Create("DButton", itemPanel)
                    sellButton:SetText("Sell")
                    sellButton:Dock(BOTTOM)
                    sellButton.DoClick = function()
                        net.Start("VAPR_SellItem")
                        net.WriteString(itemKey)
                        net.WriteString(shopConfig.name)
                        net.WriteString(currency)
                        net.WriteInt(itemData.sell_price, 32)
                        net.SendToServer()
                    end
                end
            end
        end

        propertySheet:AddSheet(categoryData.name, categoryPanel, "icon16/star.png")
    end
end

-- Example to open a shop
concommand.Add("open_shop", function()
    local shopConfig = VAPR_SHOPS_CONFIG.shop1 -- Replace with your desired shop
    CreateShopUI(shopConfig)
end)
