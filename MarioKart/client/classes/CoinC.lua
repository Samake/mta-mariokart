--[[
	Filename: CoinC.lua
	Authors: Sam@ke
--]]

CoinC = {}


function CoinC:constructor(parent, coinProperties)

	self.itemBlockManager = parent
	
	self.id = coinProperties.id
	self.modelID = coinProperties.modelID
	self.value = coinProperties.value
	self.x = coinProperties.x
	self.y = coinProperties.y
	self.z = coinProperties.z
	self.moveCX = coinProperties.x
	self.moveCY = coinProperties.y
	self.moveCZ = coinProperties.z
	self.moveSX = coinProperties.x
	self.moveSY = coinProperties.y
	self.moveSZ = coinProperties.z
	self.rx = coinProperties.rx
	self.ry = coinProperties.ry
	self.rz = coinProperties.rz
	self.moveOnXAxis = coinProperties.moveOnXAxis
	self.moveOnYAxis = coinProperties.moveOnYAxis
	self.moveOnZAxis = coinProperties.moveOnZAxis
	self.moveSpeedS = coinProperties.moveSpeed
	self.moveSpeedC = coinProperties.moveSpeed
	self.rotationSpeed = coinProperties.rotationSpeed
	self.modelSize = coinProperties.modelSize
	self.heightModifier = coinProperties.heightModifier
	self.lodDistance = coinProperties.lodDistance
	self.collisionShapeRadius = coinProperties.collisionShapeRadius
	self.updateCoordsEventName = coinProperties.updateCoordsEventName
	self.onCoinPickedEventName = coinProperties.onCoinPickedEventName
	self.enableCoinEventName = coinProperties.enableCoinEventName
	self.disableCoinEventName = coinProperties.disableCoinEventName
	self.player = getLocalPlayer()
	
	--mainOutput("CoinC was loaded. ID: " .. self.id)
	
	self:init()
end


function CoinC:init()
	
	self.m_UpdateCoords = bind(self.updateCoords, self)
	addEvent(self.updateCoordsEventName, true)
	addEventHandler(self.updateCoordsEventName, root, self.m_UpdateCoords)
	
	self.m_EnableCoin = bind(self.enableCoin, self)
	addEvent(self.enableCoinEventName, true)
	addEventHandler(self.enableCoinEventName, root, self.m_EnableCoin)
	
	self.m_DisableCoin = bind(self.disableCoin, self)
	addEvent(self.disableCoinEventName, true)
	addEventHandler(self.disableCoinEventName, root, self.m_DisableCoin)
	
	self:enableCoin()
end

function CoinC:enableCoin()
	self.coinObject = createObject(self.modelID, self.x, self.y, self.z + self.heightModifier, self.rx, self.ry, self.rz)
	self.coinObjectLOD = createObject(self.modelID, self.x, self.y, self.z + self.heightModifier, self.rx, self.ry, self.rz, true)
	self.collisionShape = createColSphere(self.x, self.y, self.z, self.collisionShapeRadius)
	
	self.isLoaded = self.coinObject and self.coinObjectLOD and self.collisionShape
	
	if (self.isLoaded) then
		self.coinObject:setScale(self.modelSize)
		self.coinObjectLOD:setScale(self.modelSize)
		
		self.coinObject:setCollisionsEnabled(false)
		
		self.coinObjectLOD:attach(self.coinObject)
		self.collisionShape:attach(self.coinObject)
		
		self.coinObject:setLowLOD(self.coinObjectLOD)
		
		engineSetModelLODDistance(self.modelID, self.lodDistance)
		
		self.coinObject:setDoubleSided(true)
		
		self.m_OnCoinPicked = bind(self.onCoinPicked, self)
		addEventHandler("onClientColShapeHit", self.collisionShape, self.m_OnCoinPicked)
	end
end


function CoinC:update(delta)
	if (self.isLoaded) then
		self.rz = self.rz + self.rotationSpeed * delta
		
		if (self.rz > 360) then
			self.rz = 0
		end
		
		self.coinObject:setRotation(self.rx, self.ry, self.rz)
		self.coinObjectLOD:setRotation(self.rx, self.ry, self.rz)
	
		if (self.moveX ~= self.x) or (self.moveY ~= self.y) or (self.moveZ ~= self.z) then
			self:interPolateMe(delta)
		end
	end
end


function CoinC:interPolateMe(delta)

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
		
		self.coinObject:setPosition(self.moveCX, self.moveCY, self.moveCZ + self.heightModifier)
		self.coinObjectLOD:setPosition(self.moveCX, self.moveCY, self.moveCZ + self.heightModifier)
end


function CoinC:onCoinPicked(element)
	if (isElement(element)) then
		if (element:getType() == "player") or (element:getType() == "vehicle") then
			triggerServerEvent(self.onCoinPickedEventName, root, self.player)
		end
	end
end


function CoinC:updateCoords(coords)
	if (coords) then
		self.moveSX = coords.x
		self.moveSY = coords.y
		self.moveSZ = coords.z
	end
end


function CoinC:disableCoin()

	self.isLoaded = nil
	
	if (self.coinObject) then
		self.coinObject:destroy()
		self.coinObject = nil
	end
	
	if (self.coinObjectLOD) then
		self.coinObjectLOD:destroy()
		self.coinObjectLOD = nil
	end
	
	if (self.collisionShape) then
		removeEventHandler("onClientColShapeHit", self.collisionShape, self.m_OnCoinPicked)
		self.collisionShape:destroy()
		self.collisionShape = nil
	end
	
	local effectProperties = {}
	effectProperties.x = self.moveCX
	effectProperties.y = self.moveCY
	effectProperties.z = self.moveCZ + self.heightModifier
	effectProperties.r = 200
	effectProperties.g = 180
	effectProperties.b = 50
	effectProperties.a = 150
	effectProperties.scale = 0.02
	effectProperties.count = 15
	
	triggerEvent("MKADDGLASSFX", root, effectProperties)
	
	local soundProperties = {}
	soundProperties.x = self.moveCX
	soundProperties.y = self.moveCY
	soundProperties.z = self.moveCZ + 0.5
	soundProperties.path = "res/sounds/coinPick.ogg"
	soundProperties.loop = false
	
	triggerEvent("MKPLAYEFFECTSOUND", root, soundProperties)
end


function CoinC:destructor()
	removeEventHandler(self.updateCoordsEventName, root, self.m_UpdateCoords)
	removeEventHandler(self.enableCoinEventName, root, self.m_EnableCoin)
	removeEventHandler(self.disableCoinEventName, root, self.m_DisableCoin)
		
	self:disableCoin()

	--mainOutput("CoinC was deleted: " .. self.id)
end
