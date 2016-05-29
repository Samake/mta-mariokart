--[[
	Filename: CoinS.lua
	Authors: Sam@ke
--]]

CoinS = {}


function CoinS:constructor(parent, coinProperties)

	self.itemBlockManager = parent
	
	self.id = coinProperties.id
	self.value = coinProperties.value
	self.x = coinProperties.x
	self.y = coinProperties.y
	self.z = coinProperties.z
	self.moveX = coinProperties.x
	self.moveY = coinProperties.y
	self.moveZ = coinProperties.z
	self.moveOnXAxis = coinProperties.moveOnXAxis
	self.moveOnYAxis = coinProperties.moveOnYAxis
	self.moveOnZAxis = coinProperties.moveOnZAxis
	self.moveSpeed = coinProperties.moveSpeed
	self.moveDirectionX = "forward"
	self.moveDirectionY = "forward"
	self.moveDirectionZ = "forward"
	self.updateCoordsEventName = coinProperties.updateCoordsEventName
	self.onCoinPickedEventName = coinProperties.onCoinPickedEventName
	self.enableCoinEventName = coinProperties.enableCoinEventName
	self.disableCoinEventName = coinProperties.disableCoinEventName
	
	self.isPicked = "false"
	
	local respawnTime = getItemPickupRespawnTime()
	self.lifeTime = math.random(respawnTime - 2000, respawnTime + 2000)
	
	self:init()
	
	triggerClientEvent("MKADDCOIN", root, coinProperties)
	
	--mainOutput("CoinS was loaded. ID: " .. self.id)
end


function CoinS:init()

	self.m_OnCoinPicked = bind(self.onCoinPicked, self)
	addEvent(self.onCoinPickedEventName, true)
	addEventHandler(self.onCoinPickedEventName, root, self.m_OnCoinPicked)
	
end


function CoinS:updateFast()
	if (self.isPicked == "false") then
		if (self.moveOnXAxis > 0) or (self.moveOnYAxis > 0) or (self.moveOnZAxis > 0) then
		
			if (self.moveDirectionX == "forward") then
				if (self.moveX < self.x + self.moveOnXAxis) then
					self.moveX = self.moveX + self.moveSpeed
				else
					self.moveDirectionX = "backward"
				end
			elseif (self.moveDirectionX == "backward") then
				if (self.moveX > self.x - self.moveOnXAxis) then
					self.moveX = self.moveX - self.moveSpeed
				else
					self.moveDirectionX = "forward"
				end
			end
			
			if (self.moveDirectionY == "forward") then
				if (self.moveY < self.y + self.moveOnYAxis) then
					self.moveY = self.moveY + self.moveSpeed
				else
					self.moveDirectionY = "backward"
				end
			elseif (self.moveDirectionY == "backward") then
				if (self.moveY > self.y - self.moveOnYAxis) then
					self.moveY = self.moveY - self.moveSpeed
				else
					self.moveDirectionY = "forward"
				end
			end
			
			if (self.moveDirectionZ == "forward") then
				if (self.moveZ < self.z + self.moveOnZAxis) then
					self.moveZ = self.moveZ + self.moveSpeed
				else
					self.moveDirectionZ = "backward"
				end
			elseif (self.moveDirectionZ == "backward") then
				if (self.moveZ > self.z - self.moveOnZAxis) then
					self.moveZ = self.moveZ - self.moveSpeed
				else
					self.moveDirectionZ = "forward"
				end
			end
			
			triggerClientEvent(self.updateCoordsEventName, root, {x = self.moveX, y = self.moveY, z = self.moveZ})
		end
	else
		self.currentTime = getTickCount()
		
		if (self.currentTime > self.isPickedTime + self.lifeTime) then
			self:respawnCoin()
		end
	end
end


function CoinS:updateSlow()

end


function CoinS:onCoinPicked()
	if (self.isPicked == "false") and (isElement(client)) then
		self.isPicked = "true"
		self.isPickedTime = getTickCount()
		
		triggerClientEvent(self.disableCoinEventName, root)
	end
end


function CoinS:respawnCoin()
	if (self.isPicked == "true") then
		triggerClientEvent(self.enableCoinEventName, root)
		self.isPicked = "false"
	end
end


function CoinS:destructor()
	removeEventHandler(self.onCoinPickedEventName, root, self.m_OnCoinPicked)

	--mainOutput("CoinS was deleted. ID: " .. self.id)
end
