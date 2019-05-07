PLUGIN.name = "Welcome Message"
PLUGIN.author = "CallowayIsWeird#7502"
PLUGIN.desc = "Sends a personalized welcome message whenever a player loads their character."

------------------ CONFIG ------------------
nut.config.add("welcomeMessageOn", true, "Whether it is enabled or not.", nil, {
    category = "welcomeMessage"
})

nut.config.add("welcomeMessage", "Welcome to my server!", "The message it sends to the player upon load in.", nil, {
    category = "welcomeMessage"
})

nut.config.add("welcomeMessageMoney", true, "Will it notify the player of their current balance?", nil, {
    category = "welcomeMessage"
})

nut.config.add("welcomeMessageName", true, "Will it notify the player of their current name (Includes prefix)?", nil, {
    category = "welcomeMessage"
})

nut.config.add("welcomeMessageNamePrefix", "Mr.", "What is the prefix of the name?", nil, {
    category = "welcomeMessage"
})

nut.config.add("welcomeMessageVipMessageOnOff", false, "Whether or not you want VIP Welcoming message on.", nil, {
    category = "welcomeMessage"
})

nut.config.add("welcomeMessageVipMessage", "Thank you for donating to our server(s)!", "What is the message you want to send to the VIP member?", nil, {
    category = "welcomeMessage"
})

nut.config.add("welcomeMessageVipGroup", "vip", "EXTRA: What is your VIP usergroup on your server? (Must be one group, will add support for multiple later on)", nil, {
    category = "welcomeMessage"
})


-- Any help if you messed this up, please contact me at CallowayIsWeird#7502
------------------ ACTUAL CODE, DO NOT EDIT UNLESS YOU KNOW WHAT YOUR DOING ------------------
hook.Add("PlayerLoadedChar", "welcomeMessage", function(client, id)
    local money = client:getChar():getMoney()
    local name = client:getChar():getName()

    if (nut.config.get("welcomeMessageOn")) then -- Checks if its on/off.
        client:notify(nut.config.get("welcomeMessage")) -- The actual message.
    
        if (nut.config.get("welcomeMessageName")) then -- Checks if name is on.
            client:notify("Your current name is " .. nut.config.get("welcomeMessageNamePrefix") .. " " .. name) -- The name notification.
        end

        if (nut.config.get("welcomeMessageMoney")) then -- Checks if money notif is on.
            client:notify("Your current balance is $" .. "" .. money .. ".") -- The money notification.
        end

        if (nut.config.get("welcomeMessageVipMessageOnOff")) then -- Checks if its on.
            if client:IsUserGroup(nut.config.get("welcomeMessageVipGroup")) then -- Checks their usergroup.
                client:notify(nut.config.get("welcomeMessageVipMessage")) -- Sends message.
            end
        end
    end
end)
------------------ ACTUAL CODE, DO NOT EDIT UNLESS YOU KNOW WHAT YOUR DOING ------------------