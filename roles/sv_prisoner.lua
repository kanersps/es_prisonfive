roles.prisoner = {
    limit = 100,
    current = 0,
    paycheck = 10,
    loadout = {},
    spawns = {
        {1745.51, 2624.14, 49.5},
        {1745.51, 2643.6, 49.5},
        {1727.001, 2644.57, 45.58},
    }
}

escapers = {}
resetTimers = {}
muted = false

RegisterNetEvent("pf_sv:sprinting")

AddEventHandler("pf_sv:sprinting", function(sprinting, loc)
    local _source = source
    local location = loc or "unknown"

    TriggerEvent("es:getPlayerFromId", _source, function(user)
        if(user.getPrisonRole() == "prisoner")then
            escapers[_source] = sprinting

            print("user trying to escape")

            TriggerClientEvent("pf_cl:sprinting", _source, true)

            if(sprinting and not resetTimers[_source])then
                resetTimers[_source] = true

                if not muted then
                    TriggerClientEvent('chat:addMessage', -1, {
                        args = {"^1ESCAPING", " (^2" .. GetPlayerName(_source) .." | ".._source.."^0) " .. " is attempting to escape! Location: ^3" .. location}
                    })
                end

                Citizen.CreateThread(function()               
                    Citizen.Wait(5000)
                    TriggerClientEvent("pf_cl:sprinting", _source, false)
                    resetTimers[_source] = false
                end)
            end
        end
    end)
end)

TriggerEvent("es:addCommand", "m", function(_source, args, user)
    TriggerEvent('es:canGroupTarget', user.getGroup(), "mod", function(canTarget)
        if(user.getPrisonRole() == "warden" or canTarget)then
            muted = not muted

            if(not muted)then
                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1ALARMS", " (^2" .. GetPlayerName(_source) .." | ".._source.."^0) " .. " has turned ^2on^0 the alarms"}
                })   
            else
                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1ALARMS", " (^2" .. GetPlayerName(_source) .." | ".._source.."^0) " .. " has turned ^1off^0 the alarms"}
                })
            end
        else
            TriggerClientEvent('chat:addMessage', _source, {
                args = {"^1PERMISSIONS", "You're not the warden!"}
            })        
        end
    end)
end)