--[[
	Filename: MapS.lua
	Author: Sam@ke
--]]

MapS = {}

function MapS:constructor(parent, map)

	self.mapManager = parent
	self.map = map
	self.mapName = self.map:getName()
	
	self.spawnPoints = {}
	self.respawnPoints = {}
	self.itemsSpawnPoints = {}
	self.coinSpawnPoints = {}
	self.checkPoints = {}
	self.startFinish = {}
	self.boostFields = {}
	self.respawnAreas = {}
	
	self.spawnPointID = 0
	self.respawnPointID = 0
	self.itemsSpawnPointID = 0
	self.coinSpawnPointID = 0
	self.checkPointID = 0
	self.finishID = 0
	self.boostFieldID = 0
	self.respawnAreaID = 0
	
	self:buildMap()
	
	triggerEvent("MKONMAPSTARTED", root, self.mapName)

	mainOutput("MapS " .. self.mapName .. " was loaded.")
end


function MapS:buildMap()
	local testX, testY, testZ
	
	for index, spawnpoint in ipairs(getElementsByType("spawnpoint"), self.map) do
		if (spawnpoint) then
			self.spawnPointID = self.spawnPointID + 1
			
			local posX = spawnpoint:getData("posX") 
			local posY = spawnpoint:getData("posY") 
			local posZ = spawnpoint:getData("posZ") 
			local rotX = spawnpoint:getData("rotX") 
			local rotY = spawnpoint:getData("rotY")
			local rotZ = spawnpoint:getData("rotZ")
			local vehicleID = spawnpoint:getData("vehicle")
			
			self.spawnPoints[self.spawnPointID] = {
				id = self.spawnPointID,
				state = "true",
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ),
				rotX = tonumber(rotX), 
				rotY = tonumber(rotY),
				rotZ = tonumber(rotZ),
				vehicleID = tonumber(vehicleID)
			}
			
			testX, testY, testZ = tonumber(posX), tonumber(posY), tonumber(posZ)
		end
	end
	
	triggerEvent("MKSPAWNPLAYERS", root, testX, testY, testZ)
	
	for index, respawnpoint in ipairs(getElementsByType("respawnpoint"), self.map) do
		if (respawnpoint) then
			self.respawnPointID = self.respawnPointID + 1
			
			local posX = respawnpoint:getData("posX") 
			local posY = respawnpoint:getData("posY") 
			local posZ = respawnpoint:getData("posZ")
			local rotX = respawnpoint:getData("rotX") 
			local rotY = respawnpoint:getData("rotY")
			local rotZ = respawnpoint:getData("rotZ")
			
			self.respawnPoints[self.respawnPointID] = {
				id = self.respawnPointID,
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ),
				rotX = tonumber(rotX), 
				rotY = tonumber(rotY),
				rotZ = tonumber(rotZ)
			}
		end
	end
	
	for index, itemspawnpoint in ipairs(getElementsByType("itemspawnpoint"), self.map) do
		if (itemspawnpoint) then
			self.itemsSpawnPointID = self.itemsSpawnPointID + 1
			
			local posX = itemspawnpoint:getData("posX") 
			local posY = itemspawnpoint:getData("posY") 
			local posZ = itemspawnpoint:getData("posZ")
			local moveOnXAxis = itemspawnpoint:getData("moveOnXAxis") 
			local moveOnYAxis = itemspawnpoint:getData("moveOnYAxis") 
			local moveOnZAxis = itemspawnpoint:getData("moveOnZAxis") 
			
			self.itemsSpawnPoints[self.itemsSpawnPointID] = {
				id = self.itemsSpawnPointID,
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ),
				moveOnXAxis = tonumber(moveOnXAxis), 
				moveOnYAxis = tonumber(moveOnYAxis), 
				moveOnZAxis = tonumber(moveOnZAxis)
			}
		end
	end
	
	for index, coinspawnpoint in ipairs(getElementsByType("coinspawnpoint"), self.map) do
		if (coinspawnpoint) then
			self.coinSpawnPointID = self.coinSpawnPointID + 1
			
			local posX = coinspawnpoint:getData("posX") 
			local posY = coinspawnpoint:getData("posY") 
			local posZ = coinspawnpoint:getData("posZ") 
			
			self.coinSpawnPoints[self.coinSpawnPointID] = {
				id = self.coinSpawnPointID,
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ)
			}
		end
	end
	
	for index, checkpoint in ipairs(getElementsByType("checkpoint"), self.map) do
		if (checkpoint) then
			self.checkPointID = self.checkPointID + 1
			
			local posX = checkpoint:getData("posX") 
			local posY = checkpoint:getData("posY") 
			local posZ = checkpoint:getData("posZ") 
			
			self.checkPoints[self.checkPointID] = {
				id = self.checkPointID,
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ)
			}
		end
	end
	
	for index, finish in ipairs(getElementsByType("finish"), self.map) do
		if (finish) then
			self.finishID = self.finishID + 1
			
			local posX = finish:getData("posX") 
			local posY = finish:getData("posY") 
			local posZ = finish:getData("posZ") 
			
			self.startFinish = {
				id = self.finishID,
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ)
			}
		end
	end
	
	for index, boostField in ipairs(getElementsByType("boostfield"), self.map) do
		if (boostField) then
			self.boostFieldID = self.boostFieldID + 1
			
			local posX = boostField:getData("posX") 
			local posY = boostField:getData("posY") 
			local posZ = boostField:getData("posZ") 
			
			self.boostFields[self.boostFieldID] = {
				id = self.boostFieldID,
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ)
			}
		end
	end
	
	for index, respawnArea in ipairs(getElementsByType("respawnArea"), self.map) do
		if (respawnArea) then
			self.respawnAreaID = self.respawnAreaID + 1
			
			local posX = respawnArea:getData("posX") 
			local posY = respawnArea:getData("posY") 
			local posZ = respawnArea:getData("posZ") 
			
			self.respawnAreas[self.respawnAreaID] = {
				id = self.respawnAreaID,
				posX = tonumber(posX), 
				posY = tonumber(posY), 
				posZ = tonumber(posZ)
			}
		end
	end
end


function MapS:updateFast()

end


function MapS:updateSlow()

end


function MapS:destroyMap()
	self.spawnPoints = {}
	self.respawnPoints = {}
	self.itemsSpawnPoints = {}
	self.coinSpawnPoints = {}
	self.checkPoints = {}
	self.startFinish = {}
	self.boostFields = {}
	self.respawnAreas = {}
	
	self.spawnPointID = 0
	self.respawnPointID = 0
	self.itemsSpawnPointID = 0
	self.coinSpawnPointID = 0
	self.checkPointID = 0
	self.finishID = 0
	self.boostFieldID = 0
	self.respawnAreaID = 0
end


function MapS:destructor()
	self:destroyMap()
	
	mainOutput("MapS " .. self.mapName .. " was stopped.")
end
