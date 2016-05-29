--[[
	Filename: MapManagerS.lua
	Authors: Sam@ke
--]]

MapManagerS = {}


function MapManagerS:constructor(parent)
	mainOutput("MapManagerS was loaded.")

	self.mainClass = parent
	self.mapManagerExt = exports.mapmanager
	self.mapLoader = self.mainClass.mapLoader
	
	if (self.mapManagerExt) then
		self.mapManagerExt:stopGamemodeMap()
	end
	
	self.compatibleMaps = {}
	self.compatibleMapsList = {}
	self.playedMaps = {}
	
	self.currentMap = nil
	self.previousMap = nil
	self.nextMap = nil
	
	self:init()
end


function MapManagerS:init()
	self:loadAllMaps()
	
	self.m_OnGamemodeMapStart = bind(self.onGamemodeMapStart, self)
	addEvent("onGamemodeMapStart", true)
	addEventHandler("onGamemodeMapStart", root, self.m_OnGamemodeMapStart)
end



function MapManagerS:updateFast()

end


function MapManagerS:updateSlow()
	--self.mapManagerExt:stopGamemodeMap()
end


function MapManagerS:onGamemodeMapStart(map)
	if (map) then
		
		triggerClientEvent("MKRESETMAP", root)
		
		self.previousMap = self.currentMap
		self.currentMap = map

		
		if (self.mapClass) then
			delete(self.mapClass)
			self.mapClass = nil
		end
		
		self.mapClass = new(MapS, self, self.currentMap)
	end
end


function MapManagerS:loadAllMaps()
	local allMaps = getResources()
	
	self.compatibleMapsList = {}

	for index, resource in pairs(allMaps) do
		if (resource) then
			if (resource:getInfo("type") =="map" and resource:getInfo("gamemodes") =="MarioKart") then
				if (not self.compatibleMaps[resource:getName()]) then
					self.compatibleMaps[resource:getName()] = {}
					self.compatibleMaps[resource:getName()].resource = resource
					self.compatibleMaps[resource:getName()].wasPlayedInThisRotation = "false"
					
					table.insert(self.compatibleMapsList, resource:getName())
				end
			end
		end
	end
end


function MapManagerS:getRandomMap()
	local mapCount = math.random(1, self:getMapCount())
	local current = 0
	
	for index, map in pairs(self.compatibleMaps) do
		if (map.resource) then
			current = current + 1
			if (current == mapCount) then
				return map.resource
			end
		end
	end
end


function MapManagerS:getMapCount()
	local maps = 0
	
	for index, map in pairs(self.compatibleMaps) do
		if (map.resource) then
			maps = maps + 1
		end
	end
	
	return maps
end


function MapManagerS:getCompatibleMaps()
	return self.compatibleMapsList
end


function MapManagerS:getCurrentMapName()
	if (self.currentMap) then
		return self.currentMap:getName()
	end
	
	return nil
end


function MapManagerS:getPreviousMapName()
	if (self.previousMap) then
		return self.previousMap:getName()
	end
	
	return nil
end


function MapManagerS:getNextMapName()
	if (self.nextMap) then
		return self.nextMap:getName()
	end
	
	return nil
end


function MapManagerS:clear()
	removeEventHandler("onGamemodeMapStart", root, self.m_OnGamemodeMapStart)

	if (self.mapClass) then
		delete(self.mapClass)
		self.mapClass = nil
	end
end


function MapManagerS:destructor()
	self:clear()
	
	mainOutput("MapManagerS was deleted.")
end
