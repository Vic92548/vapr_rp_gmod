-- Create fonts for the HUD
surface.CreateFont("HUDNumber5", {
    font = "Inter Regular",
    size = 22,
    weight = 600,
    antialias = true,
})

surface.CreateFont("HUDPlayerName", {
    font = "Inter Bold",
    size = 32,
    weight = 700,
    antialias = true,
})
-- Helper function to draw progress bars
local function DrawProgressBar(x, y, w, h, min, max, value, color)
    local fraction = (value - min) / (max - min)
    draw.RoundedBox(0, x, y, w, h, Color(27, 40, 56, 180)) -- Background bar color (Vercel black)
    draw.RoundedBox(0, x, y, w * fraction, h, color) -- Foreground bar color
    draw.SimpleText(math.floor(value), "HUDNumber5", x + w - 10, y + h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
end

-- Toggle for showing stats menu
local showStats = false
local animationStart = 0
local animationDuration = 0.1 -- Duration in seconds

hook.Add("Think", "ToggleStatsMenu", function()
    if input.IsKeyDown(KEY_TAB) and not showStats then
        showStats = true
        animationStart = CurTime()
    elseif not input.IsKeyDown(KEY_TAB) then
        showStats = false
    end
end)

-- Draw the HUD elements
local function DrawPlayerStats()
    local ply = LocalPlayer()
    local xStart, yStart = 20, 20 -- Initial positions
    local xOffset = 300 -- Offset for animation

    local currentTime = CurTime()
    local elapsed = currentTime - animationStart

    -- Draw player name
    local x = Lerp(math.min(elapsed / animationDuration, 1), xStart - xOffset, xStart)
    local y = yStart

    draw.SimpleText(ply:Name(), "HUDPlayerName", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    y = y + 50

    local index = 1
    for stat, limits in pairs(statLimits) do
        if limits.visible then
            local value = playerStats[stat] or limits.default
            if limits.min ~= limits.max then
                x = Lerp(math.min((elapsed - (index - 1) * 0.1) / animationDuration, 1), xStart - xOffset, xStart)
                DrawProgressBar(x, y, 250, 30, limits.min, limits.max, value, Color(59, 130, 246, 255)) -- Vercel blue color
                draw.SimpleText(stat, "HUDNumber5", x + 5,  y + 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText(stat .. ": " .. value, "HUDNumber5", x + 5, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
            y = y + 40
            index = index + 1
        end
    end
end

-- Hook into the HUDPaint event to draw the custom HUD
hook.Add("HUDPaint", "DrawStats", function()
    if showStats then
        DrawPlayerStats()
    end
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
