RegisterNetEvent("pf_cl:purchaseComplete")

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
    end
end)

RegisterNUICallback("disableShop", function(data)
    SendNUIMessage({
        type = "pf_ui:disableShop"
    })
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("purchase", function(data)
    TriggerServerEvent("pf_sv:purchaseItem", data.item)
end)

AddEventHandler("pf_cl:purchaseComplete", function(id)
    if(id == "give_armor")then
        SetPedArmour(PlayerPedId(), 100)
    else
        GiveWeaponToPed(PlayerPedId(), GetHashKey(id), 100, true, false)
        SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(id))        
    end
end)