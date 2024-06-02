-- Create fonts for the HUD
surface.CreateFont("HUDNumber5", {
    font = "Inter Regular",
    size = 24,
    weight = 600,
    antialias = true,
})

surface.CreateFont("HUDPlayerName", {
    font = "Inter Bold",
    size = 28,
    weight = 700,
    antialias = true,
})

-- Helper function to draw progress bars
local function DrawProgressBar(x, y, w, h, min, max, value, color)
    local fraction = (value - min) / (max - min)
    draw.RoundedBox(0, x, y, w, h, Color(32, 33, 36, 180)) -- Background bar color
    draw.RoundedBox(0, x, y, w * fraction, h, color) -- Foreground bar color
    draw.SimpleText(math.floor(value), "HUDNumber5", x + w / 2, y + h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

-- Draw the HUD elements
local function DrawPlayerStats()
    local ply = LocalPlayer()
    local x, y = 20, ScrH() - 200

    -- Draw player name
    draw.SimpleText(ply:Name(), "HUDPlayerName", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    y = y - 40

    for stat, limits in pairs(statLimits) do
        if limits.visible then
            local value = playerStats[stat] or limits.default
            if limits.min ~= limits.max then
                
                DrawProgressBar(x, y, 200, 25, limits.min, limits.max, value, Color(0, 204, 255, 255)) -- Vercel cyan color
                draw.SimpleText(stat, "HUDNumber5", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText(stat .. ": " .. value, "HUDNumber5", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
            y = y - 30
        end
    end
end

-- Hook into the HUDPaint event to draw the custom HUD
hook.Add("HUDPaint", "DrawDefaultHUD", function()
   DrawPlayerStats()
end)

-- Hide the default HUD elements
local hideHUDElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
}

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    if hideHUDElements[name] then
        return false
    end
end)
