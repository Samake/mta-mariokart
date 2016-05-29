--[[
	Filename: CoinManagerS.lua
	Authors: Sam@ke
--]]

CoinManagerS = {}


function CoinManagerS:constructor(parent)
	mainOutput("CoinManagerS was loaded.")

	self.mainClass = parent
	self.coins = {}
	
	self:init()
end


function CoinManagerS:init()
	self.m_OnGamemodeMapStart = bind(self.onGamemodeMapStart, self)

	addEvent("onGamemodeMapStart", true)
	addEventHandler("onGamemodeMapStart", root, self.m_OnGamemodeMapStart)
end


function CoinManagerS:onGamemodeMapStart(map)
	if (map) then
		self:resetMap()
		
		for index, coinSpawn in pairs(getElementsByType("coinspawnpoint")) do
			if (coinSpawn) then
				local coinProperties = {}
				
				coinProperties.id = self:getFreeCoinID()
				coinProperties.value = math.random(1, 3)
				coinProperties.x = tonumber(coinSpawn:getData("posX")) or 0
				coinProperties.y = tonumber(coinSpawn:getData("posY")) or 0
				coinProperties.z = tonumber(coinSpawn:getData("posZ")) or 0
				coinProperties.moveOnXAxis = tonumber(coinSpawn:getData("moveOnXAxis")) or 0
				coinProperties.moveOnYAxis = tonumber(coinSpawn:getData("moveOnYAxis")) or 0
				coinProperties.moveOnZAxis = tonumber(coinSpawn:getData("moveOnZAxis")) or 0
				coinProperties.rx = 90
				coinProperties.ry = 0
				coinProperties.rz = 0
				coinProperties.modelID = 2218
				coinProperties.modelSize = 0.3 + (coinProperties.value / 4)
				coinProperties.heightModifier = 0.6 + (coinProperties.modelSize / 2)
				coinProperties.lodDistance = 300
				coinProperties.rotationSpeed = math.random(50, 100) / 25
				coinProperties.moveSpeed = math.random(5, 15) / 10
				coinProperties.collisionShapeRadius = coinProperties.modelSize * 1.7
				coinProperties.updateCoordsEventName = "MKUPDATECOINCOORDS" .. coinProperties.id
				coinProperties.onCoinPickedEventName = "MKONCOINPICKED" .. coinProperties.id
				coinProperties.enableCoinEventName = "MKENABLECOIN" .. coinProperties.id
				coinProperties.disableCoinEventName = "MKDISABLECOIN" .. coinProperties.id
				
				--if (coinProperties.id < 2) then
				if (not self.coins[coinProperties.id]) then
					self.coins[coinProperties.id] = new(CoinS, self, coinProperties)
				end
				--end
			end
		end
	end
end


function CoinManagerS:updateFast()
	for index, coinClass in pairs(self.coins) do
		if (coinClass) then
			coinClass:updateFast()
		end
	end
end


function CoinManagerS:updateSlow()
	for index, coinClass in pairs(self.coins) do
		if (coinClass) then
			coinClass:updateSlow()
		end
	end
end


function CoinManagerS:resetMap()
	for index, coinClass in pairs(self.coins) do
		if (coinClass) then
			delete(coinClass)
			coinClass = nil
		end
	end
end


function CoinManagerS:getFreeCoinID()
	for index, coinClass in pairs(self.coins) do
		if (not coinClass) then
				return index
		end
	end
	
	return #self.coins + 1
end


function CoinManagerS:clear()
	removeEventHandler("onGamemodeMapStart", root, self.m_OnGamemodeMapStart)
	
	self:resetMap()
end


function CoinManagerS:destructor()
	self:clear()

	mainOutput("CoinManagerS was deleted.")
end
