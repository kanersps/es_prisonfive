RegisterNetEvent("pf_cl:spawnPlayer")

AddEventHandler("pf_cl:spawnPlayer", function(x, y, z)
    if (_role) then
        if (_role == "prisoner") then
            TriggerEvent("pf_cl:setLocation", "cellblock")
            exports.spawnmanager:spawnPlayer({
                x = x,
                y = y,
                z = z,
                model = "S_M_Y_Prisoner_01"
            })
        elseif (_role == "officer") then
            exports.spawnmanager:spawnPlayer({
                x = x,
                y = y,
                z = z,
                model = "S_M_M_PrisGuard_01"
            })
        elseif (_role == "warden") then
            exports.spawnmanager:spawnPlayer({
                x = x,
                y = y,
                z = z,
                model = "S_M_M_PrisGuard_01"
            })                    
        end
    else
        TriggerServerEvent("pf_sv:error", 0, "No role assigned but attempted to spawn player.")

        exports.spawnmanager:spawnPlayer({
            x = x,
            y = y,
            z = z,
            model = "S_M_Y_Prisoner_01"
        })        
    end
end)

-- Give loadout on spawn
AddEventHandler("playerSpawned", function()
    if(loadouts[_role])then
        for k,v in pairs(loadouts[_role])do
            GiveWeaponToPed(PlayerPedId(), v, 100, true, false)
            SetPedInfiniteAmmo(PlayerPedId(), true, v)
        end
    end

    -- Give armor real quick...
    if(_role == "officer" or _role == "warden")then
        SetPedArmour(PlayerPedId(), 100)
    end

    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        SetPlayerWantedLevel(PlayerId(), 0)
        SetPlayerWantedLevelNow(PlayerId(), false)

		-- These natives have to be called every frame. -- Google ??
		SetVehicleDensityMultiplierThisFrame(0.0) -- set traffic density to 0 
		SetPedDensityMultiplierThisFrame(0.0) -- set npc/ai peds density to 0
		SetRandomVehicleDensityMultiplierThisFrame(0.0) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
		SetParkedVehicleDensityMultiplierThisFrame(0.0) -- set random parked vehicles (parked car scenarios) to 0
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- set random npc/ai peds or scenario peds to 0
		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		SetRandomBoats(false) -- Stop random boats from spawning in the water.
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
		
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
	end
end)