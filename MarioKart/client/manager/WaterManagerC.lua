--[[
	Filename: WaterManagerC.lua
	Authors: Sam@ke
--]]

WaterManagerC = {}


function WaterManagerC:constructor(parent)
	mainOutput("WaterManagerC was loaded.")

	self.mainClass = parent

	self.waterSizeVal = 2998
	self.waterSouthWestX = -self.waterSizeVal
	self.waterSouthWestY = -self.waterSizeVal
	self.waterSouthEastX = self.waterSizeVal
	self.waterSouthEastY = -self.waterSizeVal
	self.waterNorthWestX = -self.waterSizeVal
	self.waterNorthWestY = self.waterSizeVal
	self.waterNorthEastX = self.waterSizeVal
	self.waterNorthEastY = self.waterSizeVal
	
	self.currentWaterLevel = 0
	self.newWaterLevel = self.currentWaterLevel
	
	self.flowSpeed = 0.05

	self:init()
end


function WaterManagerC:init()
	triggerServerEvent("MKREQUESTWATERLEVEL", root)
	
	self.m_ReceiveWaterLevel = bind(self.receiveWaterLevel, self)
	addEvent("MKRECEIVEWATERLEVEL", true)
	addEventHandler("MKRECEIVEWATERLEVEL", root, self.m_ReceiveWaterLevel)
	
	self.m_UpdateWaterLevel = bind(self.updateWaterLevel, self)
	addEvent("MKCHANGEWATERLEVEL", true)
	addEventHandler("MKCHANGEWATERLEVEL", root, self.m_UpdateWaterLevel)
	
	setWaterDrawnLast(true)
end


function WaterManagerC:receiveWaterLevel(waterLevel)
	if (waterLevel) then
		self.currentWaterLevel = waterLevel
		
		if (not self.water) then
			self.water = createWater(self.waterSouthWestX, self.waterSouthWestY, self.currentWaterLevel, self.waterSouthEastX, self.waterSouthEastY, self.currentWaterLevel, self.waterNorthWestX, self.waterNorthWestY, self.currentWaterLevel, self.waterNorthEastX, self.waterNorthEastY, self.currentWaterLevel)
		end
	
	end
end


function WaterManagerC:update(delta)
	if (self.water) and (delta) then
		self:interPolateMe(delta)
	end
end


function WaterManagerC:interPolateMe(delta)

	self.growSpeed  = (self.flowSpeed / 30) * delta

	if (self.currentWaterLevel < self.newWaterLevel) then
		self.currentWaterLevel = self.currentWaterLevel + self.growSpeed 
	end
	
	if (self.currentWaterLevel > self.newWaterLevel) then
		self.currentWaterLevel = self.currentWaterLevel - self.growSpeed 
	end
	
	setWaterLevel(self.water, self.currentWaterLevel)
end


function WaterManagerC:updateWaterLevel(waterLevel)
	if (waterLevel) then
		self.newWaterLevel = waterLevel
	end
end


function WaterManagerC:clear()
	removeEventHandler("MKCHANGEWATERLEVEL", root, self.m_UpdateWaterLevel)
	removeEventHandler("MKRECEIVEWATERLEVEL", root, self.m_ReceiveWaterLevel)
	
	if (self.water) then
		self.water:destroy()
		self.water = nil
	end
end


function WaterManagerC:destructor()
	self:clear()

	mainOutput("WaterManagerC was deleted.")
end
