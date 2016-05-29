--[[
	Filename: ItemBlockS.lua
	Authors: Sam@ke
--]]

ItemBlockS = {}


function ItemBlockS:constructor(parent, itemBlockProperties)

	self.itemBlockManager = parent
	
	self.id = itemBlockProperties.id
	self.x = itemBlockProperties.x
	self.y = itemBlockProperties.y
	self.z = itemBlockProperties.z
	self.moveX = itemBlockProperties.x
	self.moveY = itemBlockProperties.y
	self.moveZ = itemBlockProperties.z
	self.moveOnXAxis = itemBlockProperties.moveOnXAxis
	self.moveOnYAxis = itemBlockProperties.moveOnYAxis
	self.moveOnZAxis = itemBlockProperties.moveOnZAxis
	self.moveSpeed = itemBlockProperties.moveSpeed
	self.moveDirectionX = "forward"
	self.moveDirectionY = "forward"
	self.moveDirectionZ = "forward"
	self.updateCoordsEventName = itemBlockProperties.updateCoordsEventName
	self.onItemPickedEventName = itemBlockProperties.onItemPickedEventName
	self.enableItemBlockEventName = itemBlockProperties.enableItemBlockEventName
	self.disableItemBlockEventName = itemBlockProperties.disableItemBlockEventName
	
	self.isPicked = "false"
	
	local respawnTime = getItemPickupRespawnTime()
	self.lifeTime = math.random(respawnTime - 2000, respawnTime + 2000)
	
	self:init()
	
	triggerClientEvent("MKADDITEMBLOCK", root, itemBlockProperties)
	
	--mainOutput("ItemBlockS was loaded. ID: " .. self.id)
end


function ItemBlockS:init()

	self.m_OnItemPicked = bind(self.onItemPicked, self)
	addEvent(self.onItemPickedEventName, true)
	addEventHandler(self.onItemPickedEventName, root, self.m_OnItemPicked)
	
end


function ItemBlockS:updateFast()
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
			self:respawnItemBlock()
		end
	end
end


function ItemBlockS:updateSlow()

end


function ItemBlockS:onItemPicked()
	if (self.isPicked == "false") and (isElement(client)) then
		self.isPicked = "true"
		self.isPickedTime = getTickCount()
		
		triggerClientEvent(self.disableItemBlockEventName, root)
	end
end


function ItemBlockS:respawnItemBlock()
	if (self.isPicked == "true") then
		triggerClientEvent(self.enableItemBlockEventName, root)
		self.isPicked = "false"
	end
end


function ItemBlockS:destructor()
	removeEventHandler(self.onItemPickedEventName, root, self.m_OnItemPicked)

	--mainOutput("ItemBlockS was deleted. ID: " .. self.id)
end
