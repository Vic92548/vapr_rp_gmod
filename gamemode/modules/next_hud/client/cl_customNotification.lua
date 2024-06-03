-- Create the Inter font
surface.CreateFont("Inter", {
    font = "Inter",
    size = 18,
    weight = 500,
    antialias = true,
})

-- Define the colors
local color_black = Color(27, 40, 56, 255)
local color_blue = Color(59, 130, 246, 255)
local color_white = Color(220, 220, 220, 255)

-- Table to store active notifications
local notifications = {}

-- Function to draw the notifications
local function DrawNotifications()
    local scrW, scrH = ScrW(), ScrH()
    local yOffset = 10

    for _, notification in ipairs(notifications) do
        local alpha = (notification.dieTime - CurTime()) / notification.duration * 255
        if alpha < 0 then
            table.remove(notifications, _)
            continue
        end

        surface.SetFont("Inter")
        local textWidth, textHeight = surface.GetTextSize(notification.text)
        local boxWidth, boxHeight = textWidth + 20, textHeight + 10

        -- Background box
        draw.RoundedBox(6, scrW - boxWidth - 10, yOffset, boxWidth, boxHeight, color_black)

        -- Notification text
        draw.SimpleText(notification.text, "Inter", scrW - boxWidth / 2 - 10, yOffset + boxHeight / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        yOffset = yOffset + boxHeight + 10
    end
end

-- Hook to draw notifications
hook.Add("HUDPaint", "DrawCustomNotifications", DrawNotifications)

-- Function to override DarkRP.notify
local function OverrideDarkRPNotify()
    if not DarkRP then return end

    -- Overriding the DarkRP notification function
    function DarkRP.notify(messageType, messageLength, message)
        local duration = messageLength or 5
        table.insert(notifications, {
            text = message,
            duration = duration,
            dieTime = CurTime() + duration
        })
    end
end

-- Delay the override to ensure DarkRP is loaded
timer.Simple(5, OverrideDarkRPNotify)
