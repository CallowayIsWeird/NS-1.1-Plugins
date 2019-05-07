PLUGIN.name = "Flag Assignment"
PLUGIN.author = "CallowayIsWeird#7502"
PLUGIN.desc = "Automatically assigns flags for admins/vip groups (can be customizable, just contact me via discord and ill do it for you for free.)"

    ----------------- CONFIG -----------------
nut.config.add("flagAssignmentOn", true, "Whether it is enabled or not.", nil, {
    category = "flagAssignment"
})

nut.config.add("flagAssignmentNotif", "Since you are an admin, you have been given PET flags.", "The message that sends the administrator.", nil, {
    category = "flagAssignment"
})

----------------- CODE/DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING/CONTACT ME IF YOU WANT VIP GROUP ADDED -------------------
hook.Add("PlayerLoadedChar", "flagAssign", function(client, character)
    if (nut.config.get("flagAssignmentOn")) then -- checks if its on or not
        if (client:IsAdmin()) then -- Can be funneled into a IsUserGroup("")
            character:giveFlags("pet") -- gives flags
            client:notify(nut.config.get("flagAssignmentNotif")) -- notif
        end
    end
end)
----------------- CODE/DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING/CONTACT ME IF YOU WANT VIP GROUP ADDED -------------------