-- Define the color palette
local colors = {
    black = Color(27, 40, 56, 255),
    blue = Color(59, 130, 246, 255),
    white = Color(255, 255, 255, 255),
}

-- Notification table
local notifications = {}

-- Font setup
surface.CreateFont("NotificationFont", {
    font = "Inter Regular",
    size = 18,  -- Smaller font size
    weight = 700,
})

-- Function to add a notification
local function addNotification(text, duration)
    table.insert(notifications, {
        text = text,
        duration = duration or 5,
        startTime = CurTime(),
    })
end

-- Notification rendering function
hook.Add("HUDPaint", "DrawNotifications", function()
    local curTime = CurTime()

    for i, notification in ipairs(notifications) do
        local timePassed = curTime - notification.startTime
        local timeLeft = notification.startTime + notification.duration - curTime

        -- Remove the notification if its duration is over
        if timeLeft <= 0 then
            table.remove(notifications, i)
            continue
        end

        -- Measure text width
        surface.SetFont("NotificationFont")
        local textWidth, textHeight = surface.GetTextSize(notification.text)
        local padding = 20
        local notificationWidth = textWidth + padding * 2
        local notificationHeight = textHeight + padding
        local xOffset
        local alpha = 255

        -- Animation calculations
        local animationTime = 0.5  -- Animation duration (faster)

        if timePassed < animationTime then
            xOffset = Lerp(timePassed / animationTime, ScrW(), ScrW() - notificationWidth - 50)
        else
            xOffset = ScrW() - notificationWidth - 50
        end

        if timeLeft < animationTime then
            alpha = Lerp(timeLeft / animationTime, 0, 255)
        end

        local xPos = xOffset
        local yPos = 50 + (i - 1) * (notificationHeight + 10)

        -- Draw the notification background with a blue border on the right
        draw.RoundedBox(0, xPos, yPos, notificationWidth, notificationHeight, ColorAlpha(colors.black, math.min(alpha, 180)))
        draw.RoundedBox(0, xPos + notificationWidth - 5, yPos, 5, notificationHeight, ColorAlpha(colors.blue, alpha))
        draw.SimpleText(notification.text, "NotificationFont", xPos + notificationWidth - padding, yPos + notificationHeight / 2, ColorAlpha(colors.white, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end)

-- Network receiver to add notifications from the server
net.Receive("AddNotification", function()
    local text = net.ReadString()
    local duration = net.ReadInt(8)
    addNotification(text, duration)
end)

-- Example usage (can be removed)
concommand.Add("test_notification", function()
    addNotification("This is a test notification!", 5)
end)
