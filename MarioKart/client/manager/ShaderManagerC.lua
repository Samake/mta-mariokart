--[[
	Filename: ShaderManagerC.lua
	Authors: Sam@ke
--]]

ShaderManagerC = {}


function ShaderManagerC:constructor(parent, dataManager)
	mainOutput("ShaderManagerC was loaded.")
	
	self.mainClass = parent
	self.dataManager = dataManager
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	if (self.dataManager) then
		self.settings = self.dataManager:getSettings()
		
		self.waterShaderEnabled = self.settings.waterShaderEnabled or "true"
		self.boostFieldShaderEnabled = self.settings.boostFieldShaderEnabled or "true"
		self.ambientLightShaderEnabled = self.settings.ambientLightShaderEnabled or "true"
		self.dofShaderEnabled = self.settings.dofShaderEnabled or "true"
		self.itemShaderEnabled = self.settings.itemShaderEnabled or "true"
		self.coinShaderEnabled = self.settings.coinShaderEnabled or "true"
		self.skyBoxShaderEnabled = self.settings.skyBoxShaderEnabled or "true"
		self.sunShaderEnabled = self.settings.sunShaderEnabled or "true"
		self.godraysEnabled = self.settings.godraysEnabled or "true"
		self.lensflareEnabled = self.settings.lensflareEnabled or "true"
	else
		self.waterShaderEnabled = "true"
		self.boostFieldShaderEnabled = "true"
		self.ambientLightShaderEnabled = "true"
		self.dofShaderEnabled = "true"
		self.itemShaderEnabled = "true"
		self.coinShaderEnabled = "true"
		self.skyBoxShaderEnabled = "true"
		self.sunShaderEnabled = "true"
		self.godraysEnabled = "true"
		self.lensflareEnabled = "true"
	end

	self.weatherID = 9
	
	self.sunColor = {0, 0, 0, 0}
	self.ambientColor = {0, 0, 0, 0}
	self.sunDistance = 0
	self.sunHeight = 0
	self.sunAngle = 0
	self.sunPos = {0, 0, 0}
	self.skyTextureID = 1
	
	self.skyTextureDay = dxCreateTexture("res/textures/env/skyboxDay.tga")
	self.skyTextureNight = dxCreateTexture("res/textures/env/skyboxNight.tga")
	
	self.weatherTable = {}
	
	self.weatherTable[1] = {
		sunColor = {0.1, 0.1, 0.25, 1.0},
		ambientColor = {0.2, 0.2, 0.35, 1.0},
		sunDistance = 1500,
		sunHeight = 0,
		sunAngle = 0,
		skyTextureID = 1
	}
	
	self.weatherTable[9] = {
		sunColor = {0.92, 0.85, 0.7, 1.0},
		ambientColor = {0.65, 0.6, 0.42, 1.0},
		sunDistance = 2000,
		sunHeight = 650,
		sunAngle = 95,
		skyTextureID = 2
	}
	
	self:init()
end


function ShaderManagerC:init()

	self.skyTextureID = self.weatherTable[self.weatherID].skyTextureID
	self.sunColor = self.weatherTable[self.weatherID].sunColor
	self.ambientColor = self.weatherTable[self.weatherID].ambientColor
	self.sunDistance = self.weatherTable[self.weatherID].sunDistance
	self.sunHeight = self.weatherTable[self.weatherID].sunHeight
	self.sunAngle = self.weatherTable[self.weatherID].sunAngle
	self.skyBoxID = self.weatherTable[self.weatherID].skyTextureID
	
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
	
	if (self.waterShaderEnabled == "true") then
		self:enableWaterShader()
	end	
	
	if (self.boostFieldShaderEnabled == "true") then
		self:enableBoostFieldShader()
	end
	
	if (self.ambientLightShaderEnabled == "true") then
		self:enableAmbientLightShader()
	end
	
	if (self.dofShaderEnabled == "true") then
		self:enableDoFShader()
	end
	
	if (self.itemShaderEnabled == "true") then
		self:enableItemShader()
	end
	
	if (self.coinShaderEnabled == "true") then
		self:enableCoinShader()
	end
	
	if (self.skyBoxShaderEnabled == "true") then
		self:enableSkyBoxShader()
	end
	
	if (self.sunShaderEnabled == "true") then
		self:enableSunShader()
	end
	
	self.isLoaded = self.mainClass and self.player
end


function ShaderManagerC:toggleWaterShader(state)
	if (state == "true") then
		self:enableWaterShader()
	elseif (state == "false") then
		self:disableWaterShader()
	end
end


function ShaderManagerC:enableWaterShader()
	if (not self.waterShader) then
		self.waterShader = new(ShaderWaterC, self)
		self.waterShaderEnabled = "true"
	end
end


function ShaderManagerC:disableWaterShader()
	if (self.waterShader) then
		delete(self.waterShader)
		self.waterShader = nil
		self.waterShaderEnabled = "false"
	end
end

function ShaderManagerC:toggleBoostFieldShader(state)
	if (state == "true") then
		self:enableBoostFieldShader()
	elseif (state == "false") then
		self:disableBoostFieldShader()
	end
end


function ShaderManagerC:enableBoostFieldShader()
	if (not self.boostFieldShader) then
		self.boostFieldShader = new(ShaderBoostFieldsC, self)
		self.boostFieldShaderEnabled = "true"
	end
end


function ShaderManagerC:disableBoostFieldShader()
	if (self.boostFieldShader) then
		delete(self.boostFieldShader)
		self.boostFieldShader = nil
		self.boostFieldShaderEnabled = "false"
	end
end


function ShaderManagerC:toggleAmbientLightShader(state)
	if (state == "true") then
		self:enableAmbientLightShader()
	elseif (state == "false") then
		self:disableAmbientLightShader()
	end
end



function ShaderManagerC:enableAmbientLightShader()
	if (not self.ambientLightShader) then
		self.ambientLightShader = new(ShaderAmbientLightC, self)
		self.ambientLightShaderEnabled = "true"
	end
end


function ShaderManagerC:disableAmbientLightShader()
	if (self.ambientLightShader) then
		delete(self.ambientLightShader)
		self.ambientLightShader = nil
		self.ambientLightShaderEnabled = "false"
	end
end


function ShaderManagerC:toggleDoFShader(state)
	if (state == "true") then
		self:enableDoFShader()
	elseif (state == "false") then
		self:disableDoFShader()
	end
end


function ShaderManagerC:enableDoFShader()
	if (not self.dofShader) then
		self.dofShader = new(ShaderDoFC, self)
		self.dofShaderEnabled = "true"
	end
end


function ShaderManagerC:disableDoFShader()
	if (self.dofShader) then
		delete(self.dofShader)
		self.dofShader = nil
		self.dofShaderEnabled = "false"
	end
end


function ShaderManagerC:toggleItemShader(state)
	if (state == "true") then
		self:enableItemShader()
	elseif (state == "false") then
		self:disableItemShader()
	end
end


function ShaderManagerC:enableItemShader()
	if (not self.itemShader) then
		self.itemShader = new(ShaderItemsC, self)
		self.itemShaderEnabled = "true"
	end
end


function ShaderManagerC:disableItemShader()
	if (self.itemShader) then
		delete(self.itemShader)
		self.itemShader = nil
		self.itemShaderEnabled = "false"
	end
end


function ShaderManagerC:toggleCoinShader(state)
	if (state == "true") then
		self:enableCoinShader()
	elseif (state == "false") then
		self:disableCoinShader()
	end
end


function ShaderManagerC:enableCoinShader()
	if (not self.coinShader) then
		self.coinShader = new(ShaderCoinsC, self)
		self.coinShaderEnabled = "true"
	end
end


function ShaderManagerC:disableCoinShader()
	if (self.coinShader) then
		delete(self.coinShader)
		self.coinShader = nil
		self.coinShaderEnabled = "false"
	end
end


function ShaderManagerC:toggleSkyBoxShader(state)
	if (state == "true") then
		self:enableSkyBoxShader()
	elseif (state == "false") then
		self:disableSkyBoxShader()
	end
end


function ShaderManagerC:enableSkyBoxShader()
	if (not self.skyBoxShader) then
		self.skyBoxShader = new(ShaderSkyBoxC, self)
		self.skyBoxShaderEnabled = "true"
	end
end


function ShaderManagerC:disableSkyBoxShader()
	if (self.skyBoxShader) then
		delete(self.skyBoxShader)
		self.skyBoxShader = nil
		self.skyBoxShaderEnabled = "false"
	end
end


function ShaderManagerC:toggleSunShader(state)
	if (state == "true") then
		self:enableSunShader()
	elseif (state == "false") then
		self:disableSunShader()
	end
end


function ShaderManagerC:enableSunShader()
	if (not self.sunShader) then
		self.sunShader = new(ShaderSunC, self)
		self.sunShaderEnabled = "true"
	end
end


function ShaderManagerC:disableSunShader()
	if (self.sunShader) then
		delete(self.sunShader)
		self.sunShader = nil
		self.sunShaderEnabled = "false"
	end
end


function ShaderManagerC:update()
	if (self.isLoaded) then
		--self.sunAngle = self.sunAngle + 1
		
		if (self.sunAngle > 360) then
			self.sunAngle = 0
		end
		
		self.playerPos = self.player:getPosition()

		self.sunX, self.sunY, self.sunZ = getAttachedPosition(self.playerPos.x, self.playerPos.y, self.playerPos.z, 0, 0, 0, self.sunDistance, self.sunAngle, self.sunHeight)
		self.sunPos = {self.sunX, self.sunY, self.sunZ}
		
		if (self.sunShader) then
			self.sunShader:update()
		end
		
		if (self.dofShader) then
			self.dofShader:update()
		end
		
		if (self.waterShader) then
			self.waterShader:update()
		end
		
		if (self.boostFieldShader) then
			self.boostFieldShader:update()
		end
		
		if (self.ambientLightShader) then
			self.ambientLightShader:update()
		end
		
		if (self.itemShader) then
			self.itemShader:update()
		end
		
		if (self.coinShader) then
			self.coinShader:update()
		end
		
		if (self.skyBoxShader) then
			self.skyBoxShader:update()
		end
	end
end


function ShaderManagerC:getSunColor()
	return self.sunColor
end


function ShaderManagerC:getShadowColor()
	return self.shadowColor
end


function ShaderManagerC:getAmbientColor()
	return self.ambientColor
end


function ShaderManagerC:getSunPosition()
	return self.sunPos
end


function ShaderManagerC:clear()
	removeEventHandler("MKTOGGLEWATERSHADER", root, self.m_ToggleWaterShader)
	removeEventHandler("MKTOGGLEBOOSTFIELDSHADER", root, self.m_ToggleBoostFieldShader)
	removeEventHandler("MKTOGGLEDYNAMICLIGHTSHADER", root, self.m_ToggleAmbientLightShader)
	removeEventHandler("MKTOGGLEDOFSHADER", root, self.m_ToggleDoFShader)
	removeEventHandler("MKTOGGLEITEMSHADER", root, self.m_ToggleItemShader)
	removeEventHandler("MKTOGGLECOINSHADER", root, self.m_ToggleCoinShader)
	removeEventHandler("MKTOGGLESKYBOXSHADER", root, self.m_ToggleSkyBoxShader)
	removeEventHandler("MKTOGGLESUNSHADER", root, self.m_ToggleSunShader)
	
	self:disableWaterShader()
	self:disableBoostFieldShader()
	self:disableAmbientLightShader()
	self:disableDoFShader()
	self:disableItemShader()
	self:disableCoinShader()
	self:disableSkyBoxShader()
	self:disableSunShader()
	
	if (self.skyTextureDay) then
		self.skyTextureDay:destroy()
		self.skyTextureDay = nil
	end
	
	if (self.skyTextureNight) then
		self.skyTextureNight:destroy()
		self.skyTextureNight = nil
	end
end


function ShaderManagerC:destructor()
	self:clear()

	mainOutput("ShaderManagerC was deleted.")
end