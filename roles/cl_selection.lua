RegisterNetEvent("pf_cl:setPlayerRole")
RegisterNetEvent("pf_cl:selectNewRole")

loadouts = {}

-- Default player variables.
_role = "player"

AddEventHandler("pf_cl:setPlayerRole", function(role)
    _role = role

    SendNUIMessage({
        type = "pf_ui:disableRoleSelection"
    })
    SetNuiFocus(false, false)
end)

AddEventHandler("pf_cl:selectNewRole", function()
    SendNUIMessage({
        type = "pf_ui:enableRoleSelection"
    })
    SetNuiFocus(true, true) 
end)

RegisterNUICallback("select", function(data)
    Citizen.Trace("A role was selected.\n")
    TriggerServerEvent("pf_sv:selectRole", data.role)
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsSessionStarted() then
            exports.spawnmanager:spawnPlayer({
                x = 1476.03,
                y = 2569.80,
                z = 51.53,
                model = "S_M_Y_Prisoner_01"
            })
        
            SetNuiFocus(true, true)
            exports.spawnmanager:setAutoSpawn(false)

			return
		end
	end
end)

local isDead = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        if(IsPedFatallyInjured(PlayerPedId()) and not isDead)then
            isDead = true
            TriggerEvent("pf_cl:died")
            TriggerServerEvent("pf_sv:requestRespawn")
        end
    end
end)

AddEventHandler("playerSpawned", function()
    isDead = false
end)

AddEventHandler("onClientResourceStart", function(name)
    -- Allows restarting es_prisonfive
    if(name == "es_prisonfive")then
        SetNuiFocus(true, true)
    end
end)