roles.prisoner = {
    limit = 100,
    current = 0,
    paycheck = 10,
    loadout = {},
    spawns = {
        {1745.51, 2624.14, 49.5},
        {1745.51, 2643.6, 49.5},
        {1727.001, 2644.57, 45.58},
    },
    escapeLocation = {1851.38, 2607.33, 45.65}
}

escapers = {}
resetTimers = {}
muted = false

schedule = {
    {name = "Meal time", time=300000},
    {name = "Locking up", time=120000},
    {name = "Lockup", time=120000},
    {name = "Shower time", time=180000},
    {name = "Yard time", time=300000},
    {name = "Meal time", time=300000},
    {name = "Visitation/free time", 360000},
    {name = "Locking up", 120000},
    {name = "Lockup", 120000}
}

currentSchedule = 1

RegisterNetEvent("pf_sv:sprinting")
RegisterNetEvent("pf_sv:escape")

AddEventHandler("pf_sv:sprinting", function(sprinting, loc)
    local _source = source
    local location = loc or "unknown"

    TriggerEvent("es:getPlayerFromId", _source, function(user)
        if(user.getPrisonRole() == "prisoner")then
            escapers[_source] = sprinting

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

local escapeTimers = {}

AddEventHandler("pf_sv:escape", function()
    local _source = source

    TriggerEvent("es:getPlayerFromId", _source, function(user)
        if(escapeTimers[_source] == nil and user.getPrisonRole() == "prisoner")then
            escapeTimers[_source] = true
            
                user.addMoney(100)
                
                TriggerEvent("pf_sv:spawnPlayer", _source, {
                    x = roles["prisoner"].spawns[math.random(#roles["prisoner"].spawns)][1],
                    y = roles["prisoner"].spawns[math.random(#roles["prisoner"].spawns)][2],
                    z = roles["prisoner"].spawns[math.random(#roles["prisoner"].spawns)][3]
                })

                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1ESCAPE", " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. " has ^1ESCAPED^0! The warden needs to do a better job than this..."}
                })                

            Citizen.CreateThread(function()
                Citizen.Wait(120000)

                escapeTimers[_source] = nil
            end)
        else
            print("Someone is escaping really quickly: " .. GetPlayerName(_source))
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

Citizen.CreateThread(function()
    while true do
        currentSchedule = currentSchedule + 1
        if not schedule[currentSchedule] then currentSchedule = 1 end

        if schedule[currentSchedule].name == "Lockup" then
            cellblockOpen = false
            TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
        else
            cellblockOpen = true
            TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
        end

        TriggerClientEvent("pf_cl:changeSchedule", -1, schedule[currentSchedule].name)
        TriggerClientEvent('chat:addMessage', -1, {
            args = {"^1SCHEDULE", "Changed to: ^2" .. schedule[currentSchedule].name}
        })
        print("[PrisonFive] New schedule: " .. schedule[currentSchedule].name)

        Citizen.Wait(schedule[currentSchedule].time or 60000)
    end
end)