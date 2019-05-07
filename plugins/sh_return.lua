PLUGIN.name = "Return to Death POS"
PLUGIN.author = "CallowayIsWeird#7502"
PLUGIN.desc = "Go back. /return."

----------------- CODE/DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING -----------------
function PLUGIN:PlayerDeath(victim, inflictor, attacker)
	local char = victim:getChar()
	
	if(char) then
		char:setData("deathPos", victim:GetPos())
	end
end

-------------- COMMAND -------------
nut.command.add("return", {
	onRun = function(client, arguments)
		if(IsValid(client)) then
            if(client:Alive()) then
                if(client:IsAdmin()) then
				    local char = client:getChar()
				    local oldPos = char:getData("deathPos")
				
				    if(oldPos) then
					    client:SetPos(oldPos)
					    char:setData("deathPos", nil)
				    else
					    client:notify("No death position saved.")
                    end
                else
                    client:notify("You are not an administrator.")
                end
			else
				client:notify("Wait until you respawn.")
			end
		end
	end
})
-------------- COMMAND -------------