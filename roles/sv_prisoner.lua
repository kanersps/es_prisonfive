roles.prisoner = {
    limit = 100,
    current = 0,
    paycheck = 2,
    loadout = {},
    spawns = {
        -- Level one
        {x = 1746.10, y = 2631.81, z = 45.08},
        {x = 1745.90, y = 2635.56, z = 45.08},
        {x = 1746.55, y = 2640.92, z = 45.08},
        {x = 1745.86, y = 2644.15, z = 45.08},
        {x = 1745.64, y = 2648.28, z = 45.08},
        {x = 1727.42, y = 2648.71, z = 45.08},
        {x = 1727.66, y = 2644.56, z = 45.08},
        {x = 1727.10, y = 2640.24, z = 45.08},
        {x = 1727.77, y = 2636.23, z = 45.08},
        {x = 1727.62, y = 2632.22, z = 45.08},
        {x = 1727.50, y = 2628.01, z = 45.08},
        {x = 1726.56, y = 2623.95, z = 45.08},
    },
    escapeLocation = {1851.38, 2607.33, 45.65}
}

escapers = {}
resetTimers = {}
muted = false

schedule = {
    {name = "Meal time", time=300000},
    {name = "Work/free time", time=80000},
    {name = "Visitation/free time", 60000},
    {name = "Locking up", time=120000},
    {name = "Lockup", time=120000},
    {name = "Work/free time", time=80000},
    {name = "Shower time", time=120000},
    {name = "Yard time", time=300000},
    {name = "Meal time", time=300000},
    {name = "Visitation/free time", 360000},
    {name = "Work/free time", time=80000},
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
                    x = roles["prisoner"].spawns[math.random(#roles["prisoner"].spawns)].x,
                    y = roles["prisoner"].spawns[math.random(#roles["prisoner"].spawns)].y,
                    z = roles["prisoner"].spawns[math.random(#roles["prisoner"].spawns)].z
                })

                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1ESCAPE", " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. " has ^1ESCAPED^0! The warden needs to do a better job than this..."}
                })                

            Citizen.CreateThread(function()
                Citizen.Wait(120000)

                escapeTimers[_source] = nil
            end)
        else
            print("[PrisonFive] Someone is escaping really quickly: " .. GetPlayerName(_source))
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

local lesterSpoken = false

RegisterNetEvent("pf_sv:speakToLester")
AddEventHandler("pf_sv:speakToLester", function()
    if not lesterSpoken then
        if math.random() * 100 < 40 then
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^1LESTER", "I'll help you get out of here... Go to the yard in about 5 to 10 minutes, you'll see what I mean..."}
            })

            Citizen.CreateThread(function()
                Citizen.Wait(60000 * 6)
                TriggerClientEvent("pf_cl:escapePossible", -1, true)
                Citizen.Wait(6000)
                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1[PrisonFive]", "The fence was blown to pieces, don't let prisoners escape!"}
                })
                Citizen.Wait(60000 * 3)
                TriggerClientEvent("pf_cl:escapePossible", -1, false)
                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1[PrisonFive]", "The fence was repaired"}
                })
            end)
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^1LESTER", "I'll help you get out of here... Not now, but soon, I promise."}
            })
        end

        lesterSpoken = true
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1LESTER", "I've spoken to who I came for already"}
        })        
    end
end)

Citizen.CreateThread(function()
    while true do
        currentSchedule = currentSchedule + 1
        if not schedule[currentSchedule] then currentSchedule = 1 end

        if schedule[currentSchedule].name == "Work/free time" then
            if jobs then
                for _,job in pairs(jobs)do
                    job.occupied = false
                end
            end
        else
            for pl,job in pairs(curJobs)do
                if(job)then
                    local worked = os.time() - workStarted[pl]
                    print("[PrisonFive] User " .. GetPlayerName(pl) .. " worked for " .. worked)
        
                    local payout = math.floor(jobs[curJobs[pl]].paycheck * (worked / 10))
        
                    TriggerClientEvent("pf_cl:playerStopJob", -1, pl, curJobs[pl], mops[pl])
                    TriggerEvent("es:getPlayerFromId", pl, function(user)
                        user.addMoney(payout)
                        TriggerClientEvent('chat:addMessage', pl, {
                            args = {"^1PrisonFive", "^0You finished your job and earned ^3$" .. payout}
                        })
                    end)
                end
            end

            curJobs = {}
        end

        if schedule[currentSchedule].name == "Lockup" then
            cellblockOpen = false
            TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
        else
            cellblockOpen = true
            TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
        end

        if schedule[currentSchedule].name == "Visitation/free time" then
            TriggerClientEvent("pf_cl:visitationLester", -1)
        else
            lesterSpoken = false
            TriggerClientEvent("pf_cl:visitationLesterRemove", -1)
        end

        TriggerClientEvent("pf_cl:changeSchedule", -1, schedule[currentSchedule].name)
        TriggerClientEvent('chat:addMessage', -1, {
            args = {"^1SCHEDULE", "Changed to: ^2" .. schedule[currentSchedule].name}
        })
        print("[PrisonFive] New schedule: " .. schedule[currentSchedule].name)

        Citizen.Wait(schedule[currentSchedule].time or 60000)
    end
end)

function round2(num, numDecimalPlaces)
    return string.format("%." .. (numDecimalPlaces or 0) .. "f", num)
  end


  --[[
RegisterNetEvent("savepos")
AddEventHandler("savepos", function(x, y, z)
    local curData = LoadResourceFile("es_prisonfive", "positions.txt") or ""
    curData = curData .. "{x = " .. round2(x, 2) .. ", y = " .. round2(y, 2) .. ", z = " .. round2(z, 2) .. "},\n"
    SaveResourceFile("es_prisonfive", "positions.txt", curData, -1)
end)]]