--[[
	Filename: RenderClassC.lua
	Authors: Sam@ke
--]]

RenderClassC = {}


function RenderClassC:constructor(parent, dataManager)

	mainOutput("RenderClassC was loaded.")
	
	self.mainClass = parent
	self.dataManager = dataManager
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()

	
	self.baseSaturation = 1.15 -- default: 1.15
	self.baseBrightness = 0.6 -- default: 0.6
	self.baseContrast = 1.2 -- default: 1.2
	
	self.minBlur = 0 -- default: 0
	self.maxBlur = 12 -- default: 12
	self.currentBlur = 0 -- default: 0
	self.blurStep = 0.5 -- default: 0.5
	
	self.minFadeValue = 80
	self.maxFadeValue = 255
	self.currentFadeValue = 255
	self.mainFadeStep = 5
	
	self.isFaded = "false"
	self.fadeStep = 0.025 -- default: 0.01
	
	if (self.dataManager) then
		self.settings = self.dataManager:getSettings()
		
		self.blurShaderEnabled = self.settings.blurShaderEnabled or "true"
	else
		self.blurShaderEnabled = "true"
	end
	

	self:init()
end


function RenderClassC:init()

	self.screenSource = dxCreateScreenSource(self.screenWidth, self.screenHeight)
	self.renderTargetFinal = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	self.pictureQualityShader = dxCreateShader("res/shaders/pictureQuality.fx")
	
	self.m_ToggleScreenFade = bind(self.toggleScreenFade, self)
	addEvent("MKFADESCREEN", true)
	addEventHandler("MKFADESCREEN", root, self.m_ToggleScreenFade)
	
	self.isLoaded = self.mainClass and self.dataManager and self.screenSource and self.renderTargetFinal and self.pictureQualityShader

	if (self.isLoaded) then
		self.defaultSaturation = self.baseSaturation * self.dataManager:getSaturation()
		self.defaultBrightness = self.baseBrightness * self.dataManager:getBrightness()
		self.defaultContrast = self.baseContrast * self.dataManager:getContrast()
	else
		self.defaultSaturation = self.baseSaturation
		self.defaultBrightness = self.baseBrightness
		self.defaultContrast = self.baseContrast
	end
	
	self.currentSaturation = self.defaultSaturation
	self.currentBrightness = self.defaultBrightness
	self.currentContrast = self.defaultContrast
	
	self.m_ToggleBlurShader = bind(self.toggleBlurShader, self)
	addEvent("MKTOGGLEBLURSHADER", true)
	addEventHandler("MKTOGGLEBLURSHADER", root, self.m_ToggleBlurShader)
	
	if (self.blurShaderEnabled == "true") then
		self:enableBlurShader()
	end
end


function RenderClassC:toggleBlurShader(state)
	if (state == "true") then
		self:enableBlurShader()
	elseif (state == "false") then
		self:disableBlurShader()
	end
end


function RenderClassC:enableBlurShader()
	if (not self.blurShader) then
		self.blurShader = new(ShaderBlurC, self)
		self.blurShaderEnabled = "true"
	end
end


function RenderClassC:disableBlurShader()
	if (self.blurShader) then
		delete(self.blurShader)
		self.blurShader = nil
		self.blurShaderEnabled = "false"
	end
end


function RenderClassC:toggleScreenFade(fadeState)
	if (fadeState) then
		self.isFaded = fadeState
		
		if (self.isFaded == "true") then
			self:screenFadeIn()
		elseif (self.isFaded == "false") then
			self:screenFadeOut()
		end
	end
end


function RenderClassC:screenFadeIn()
	if (self.isLoaded) then
		self.isFaded = "true"
	end
end


function RenderClassC:screenFadeOut()
	if (self.isLoaded) then
		self.isFaded = "false"
	end
end


function RenderClassC:update()
	if (self.isLoaded) then
	    self.screenSource:update()
		
		self.defaultSaturation = self.baseSaturation * self.dataManager:getSaturation()
		self.defaultBrightness = self.baseBrightness * self.dataManager:getBrightness()
		self.defaultContrast = self.baseContrast * self.dataManager:getContrast()
		
		self.gameScene = self.screenSource
		
		if (self.currentSaturation < self.defaultSaturation) then
			self.currentSaturation = self.currentSaturation + self.fadeStep
		end
		
		if (self.currentSaturation > self.defaultSaturation) then
			self.currentSaturation = self.currentSaturation - self.fadeStep
		end
		
		if (self.currentBrightness < self.defaultBrightness) then
			self.currentBrightness = self.currentBrightness + self.fadeStep
		end
		
		if (self.currentBrightness > self.defaultBrightness) then
			self.currentBrightness = self.currentBrightness - self.fadeStep
		end
		
		if (self.currentContrast < self.defaultContrast) then
			self.currentContrast = self.currentContrast + self.fadeStep
		end
		
		if (self.currentContrast > self.defaultContrast) then
			self.currentContrast = self.currentContrast - self.fadeStep
		end
		
		if (self.isFaded == "false") then
			if (self.currentBlur > self.minBlur) then
				self.currentBlur = self.currentBlur - self.blurStep
			end
					
			if (self.currentFadeValue < self.maxFadeValue) then
				self.currentFadeValue = self.currentFadeValue + self.mainFadeStep
			end
		elseif (self.isFaded == "true") then
			if (self.currentBlur < self.maxBlur) then
				self.currentBlur = self.currentBlur + self.blurStep
			end
			
			if (self.currentFadeValue > self.minFadeValue) then
				self.currentFadeValue = self.currentFadeValue - self.mainFadeStep
			end
		end
		
		if (self.mainClass.shaderManager) then
			if (self.mainClass.shaderManager.dofShader) then
				self.gameScene = self.mainClass.shaderManager.dofShader:getDoFResult()
			end

			if (self.mainClass.shaderManager.sunShader) then
				self.pictureQualityShader:setValue("isSun", true)
				self.pictureQualityShader:setValue("sunSource", self.mainClass.shaderManager.sunShader:getResult())
			else
				self.pictureQualityShader:setValue("isSun", false)
			end
		else
			self.pictureQualityShader:setValue("isSun", false)
		end
		
		self.pictureQualityShader:setValue("screenSource", self.gameScene)
		self.pictureQualityShader:setValue("saturation", self.currentSaturation)
		self.pictureQualityShader:setValue("brightness", self.currentBrightness)
		self.pictureQualityShader:setValue("contrast", self.currentContrast)
		
		dxSetRenderTarget(self.renderTargetFinal, true)
        dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.pictureQualityShader)
		
		if (self.mainClass.guiManager) then
			dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.mainClass.guiManager:getGUIResult())
		end
		
		dxSetRenderTarget()
		
		self.gameScene = self.renderTargetFinal
		
		if (self.currentBlur > 0) then
			if (self.blurShader) then
				self.blurShader:setInput(self.gameScene)
				self.blurShader:setBlurStrentgh(self.currentBlur)
				self.blurShader:update()
				self.blurScene = self.blurShader:getResult()
			end
			
			if (isElement(self.blurScene)) then
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.blurScene, 0, 0, 0,tocolor(self.currentFadeValue, self.currentFadeValue, self.currentFadeValue, self.maxFadeValue))
			else
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.gameScene, 0, 0, 0,tocolor(self.currentFadeValue, self.currentFadeValue, self.currentFadeValue, self.maxFadeValue))
			end
		else
			dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.gameScene, 0, 0, 0,tocolor(self.maxFadeValue, self.maxFadeValue, self.maxFadeValue, self.maxFadeValue))
		end
	end
end


function RenderClassC:getGameResult()
	return self.gameScene
end


function RenderClassC:clear()
	removeEventHandler("MKFADESCREEN", root, self.m_ToggleScreenFade)
	removeEventHandler("MKTOGGLEBLURSHADER", root, self.m_ToggleBlurShader)
	
	self:disableBlurShader()
	
	if (self.screenSource) then
		self.screenSource:destroy()
		self.screenSource = nil
	end
	
	if (self.renderTargetFinal) then
		self.renderTargetFinal:destroy()
		self.renderTargetFinal = nil
	end
	
	if (self.pictureQualityShader) then
		self.pictureQualityShader:destroy()
		self.pictureQualityShader = nil
	end
end


function RenderClassC:destructor()
	self:clear()
	
	mainOutput("RenderClassC was deleted.")
end
