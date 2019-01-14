print("Finding roles...")

for k,v in pairs(roles)do
    print(k .. " found, limit: " .. v.limit)
end

print("es_prisonfive started")

TriggerEvent("es:addGroupCommand", "pinfo", "admin", function(_source, args, user)
    if GetPlayerName(args[1]) then
        print("[PrisonFive] Player info (" .. GetPlayerName(args[1]) .. ")")

        TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(_target)
            print("\n[PrisonFive] Player info (" .. GetPlayerName(args[1]) .. ")")
            print("\n[PrisonFive] Money: " .. user.getMoney())
            print("\n[PrisonFive] Role: " .. user.getPrisonRole())
        end)
    end
end)