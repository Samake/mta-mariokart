--[[
	Filename: ItemBlockManagerS.lua
	Authors: Sam@ke
--]]

ItemBlockManagerS = {}


function ItemBlockManagerS:constructor(parent)
	mainOutput("ItemBlockManagerS was loaded.")

	self.mainClass = parent
	self.itemBlocks = {}
	
	self:init()
end


function ItemBlockManagerS:init()
	self.m_OnGamemodeMapStart = bind(self.onGamemodeMapStart, self)

	addEvent("onGamemodeMapStart", true)
	addEventHandler("onGamemodeMapStart", root, self.m_OnGamemodeMapStart)
end


function ItemBlockManagerS:onGamemodeMapStart(map)
	if (map) then
		self:resetMap()
		
		for index, itemBlockSpawn in pairs(getElementsByType("itemspawnpoint")) do
			if (itemBlockSpawn) then
				local itemBlockProperties = {}
				
				itemBlockProperties.id = self:getFreeBlockID()
				itemBlockProperties.x = tonumber(itemBlockSpawn:getData("posX")) or 0
				itemBlockProperties.y = tonumber(itemBlockSpawn:getData("posY")) or 0
				itemBlockProperties.z = tonumber(itemBlockSpawn:getData("posZ")) or 0
				itemBlockProperties.moveOnXAxis = tonumber(itemBlockSpawn:getData("moveOnXAxis")) or 0
				itemBlockProperties.moveOnYAxis = tonumber(itemBlockSpawn:getData("moveOnYAxis")) or 0
				itemBlockProperties.moveOnZAxis = tonumber(itemBlockSpawn:getData("moveOnZAxis")) or 0
				itemBlockProperties.itemID = 2215
				itemBlockProperties.itemInnerID = 2217
				itemBlockProperties.rx = 45
				itemBlockProperties.ry = 45
				itemBlockProperties.rz = 0
				itemBlockProperties.itemModelSize = 0.75
				itemBlockProperties.heightModifier = 1.5
				itemBlockProperties.lodDistance = 300
				itemBlockProperties.rotationSpeed = math.random(50,100) / 60
				itemBlockProperties.moveSpeed = math.random(5, 15) / 10
				itemBlockProperties.collisionShapeRadius = 2
				itemBlockProperties.updateCoordsEventName = "MKUPDATEITEMBLOCKCOORDS" .. itemBlockProperties.id
				itemBlockProperties.onItemPickedEventName = "MKONITEMPICKED" .. itemBlockProperties.id
				itemBlockProperties.enableItemBlockEventName = "MKENABLEITEMBLOCK" .. itemBlockProperties.id
				itemBlockProperties.disableItemBlockEventName = "MKDISABLEITEMBLOCK" .. itemBlockProperties.id
				
				--if (itemBlockProperties.id < 2) then
				if (not self.itemBlocks[itemBlockProperties.id]) then
					self.itemBlocks[itemBlockProperties.id] = new(ItemBlockS, self, itemBlockProperties)
				end
				--end
			end
		end
	end
end


function ItemBlockManagerS:updateFast()
	for index, blockClass in pairs(self.itemBlocks) do
		if (blockClass) then
			blockClass:updateFast()
		end
	end
end


function ItemBlockManagerS:updateSlow()
	for index, blockClass in pairs(self.itemBlocks) do
		if (blockClass) then
			blockClass:updateSlow()
		end
	end
end


function ItemBlockManagerS:resetMap()
	for index, blockClass in pairs(self.itemBlocks) do
		if (blockClass) then
			delete(blockClass)
			blockClass = nil
		end
	end
end


function ItemBlockManagerS:getFreeBlockID()
	for index, blockClass in pairs(self.itemBlocks) do
		if (not blockClass) then
				return index
		end
	end
	
	return #self.itemBlocks + 1
end


function ItemBlockManagerS:clear()
	removeEventHandler("onGamemodeMapStart", root, self.m_OnGamemodeMapStart)
	
	self:resetMap()
end


function ItemBlockManagerS:destructor()
	self:clear()

	mainOutput("ItemBlockManagerS was deleted.")
end
