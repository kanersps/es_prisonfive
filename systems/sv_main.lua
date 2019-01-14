print("Finding roles...")

for k,v in pairs(roles)do
    print(k .. " found, limit: " .. v.limit)
end

print("es_prisonfive started")

TriggerEvent("es:addGroupCommand", "pinfo", "admin", function(_source, args, user)
    if GetPlayerName(args[1]) then
        TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(_target)
            if(_source ~= 0)then
                TriggerClientEvent('chat:addMessage', source, { args = {"^1PrisonFive", "^0Player info (" .. GetPlayerName(args[1]) .. ")"}})
                TriggerClientEvent('chat:addMessage', source, { args = {"^1PrisonFive", "^0Money: " .. _target.getMoney()}})
                TriggerClientEvent('chat:addMessage', source, { args = {"^1PrisonFive", "^0Role: " .. _target.getPrisonRole()}})
            else
                print("^1[PrisonFive] ^0Player info (" .. GetPlayerName(args[1]) .. ")")
                print("^1[PrisonFive] ^0Money: " .. _target.getMoney())
                print("^1[PrisonFive] ^0Role: " .. _target.getPrisonRole())
            end
        end)
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Retrieves a user information", params = {{name = "userid", help = "The ID of the player"}}})