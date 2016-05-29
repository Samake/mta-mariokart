--[[
	Filename: ItemBlockC.lua
	Authors: Sam@ke
--]]

ItemBlockC = {}


function ItemBlockC:constructor(parent, itemBlockProperties)

	self.itemBlockManager = parent
	
	self.id = itemBlockProperties.id
	self.itemID = itemBlockProperties.itemID
	self.itemInnerID = itemBlockProperties.itemInnerID
	self.x = itemBlockProperties.x
	self.y = itemBlockProperties.y
	self.z = itemBlockProperties.z
	self.moveCX = itemBlockProperties.x
	self.moveCY = itemBlockProperties.y
	self.moveCZ = itemBlockProperties.z
	self.moveSX = itemBlockProperties.x
	self.moveSY = itemBlockProperties.y
	self.moveSZ = itemBlockProperties.z
	self.rx = itemBlockProperties.rx
	self.ry = itemBlockProperties.ry
	self.rz = itemBlockProperties.rz
	self.moveOnXAxis = itemBlockProperties.moveOnXAxis
	self.moveOnYAxis = itemBlockProperties.moveOnYAxis
	self.moveOnZAxis = itemBlockProperties.moveOnZAxis
	self.moveSpeedS = itemBlockProperties.moveSpeed
	self.moveSpeedC = itemBlockProperties.moveSpeed
	self.rotationSpeed = itemBlockProperties.rotationSpeed
	self.itemModelSize = itemBlockProperties.itemModelSize
	self.heightModifier = itemBlockProperties.heightModifier
	self.lodDistance = itemBlockProperties.lodDistance
	self.collisionShapeRadius = itemBlockProperties.collisionShapeRadius
	self.updateCoordsEventName = itemBlockProperties.updateCoordsEventName
	self.onItemPickedEventName = itemBlockProperties.onItemPickedEventName
	self.enableItemBlockEventName = itemBlockProperties.enableItemBlockEventName
	self.disableItemBlockEventName = itemBlockProperties.disableItemBlockEventName
	self.player = getLocalPlayer()
	
	--mainOutput("ItemBlockC was loaded. ID: " .. self.id)
	
	self:init()
end


function ItemBlockC:init()
	
	self.m_UpdateCoords = bind(self.updateCoords, self)
	addEvent(self.updateCoordsEventName, true)
	addEventHandler(self.updateCoordsEventName, root, self.m_UpdateCoords)
	
	self.m_EnableItemBlock = bind(self.enableItemBlock, self)
	addEvent(self.enableItemBlockEventName, true)
	addEventHandler(self.enableItemBlockEventName, root, self.m_EnableItemBlock)
	
	self.m_DisableItemBlock = bind(self.disableItemBlock, self)
	addEvent(self.disableItemBlockEventName, true)
	addEventHandler(self.disableItemBlockEventName, root, self.m_DisableItemBlock)
	
	self:enableItemBlock()
end

function ItemBlockC:enableItemBlock()
	self.itemObject = createObject(self.itemID, self.x, self.y, self.z + self.heightModifier, self.rx, self.ry, self.rz)
	self.itemObjectLOD = createObject(self.itemID, self.x, self.y, self.z + self.heightModifier, self.rx, self.ry, self.rz, true)
	self.itemObjectInner = createObject(self.itemInnerID, self.x, self.y, self.z + self.heightModifier, self.rx, self.ry, self.rz)
	self.itemObjectInnerLOD = createObject(self.itemInnerID, self.x, self.y, self.z + self.heightModifier, self.rx, self.ry, self.rz, true)
	self.collisionShape = createColSphere(self.x, self.y, self.z, self.collisionShapeRadius)
	
	self.isLoaded = self.itemObject and self.itemObjectLOD and self.itemObjectInner and self.itemObjectInnerLOD and self.collisionShape
	
	if (self.isLoaded) then
		self.itemObject:setScale(self.itemModelSize)
		self.itemObjectLOD:setScale(self.itemModelSize)
		self.itemObjectInner:setScale(self.itemModelSize)
		self.itemObjectInnerLOD:setScale(self.itemModelSize)
		
		self.itemObject:setCollisionsEnabled(false)
		self.itemObjectInner:setCollisionsEnabled(false)
		
		self.itemObjectLOD:attach(self.itemObject)
		self.itemObjectInner:attach(self.itemObject)
		self.itemObjectInnerLOD:attach(self.itemObject)
		self.collisionShape:attach(self.itemObject)
		
		self.itemObject:setLowLOD(self.itemObjectLOD)
		self.itemObjectInner:setLowLOD(self.itemObjectInnerLOD)
		
		engineSetModelLODDistance(self.itemID, self.lodDistance)
		engineSetModelLODDistance(self.itemInnerID, self.lodDistance)
		
		self.itemObject:setDoubleSided(true)
		self.itemObjectInner:setDoubleSided(true)
		
		self.m_OnItemPicked = bind(self.onItemPicked, self)
		addEventHandler("onClientColShapeHit", self.collisionShape, self.m_OnItemPicked)
	end
end


function ItemBlockC:update(delta)
	if (self.isLoaded) then
		self.rx = self.rx + self.rotationSpeed * delta
		self.ry = self.ry + self.rotationSpeed * delta
		self.rz = self.rz + self.rotationSpeed * delta
	
		if (self.rx > 360) then
			self.rx = 0
		end
		
		if (self.ry > 360) then
			self.ry = 0
		end
		
		if (self.rz > 360) then
			self.rz = 0
		end
		
		self.itemObject:setRotation(self.rx, self.ry, self.rz)
		self.itemObjectLOD:setRotation(self.rx, self.ry, self.rz)
	
		if (self.moveX ~= self.x) or (self.moveY ~= self.y) or (self.moveZ ~= self.z) then
			self:interPolateMe(delta)
		end
	end
end


function ItemBlockC:interPolateMe(delta)

		self.moveSpeedC  = (self.moveSpeedS / 30) * delta

		if (self.moveCX < self.moveSX) then
			self.moveCX = self.moveCX + self.moveSpeedC 
		end
		
		if (self.moveCX > self.moveSX) then
			self.moveCX = self.moveCX - self.moveSpeedC 
		end
		
		if (self.moveCY < self.moveSY) then
			self.moveCY = self.moveCY + self.moveSpeedC 
		end
		
		if (self.moveCY > self.moveSY) then
			self.moveCY= self.moveCY - self.moveSpeedC 
		end
		
		if (self.moveCZ < self.moveSZ) then
			self.moveCZ = self.moveCZ + self.moveSpeedC 
		end
		
		if (self.moveCZ > self.moveSZ) then
			self.moveCZ = self.moveCZ - self.moveSpeedC 
		end
		
		self.itemObject:setPosition(self.moveCX, self.moveCY, self.moveCZ + self.heightModifier)
		self.itemObjectLOD:setPosition(self.moveCX, self.moveCY, self.moveCZ + self.heightModifier)
end


function ItemBlockC:onItemPicked(element)
	if (isElement(element)) then
		if (element:getType() == "player") or (element:getType() == "vehicle") then
			triggerServerEvent(self.onItemPickedEventName, root, self.player)
		end
	end
end


function ItemBlockC:updateCoords(coords)
	if (coords) then
		self.moveSX = coords.x
		self.moveSY = coords.y
		self.moveSZ = coords.z
	end
end


function ItemBlockC:disableItemBlock()

	self.isLoaded = nil
	
	if (self.itemObject) then
		self.itemObject:destroy()
		self.itemObject = nil
	end
	
	if (self.itemObjectLOD) then
		self.itemObjectLOD:destroy()
		self.itemObjectLOD = nil
	end
	
	if (self.itemObjectInner) then
		self.itemObjectInner:destroy()
		self.itemObjectInner = nil
	end
	
	if (self.itemObjectInnerLOD) then
		self.itemObjectInnerLOD:destroy()
		self.itemObjectInnerLOD = nil
	end
	
	if (self.collisionShape) then
		removeEventHandler("onClientColShapeHit", self.collisionShape, self.m_OnItemPicked)
		self.collisionShape:destroy()
		self.collisionShape = nil
	end
	
	local effectProperties = {}
	effectProperties.x = self.moveCX
	effectProperties.y = self.moveCY
	effectProperties.z = self.moveCZ + self.heightModifier
	effectProperties.r = 100
	effectProperties.g = 100
	effectProperties.b = 200
	effectProperties.a = 150
	effectProperties.scale = 0.03
	effectProperties.count = 5
	
	triggerEvent("MKADDGLASSFX", root, effectProperties)
	
	local effectProperties = {}
	effectProperties.x = self.moveCX
	effectProperties.y = self.moveCY
	effectProperties.z = self.moveCZ + self.heightModifier
	effectProperties.r = 200
	effectProperties.g = 100
	effectProperties.b = 100
	effectProperties.a = 150
	effectProperties.scale = 0.05
	effectProperties.count = 5
	
	triggerEvent("MKADDGLASSFX", root, effectProperties)
	
	local effectProperties = {}
	effectProperties.x = self.moveCX
	effectProperties.y = self.moveCY
	effectProperties.z = self.moveCZ + self.heightModifier
	effectProperties.r = 100
	effectProperties.g = 200
	effectProperties.b = 100
	effectProperties.a = 150
	effectProperties.scale = 0.08
	effectProperties.count = 10
	
	triggerEvent("MKADDGLASSFX", root, effectProperties)
	
	local soundProperties = {}
	soundProperties.x = self.moveCX
	soundProperties.y = self.moveCY
	soundProperties.z = self.moveCZ + 0.5
	soundProperties.path = "res/sounds/shimmer.ogg"
	soundProperties.loop = false
	
	triggerEvent("MKPLAYEFFECTSOUND", root, soundProperties)
end


function ItemBlockC:destructor()
	removeEventHandler(self.updateCoordsEventName, root, self.m_UpdateCoords)
	removeEventHandler(self.enableItemBlockEventName, root, self.m_EnableItemBlock)
	removeEventHandler(self.disableItemBlockEventName, root, self.m_DisableItemBlock)
		
	self:disableItemBlock()

	--mainOutput("ItemBlockC was deleted: " .. self.id)
end
