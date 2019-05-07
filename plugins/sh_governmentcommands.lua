PLUGIN.name = "New Commands"
PLUGIN.author = "CallowayIsWeird#7502"
PLUGIN.desc = "New commands with administrative control over who can access or not."
-- Stuff in this script can get a bit confusing, due to the configuration aspect.
-- Most if not everything will work, so don't worry about the coding aspect.


----------------- GOV CONFIG -------------
nut.config.add("governmentTeam", "TEAM_GOVERNMENT", "The custom check for the government command. Please dont fuck this up. Its so hard not to. Must be in 'FACTION_WHATEVER' format, (check faction file)", nil, {
    category = "governmentCommand"
})

nut.config.add("governmentMoneyTake", "30", "The amount of money it takes from your wallet to put out the command.", nil, {
    category = "governmentCommand"
})

nut.config.add("governmentNotif", "has been deducted from your wallet. An official press conference has been released to the public.", "The notification it puts out to the initiating player.", nil, {
    category = "governmentCommand"
})

nut.config.add("governmentName", "New York City Government", "The actual city government name.", nil, {
    category = "governmentCommand"
})

----------------- POLICE CONFIG -------------
nut.config.add("policeTeam", "TEAM_POLICE", "The custom check for the police command. Please dont fuck this up. Its so hard not to. Must be in 'FACTION_WHATEVER' format, (check faction file)", nil, {
    category = "policeCommand"
})

nut.config.add("policeMoneyTake", "30", "The amount of money it takes from your wallet to put out the command.", nil, {
    category = "policeCommand"
})

nut.config.add("policeNotif", "has been deducted from your wallet. An official press conference has been released to the public.", "The notification it puts out to the initiating player.", nil, {
    category = "policeCommand"
})

nut.config.add("policeName", "New York City PD", "The actual city police department name.", nil, {
    category = "policeCommand"
})

----------------- CODE/DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING -------------
nut.chat.register("government", {
	onCanSay =  function(speaker, text)	
		if speaker:Team() == nut.config.get("governmentTeam") then
			speaker:getChar():takeMoney(nut.config.get("governmentMoneyTake"))
			speaker:notify("$" .. nut.config.get("governmentMoneyTake") .. " " .. nut.config.get("governmentNotif"))
			return true
		else 
			speaker:notify("You cannot put out a " .. nut.config.get("governmentName") .. " press conference.")
			return false 
		end
		end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(61, 86, 247), " " .. nut.config.get("governmentName") .. " ", color_white, text)
	end,
	prefix = {"/government"},
	noSpaceAfter = true,
	filter = "advertisements",
	syntax = "<string message>"
})

------------------- POLICE -----------------
nut.chat.register("policead", {
	onCanSay =  function(speaker, text)	
		if speaker:Team() == nut.config.get("policeTeam") then
				speaker:getChar():takeMoney(nut.config.get("policeMoneyTake"))
				speaker:notify("$" .. nut.config.get("policeMoneyTake") .. " " .. nut.config.get("policeNotif"))
			return true
		else 
			speaker:notify("You cannot put out a " .. nut.config.get("policeName") .. " statement.")
			return false 
		end
		end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(61, 86, 247), " " .. nut.config.get("policeName") .. " ", color_white, text)
	end,
	prefix = {"/policead"},
	noSpaceAfter = true,
	filter = "advertisements",
	syntax = "<string message>"
})