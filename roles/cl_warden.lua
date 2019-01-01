loadouts.warden = {
    0x3656C8C1, -- WEAPON_STUNGUN
    0x1D073A89, -- WEAPON_PUMPSHOTGUN
    0x5EF9FEC4, -- WEAPON_COMBATPISTOL
    0x678B81B1, -- WEAPON_NIGHTSTICK            
}

currentWarden = -1

RegisterNetEvent("pf_cl:setWarden")

AddEventHandler("pf_cl:setWarden", function(wid)
    currentWarden = wid
    Citizen.Trace("WARDEN: " .. tostring(wid) .. " <<<\n" )
end)

function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(100, 100, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for id = 0, 31 do
            if (NetworkIsPlayerActive(id)) then
                local pos = GetEntityCoords(GetPlayerPed(id))
                if(GetPlayerServerId(id) == currentWarden and GetPlayerServerId(id) ~= GetPlayerServerId(PlayerId()))then
                    DrawText3D(pos.x, pos.y, pos.z + 1.0, "Warden")
                end
            end
        end
    end
end)