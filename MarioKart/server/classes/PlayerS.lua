--[[
	Filename: PlayerS.lua
	Authors: Sam@ke
--]]

PlayerS = {}


function PlayerS:constructor(parent, playerStats)

	self.playerManager = parent
	self.id = playerStats.id
	self.player = playerStats.player
	self.name = playerStats.name
	self.modelID = playerStats.modelID 
	self.vehicleID = playerStats.vehicleID
	self.coins = playerStats.coins 
	self.xp = playerStats.xp
	self.level = playerStats.level
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	self.m_SpawnPlayer = bind(self.spawnPlayer, self)
	addEvent("MKSPAWNPLAYERS", true)
	addEventHandler("MKSPAWNPLAYERS", root, self.m_SpawnPlayer)
	
	mainOutput("SERVER || PlayerS was loaded! || ID: " .. self.id .. ", Name: " .. self.name)
end


function PlayerS:spawnPlayer(x, y, z)
	if (self.player) then
		self.x = x
		self.y = y
		self.z = z
		
		self.player:fadeCamera(true, 2.0, 0, 0, 25)
		self.player:spawn(self.x, self.y, self.z, 0, self.modelID)
		self.player:setCameraTarget(player)
		
		if (not self.vehicle) then
			local vehicleStats = {}
			vehicleStats.id = self.id
			vehicleStats.vehicleID = self.vehicleID
			vehicleStats.player = self.player
			vehicleStats.x = self.x
			vehicleStats.y = self.y
			vehicleStats.z = self.z
			vehicleStats.rx = self.rx
			vehicleStats.rx = self.rz
			vehicleStats.rz = self.rx
			
			self.vehicle = new(VehicleS, self, vehicleStats)
		end
	end
end


function PlayerS:updateFast()
	if (self.vehicle) then
		self.vehicle:updateFast()
	end
end


function PlayerS:updateSlow()
	if (self.vehicle) then
		self.vehicle:updateSlow()
	end
end


function PlayerS:clear()
	removeEventHandler("MKSPAWNPLAYERS", root, self.m_SpawnPlayer)
	
	if (self.vehicle) then
		delete(self.vehicle)
		self.vehicle = nil
	end
end


function PlayerS:destructor()
	self:clear()
	
	mainOutput("SERVER || PlayerS was stopped! || ID: " .. self.id .. ", Name: " .. self.name)
end