--[[
	Filename: ItemBlockManagerC.lua
	Authors: Sam@ke
--]]

ItemBlockManagerC = {}


function ItemBlockManagerC:constructor(parent)
	mainOutput("ItemBlockManagerC was loaded.")

	self.mainClass = parent
	
	self.itemBlocks = {}
	
	self:init()
end


function ItemBlockManagerC:init()
	self.m_AddItemBlock = bind(self.addItemBlock, self)
	addEvent("MKADDITEMBLOCK", true)
	addEventHandler("MKADDITEMBLOCK", root, self.m_AddItemBlock)
	
	self.m_ResetMap = bind(self.resetMap, self)
	addEvent("MKRESETMAP", true)
	addEventHandler("MKRESETMAP", root, self.m_ResetMap)
end


function ItemBlockManagerC:addItemBlock(itemBlockProperties)
	if (itemBlockProperties) then
		if (not self.itemBlocks[itemBlockProperties.id]) then
			self.itemBlocks[itemBlockProperties.id] = new(ItemBlockC, self, itemBlockProperties)
		end
	end
end


function ItemBlockManagerC:update(delta)
	for index, blockClass in pairs(self.itemBlocks) do
		if (blockClass) then
			blockClass:update(delta)
		end
	end
end


function ItemBlockManagerC:resetMap()
	for index, blockClass in pairs(self.itemBlocks) do
		if (blockClass) then
			delete(blockClass)
			blockClass = nil
		end
	end
end


function ItemBlockManagerC:clear()
	self:resetMap()
	
	removeEventHandler("MKADDITEMBLOCK", root, self.m_AddItemBlock)
	removeEventHandler("MKRESETMAP", root, self.m_ResetMap)
end


function ItemBlockManagerC:destructor()
	self:clear()

	mainOutput("ItemBlockManagerC was deleted.")
end
