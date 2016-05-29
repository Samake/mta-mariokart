--[[
	Filename: MainClassC.lua
	Authors: Sam@ke
--]]

local Instance = nil

MainClassC = {}


function MainClassC:constructor()
	mainOutput("MainClassC was loaded.")

	self.isDevelopmentMode = true
	self.isDevelopmentModeBrowser = true
	self.showMTAHUD = false
	self.isDebugEnabled = "false"

	self.player = getLocalPlayer()

	self.shadersEnabled = "true"
	self.blurLevel = 0
	self.delta = 0

	self:setClientParams()
	self:init()
end


function MainClassC:setClientParams()
	setBirdsEnabled(false)
	setBlurLevel(self.blurLevel)
	setDevelopmentMode(self.isDevelopmentMode, self.isDevelopmentModeBrowser)
	setPedCanBeKnockedOffBike(self.player, false)
end


function MainClassC:init()
	self.m_UpdatePRE = bind(self.updatePRE, self)
	addEventHandler("onClientPreRender", root, self.m_UpdatePRE)

	self.m_UpdateHUD = bind(self.updateHUD, self)
	addEventHandler("onClientHUDRender", root, self.m_UpdateHUD)
	
	self.m_ToggleShaderManager = bind(self.toggleShaderManager, self)
	addEvent("MKTOGGLEALLSHADERS", true)
	addEventHandler("MKTOGGLEALLSHADERS", root, self.m_ToggleShaderManager)
	
	self.m_ToggleDebugMode = bind(self.toggleDebugMode, self)
	bindKey(getKeyToggleDebug(), "down", self.m_ToggleDebugMode)
	
	if (not self.xmlHandler) then
		self.xmlHandler = new(XMLHandlerC, self)
	end
	
	if (not self.customCursor) then
		self.customCursor = new(CustomCursorC, self)
	end
	
	if (not self.modelHandler) then
		self.modelHandler = new(ModelHandlerC, self)
	end
	
	if (not self.dataManager) then
		self.dataManager = new(DataManagerC, self)
	end
	
	if (not self.loginClass) then
		--self.loginClass = new(LoginC, self)
	end
	
	if (self.dataManager) then
		self.settings = self.dataManager:getSettings()
		
		shadersEnabled = self.settings.shadersEnabled
	end
	
	if (self.shadersEnabled == "true") then
		self:enableShaderManager()
	end
	
	if (not self.soundManager) then
		self.soundManager = new(SoundManagerC, self)
	end
	
	if (not self.effectManager) then
		self.effectManager = new(EffectManagerC, self)
	end
	
	if (not self.mapLoader) then
		-- // wont work at the moment // --
		--self.mapLoader = new(MapLoaderC, self)
	end
	
	if (not self.notificationManager) then
		self.notificationManager = new(NotificationManagerC, self)
	end
	
	if (not self.itemBlockManager) then
		self.itemBlockManager = new(ItemBlockManagerC, self)
	end
	
	if (not self.coinManager) then
		self.coinManager = new(CoinManagerC, self)
	end

	if (not self.guiManager) then
		self.guiManager = new(GUIManagerC, self, self.dataManager)
	end

	if (self.isDebugEnabled == "true") then
		self:enableDebugMode()
	end
	
	if (not self.renderClass) then
		self.renderClass = new(RenderClassC, self, self.dataManager)
	end
	
	if (not self.cameraHandler) then
		self.cameraHandler = new(CameraHandlerC, self)
	end
	
	if (not self.waterManager) then
		self.waterManager = new(WaterManagerC, self)
	end
end


function MainClassC:toggleShaderManager(state)
	if (state == "true") then
		self:enableShaderManager()
	elseif (state == "false") then
		self:disableShaderManager()
	end
end


function MainClassC:enableShaderManager()
	if (not self.shaderManager) then
		self.shaderManager = new(ShaderManagerC, self, self.dataManager)
		self.shadersEnabled = "true"
	end
end


function MainClassC:disableShaderManager()
	if (self.shaderManager) then
		delete(self.shaderManager)
		self.shaderManager = nil
		self.shadersEnabled = "false"
	end
end


function MainClassC:toggleDebugMode()
	if (self.isDebugEnabled == "true") then
		self:disableDebugMode()
	elseif (self.isDebugEnabled == "false") then
		self:enableDebugMode()
	end
end


function MainClassC:enableDebugMode()
	if (not self.debugClass) then
		self.debugClass = new(DebugClassC, self)
		self.isDebugEnabled = "true"
		mainOutput("CLIENT || Debug enabled: " .. self.isDebugEnabled)
	end
end


function MainClassC:disableDebugMode()
	if (self.debugClass) then
		delete(self.debugClass)
		self.debugClass = nil
		self.isDebugEnabled = "false"
		mainOutput("CLIENT || Debug enabled: " .. self.isDebugEnabled)
	end
end


function MainClassC:updatePRE(deltaTime)
	if (self.shaderManager) then
		self.shaderManager:update(self.delta)
	end
	
	if (deltaTime) then
		self.delta = (1 / 17) * deltaTime
	end
	
	--[[for index, object in ipairs(getElementsByType("object")) do
		if isElement(object) and (object:isLowLOD()) then
			local modelID = object:getModel()
			engineSetModelLODDistance(modelID, 300)
		end
		
		object:setDoubleSided(true)
	end ]]
end


function MainClassC:updateHUD()
	setPlayerHudComponentVisible("all", self.showMTAHUD)
	setRadioChannel(0)
	
	if (self.mapLoader) then
		self.mapLoader:update(self.delta)
	end
	
	if (self.dataManager) then
		self.dataManager:update(self.delta)
	end
	
	if (self.waterManager) then
		self.waterManager:update(self.delta)
	end
	
	if (self.notificationManager) then
		self.notificationManager:update(self.delta)
	end
	
	if (self.itemBlockManager) then
		self.itemBlockManager:update(self.delta)
	end
	
	if (self.coinManager) then
		self.coinManager:update(self.delta)
	end

	if (self.debugClass) then
		self.debugClass:update(self.delta)
	end
	
	if (self.cameraHandler) then
		self.cameraHandler:update(self.delta)
	end
	
	if (self.renderClass) then
		self.renderClass:update(self.delta)
	end
	
	if (self.guiManager) then
		self.guiManager:update(self.delta)
	end
	
	if (self.customCursor) then
		self.customCursor:update(self.delta)
	end
end


function MainClassC:clear()
	removeEventHandler("onClientPreRender", root, self.m_UpdatePRE)
	removeEventHandler("onClientHUDRender", root, self.m_UpdateHUD)
	removeEventHandler("MKTOGGLEALLSHADERS", root, self.m_ToggleShaderManager)
	
	unbindKey(getKeyToggleDebug(), "down", self.m_ToggleDebugMode)
	
	if (self.customCursor) then
		delete(self.customCursor)
		self.customCursor = nil
	end
	
	if (self.modelHandler) then
		delete(self.modelHandler)
		self.modelHandler = nil
	end
	
	if (self.dataManager) then
		delete(self.dataManager)
		self.dataManager = nil
	end
	
	if (self.xmlHandler) then
		delete(self.xmlHandler)
		self.xmlHandler = nil
	end
	
	if (self.loginClass) then
		delete(self.loginClass)
		self.loginClass = nil
	end
	
	if (self.waterManager) then
		delete(self.waterManager)
		self.waterManager = nil
	end
	
	if (self.soundManager) then
		delete(self.soundManager)
		self.soundManager = nil
	end
	
	if (self.effectManager) then
		delete(self.effectManager)
		self.effectManager = nil
	end
	
	if (self.mapLoader) then
		delete(self.mapLoader)
		self.mapLoader = nil
	end
	
	if (self.notificationManager) then
		delete(self.notificationManager)
		self.notificationManager = nil
	end
	
	if (self.itemBlockManager) then
		delete(self.itemBlockManager)
		self.itemBlockManager = nil
	end
	
	if (self.coinManager) then
		delete(self.coinManager)
		self.coinManager = nil
	end
	
	if (self.shaderManager) then
		delete(self.shaderManager)
		self.shaderManager = nil
	end
	
	if (self.renderClass) then
		delete(self.renderClass)
		self.renderClass = nil
	end
	
	if (self.cameraHandler) then
		delete(self.cameraHandler)
		self.cameraHandler = nil
	end

	self:disableDebugMode()
end


function MainClassC:resetClientParams()
	setBirdsEnabled(true)
	resetAmbientSounds()
	setDevelopmentMode(false, false)
	setPlayerHudComponentVisible("all", true)
	setPedCanBeKnockedOffBike(self.player, true)
end


function MainClassC:destructor()
	self:clear()
	self:resetClientParams()

	mainOutput("MainClassC was deleted.")
end


addEventHandler("onClientResourceStart", resourceRoot,
function()
	Instance = new(MainClassC)
end)


addEventHandler("onClientResourceStop", resourceRoot,
function()
	if (Instance) then
		delete(Instance)
		Instance = nil
	end
end)
