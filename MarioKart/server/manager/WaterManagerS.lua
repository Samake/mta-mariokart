--[[
	Filename: WaterManagerS.lua
	Authors: Sam@ke
--]]

WaterManagerS = {}


function WaterManagerS:constructor(parent)
	mainOutput("WaterManagerS was loaded.")

	self.mainClass = parent

	self.minWaterLevel = 595
	self.maxWaterLevel = 598
	self.currentWaterLevel = 596
	self.flowSpeed = 0.05
	
	self.growDirection = "up"
	
	self:init()
end

function WaterManagerS:init()
	self.m_RequestWaterLevel = bind(self.requestWaterLevel, self)
	addEvent("MKREQUESTWATERLEVEL", true)
	addEventHandler("MKREQUESTWATERLEVEL", root, self.m_RequestWaterLevel)
end


function WaterManagerS:requestWaterLevel()
	if (client) then
		triggerClientEvent(client, "MKRECEIVEWATERLEVEL", client, self.currentWaterLevel)
	end
end


function WaterManagerS:updateFast()
	if (self.growDirection == "up") then
		if (self.currentWaterLevel < self.maxWaterLevel) then
			self.currentWaterLevel = self.currentWaterLevel + self.flowSpeed
		else
			self.growDirection = "down"
		end
	end
	
	if (self.growDirection == "down") then
		if (self.currentWaterLevel > self.minWaterLevel) then
			self.currentWaterLevel = self.currentWaterLevel - self.flowSpeed
		else
			self.growDirection = "up"
		end
	end
	
	triggerClientEvent("MKCHANGEWATERLEVEL", root, self.currentWaterLevel)
end


function WaterManagerS:clear()
	removeEventHandler("MKREQUESTWATERLEVEL", root, self.m_RequestWaterLevel)
	resetWaterLevel()
end


function WaterManagerS:destructor()
	
	self:clear()

	mainOutput("WaterManagerS was deleted.")
end
