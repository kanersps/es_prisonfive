roles = {}
currentWarden = -1

RegisterNetEvent("pf_sv:selectRole")

AddEventHandler("es:playerLoaded", function(source, user)
    user.setGlobal("prisonRole", "menu")
end)

AddEventHandler("es:playerDropped", function(user)
    if(user.getPrisonRole() ~= "menu")then
        roles[user.getPrisonRole()].current = roles[user.getPrisonRole()].current - 1

        -- If resource is restarted and people leave before getting a role it will remove them again making stuff go into minus.
        if(roles[user.getPrisonRole()].current < 0)then
            roles[user.getPrisonRole()].current = 0
        end
    end
end)

AddEventHandler("pf_sv:selectRole", function(role)
    local _source = source

    print("User wants role: " .. role)
    print("User role limit: " .. roles[role].current .. "/" .. roles[role].limit)

    TriggerEvent("es:getPlayerFromId", _source, function(user)

        if(user.getPrisonRole() ~= "menu")then
            roles[user.getPrisonRole()].current = roles[user.getPrisonRole()].current - 1
            if roles[user.getPrisonRole()].current < 0 then
                roles[user.getPrisonRole()].current = 0
            end
        end

        if(user.getPrisonRole() == "warden")then
            TriggerClientEvent("pf_cl:setWarden", -1, -1)
        end

        if(user.getPrisonRole() == role and roles[role].limit > roles[role].current)then
            print("User already has this role. Continueing to spawn...")

            roles[role].current = roles[role].current + 1

            user.displayMoney(user.getMoney())

            -- Refunding the dollar it costed to select a new role
            user.addMoney(1)

            if(role == "warden")then
                currentWarden = _source
                TriggerClientEvent("pf_cl:setWarden", -1, _source)
            else
                TriggerClientEvent("pf_cl:setWarden", _source, currentWarden)
            end

            TriggerClientEvent("pf_cl:setPlayerRole", _source, role)
            TriggerClientEvent('toggleJailDoors', _source, cellblockOpen)
            TriggerClientEvent("pf_cl:changeSchedule", _source, schedule[currentSchedule].name)
            TriggerEvent("pf_sv:spawnPlayer", _source, {
                x = roles[role].spawns[math.random(#roles[role].spawns)].x,
                y = roles[role].spawns[math.random(#roles[role].spawns)].y,
                z = roles[role].spawns[math.random(#roles[role].spawns)].z
            })

            print("User role limit: " .. roles[role].current .. "/" .. roles[role].limit)
        else
            if(roles[role])then
                if(roles[role].limit > roles[role].current)then

                    roles[role].current = roles[role].current + 1
                    
                    -- Limiting user role joins, so we dont get 100 wardens

                    user.setPrisonRole(role)
                    print("User added to role. Continueing to spawn...")

                    user.displayMoney(user.getMoney())

                    if(role == "warden")then
                        currentWarden = _source
                        TriggerClientEvent("pf_cl:setWarden", -1, _source)
                    else
                        TriggerClientEvent("pf_cl:setWarden", _source, currentWarden)
                    end

                    TriggerClientEvent("pf_cl:setPlayerRole", _source, role)
                    TriggerClientEvent('toggleJailDoors', _source, cellblockOpen)
                    TriggerClientEvent("pf_cl:changeSchedule", _source, schedule[currentSchedule].name)
                    TriggerEvent("pf_sv:spawnPlayer", _source, {
                        x = roles[role].spawns[math.random(#roles[role].spawns)].x,
                        y = roles[role].spawns[math.random(#roles[role].spawns)].y,
                        z = roles[role].spawns[math.random(#roles[role].spawns)].z
                    })

                    print("User role limit: " .. roles[role].current .. "/" .. roles[role].limit)
                else
                    print("User selected full role")
                end
            end
        end
    end)
end)

RegisterCommand("setrole", function(args)

end, true)