util.AddNetworkString("AddNotification")

-- Function to trigger notification on the client
function notifyPlayer(ply, text, duration)
    net.Start("AddNotification")
    net.WriteString(text)
    net.WriteInt(duration or 5, 8)
    net.Send(ply)
end
