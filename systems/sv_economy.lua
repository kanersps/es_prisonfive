RegisterNetEvent("pf_sv:purchaseItem")
RegisterNetEvent("pf_sv:startJob")
RegisterNetEvent("pf_sv:stopJob")

-- Payments
Citizen.CreateThread(function()
    while true do
        TriggerEvent("es:getPlayers", function(players)
            for k,v in pairs(players) do
                if (v.getPrisonRole() == "prisoner") then
                    v.addMoney(roles.prisoner.paycheck)
                elseif (v.getPrisonRole() == "officer") then
                    v.addMoney(roles.officer.paycheck)
                elseif (v.getPrisonRole() == "warden") then
                    v.addMoney(roles.warden.paycheck)
                end
            end
        end)

        Citizen.Wait(60000)
    end
end)

-- Selecting a new role
TriggerEvent("es:addCommand", "role", function(_source, args, user)
    user.removeMoney(1)

    TriggerClientEvent("pf_cl:selectNewRole", _source)
end)

jobs = {
    {
        name = "Food server",
        location = {x = 1743.09, y = 2579.12, z = 44.46},
        paycheck = 4,
        occupied = false
    },
    {
        name = "Cleaner",
        location = {x = 1735.16, y = 2629.56, z = 45.06},
        paycheck = 4,
        occupied = false
    },
    {
        name = "Cleaner",
        location = {x = 1740.16, y = 2645.19, z = 45.06},
        paycheck = 4,
        occupied = false
    }
}

curJobs = {}
workStarted = {}
mops = {}

AddEventHandler("pf_sv:startJob", function(job)
    local _source = source

    if schedule[currentSchedule].name == "Work/free time" then
        print("[PrisonFive] Starting job for " .. GetPlayerName(_source))
        if (jobs[job] and jobs[job].occupied == false) then
            mops[_source] = tostring(math.random())
            jobs[job].occupied = true
            workStarted[_source] = os.time()
            curJobs[_source] = job
            TriggerClientEvent('pf_cl:startJob', _source, job)
            TriggerClientEvent("pf_cl:playerStartJob", -1, _source, job, mops[_source])
            print("[PrisonFive] Started job for " .. GetPlayerName(_source))
        else
            TriggerClientEvent('chat:addMessage', _source, { args = {"^1PrisonFive", "^0Can't work here for this period"}})
        end
    end
end)

AddEventHandler("pf_sv:stopJob", function(respawned)
    local _source = source
    if(curJobs[_source])then
        if(jobs[curJobs[_source]])then
            jobs[curJobs[_source]].occupied = false

            local worked = os.time() - workStarted[_source]
            print("[PrisonFive] User " .. GetPlayerName(_source) .. " worked for " .. worked)

            local payout = math.floor(jobs[curJobs[_source]].paycheck * (worked / 10))

            TriggerClientEvent("pf_cl:stopJob", _source)
            TriggerClientEvent("pf_cl:playerStopJob", -1, _source, curJobs[_source], mops[_source], respawned)

            TriggerEvent("es:getPlayerFromId", _source, function(user)
                user.addMoney(payout)
                TriggerClientEvent('chat:addMessage', _source, {
                    args = {"^1PrisonFive", "^0You finished your job and earned ^3$" .. payout}
                })
            end)
        end

        curJobs[_source] = nil
    end
end)

-- Purchasing items
local items = {
    {
        price = 60,
        item = "WEAPON_PISTOL"
    },
    {
        price = 30,
        item = "WEAPON_KNIFE"
    },
    {
        price = 200,
        item = "WEAPON_SAWNOFFSHOTGUN"
    },
    {
        price = 500,
        item = "WEAPON_ASSAULTRIFLE"
    },
    {
        price = 20,
        item = "give_armor"
    }
}

AddEventHandler("pf_sv:purchaseItem", function(id)
    local _source = source
    TriggerEvent("es:getPlayerFromId", _source, function(user)
        if(user.getMoney() >= items[id].price)then
            user.removeMoney(items[id].price)
            TriggerClientEvent("pf_cl:purchaseComplete", _source, items[id].item)
        else

        end
    end)
end)