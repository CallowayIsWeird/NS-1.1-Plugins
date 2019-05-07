PLUGIN.name = "Medical Bills"
PLUGIN.desc = "Provide medical bills."
PLUGIN.author = "CallowayIsWeird#7502"
------------------- CONFIG -------------------
nut.config.add("medBillsPrice", "30", "The price for the medical bills", nil, {
    category = "medBills"
})

nut.config.add("medBills", true, "Include medical bills whenever someone dies.", nil, {
    category = "medBills"
})

nut.config.add("medBillsTeam", "FACTION_POLICE", "The team that is excluded from dropping weapons. (WILL MAKE MORE FACTIONS LATER)", nil, {
    category = "medBills"
})
------------------- ACTUAL CODE/DO NOT EDIT UNLESS YOU KNOW WHAT YOU'RE DOING -------------------
hook.Add("PlayerDeath", "medBills", function(client, inflictor, attacker)
    local character = client:getChar()

    if (nut.config.get("medBills")) then
        if client:Team() != nut.config.get("medBillsTeam") then
            if !(nut.config.get("medBills") and (client == attacker or inflictor:IsWorld())) then
                return
            end
            client:notify("You have been charged $" .. nut.config.get("medBillsPrice") .. " for medical fee's.")
        end
    end
    character:takeMoney(nut.config.get("medBillsPrice"))
end)