loadouts.officer = {
    0x3656C8C1, -- WEAPON_STUNGUN
    0x1D073A89, -- WEAPON_PUMPSHOTGUN
    0x5EF9FEC4, -- WEAPON_COMBATPISTOL
    0x678B81B1, -- WEAPON_NIGHTSTICK   
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if(_role == "officer" or _role == "warden")then
            ResetPlayerStamina(PlayerId())
        end
    end
end)