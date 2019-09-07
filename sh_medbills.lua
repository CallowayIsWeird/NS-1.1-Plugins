PLUGIN.name = "Medical Bills"
PLUGIN.desc = "Provide medical bills."
PLUGIN.author = "CallowayIsWeird#7502"

nut.config.add("medBillsPrice", 30, "The price for the medical bills", nil, {
    data = {min = 1, max = 50},
    category = "medBills"
})

nut.config.add("medBills", true, "Include medical bills whenever someone dies.", nil, {
    category = "medBills"
})

function MedBills( client )
    local character = client:getChar()

    timer.Simple(nut.config.get("spawnTime"), function()
    	if (nut.config.get("medBills")) then
        	if client:Team() != FACTION_GOVERNMENT then
            	if !(nut.config.get("medBills")) then
                	return
				end
				
				if (character:hasReserve(nut.config.get("medBillsPrice"))) then
					character:takeReserve(nut.config.get("medBillsPrice"))
					client:notify("$" .. nut.config.get("medBillsPrice") .. " has been taken out of your bank account for medical fee's.")
				else
					client:notify("You have been charged $" .. nut.config.get("medBillsPrice") .. " directly out of your wallet for medical fee's.")
					character:takeMoney(nut.config.get("medBillsPrice"))
				end
        	end
    	end
    end)
end

hook.Add("PlayerDeath", "medBills", MedBills)