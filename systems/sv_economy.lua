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