if SERVER then
    util.AddNetworkString("SendVehicleMaxSpeed")

    hook.Add("PlayerEnteredVehicle", "SendVehicleMaxSpeed", function(player, vehicle)
        local maxSpeed = 200  -- Valeur par défaut

        if vehicle.GetMaxSpeed then
            maxSpeed = vehicle:GetMaxSpeed()
        elseif vehicle:GetClass() == "prop_vehicle_jeep" then
            maxSpeed = 100  -- Exemple pour un véhicule Jeep
        elseif vehicle:GetClass() == "prop_vehicle_airboat" then
            maxSpeed = 120  -- Exemple pour un Airboat
        else
            local phys = vehicle:GetPhysicsObject()
            if IsValid(phys) then
                maxSpeed = phys:GetVelocity():Length() * 1.5  -- Estimation
            end
        end
        
        net.Start("SendVehicleMaxSpeed")
        net.WriteEntity(vehicle)
        net.WriteInt(maxSpeed, 32)
        net.Send(player)
    end)
end
