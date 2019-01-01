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
end)