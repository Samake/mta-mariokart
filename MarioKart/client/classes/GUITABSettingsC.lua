--[[
	Filename: GUITABSettingsC.lua
	Authors: Sam@ke
--]]

GUITABSettingsC = {}


function GUITABSettingsC:constructor(parent, window, dataManager)
	mainOutput("GUITABSettingsC was loaded.")

	self.userPanel = parent
	self.window = window
	self.dataManager = dataManager

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.scaleFactor = (1 / 1080) * self.screenHeight
	
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	self.lineSize = 0
	self.rowWidth = 0

	self.fonts = self.window.fonts
	self.fontSize = self.window.cFontSize or 1
	self.fontColor = tocolor(220, 220, 220, 220)
	self.postGUI = self.window.postGUI or false
	self.subPixelPositioning = self.window.subPixelPositioning or false
	
	self.fps = 0
	self.ping = 0
	
	self.contentAdded = "false"
	self.contentList = {}
	
	self.informationText = nil
	
	self:init()
end


function GUITABSettingsC:init()
	self.logo = dxCreateTexture("res/textures/icons/settings_icon.png")
	self.screenSource = dxCreateScreenSource(self.screenWidth, self.screenHeight)
	
	self.isLoaded = self.userPanel and self.window and self.logo and self.screenSource and self.fonts and self.fontSize and self.dataManager
end


function GUITABSettingsC:addContent()
	if (self.contentAdded == "false") and (self.isLoaded) then
	
		self.settings = self.dataManager:getSettings()
		
		local toggleProperties = {}
		toggleProperties.id = "AllShadersToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 2
		toggleProperties.row = 1
		toggleProperties.state = self.settings.shadersEnabled or "true"
		toggleProperties.text = "All shaders"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99MarioKart shaders:\n\nEnabling shaders will have an #EE2222high #FFDD99\nperformance impact, but game looks\nmuch better with enables shaders!"

		if (not self.contentList.toggleShaders) then
			self.contentList.toggleShaders = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "BlurShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 3
		toggleProperties.row = 1
		toggleProperties.state = self.settings.blurShaderEnabled or "true"
		toggleProperties.text = "Blur shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Blur shader:\n\nEnabling this will have an #FFDD11medium #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleBlurShader) then
			self.contentList.toggleBlurShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "WaterShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 4
		toggleProperties.row = 1
		toggleProperties.state = self.settings.waterShaderEnabled or "true"
		toggleProperties.text = "Water shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Water shader:\n\nEnabling this will have an #22EE22low #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleWaterShader) then
			self.contentList.toggleWaterShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "BoostFieldShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 5
		toggleProperties.row = 1
		toggleProperties.state = self.settings.boostFieldShaderEnabled or "true"
		toggleProperties.text = "Boostfield shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Boostfield shader:\n\nEnabling this will have an #22EE22low #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleBoostFieldShader) then
			self.contentList.toggleBoostFieldShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "DynamicLightShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 6
		toggleProperties.row = 1
		toggleProperties.state = self.settings.ambientLightShaderEnabled or "true"
		toggleProperties.text = "Dynamic light shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Dynamic light shader:\n\nEnabling this will have an #FFDD11medium #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleDynamicLightShader) then
			self.contentList.toggleDynamicLightShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "DoFShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 7
		toggleProperties.row = 1
		toggleProperties.state = self.settings.dofShaderEnabled or "true"
		toggleProperties.text = "DoF shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99DoF shader:\n\nEnabling this will have an #EE2222high #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleDoFShader) then
			self.contentList.toggleDoFShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "ItemShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 8
		toggleProperties.row = 1
		toggleProperties.state = self.settings.itemShaderEnabled or "true"
		toggleProperties.text = "Item shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Item shader:\n\nEnabling this will have an #22EE22low #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleItemShader) then
			self.contentList.toggleItemShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "CoinShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 9
		toggleProperties.row = 1
		toggleProperties.state = self.settings.coinShaderEnabled or "true"
		toggleProperties.text = "Coin shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Coin shader:\n\nEnabling this will have an #22EE22low #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleCoinShader) then
			self.contentList.toggleCoinShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "SkyBoxShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 10
		toggleProperties.row = 1
		toggleProperties.state = self.settings.skyBoxShaderEnabled or "true"
		toggleProperties.text = "SkyBox shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99SkyBox shader:\n\nEnabling this will have an #22EE22low #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleSkyBoxShader) then
			self.contentList.toggleSkyBoxShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "SunShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 11
		toggleProperties.row = 1
		toggleProperties.state = self.settings.sunShaderEnabled or "true"
		toggleProperties.text = "Sun shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Sun shader:\n\nEnabling this will have an #FFDD11medium #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleSunShader) then
			self.contentList.toggleSunShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "GodrayShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 12
		toggleProperties.row = 1
		toggleProperties.state = self.settings.godraysEnabled or "true"
		toggleProperties.text = "Godray shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Godray shader:\n\nEnabling this will have an #EE2222high #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleGodrayShader) then
			self.contentList.toggleGodrayShader = new(dxToggleC, self, toggleProperties)
		end
		
		local toggleProperties = {}
		toggleProperties.id = "LensflareShaderToggle"
		toggleProperties.screenWidth = self.width
		toggleProperties.screenHeight = self.height
		toggleProperties.width = self.rowWidth * 0.9
		toggleProperties.height = self.lineSize
		toggleProperties.line = 13
		toggleProperties.row = 1
		toggleProperties.state = self.settings.lensflareEnabled or "true"
		toggleProperties.text = "Lensflare shader"
		toggleProperties.alignX = "left"
		toggleProperties.font = self.fonts.mario12
		toggleProperties.fontSize = self.fontSize
		toggleProperties.textColorR = 220
		toggleProperties.textColorG = 220
		toggleProperties.textColorB = 220
		toggleProperties.textHighLightColorR = 95
		toggleProperties.textHighLightColorG = 220
		toggleProperties.textHighLightColorB = 95
		toggleProperties.textures = {}
		toggleProperties.textures.toggleON = self.window.textures.toggleON
		toggleProperties.textures.toggleOFF = self.window.textures.toggleOFF
		toggleProperties.informationText = "\n#FFDD99Lensflare shader:\n\nEnabling this will have an #FFDD11medium #FFDD99\nperformance impact."
		
		if (not self.contentList.toggleLensflareShader) then
			self.contentList.toggleLensflareShader = new(dxToggleC, self, toggleProperties)
		end
		
		local sliderProperties = {}
		sliderProperties.id = "BRIGHTNESSSLIDER"
		sliderProperties.screenWidth = self.width
		sliderProperties.screenHeight = self.height
		sliderProperties.width = self.rowWidth * 0.9
		sliderProperties.height = self.lineSize
		sliderProperties.line = 2
		sliderProperties.row = 2
		sliderProperties.text = "Brightness"
		sliderProperties.value = self.settings.brightness * 100 or 100
		sliderProperties.font = self.fonts.mario12
		sliderProperties.fontSize = self.fontSize
		sliderProperties.textColorR = 220
		sliderProperties.textColorG = 220
		sliderProperties.textColorB = 220
		sliderProperties.textHighLightColorR = 95
		sliderProperties.textHighLightColorG = 220
		sliderProperties.textHighLightColorB = 95
		sliderProperties.textures = {}
		sliderProperties.textures.sliderToggle = self.window.textures.sliderToggle
		sliderProperties.informationText = "\n#FFDD99Brightness:\n\nChanging this will have #22EE22NO #FFDD99\nperformance impact!"

		if (not self.contentList.brightnessSlider) then
			self.contentList.brightnessSlider = new(dxSliderC, self, sliderProperties)
		end
		
		local sliderProperties = {}
		sliderProperties.id = "CONTRASTSLIDER"
		sliderProperties.screenWidth = self.width
		sliderProperties.screenHeight = self.height
		sliderProperties.width = self.rowWidth * 0.9
		sliderProperties.height = self.lineSize
		sliderProperties.line = 4
		sliderProperties.row = 2
		sliderProperties.text = "Contrast"
		sliderProperties.value = self.settings.contrast * 100 or 100
		sliderProperties.font = self.fonts.mario12
		sliderProperties.fontSize = self.fontSize
		sliderProperties.textColorR = 220
		sliderProperties.textColorG = 220
		sliderProperties.textColorB = 220
		sliderProperties.textHighLightColorR = 95
		sliderProperties.textHighLightColorG = 220
		sliderProperties.textHighLightColorB = 95
		sliderProperties.textures = {}
		sliderProperties.textures.sliderToggle = self.window.textures.sliderToggle
		sliderProperties.informationText = "\n#FFDD99Contrast:\n\nChanging this will have #22EE22NO #FFDD99\nperformance impact!"

		if (not self.contentList.contrastSlider) then
			self.contentList.contrastSlider = new(dxSliderC, self, sliderProperties)
		end
		
		local sliderProperties = {}
		sliderProperties.id = "SATURATIONSLIDER"
		sliderProperties.screenWidth = self.width
		sliderProperties.screenHeight = self.height
		sliderProperties.width = self.rowWidth * 0.9
		sliderProperties.height = self.lineSize
		sliderProperties.line = 6
		sliderProperties.row = 2
		sliderProperties.text = "Saturation"
		sliderProperties.value = self.settings.saturation * 100 or 100
		sliderProperties.font = self.fonts.mario12
		sliderProperties.fontSize = self.fontSize
		sliderProperties.textColorR = 220
		sliderProperties.textColorG = 220
		sliderProperties.textColorB = 220
		sliderProperties.textHighLightColorR = 95
		sliderProperties.textHighLightColorG = 220
		sliderProperties.textHighLightColorB = 95
		sliderProperties.textures = {}
		sliderProperties.textures.sliderToggle = self.window.textures.sliderToggle
		sliderProperties.informationText = "\n#FFDD99Saturation:\n\nChanging this will have #22EE22NO #FFDD99\nperformance impact!"

		if (not self.contentList.saturationSlider) then
			self.contentList.saturationSlider = new(dxSliderC, self, sliderProperties)
		end
		
		self.contentAdded = "true"
	end
end


function GUITABSettingsC:update()
	
	if (self.isLoaded) then
		self.x = self.window.contentArea.x
		self.y = self.window.contentArea.y
		self.width = self.window.contentArea.w
		self.height = self.window.contentArea.h
		self.lineSize = self.height / 20
		self.fontSize = self.window.cFontSize
		self.rowWidth = self.width / 3
		self.xFirstRow = self.x + (self.rowWidth * 0)
		self.xSecondRow = self.x + (self.rowWidth * 1)
		self.xThirdRow = self.x + (self.rowWidth * 2)
		
		self:addContent()
		self.screenSource:update()

		if (self.window.parent) then
			if (self.window.parent.guiManager) then
				if (self.window.parent.guiManager.mainClass) then
					if (self.window.parent.guiManager.mainClass.renderClass) then
						self.gameScene = self.window.parent.guiManager.mainClass.renderClass:getGameResult()
					else
						self.gameScene = nil
					end
					
					if (self.window.parent.guiManager.mainClass.dataManager) then
						self.fps = self.window.parent.guiManager.mainClass.dataManager:getFPS()
						self.ping = self.window.parent.guiManager.mainClass.dataManager:getPing()
					else
						self.fps = 0
						self.ping = 0
					end
				end
			end
		end
		
		for index, contentClass in pairs(self.contentList) do 
			if (contentClass) then
				contentClass:update()
			end
		end
		
		-- // bg // --
		dxDrawImage(self.x + (self.width * 0.5) - (self.height * 0.5), self.y, self.height, self.height, self.logo, 0, 0, 0, tocolor(95, 95, 95, 24), self.postGUI)
		
		-- // first row // --
		self.t1x = self.xFirstRow + 15
		self.t1y = self.y + self.lineSize * 1
		
		-- // fps // --
		if (self.fps > 30) then
			dxDrawText("#EEEEEEFPS: #22EE22" .. self.fps, self.t1x, self.t1y, self.t1x + self.rowWidth, self.t1y + self.lineSize, self.fontColor, self.fontSize, self.fonts.mario12, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEFPS: #EE2222" .. self.fps, self.t1x, self.t1y, self.t1x + self.rowWidth, self.t1y + self.lineSize, self.fontColor, self.fontSize, self.fonts.mario12, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // second row // --
		self.t2x = self.xSecondRow + 15
		self.t2y = self.y + self.lineSize * 1
		
		-- // ping // --
		if (self.ping < 90) then
			dxDrawText("#EEEEEEPing: #22EE22" .. self.ping, self.t2x, self.t2y, self.t2x + self.rowWidth, self.t2y + self.lineSize, self.fontColor, self.fontSize, self.fonts.mario12, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		elseif (self.ping < 180) then
			dxDrawText("#EEEEEEPing: #EEEE22" .. self.ping, self.t2x, self.t2y, self.t2x + self.rowWidth, self.t2y + self.lineSize, self.fontColor, self.fontSize, self.fonts.mario12, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		elseif (self.ping > 180) then
			dxDrawText("#EEEEEEPing: #EE2222" .. self.ping, self.t2x, self.t2y, self.t2x + self.rowWidth, self.t2y + self.lineSize, self.fontColor, self.fontSize, self.fonts.mario12, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // third row // --
		
		-- // preview // -- 
		self.px = self.xThirdRow
		self.py = self.y + self.lineSize * 1
		self.pHeight = (self.height - self.lineSize * 3) / 2
		self.pWidth = self.rowWidth * 0.9
		
		dxDrawRectangle(self.px, self.py, self.pWidth, self.pHeight, tocolor(0, 0, 0, 255), self.postGUI, self.subPixelPositioning)

		if (isElement(self.gameScene)) then
			dxDrawImage(self.px + 2, self.py + 2, self.pWidth - 4, self.pHeight - 4, self.gameScene, 0, 0, 0, tocolor(255, 255, 255, 255), self.postGUI)
		else
			dxDrawImage(self.px + 2, self.py + 2, self.pWidth - 4, self.pHeight - 4, self.screenSource, 0, 0, 0, tocolor(255, 255, 255, 255), self.postGUI)
		end
			
		-- // info box // -- 
		self.ibx = self.xThirdRow
		self.iby = self.py + self.pHeight + self.lineSize
		self.ibWidth = self.pWidth
		self.ibHeight = self.pHeight
		
		dxDrawRectangle(self.ibx, self.iby, self.ibWidth, self.ibHeight, tocolor(25, 25, 25, 95), self.postGUI, self.subPixelPositioning)
		dxDrawText("Information:", self.ibx + 5, self.iby, self.ibx + self.rowWidth, self.iby + self.lineSize, self.fontColor, self.fontSize, self.fonts.mario12, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
	
		if (self.informationText) then
			dxDrawText(self.informationText, self.ibx + 5, self.iby + self.lineSize, self.ibx + self.rowWidth, self.iby + (self.ibHeight - self.lineSize), self.fontColor, self.fontSize, self.fonts.mario12, "left", "top", true, true, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
	end
	
	self.informationText = nil
end


function GUITABSettingsC:setInformationText(text)
	self.informationText = text
end


function GUITABSettingsC:clear()
	
	if (self.logo) then
		self.logo:destroy()
		self.logo = nil
	end
	
	if (self.screenSource) then
		self.screenSource:destroy()
		self.screenSource = nil
	end
	
	for index, contentClass in pairs(self.contentList) do 
		if (contentClass) then
			delete(contentClass)
			contentClass = nil
		end
	end
end


function GUITABSettingsC:destructor()
	self:clear()
	
	mainOutput("GUITABSettingsC was deleted.")
end
