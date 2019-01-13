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