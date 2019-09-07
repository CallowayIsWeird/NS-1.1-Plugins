PLUGIN.name = "Licenses"
PLUGIN.author = "Bok#1740 and CallowayIsWeird#7502"
PLUGIN.desc = "you need licenses to buy items from vendors"

local guns = {
	["uniqueid1"] = true,
	["uniqueid2"] = true,
}
    
local licenseid = {
	["uniqueid1"] = "permit_gun",
	["uniqueid2"] = "permit_heavygun",
}
	
hook.Add("CanPlayerTradeWithVendor", "LicenseHook", function(client, ent, id, isSelling)
	local gunLicense = nut.config.get("gunLicense")

    if (isSelling) then
		return true
	end
    
    if (guns[id]) then
		if (client:getChar():getInv():hasItem(licenseid[id])) then
			return true
		else
			client:notify("You need a license to purchase this item.")
            return false
		end
	end
end)