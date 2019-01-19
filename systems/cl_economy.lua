RegisterNetEvent("pf_cl:purchaseComplete")
RegisterNetEvent("pf_cl:startJob")
RegisterNetEvent("pf_cl:stopJob")
RegisterNetEvent("pf_cl:playerStartJob")
RegisterNetEvent("pf_cl:playerStopJob")

local doingJob = false

local jobs = {
    {
        name = "Food server",
        location = {x = 1743.09, y = 2579.12, z = 44.46},
    },
    {
        name = "Cleaner",
        location = {x = 1735.16, y = 2629.56, z = 44.56},
        anim = "clean"
    },
    {
        name = "Cleaner",
        location = {x = 1740.16, y = 2645.19, z = 44.56},
        anim = "clean"
    }
}

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    RequestModel(0xb1bb9b59)

    Citizen.Trace("Loading prisoner model...\n")
    while not HasModelLoaded(0xb1bb9b59) do Citizen.Wait(0) end

    Citizen.Trace("Canteen dealer spawning...\n")
    local dealer = CreatePed(4, 0xb1bb9b59, 1748.09, 2591.85, 44.56, 100.001, false, true)

    FreezeEntityPosition(dealer, true)
    SetEntityInvincible(dealer, true)
    SetEntityAsMissionEntity(dealer, true, true)
    
    -- Combat attributes
    SetPedCombatAttributes(dealer, 46, 0)
    SetPedCombatAttributes(dealer, 0, 0)
    SetPedCombatAttributes(dealer, 5, 0)
    SetPedCombatAttributes(dealer, 17, 1)
    TaskSetBlockingOfNonTemporaryEvents(dealer, true)
    SetPedFleeAttributes(dealer, 0, 0)
    SetPedHearingRange(dealer, 0.0)
    SetPedSeeingRange(dealer, 0.0)
    SetPedCombatRange(dealer, 0.0)
    SetPedCombatAbility(dealer, 0)
    SetPedAlertness(dealer, 0)

    while true do
        Citizen.Wait(0)

        local playerLocation = GetEntityCoords(PlayerPedId())
        if Vdist2(playerLocation.x, playerLocation.y, playerLocation.z, 1748.09, 2591.85, 44.56) < 3.0 then
            if(_role == "prisoner")then
                DisplayHelpText("Press ~INPUT_CONTEXT~ to open the shop")

                if(IsControlJustReleased(1, 51))then
                    SendNUIMessage({
                        type = "pf_ui:enableShop"
                    })
                    SetNuiFocus(true, true) 
                end
            else
                DisplayHelpText("Get away from me, you pig!")
            end
        end

        if schedule == "Work/free time" and not doingJob then
            for jid,v in pairs(jobs)do
                DrawMarker(1, v.location.x, v.location.y, v.location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 0, 0, 255, 150, false, 2, false, nil, nil, true)
                if Vdist2(playerLocation.x, playerLocation.y, playerLocation.z, v.location.x, v.location.y, v.location.z) < 3.0 then
                    if(_role == "prisoner")then
                        DisplayHelpText("Press ~INPUT_CONTEXT~ to start working")

                        if(IsControlJustReleased(1, 51))then
                            TriggerServerEvent("pf_sv:startJob", jid)
                        end
                    else
                        DisplayHelpText("Only prisoners can work")
                    end
                end
            end
        end

        if doingJob then
            DisplayHelpText("Press ~INPUT_CONTEXT~ to stop working")
            if(IsControlJustReleased(1, 51))then
                TriggerServerEvent("pf_sv:stopJob")
            end

            if IsPedRagdoll(PlayerPedId()) then
                TriggerServerEvent("pf_sv:stopJob")
            end
        end
    end
end)

RegisterNUICallback("disableShop", function(data)
    SendNUIMessage({
        type = "pf_ui:disableShop"
    })
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("purchase", function(data)
    local playerLocation = GetEntityCoords(PlayerPedId())
    if Vdist2(playerLocation.x, playerLocation.y, playerLocation.z, 1748.09, 2591.85, 44.56) < 5.0 then
        TriggerServerEvent("pf_sv:purchaseItem", data.item)
    end
end)

local mops = {}

AddEventHandler("pf_cl:playerStartJob", function(user, jid, mid)
    if(user == GetPlayerServerId(PlayerId()))then
        doingJob = true
    end

    print("[PrisonFive] Starting animation for " .. GetPlayerName(GetPlayerFromServerId(user)) .. " (" ..  tostring(user) .. ") JOB: " .. tostring(jid))

    if jobs[jid].anim == "clean" then
        Citizen.CreateThread(function()
            local dict = "move_mop"
            RequestAnimDict(dict)
        
            mops[mid] = CreateObjectNoOffset(GetHashKey("prop_cs_mop_s"), 134.7101, -766.0931, 241.152, false, false, false)
            SetEntityRotation(mops[mid], 15.42, -2.75, 0.0, 2, 1)
        
            while not HasAnimDictLoaded(dict) do Wait(0) end
        
            AttachEntityToEntity(mops[mid], GetPlayerPed(GetPlayerFromServerId(user)), GetPedBoneIndex(GetPlayerPed(GetPlayerFromServerId(user)), 0x68FB), 0.0, 0.0, 1.1, 180.0, 0.0, 90.0, 0, 0, 0, 0, 2, 1)
        
            print("[PrisonFive] Started animation for " .. GetPlayerName(GetPlayerFromServerId(user)) .. " (" ..  tostring(user) .. ")")
            TaskPlayAnim(GetPlayerPed(GetPlayerFromServerId(user)), dict, "idle_scrub", 8.0, 1.0, -1, 1, 1.0, true, true, true, true)
        end)
    end
end)

AddEventHandler("pf_cl:playerStopJob", function(user, jid, mid, respawn)
    if(user == GetPlayerServerId(PlayerId()))then
        doingJob = false
    end

        if mops[mid] and not respawn then
            DetachEntity(mops[mid], 1, 1)
            ClearPedTasksImmediately(GetPlayerPed(GetPlayerFromServerId(user)))
            StopAnimPlayback(GetPlayerPed(GetPlayerFromServerId(user)), true, true)
            SetEntityCoords(mops[mid], 1000.0, 1000.0, 1000.0)
            SetObjectAsNoLongerNeeded(mops[mid])
            mops[mid] = false
            StopAnimTask(GetPlayerPed(GetPlayerFromServerId(user)), "move_mop", "idle_scrub", 1.0)

            print("[PrisonFive] Stopping animation for " .. GetPlayerName(GetPlayerFromServerId(user)))
        end
end)

AddEventHandler("pf_cl:died", function()
    if doingJob then
        TriggerServerEvent("pf_sv:stopJob", 1)
    end
end)

AddEventHandler("pf_cl:purchaseComplete", function(id)
    if(id == "give_armor")then
        SetPedArmour(PlayerPedId(), 100)
    else
        GiveWeaponToPed(PlayerPedId(), GetHashKey(id), 100, true, false)
        SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(id))        
    end
end)