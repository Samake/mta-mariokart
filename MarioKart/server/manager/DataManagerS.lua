--[[
	Filename: DataManagerS.lua
	Authors: Sam@ke
--]]

DataManagerS = {}


function DataManagerS:constructor(parent, playerManager)
	mainOutput("DataManagerS was loaded.")

	self.mainClass = parent
	self.playerManager = playerManager
	
	self.gameState = "idle"
	self.hasMySQLConnection = "false"
	self.isInternalMapManager = "false"
	self.isExternalMapManager = "false"
	self.mapList = {}
	self.mapCount = 0
	self.isMapLoader = "false"
	self.currentMapName = nil
	self.previousMapName = nil
	self.nextMapName = nil
	
	self.serverStats = {}
	self.serverStats.players = {}
	
	self.mapStats = {}
	self.mapVotes = {}

	self.saveInterVal = 5000
	self.startTick = getTickCount()

	self:init()
end


function DataManagerS:init()
	self.m_UpdateGameState = bind(self.updateGameState, self)
	addEvent("MKUPDATEGAMESTATE", true)
	addEventHandler("MKUPDATEGAMESTATE", root, self.m_UpdateGameState)
	
	self.m_OnMapStarted = bind(self.onMapStarted, self)
	addEvent("MKONMAPSTARTED", true)
	addEventHandler("MKONMAPSTARTED", root, self.m_OnMapStarted)
	
	self.m_VoteMap = bind(self.voteMap, self)
	addEvent("MKONMAPVOTED", true)
	addEventHandler("MKONMAPVOTED", root, self.m_VoteMap)
	
	if (not self.mySQLHandler) then
		self.mySQLHandler = new(MySQLHandlerS, self)
	end
	
	if (self.mySQLHandler) then
		self:readMySQLData()
	end
end


function DataManagerS:updateGameState(state)
	if (state) then
		self.gameState = state
	end
end


function DataManagerS:updateFast()
	if (self.mySQLHandler) then
		if (self.mySQLHandler.dbConnection) then
			self.hasMySQLConnection = "true"
		else
			self.hasMySQLConnection = "false"
		end
	else
		self.hasMySQLConnection = "false"
	end
	
	if (self.mainClass.mapManager) then
		self.isInternalMapManager = "true"
		self.currentMapName = self.mainClass.mapManager:getCurrentMapName()
		self.previousMapName = self.mainClass.mapManager:getPreviousMapName()
		self.nextMapName = self.mainClass.mapManager:getNextMapName()
	else
		self.isInternalMapManager = "false"
		self.currentMapName = nil
		self.previousMapName = nil
		self.nextMapName = nil
	end
	
	if (self.mainClass.mapManager) then
		if (self.mainClass.mapManager.mapManagerExt) then
			self.isExternalMapManager = "true"
		else
			self.isExternalMapManager = "false"
		end
	else
		self.isExternalMapManager = "false"
	end
	
	if (self.mainClass.mapManager) then
		if (self.mainClass.mapManager.mapLoader) then
			self.isMapLoader = "true"
		else
			self.isMapLoader = "false"
		end
	else
		self.isMapLoader = "false"
	end

	if (self.hasMySQLConnection == "true") then
		self.currentTick = getTickCount()

		if ((self.currentTick - self.startTick) > self.saveInterVal) then
			self:saveMySQLData()
		end
	end
end


function DataManagerS:updateSlow()

	if (self.mainClass.mapManager) then
		self.mapCount = self.mainClass.mapManager:getMapCount()
		self.mapList = self.mainClass.mapManager:getCompatibleMaps()
	else
		self.mapCount = 0
	end
	
	self:calculateMapVotes()
	
	if (self.playerManager) then
		for index, playerClass in pairs(self.playerManager.playerClasses) do
			if (playerClass) then
				if (isElement(playerClass.player)) then
					local player = tostring(playerClass.player)
					
					if (not self.serverStats.players[player]) then
						self.serverStats.players[player] = {}
						self.serverStats.players[player].player = playerClass.player
						self.serverStats.players[player].id = playerClass.id
						self.serverStats.players[player].modelID = playerClass.modelID
						self.serverStats.players[player].vehicleID = playerClass.vehicleID
						self.serverStats.players[player].coins = playerClass.coins
						self.serverStats.players[player].xp = playerClass.xp
						self.serverStats.players[player].level = playerClass.level
					else
						self.serverStats.players[player].player = playerClass.player
						self.serverStats.players[player].id = playerClass.id
						self.serverStats.players[player].modelID = playerClass.modelID
						self.serverStats.players[player].vehicleID = playerClass.vehicleID
						self.serverStats.players[player].coins = playerClass.coins
						self.serverStats.players[player].xp = playerClass.xp
						self.serverStats.players[player].level = playerClass.level
					end
				end
			end
		end
	end
	
	self:triggerServerData()
end


function DataManagerS:voteMap(mapName, currentVote)
	if (client) then
		if (mapName) and (currentVote) then
			if (not string.find(mapName, "PLACEHOLDER")) then
				local player = removeHEXColorCode(client:getName())

				local voteTable = {}
				voteTable.map = mapName
				voteTable.player = removeHEXColorCode(client:getName())
				voteTable.value = currentVote
				
				for index, vote in pairs(self.mapVotes) do
					if (vote) then
						if (vote.map == voteTable.map) and (vote.player == voteTable.player) then
							vote.value = voteTable.value
							return true
						end
					end
				end
				
				table.insert(self.mapVotes, voteTable)
			end
		end
	end
end


function DataManagerS:readMySQLData()

	self:loadAllMapsData()
	
end


function DataManagerS:saveMySQLData()
	self.startTick = getTickCount()
	
	for map, mapStat in pairs(self.mapStats) do
		if (mapStat) then
			--self.mySQLHandler:saveMapStats(map, mapStat)
		end
	end
	
	self.mySQLHandler:saveMapVotes(self.mapVotes)

end


function DataManagerS:loadAllMapsData()
	local allMapsStatsSaved = self.mySQLHandler:getAllMapStats()
	
	if (#allMapsStatsSaved > 0) then
		for id, map in pairs(allMapsStatsSaved) do
			if (map) then
			
				local currentMap
				
				for key, value in pairs(map) do
					if (key == "mapname") then
						currentMap = value
						self.mapStats[currentMap] = {}
					else
						if (self.mapStats[currentMap]) then
							self.mapStats[currentMap][key] = value
						end
					end
				end
			end
		end
	end
	
	
	local allMapVotesSaved = self.mySQLHandler:getAllMapVotes()
	
	if (#allMapVotesSaved > 0) then
		for id, map in pairs(allMapVotesSaved) do
			if (map) then
			
				local currentMap = {}
				
				for key, value in pairs(map) do
					if (key == "mapname") then
						currentMap.map = value
					end
					
					if (key == "player") then
						currentMap.player = value
					end
					
					if (key == "vote") then
						currentMap.value = value
					end
				end
				
				if (currentMap.map) and (currentMap.player) and (currentMap.value) then
					table.insert(self.mapVotes, currentMap)
				end
			end
		end
	end
end


function DataManagerS:onMapStarted(mapName)
	if (mapName) then
		self:createMapStatsInstance(mapName)
	end
end


function DataManagerS:createMapStatsInstance(mapName)
	if (mapName) then
		if (not self.mapStats[mapName]) then
			local mapStatsSaved = self.mySQLHandler:getMapStats(mapName)
			
			self.mapStats[mapName] = {}
			
			if (mapStatsSaved) then
				if (#mapStatsSaved > 0) then
					for index, value in pairs(mapStatsSaved) do
						if (value) then
							for index2, value2 in pairs(value) do
								self.mapStats[mapName][index2] = value2
							end
						end
					end
				else
					self.mapStats[mapName].played = 0
					self.mapStats[mapName].laprecordtime1 = 0
					self.mapStats[mapName].laprecordtime2 = 0
					self.mapStats[mapName].laprecordtime3 = 0
					self.mapStats[mapName].laprecordtime4 = 0
					self.mapStats[mapName].laprecordtime5 = 0
					self.mapStats[mapName].laprecordtime6 = 0
					self.mapStats[mapName].laprecordtime7 = 0
					self.mapStats[mapName].laprecordtime8 = 0
					self.mapStats[mapName].laprecordtime9 = 0
					self.mapStats[mapName].laprecordtime10 = 0
					self.mapStats[mapName].laprecordname1 = "-"
					self.mapStats[mapName].laprecordname2 = "-"
					self.mapStats[mapName].laprecordname3 = "-"
					self.mapStats[mapName].laprecordname4 = "-"
					self.mapStats[mapName].laprecordname5 = "-"
					self.mapStats[mapName].laprecordname6 = "-"
					self.mapStats[mapName].laprecordname7 = "-"
					self.mapStats[mapName].laprecordname8 = "-"
					self.mapStats[mapName].laprecordname9 = "-"
					self.mapStats[mapName].laprecordname10 = "-"
				end
			else
				self.mapStats[mapName].played = 0
				self.mapStats[mapName].laprecordtime1 = 0
				self.mapStats[mapName].laprecordtime2 = 0
				self.mapStats[mapName].laprecordtime3 = 0
				self.mapStats[mapName].laprecordtime4 = 0
				self.mapStats[mapName].laprecordtime5 = 0
				self.mapStats[mapName].laprecordtime6 = 0
				self.mapStats[mapName].laprecordtime7 = 0
				self.mapStats[mapName].laprecordtime8 = 0
				self.mapStats[mapName].laprecordtime9 = 0
				self.mapStats[mapName].laprecordtime10 = 0
				self.mapStats[mapName].laprecordname1 = "-"
				self.mapStats[mapName].laprecordname2 = "-"
				self.mapStats[mapName].laprecordname3 = "-"
				self.mapStats[mapName].laprecordname4 = "-"
				self.mapStats[mapName].laprecordname5 = "-"
				self.mapStats[mapName].laprecordname6 = "-"
				self.mapStats[mapName].laprecordname7 = "-"
				self.mapStats[mapName].laprecordname8 = "-"
				self.mapStats[mapName].laprecordname9 = "-"
				self.mapStats[mapName].laprecordname10 = "-"
			end
			
			self.mapStats[mapName].played = self.mapStats[mapName].played + 1
		else
			self.mapStats[mapName].played = self.mapStats[mapName].played + 1
		end
	end
end


function DataManagerS:calculateMapVotes()

	local tmpMaps = {}
	
	for index, mapVotes in pairs(self.mapVotes) do
		if (mapVotes) then
			if (mapVotes.map) and (mapVotes.player) and (mapVotes.value) then
				if (not tmpMaps[mapVotes.map]) then
					tmpMaps[mapVotes.map] = {}
					table.insert(tmpMaps[mapVotes.map], mapVotes.value)
				else
					table.insert(tmpMaps[mapVotes.map], mapVotes.value)
				end
			end
		end
	end
	
	local votes = {}
	
	for index, map in pairs(tmpMaps) do
		if (map) then
			local voteValues = 0
			local count = 0
			
			for _, vote in pairs(map) do
				if (vote) then
					voteValues = voteValues + vote
					count = count + 1
				end
			end
			
			local finalVote = voteValues / count
			
			votes[index] = finalVote
		end
	end
	
	self.serverStats.votes = votes
end


function DataManagerS:triggerServerData()
	self.serverStats.hasMySQLConnection = self.hasMySQLConnection
	self.serverStats.gameState = self.gameState
	self.serverStats.isInternalMapManager = self.isInternalMapManager
	self.serverStats.isExternalMapManager = self.isExternalMapManager
	self.serverStats.mapList = self.mapList
	self.serverStats.mapCount = self.mapCount
	self.serverStats.isMapLoader = self.isMapLoader
	self.serverStats.currentMapName = self.currentMapName
	self.serverStats.previousMapName = self.previousMapName
	self.serverStats.nextMapName = self.nextMapName
	
	self.serverStats.mapStats = self.mapStats

	self.serverStats.playerCount = #getElementsByType("player")
	self.serverStats.vehicleCount = #getElementsByType("vehicle")
	self.serverStats.objectCount = #getElementsByType("object")
	self.serverStats.colCount = #getElementsByType("colshape")
	self.serverStats.soundCount = #getElementsByType("sound")
	self.serverStats.effectCount = #getElementsByType("effect")
	self.serverStats.timerCount = #getTimers()
	self.serverStats.playerSpawnCount = #getElementsByType("spawnpoint")
	self.serverStats.respawnCount = #getElementsByType("respawnpoint")
	self.serverStats.respawnAreasCount = #getElementsByType("respawnArea")
	self.serverStats.itemSpawnCount = #getElementsByType("itemspawnpoint")
	self.serverStats.coinSpawnCount = #getElementsByType("coinspawnpoint")
	self.serverStats.checkpointCount = #getElementsByType("checkpoint")
	self.serverStats.finishCount = #getElementsByType("finish")
	self.serverStats.boostfieldCount = #getElementsByType("boostfield")

	
	triggerClientEvent("MKRECEIVESERVERSTATS", root, self.serverStats)
end


function DataManagerS:clear()
	removeEventHandler("MKUPDATEGAMESTATE", root, self.m_UpdateGameState)
	removeEventHandler("MKONMAPSTARTED", root, self.m_OnMapStarted)
	removeEventHandler("MKONMAPVOTED", root, self.m_VoteMap)
	
	self:saveMySQLData()
	
	if (self.mySQLHandler) then
		delete(self.mySQLHandler)
		self.mySQLHandler = nil
	end
end


function DataManagerS:destructor()
	self:clear()

	mainOutput("DataManagerS was deleted.")
end
