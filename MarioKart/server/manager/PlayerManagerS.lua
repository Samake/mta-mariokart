--[[
	Filename: PlayerManagerS.lua
	Authors: Sam@ke
--]]

PlayerManagerS = {}


function PlayerManagerS:constructor(parent)
	mainOutput("PlayerManagerS was loaded.")

	self.mainClass = parent

	self.defaultSpawn = {x = 0, y = 0, z = 645}
	self.playerClasses = {}

	self:init()
end


function PlayerManagerS:init()
	self.m_OnPlayerJoin = bind(self.onPlayerJoin, self)
	addEventHandler("onPlayerJoin", root, self.m_OnPlayerJoin)

	self.m_OnPlayerLogin = bind(self.onPlayerLogin, self)
	addEventHandler("onPlayerLogin", root, self.m_OnPlayerLogin)

	self.m_OnPlayerLogout = bind(self.onPlayerLogout, self)
	addEventHandler("onPlayerLogout", root, self.m_OnPlayerLogout)

	self.m_OnPlayerQuit = bind(self.onPlayerQuit, self)
	addEventHandler("onPlayerQuit", root, self.m_OnPlayerQuit)

	for index, player in pairs(getElementsByType("player")) do
		if (player) then
			local playerStats = {}
			playerStats.id = self:getFreeID()
			playerStats.player = player
			playerStats.name = player:getName()
			playerStats.modelID = 190
			playerStats.vehicleID = 602

			if (not self.playerClasses[playerStats.id]) then
				self.playerClasses[playerStats.id] = new(PlayerS, self, playerStats)
			end
		end
	end
end


function PlayerManagerS:onPlayerJoin()
	if (isElement(client)) then
		local player = client
		player:fadeCamera(true, 2.0, 0, 0, 25)
		toggleAllControls(player, false)
		player:spawn(self.defaultSpawn.x, self.defaultSpawn.y, self.defaultSpawn.z, 0, 190)
		player:setCameraTarget(player)
	end
end


function PlayerManagerS:onPlayerLogin()
	if (isElement(client)) then
		local player = client
		local playerStats = {}
		playerStats.id = self:getFreeID()
		playerStats.player = player
		playerStats.name = player:getName()
		playerStats.modelID = 190
		playerStats.vehicleID = 471
		playerStats.coins = 200
		playerStats.xp = 345320
		playerStats.level = 8

		if (not self.playerClasses[playerStats.id]) then
			self.playerClasses[playerStats.id] = new(PlayerS, self, playerStats)
		end
	end
end


function PlayerManagerS:onPlayerLogout()
	if (isElement(client)) then
		local player = client

		for index, playerClass in pairs(self.playerClasses) do
			if (playerClass) then
				if (playerClass.player == player) then
					delete(playerClass)
					self.playerClasses[index] = nil
					playerClass = nil
				end
			end
		end
	end
end


function PlayerManagerS:onPlayerQuit()
	local player = source

	for index, playerClass in pairs(self.playerClasses) do
		if (playerClass) then
			if (playerClass.player == player) then
				delete(playerClass)
				self.playerClasses[index] = nil
				playerClass = nil
			end
		end
	end
end


function PlayerManagerS:updateFast()
	for index, playerClass in pairs(self.playerClasses) do
		if (playerClass) then
			playerClass:updateFast()
		end
	end
end


function PlayerManagerS:updateSlow()
	for index, playerClass in pairs(self.playerClasses) do
		if (playerClass) then
			playerClass:updateSlow()
		end
	end
end


function PlayerManagerS:getFreeID()
	for index, playerClass in ipairs(self.playerClasses) do
		if (not playerClass) then
			return index
		end
	end

	return #self.playerClasses + 1
end



function PlayerManagerS:clear()

	for index, player in pairs(getElementsByType("player")) do
		if (player) then
			player:fadeCamera(true, 2.0, 0, 0, 25)
			--toggleAllControls(player, true)
			--player:logOut()
		end
	end

	for index, playerClass in pairs(self.playerClasses) do
		if (playerClass) then
			delete(playerClass)
			playerClass = nil
		end
	end

	removeEventHandler("onPlayerJoin", root, self.m_OnPlayerJoin)
	removeEventHandler("onPlayerLogin", root, self.m_OnPlayerLogin)
	removeEventHandler("onPlayerLogout", root, self.m_OnPlayerLogout)
	removeEventHandler("onPlayerQuit", root, self.m_OnPlayerQuit)
end


function PlayerManagerS:destructor()
	self:clear()

	mainOutput("PlayerManagerS was deleted.")
end
