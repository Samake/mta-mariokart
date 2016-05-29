--[[
	Filename: GUIUserPanelC.lua
	Authors: Sam@ke
--]]

GUIUserPanelC = {}


function GUIUserPanelC:constructor(parent, dataManager)
	mainOutput("GUIUserPanelC was loaded.")

	self.guiManager = parent
	self.dataManager = dataManager

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.renderTarget = self.guiManager.renderTarget
	self.scaleFactor = (1 / 1080) * self.screenHeight
	
	self.fonts = self.guiManager.fonts
	self.textures = self.guiManager.textures
	
	self.width = self.screenWidth * 0.8
	self.height = self.screenHeight * 0.8

	triggerEvent("MKFADESCREEN", root, "true")
	
	self:init()
end


function GUIUserPanelC:init()

	self.m_TriggerUserPanelEvent = bind(self.triggerUserPanelEvent, self)
	addEvent("MKTRIGGERUSERPANELEVENT", true)
	addEventHandler("MKTRIGGERUSERPANELEVENT", root, self.m_TriggerUserPanelEvent)

	self.window = new(dxWindowC, self)
	self.window:setID("ID1")
	self.window:setTitleBar("false")
	self.window:setTitle("MK - UserPanel v0.1")
	self.window:setPosition((self.screenWidth * 0.5) - (self.width * 0.5), (self.screenHeight * 0.5) - (self.height * 0.5))
	self.window:setSize(self.width, self.height)
	self.window:setColor(15, 15, 15, 180)
	self.window:setBorderSize(1)
	self.window:setBorderColor(0, 0, 0, 200)
	self.window:setFontSize(0.65)
	self.window:setSubPixelPositioning(false)
	self.window:setPostGUI(true)
	
	self.tabStatitics = new(GUITABStatisticsC, self, self.window, self.dataManager)
	self.window:addTab("Statistics", self.tabStatitics)
	
	self.tabMapShop = new(GUITABMapShopC, self, self.window, self.dataManager)
	self.window:addTab("MapShop", self.tabMapShop)
	
	self.tabSettings = new(GUITABSettingsC, self, self.window, self.dataManager)
	self.window:addTab("Settings", self.tabSettings)
	
	showCursor(true, false)
	
	self.isLoaded = self.guiManager and self.window
end


function GUIUserPanelC:update()
	dxSetRenderTarget(self.renderTarget, true)
	
	if (self.isLoaded) then
		self.window:update()
	end
	
	dxSetRenderTarget()
end


function GUIUserPanelC:triggerUserPanelEvent(id, type, value)
	if (id) and (type) then
		if (type == "TOGGLE") then
			if (value) then
				if (id == "AllShadersToggle") then
					triggerEvent("MKTOGGLEALLSHADERS", root, value)
				elseif (id == "BlurShaderToggle") then
					triggerEvent("MKTOGGLEBLURSHADER", root, value)
				elseif (id == "WaterShaderToggle") then
					triggerEvent("MKTOGGLEWATERSHADER", root, value)
				elseif (id == "BoostFieldShaderToggle") then
					triggerEvent("MKTOGGLEBOOSTFIELDSHADER", root, value)
				elseif (id == "DynamicLightShaderToggle") then
					triggerEvent("MKTOGGLEDYNAMICLIGHTSHADER", root, value)
				elseif (id == "DoFShaderToggle") then
					triggerEvent("MKTOGGLEDOFSHADER", root, value)
				elseif (id == "ItemShaderToggle") then
					triggerEvent("MKTOGGLEITEMSHADER", root, value)
				elseif (id == "CoinShaderToggle") then
					triggerEvent("MKTOGGLECOINSHADER", root, value)
				elseif (id == "SkyBoxShaderToggle") then
					triggerEvent("MKTOGGLESKYBOXSHADER", root, value)
				elseif (id == "SunShaderToggle") then
					triggerEvent("MKTOGGLESUNSHADER", root, value)
					
					if (value == "false") then
						triggerEvent("MKTOGGLEGODRAYSHADER", root, value)
						self.tabSettings.contentList.toggleGodrayShader.state = value
						triggerEvent("MKTOGGLELENSFLARESHADER", root, value)
						self.tabSettings.contentList.toggleLensflareShader.state = value
					else
						self.settings = self.dataManager:getSettings()
						
						if (self.settings.godraysEnabled == "true") then
							triggerEvent("MKTOGGLEGODRAYSHADER", root, value)
							self.tabSettings.contentList.toggleGodrayShader.state = value
						end
						
						if (self.settings.lensflareEnabled == "true") then
							triggerEvent("MKTOGGLELENSFLARESHADER", root, value)
							self.tabSettings.contentList.toggleLensflareShader.state = value
						end
					end
				elseif (id == "GodrayShaderToggle") then
					triggerEvent("MKTOGGLEGODRAYSHADER", root, value)
				elseif (id == "LensflareShaderToggle") then
					triggerEvent("MKTOGGLELENSFLARESHADER", root, value)
				end
			end
		elseif (type == "SLIDER") then
			if (value) then
				if (id == "BRIGHTNESSSLIDER") then
					triggerEvent("MKSETBRIGHTNESS", root, value)
				elseif (id == "CONTRASTSLIDER") then
					triggerEvent("MKSETCONTRAST", root, value)
				elseif (id == "SATURATIONSLIDER") then
					triggerEvent("MKSETSATURATION", root, value)
				end
			end
		end
	end
end


function GUIUserPanelC:clear()
	
	removeEventHandler("MKTRIGGERUSERPANELEVENT", root, self.m_TriggerUserPanelEvent)
	
	if (self.window) then
		delete(self.window)
		self.window = nil
	end
	
	if (self.tabStatitics) then
		delete(self.tabStatitics)
		self.tabStatitics = nil
	end
	
	if (self.tabMapShop) then
		delete(self.tabMapShop)
		self.tabMapShop = nil
	end
	
	if (self.tabSettings) then
		delete(self.tabSettings)
		self.tabSettings = nil
	end
	
	showCursor(false, false)
end


function GUIUserPanelC:destructor()
	self:clear()
	
	triggerEvent("MKFADESCREEN", root, "false")
	triggerEvent("MKSAVESETTINGS", root)
	
	mainOutput("GUIUserPanelC was deleted.")
end
