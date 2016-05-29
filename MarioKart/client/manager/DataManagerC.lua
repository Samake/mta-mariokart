--[[
	Filename: DataManagerC.lua
	Authors: Sam@ke
--]]

DataManagerC = {}


function DataManagerC:constructor(parent)
	mainOutput("DataManagerC was loaded.")

	self.mainClass = parent
	self.xmlHandler = self.mainClass.xmlHandler

	self.player = getLocalPlayer()
	self.isPlayerLoggedIn = "false"
	self.modelID = 0
	self.vehicleID = 0
	self.coins = 0
	self.xp = 0
	self.level = 0
	
	self.serverStats = nil
	self.fps = 0
	self.ping = 0
	
	self.isLoaded = self.xmlHandler
	
	self.settings = {}
	self:init()
	self:loadSettings()
end


function DataManagerC:init()
	self.m_ReceiveServerStats = bind(self.receiveServerStats, self)
	addEvent("MKRECEIVESERVERSTATS", true)
	addEventHandler("MKRECEIVESERVERSTATS", root, self.m_ReceiveServerStats)
	
	self.m_SaveSettings = bind(self.saveSettings, self)
	addEvent("MKSAVESETTINGS", true)
	addEventHandler("MKSAVESETTINGS", root, self.m_SaveSettings)
	
	self.m_SetBrightness = bind(self.setBrightness, self)
	addEvent("MKSETBRIGHTNESS", true)
	addEventHandler("MKSETBRIGHTNESS", root, self.m_SetBrightness)
	
	self.m_SetContrast = bind(self.setContrast, self)
	addEvent("MKSETCONTRAST", true)
	addEventHandler("MKSETCONTRAST", root, self.m_SetContrast)
	
	self.m_SetSaturation = bind(self.setSaturation, self)
	addEvent("MKSETSATURATION", true)
	addEventHandler("MKSETSATURATION", root, self.m_SetSaturation)
	
	self.m_ToggleShaderManager = bind(self.toggleShaderManager, self)
	addEvent("MKTOGGLEALLSHADERS", true)
	addEventHandler("MKTOGGLEALLSHADERS", root, self.m_ToggleShaderManager)
	
	self.m_ToggleBlurShader = bind(self.toggleBlurShader, self)
	addEvent("MKTOGGLEBLURSHADER", true)
	addEventHandler("MKTOGGLEBLURSHADER", root, self.m_ToggleBlurShader)
	
	self.m_ToggleWaterShader = bind(self.toggleWaterShader, self)
	addEvent("MKTOGGLEWATERSHADER", true)
	addEventHandler("MKTOGGLEWATERSHADER", root, self.m_ToggleWaterShader)
	
	self.m_ToggleBoostFieldShader = bind(self.toggleBoostFieldShader, self)
	addEvent("MKTOGGLEBOOSTFIELDSHADER", true)
	addEventHandler("MKTOGGLEBOOSTFIELDSHADER", root, self.m_ToggleBoostFieldShader)
	
	self.m_ToggleAmbientLightShader = bind(self.toggleAmbientLightShader, self)
	addEvent("MKTOGGLEDYNAMICLIGHTSHADER", true)
	addEventHandler("MKTOGGLEDYNAMICLIGHTSHADER", root, self.m_ToggleAmbientLightShader)
	
	self.m_ToggleDoFShader = bind(self.toggleDoFShader, self)
	addEvent("MKTOGGLEDOFSHADER", true)
	addEventHandler("MKTOGGLEDOFSHADER", root, self.m_ToggleDoFShader)
	
	self.m_ToggleItemShader = bind(self.toggleItemShader, self)
	addEvent("MKTOGGLEITEMSHADER", true)
	addEventHandler("MKTOGGLEITEMSHADER", root, self.m_ToggleItemShader)
	
	self.m_ToggleCoinShader = bind(self.toggleCoinShader, self)
	addEvent("MKTOGGLECOINSHADER", true)
	addEventHandler("MKTOGGLECOINSHADER", root, self.m_ToggleCoinShader)
	
	self.m_ToggleSkyBoxShader = bind(self.toggleSkyBoxShader, self)
	addEvent("MKTOGGLESKYBOXSHADER", true)
	addEventHandler("MKTOGGLESKYBOXSHADER", root, self.m_ToggleSkyBoxShader)
	
	self.m_ToggleSunShader = bind(self.toggleSunShader, self)
	addEvent("MKTOGGLESUNSHADER", true)
	addEventHandler("MKTOGGLESUNSHADER", root, self.m_ToggleSunShader)
	
	self.m_ToggleGodrayShader = bind(self.toggleGodrayShader, self)
	addEvent("MKTOGGLEGODRAYSHADER", true)
	addEventHandler("MKTOGGLEGODRAYSHADER", root, self.m_ToggleGodrayShader)
	
	self.m_ToggleLensflareShader = bind(self.toggleLensflareShader, self)
	addEvent("MKTOGGLELENSFLARESHADER", true)
	addEventHandler("MKTOGGLELENSFLARESHADER", root, self.m_ToggleLensflareShader)
end


function DataManagerC:update()

	self.fps = getFPS()
	
	if (isElement(self.player)) then
		self.ping = self.player:getPing()
	else
		self.ping = 0
	end
end


function DataManagerC:receiveServerStats(serverStats)
	if (serverStats) then
		self.serverStats = serverStats
		
		self:updatePlayerStats()
	end
end


function DataManagerC:updatePlayerStats()
	if (self.serverStats.players) then
		if (self.serverStats.players[tostring(self.player)]) then
			local playerStats = self.serverStats.players[tostring(self.player)]
			
			self.playerID = playerStats.id
			self.modelID = playerStats.modelID
			self.vehicleID = playerStats.vehicleID
			self.coins = playerStats.coins
			self.xp = playerStats.xp
			self.level = playerStats.level
		end
	end
end


function DataManagerC:setModelID(value)
	if (value) then
		self.modelID = value
	end
end


function DataManagerC:getModelID()
	return self.modelID
end


function DataManagerC:setVehicleID(value)
	if (value) then
		self.vehicleID = value
	end
end


function DataManagerC:getVehicleID()
	return self.vehicleID
end


function DataManagerC:setCoins(value)
	if (value) then
		self.coins = value
	end
end


function DataManagerC:getCoins()
	return self.coins
end


function DataManagerC:setXP(value)
	if (value) then
		self.xp = value
	end
end


function DataManagerC:getXP()
	return self.xp
end


function DataManagerC:setLevel(value)
	if (value) then
		self.level = value
	end
end


function DataManagerC:getLevel()
	return self.level
end


function DataManagerC:setBrightness(value)
	if (value) then
		self.settings.brightness = value
	end
end


function DataManagerC:getBrightness()
	return self.settings.brightness
end


function DataManagerC:setContrast(value)
	if (value) then
		self.settings.contrast = value
	end
end


function DataManagerC:getContrast()
	return self.settings.contrast
end


function DataManagerC:setSaturation(value)
	if (value) then
		self.settings.saturation = value
	end
end


function DataManagerC:getSaturation()
	return self.settings.saturation
end


function DataManagerC:toggleShaderManager(state)
	if (state) then
		self.settings.shadersEnabled = state
	end
end


function DataManagerC:toggleBlurShader(state)
	if (state) then
		self.settings.blurShaderEnabled = state
	end
end


function DataManagerC:toggleWaterShader(state)
	if (state) then
		self.settings.waterShaderEnabled = state
	end
end


function DataManagerC:toggleBoostFieldShader(state)
	if (state) then
		self.settings.boostFieldShaderEnabled = state
	end
end


function DataManagerC:toggleAmbientLightShader(state)
	if (state) then
		self.settings.ambientLightShaderEnabled = state
	end
end


function DataManagerC:toggleDoFShader(state)
	if (state) then
		self.settings.dofShaderEnabled = state
	end
end


function DataManagerC:toggleItemShader(state)
	if (state) then
		self.settings.itemShaderEnabled = state
	end
end


function DataManagerC:toggleCoinShader(state)
	if (state) then
		self.settings.coinShaderEnabled = state
	end
end


function DataManagerC:toggleSkyBoxShader(state)
	if (state) then
		self.settings.skyBoxShaderEnabled = state
	end
end


function DataManagerC:toggleSunShader(state)
	if (state) then
		self.settings.sunShaderEnabled = state
	end
end


function DataManagerC:toggleGodrayShader(state)
	if (state) then
		self.settings.godraysEnabled = state
	end
end


function DataManagerC:toggleLensflareShader(state)
	if (state) then
		self.settings.lensflareEnabled = state
	end
end


function DataManagerC:loadSettings()
	if (self.isLoaded) then
		self.settings.brightness = self.xmlHandler:readFromXML("brightness") or 1.0
		self.settings.contrast = self.xmlHandler:readFromXML("contrast") or 1.0
		self.settings.saturation = self.xmlHandler:readFromXML("saturation") or 1.0
	
		self.settings.shadersEnabled = self.xmlHandler:readFromXML("shadersEnabled") or "true"
		self.settings.blurShaderEnabled = self.xmlHandler:readFromXML("blurShaderEnabled") or "true"
		self.settings.waterShaderEnabled = self.xmlHandler:readFromXML("waterShaderEnabled") or "true"
		self.settings.boostFieldShaderEnabled = self.xmlHandler:readFromXML("boostFieldShaderEnabled") or "true"
		self.settings.ambientLightShaderEnabled = self.xmlHandler:readFromXML("ambientLightShaderEnabled") or "true"
		self.settings.dofShaderEnabled = self.xmlHandler:readFromXML("dofShaderEnabled") or "true"
		self.settings.itemShaderEnabled = self.xmlHandler:readFromXML("itemShaderEnabled") or "true"
		self.settings.coinShaderEnabled = self.xmlHandler:readFromXML("coinShaderEnabled") or "true"
		self.settings.skyBoxShaderEnabled = self.xmlHandler:readFromXML("skyBoxShaderEnabled") or "true"
		self.settings.sunShaderEnabled = self.xmlHandler:readFromXML("sunShaderEnabled") or "true"
		self.settings.godraysEnabled = self.xmlHandler:readFromXML("godraysEnabled") or "true"
		self.settings.lensflareEnabled = self.xmlHandler:readFromXML("lensflareEnabled") or "true"
	end
end


function DataManagerC:saveSettings()
	if (self.isLoaded) then
		self.xmlHandler:writeToXML("brightness", self.settings.brightness)
		self.xmlHandler:writeToXML("contrast", self.settings.contrast)
		self.xmlHandler:writeToXML("saturation", self.settings.saturation)
		
		self.xmlHandler:writeToXML("shadersEnabled", self.settings.shadersEnabled)
		self.xmlHandler:writeToXML("blurShaderEnabled", self.settings.blurShaderEnabled)
		self.xmlHandler:writeToXML("waterShaderEnabled", self.settings.waterShaderEnabled)
		self.xmlHandler:writeToXML("boostFieldShaderEnabled", self.settings.boostFieldShaderEnabled)
		self.xmlHandler:writeToXML("ambientLightShaderEnabled", self.settings.ambientLightShaderEnabled)
		self.xmlHandler:writeToXML("dofShaderEnabled", self.settings.dofShaderEnabled)
		self.xmlHandler:writeToXML("itemShaderEnabled", self.settings.itemShaderEnabled)
		self.xmlHandler:writeToXML("coinShaderEnabled", self.settings.coinShaderEnabled)
		self.xmlHandler:writeToXML("skyBoxShaderEnabled", self.settings.skyBoxShaderEnabled)
		self.xmlHandler:writeToXML("sunShaderEnabled", self.settings.sunShaderEnabled)
		self.xmlHandler:writeToXML("godraysEnabled", self.settings.godraysEnabled)
		self.xmlHandler:writeToXML("lensflareEnabled", self.settings.lensflareEnabled)
	end
end


function DataManagerC:getSettings()
	return self.settings
end



function DataManagerC:getServerStats()
	return self.serverStats
end


function DataManagerC:getAllMaps()
	if (self.serverStats) then
		if (self.serverStats.mapList) then
			return self.serverStats.mapList
		end
	end
	
	return nil
end


function DataManagerC:getFPS()
	return self.fps
end


function DataManagerC:getPing()
	return self.ping
end


function DataManagerC:destructor()
	
	removeEventHandler("MKRECEIVESERVERSTATS", root, self.m_ReceiveServerStats)
	removeEventHandler("MKSAVESETTINGS", root, self.m_SaveSettings)
	removeEventHandler("MKSETBRIGHTNESS", root, self.m_SetBrightness)
	removeEventHandler("MKSETCONTRAST", root, self.m_SetContrast)
	removeEventHandler("MKSETSATURATION", root, self.m_SetSaturation)
	removeEventHandler("MKTOGGLEALLSHADERS", root, self.m_ToggleShaderManager)
	removeEventHandler("MKTOGGLEBLURSHADER", root, self.m_ToggleBlurShader)
	removeEventHandler("MKTOGGLEWATERSHADER", root, self.m_ToggleWaterShader)
	removeEventHandler("MKTOGGLEBOOSTFIELDSHADER", root, self.m_ToggleBoostFieldShader)
	removeEventHandler("MKTOGGLEDYNAMICLIGHTSHADER", root, self.m_ToggleAmbientLightShader)
	removeEventHandler("MKTOGGLEDOFSHADER", root, self.m_ToggleDoFShader)
	removeEventHandler("MKTOGGLEITEMSHADER", root, self.m_ToggleItemShader)
	removeEventHandler("MKTOGGLECOINSHADER", root, self.m_ToggleCoinShader)
	removeEventHandler("MKTOGGLESKYBOXSHADER", root, self.m_ToggleSkyBoxShader)
	removeEventHandler("MKTOGGLESUNSHADER", root, self.m_ToggleSunShader)
	removeEventHandler("MKTOGGLEGODRAYSHADER", root, self.m_ToggleGodrayShader)
	removeEventHandler("MKTOGGLELENSFLARESHADER", root, self.m_ToggleLensflareShader)

	self:saveSettings()
	
	mainOutput("DataManagerC was deleted.")
end
