loadouts.prisoner = {}
location = "cellblock"
schedule = "Meal time"

RegisterNetEvent("pf_cl:sprinting")
RegisterNetEvent("pf_cl:changeSchedule")

local acknowledgedSprinting = false

AddEventHandler("pf_cl:sprinting", function(bool)
    acknowledgedSprinting = bool
end)

AddEventHandler("pf_cl:setLocation", function(l)
    location = l
end)

AddEventHandler("pf_cl:changeSchedule", function(s)
    schedule = s
end)

--[[
RegisterCommand("add", function()
    local pLocation = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("savepos", pLocation.x, pLocation.y, pLocation.z - 0.5)    
end)]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        -- Announcer
        TerminateAllScriptsWithThisName("re_prison")
        ClearAmbientZoneState("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_ALARM", 0)
        ClearAmbientZoneState("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_GENERAL", 0)
        ClearAmbientZoneState("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_WARNING", 0)
        StopAlarm("PRISON_ALARMS", 1)

        if(_role == "prisoner")then
            if(not IsPedWalking(PlayerPedId()) and not acknowledgedSprinting and not IsPedStill(PlayerPedId()))then
                TriggerServerEvent("pf_sv:sprinting", true, location)
            elseif(IsPedWalking(PlayerPedId()) and acknowledgedSprinting)then
                TriggerServerEvent("pf_sv:sprinting", false)
            end

            local pLocation = GetEntityCoords(PlayerPedId())

            if Vdist2(pLocation.x, pLocation.y, pLocation.z, 1851.38, 2607.33, 45.65) < 25.0 then
                TriggerServerEvent("pf_sv:escape")
            end
        end
    end
end)

AddEventHandler("playerSpawned", function()
    Citizen.CreateThread(function()
        if(_role ~= "prisoner")then
            return
        end
        
        local model = GetHashKey("mp_m_freemode_01")
    
        RequestModel(model)
        while not HasModelLoaded(model)do Wait(0) end
    
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 0)
        SetPedComponentVariation(PlayerPedId(), 2, math.random(5), math.random(5), 0)
    
        if math.random(5) < 3 then
            SetPedComponentVariation(PlayerPedId(), 8, 70, 0, 0)
            SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 0)
            SetPedComponentVariation(PlayerPedId(), 11, 146, 7, 0)
        else
            SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)
            SetPedComponentVariation(PlayerPedId(), 11, 1, 0, 0)
        end
        SetPedComponentVariation(PlayerPedId(), 4, 27, 2, 0)
        SetPedComponentVariation(PlayerPedId(), 6, 8, 0, 0)
    end)
end)