RegisterNetEvent("pf_sv:purchaseItem")

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