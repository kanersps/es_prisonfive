loadouts.prisoner = {}
location = "cellblock"

RegisterNetEvent("pf_cl:sprinting")

local acknowledgedSprinting = false

AddEventHandler("pf_cl:sprinting", function(bool)
    acknowledgedSprinting = bool
end)

AddEventHandler("pf_cl:setLocation", function(l)
    location = l
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        if(_role == "prisoner")then
            if(not IsPedWalking(PlayerPedId()) and not acknowledgedSprinting and not IsPedStill(PlayerPedId()))then
                TriggerServerEvent("pf_sv:sprinting", true, location)
            elseif(IsPedWalking(PlayerPedId()) and acknowledgedSprinting)then
                TriggerServerEvent("pf_sv:sprinting", false)
            end
        end
    end
end)