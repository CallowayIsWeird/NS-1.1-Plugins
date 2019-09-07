local PLUGIN = PLUGIN
PLUGIN.name = "Banking"
PLUGIN.author = "CallowayIsWeird#7502 and ProFragHosting.Com ✓ᵛᵉʳᶦᶠᶦᵉᵈ#2179"
PLUGIN.desc = "This plugin allows people to rob the bank."

PLUGIN.lastRaid = RealTime()
PLUGIN.reward = 5000
PLUGIN.holdTime = 200
PLUGIN.grabTime = 30
PLUGIN.doorTime = 100
PLUGIN.penalty = 2000

nut.bankrob = nut.bankrob or {}


if (CLIENT) then
	WORLDEMITTER = WORLDEMITTER or ParticleEmitter(Vector(0, 0, 0))
	function PLUGIN:UpdateAnimation(client)
		local money = client:getStolenMoney()

		if (money and money > 0) then
			if (client.nMoney and client.nMoney > CurTime()) then return end
			client.nMoney = CurTime() + .1
			local new = nut.util.getMaterial("icon16/page.png")

			local vc1, vc2 = client:GetRenderBounds()

			local pos = client:GetPos()
			for i = 1, 2 do
				local randPos = Vector(math.random(vc1.x, vc2.x), math.random(vc1.y, vc2.y), math.random(vc1.z, vc2.z))

				local p = WORLDEMITTER:Add(new, pos + client:OBBCenter() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-2, 2))*10)
				p:SetVelocity(randPos*1)
				p:SetDieTime(1)
				p:SetStartAlpha(255)
				p:SetEndAlpha(0)
				p:SetStartSize(2)
				p:SetEndSize(4)
				p:SetRoll(math.Rand(180,480))
				p:SetRollDelta(math.Rand(-3,3))
				p:SetColor(150,150,150)
				p:SetGravity( Vector( 0, 0, -100 )*math.Rand( .2, 1 ) )
			end
		end
	end

	local gradient = nut.util.getMaterial("vgui/gradient-l")
	
	function PLUGIN:HUDPaint()
		local client = LocalPlayer()
		
		if (client and client:getChar() and client:getStolenMoney() > 0) then
			local tx, ty = nut.util.drawText("You're Robbing The Bank!", 36, 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "nutBigFont")
			local a, b = nut.util.drawText("Time Left: " .. math.Round(math.max(0, client:getNetVar("rTimer") - CurTime())) .. " seconds", 40, 40 + ty*.9, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "nutMediumFont")
			a, b = a + tx, b + ty*.9
			tx, ty = nut.util.drawText("Stolen Money: " .. nut.currency.get(client:getStolenMoney()), 40, 40 + b, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "nutMediumFont")
		end
	end	
else
	function PLUGIN:SaveData()
		local entTable = {}
		local class
		for k, v in ipairs(ents.GetAll()) do
			class = v:GetClass():lower()
			if (class == "bankreserve") then
				table.insert(entTable, {
					class = class,
					pos = v:GetPos(),
					ang = v:GetAngles()
				})
			end
		end

		self:setData(entTable)
	end

	function PLUGIN:LoadData()
		local entTable = self:getData(entTable) or {}
		
		for k, v in ipairs(entTable) do
			local ent = ents.Create(v.class or "bankreserve")
			ent:SetPos(v.pos)
			ent:SetAngles(v.ang)
			ent:Spawn()
			ent:Activate()
		end
	end

	function PLUGIN:OnPlayerStealMoney(client, reserve)
		if (!nut.config.get("raidWanted")) then return end
			for k, v in pairs(player.GetAll()) do
				v:notify("There is a bank robbery in progress.");
			end
		/*if (!client:isWanted()) then NEXT UPDATE
			nut.log.add(client, "robbery")
			client:wanted(true, "Bank Robbery", client)
		end		*/
	end

	function PLUGIN:PlayerDisconnect(client)
		if (client and client:IsValid()) then
			client:resetStealing()
		end
	end

	function PLUGIN:CanDoRobbery(client)
		if (!client or !client:IsValid()) then return end

		local char = client:getChar()

		if (char) then
			local faction = char:getFaction()
			local factionData = nut.faction.indices[char:getFaction()]

			if (faction == FACTION_NYPD or
			faction == FACTION_GOVERNMENT) then
				return false, "You cannot rob the bank as your current role!"
			end
		else
			return false, "what"
		end

		-- get police
		local laws = 0

		for k, v in ipairs(player.GetAll()) do
			local char = v:getChar()

			if (char) then
				local class = char:getClass()
				local classData = nut.class.list[class]

				if (classData and classData.law) then
					laws = laws + 1
				end
			end
		end

		if (laws < nut.config.get("raidLaws", 5)) then
			return false, "There is not enough law enforcement officers to rob the bank!"
		end

		return true
	end

	function PLUGIN:OnPlayerFailedRobbery(client)
		nut.log.add(client, "robberyB")
		client:notifyLocalized("You failed the robbery, better luck next time pal.")
	end

	function PLUGIN:OnPlayerRobberyDone(client, reward)
		nut.log.add(client, "robberyA")
		client:notifyLocalized("You have completed the robbery! Get out of there!")
	end
end

function PLUGIN:PlayerLoadedChar(client, character, lastChar)
	local char = client:getChar()
	local legacy = false

	if (char:getData("reserve")) then
		local restore = char:getData("reserve", 0)

		char:setReserve(tonumber(restore))
		char:setData("reserve", nil)
		legacy = true
		print("legacy = true")
	end

	nut.db.query("SELECT _reserve FROM nut_reserve WHERE _charID = "..char:getID(), function(data)
		if (data and #data > 0) then
			for k, v in ipairs(data) do
				local money = tonumber(v._reserve)

				if (!legacy) then
					char:setReserve(money)
				end
			end
		else
			nut.db.insertTable({
				_reserve = 0,
				_charID = char:getID(),
			}, function(data)
				if (!legacy) then
					char:setReserve(0)
				end
			end, "reserve")
		end
	end)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:getStolenMoney()
	return self:getNetVar("rMoney", 0)
end

if (SERVER) then
	function PLUGIN:PlayerDeath(victim, inflictor, attacker)
		if (victim and victim:IsValid() and victim:getStolenMoney() > 0) then
			hook.Run("OnPlayerFailedRobbery", victim)
			victim:resetStealing()
		end
		
		if (IsValid(victim) and IsValid(attacker)) then 
			if (victim:IsPlayer() and attacker:IsPlayer()) then
				local robChar, lawChar = victim:getChar(), attacker:getChar()
				local robClass, lawClass = robChar:getClass(), lawChar:getClass()
				local robData, lawData = nut.class.list[robClass], nut.class.list[lawClass]

				if (robChar and lawChar and victim:getStolenMoney() > 0) then
					if (lawData.law) then
						local reward = math.Round(victim:getStolenMoney() * (nut.config.get("rewardKill", 10) / 100))
						lawChar:giveMoney(reward)
						lawChar:notifyLocalized("You took down the robbers, heres a bonus!", reward)
					end
				end
			end
		end
	end

	function PLUGIN:OnPlayerArrested(arrester, arrested, isArrest)
		if (arrested and arrested:IsValid() and isArrest and arrested:getStolenMoney() > 0) then
			hook.Run("OnPlayerFailedRobbery", arrested)
			arrested:resetStealing()
		end
		
        if (IsValid(arrester) and IsValid(arrested)) then
			if (arrester:IsPlayer() and arrested:IsPlayer()) then
				local robChar, lawChar = arrested:getChar(), arrester:getChar()
				local robClass, lawClass = robChar:getClass(), lawChar:getClass()
				local robData, lawData = nut.class.list[robClass], nut.class.list[lawClass]

				if (robChar and lawChar and arrested:getStolenMoney() > 0) then
					if (lawData.law) then
						local reward = math.Round(victim:getStolenMoney() * (nut.config.get("rewardArrest", 20) / 100))
						lawChar:giveMoney(reward)
						lawChar:notifyLocalized("You were rewarded a bonus for your service!", reward)
					end
				end
			end
		end
	end

	function PLAYER:setStolenMoney(amount, noTimer)
		local char = self:getChar()

		if (!char) then return end

		if (amount > 0 and !noTimer) then
			local time = nut.config.get("raidTimer", 100)

			self:setNetVar("rTimer", CurTime() + time)

			local timerChar = char:getID()
			timer.Create(self:UniqueID() .. "_robTimer", time, 1, function()
				if (self and self:IsValid()) then
					if (self:getChar():getID() == timerChar) then
						self:doneStealing()
					end
				end
			end)
		end

		self:setNetVar("rMoney", amount)
	end

	function PLAYER:addStolenMoney(amount, noTimer)
		local char = self:getChar()

		if (!char) then return end

		if (amount > 0 and !noTimer) then
			local time = nut.config.get("raidTimer", 100)

			self:setNetVar("rTimer", CurTime() + time)

			local timerChar = char:getID()
			timer.Create(self:UniqueID() .. "_robTimer", time, 1, function()
				if (self and self:IsValid()) then
					if (self:getChar():getID() == timerChar) then
						self:doneStealing()
					end
				end
			end)
		end

		self:setNetVar("rMoney", self:getNetVar("rMoney", 0) + amount)
	end

	function PLAYER:destoryTimer()
		timer.Remove(self:UniqueID() .. "_robTimer")
	end

	function PLAYER:resetStealing()
		self:setStolenMoney(0)
		self:destoryTimer()
	end	

	function PLAYER:doneStealing()
		local reward = self:getStolenMoney()
		local char = self:getChar()

		if (char and reward > 0) then
			char:giveMoney(reward)

			if (nut.config.get("raidWanted")) then
				//char:setData("wanted", false, nil, player.GetAll()) NEXT UPDATE ILL ADD THIS IN, FOR NOW WE USE NOTIFY!
			end	
		end

		hook.Run("OnPlayerRobberyDone", self, reward)

		self:resetStealing()
	end

	function PLAYER:failedStealing()
		self:resetStealing()
	end
end

nut.config.add("raidGovernment", true, "Can the police/government rob the bank?", nil, {
	category = "bankraid"
})

nut.config.add("raidWanted", true, /*Wanted player when they steal the money*/"WIP! NOTIFY ONLY ", nil, {
	category = "bankraid"
})

nut.config.add("raidLaws", 5, "Amount of police needed to steal the bank money.", nil, {
	data = {min = 0, max = 10},
	category = "bankraid"
})

nut.config.add("raidTimer", 100, "Amount of time needed to convert the money to the funt", nil, {
	data = {min = 1, max = 900},
	category = "bankraid"
})

nut.config.add("raidMoneyWorth", 1500, "Amount of money steal per use on Bank Reserve", nil, {
	data = {min = 1, max = 100000},
	category = "bankraid"
})

nut.config.add("raidSpawn", 259200, "Respawn time of the Bank Reserve.", nil, {
	data = {min = 1, max = 2592000},
	category = "bankraid"
})


nut.config.add("rewardKill", 2500, ".", nil, {
	data = {min = 1, max = 25000},
	category = "bankraid"
})

nut.config.add("rewardArrest", 5000, ".", nil, {
	data = {min = 1, max = 25000},
	category = "bankraid"
})
