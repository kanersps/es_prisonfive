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

AddEventHandler("onClientMapStart", function()
    SetNuiFocus(true, true)
    exports.spawnmanager:setAutoSpawn(false)
end)

AddEventHandler("baseevents:onPlayerDied", function()
    TriggerServerEvent("pf_sv:requestRespawn") 
end)

AddEventHandler("onClientResourceStart", function(name)
    -- Allows restarting es_prisonfive
    if(name == "es_prisonfive")then
        SetNuiFocus(true, true)
    end
end)