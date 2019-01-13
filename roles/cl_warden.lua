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
    if 1 then
        SetDrawOrigin(x, y, z)
        SetTextScale(0.2, 0.4)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(100, 100, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(0.0, 0.0)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pPos = GetEntityCoords(GetPlayerPed(id))

        for id = 0, 31 do
            if (NetworkIsPlayerActive(id)) then
                local pos = GetEntityCoords(GetPlayerPed(id))
                if (Vdist2(pos.x, pos.y, pos.z, pPos.x, pPos.y, pPos.z) < 60.1 and GetPlayerServerId(id) == currentWarden and GetPlayerServerId(id) ~= GetPlayerServerId(PlayerId()))then
                    DrawText3D(pos.x, pos.y, pos.z + 1.0, "Warden")
                end
            end
        end
    end
end)