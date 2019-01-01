roles.officer = {
    limit = 10,
    current = 0,
    paycheck = 20,
    loadout = {
        0x3656C8C1, -- WEAPON_STUNGUN
        0x1D073A89, -- WEAPON_PUMPSHOTGUN
        0x5EF9FEC4, -- WEAPON_COMBATPISTOL
        0x678B81B1, -- WEAPON_NIGHTSTICK
    },
    spawns = {
        {1731.01, 2570.6, 49.65}
    }
}

cellblockOpen = false

TriggerEvent("es:addCommand", "c", function(source, args, user)
    TriggerEvent('es:canGroupTarget', user.getGroup(), "mod", function(canTarget)
        if(user.getPrisonRole() == "officer" or user.getPrisonRole() == "warden" or canTarget)then
            cellblockOpen = not cellblockOpen
            TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)

            if(cellblockOpen)then
                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1CELLS", " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. " has ^2opened^0 all celldoors."}
                })
            else
                TriggerClientEvent('chat:addMessage', -1, {
                    args = {"^1CELLS", " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. " has ^1closed^0 all celldoors."}
                })
            end
        end
    end)
end)