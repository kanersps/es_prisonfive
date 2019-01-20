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

local explosionEscape = false
local lester
local lesterHere = false

function addLester()
    lesterHere = true
    Citizen.CreateThread(function()
        RequestModel(0x4da6e849)

        Citizen.Trace("Loading lester model...\n")
        while not HasModelLoaded(0x4da6e849) do Citizen.Wait(0) end

        Citizen.Trace("Lester spawning...\n")
        lester = CreatePed(4, 0x4da6e849, 1838.91, 2576.63, 44.86, 100.001, false, true)

        FreezeEntityPosition(lester, true)
        SetEntityInvincible(lester, true)
        SetEntityAsMissionEntity(lester, true, true)
        
        -- Combat attributes
        SetPedCombatAttributes(lester, 46, 0)
        SetPedCombatAttributes(lester, 0, 0)
        SetPedCombatAttributes(lester, 5, 0)
        SetPedCombatAttributes(lester, 17, 1)
        TaskSetBlockingOfNonTemporaryEvents(lester, true)
        SetPedFleeAttributes(lester, 0, 0)
        SetPedHearingRange(lester, 0.0)
        SetPedSeeingRange(lester, 0.0)
        SetPedCombatRange(lester, 0.0)
        SetPedCombatAbility(lester, 0)
        SetPedAlertness(lester, 0)
    end)
end

function removeLester()
    lesterHere = false
    SetPedAsNoLongerNeeded(lester)
    SetEntityCoords(lester, 1000.0, 1000.0, 1000.0)
end

RegisterNetEvent("pf_cl:visitationLester")
RegisterNetEvent("pf_cl:visitationLesterRemove")
RegisterNetEvent("pf_cl:escapePossible")

AddEventHandler("pf_cl:visitationLester", function()
    addLester()
end)

AddEventHandler("pf_cl:visitationLesterRemove", function()
    removeLester()
end)

AddEventHandler("pf_cl:escapePossible", function(possible)
    if possible then
        AddExplosion(1616.33, 2524.32, 45.56 + 1.0, 29, 10.0, true, false, true)
    end
    explosionEscape = possible
end)

Citizen.CreateThread(function()
    while true do
        if lesterHere then
            DrawMarker(1, 1836.12, 2576.45, 44.81, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 255, 255, 0, 150, false, 2, false, nil, nil, true)
            
            local playerLocation = GetEntityCoords(PlayerPedId())

            if Vdist2(playerLocation.x, playerLocation.y, playerLocation.z, 1836.12, 2576.45, 44.81) < 3.0 then
                if(true)then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to talk to Lester")

                    if(IsControlJustReleased(1, 51))then
                        TriggerServerEvent("pf_sv:speakToLester")
                    end
                else
                    DisplayHelpText("Only prisoners can take visitation")
                end
            end
        end

        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if explosionEscape then
            AddExplosion(1616.33, 2524.32, 45.56 + 3.5, 1, 0.1, false, true, false)
        end

        Wait(1000)
    end
end)