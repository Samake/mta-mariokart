--[[
	Filename: CoinManagerC.lua
	Authors: Sam@ke
--]]

CoinManagerC = {}


function CoinManagerC:constructor(parent)
	mainOutput("CoinManagerC was loaded.")

	self.mainClass = parent
	
	self.coins = {}
	
	self:init()
end


function CoinManagerC:init()
	self.m_AddCoin = bind(self.addCoin, self)
	addEvent("MKADDCOIN", true)
	addEventHandler("MKADDCOIN", root, self.m_AddCoin)
	
	self.m_ResetMap = bind(self.resetMap, self)
	addEvent("MKRESETMAP", true)
	addEventHandler("MKRESETMAP", root, self.m_ResetMap)
end


function CoinManagerC:addCoin(coinProperties)
	if (coinProperties) then
		if (not self.coins[coinProperties.id]) then
			self.coins[coinProperties.id] = new(CoinC, self, coinProperties)
		end
	end
end


function CoinManagerC:update(delta)
	for index, coinClass in pairs(self.coins) do
		if (coinClass) then
			coinClass:update(delta)
		end
	end
end


function CoinManagerC:resetMap()
	for index, coinClass in pairs(self.coins) do
		if (coinClass) then
			delete(coinClass)
			coinClass = nil
		end
	end
end


function CoinManagerC:clear()
	self:resetMap()
	
	removeEventHandler("MKADDCOIN", root, self.m_AddCoin)
	removeEventHandler("MKRESETMAP", root, self.m_ResetMap)
end


function CoinManagerC:destructor()
	self:clear()

	mainOutput("CoinManagerC was deleted.")
end
