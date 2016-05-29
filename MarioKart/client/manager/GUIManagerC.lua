--[[
	Filename: GUIManagerC.lua
	Authors: Sam@ke
--]]

GUIManagerC = {}


function GUIManagerC:constructor(parent, dataManager)
	mainOutput("GUIManagerC was loaded.")

	self.mainClass = parent
	self.dataManager = dataManager
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.scaleFactor = (1 / 1080) * self.screenHeight

	self:init()
end


function GUIManagerC:init()
	
	self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	
	self.textures = {}
	self.textures.closeButtonN = dxCreateTexture("res/textures/dxLibs/closeN.png")
	self.textures.closeButtonH = dxCreateTexture("res/textures/dxLibs/closeH.png")
	self.textures.closeButtonC = dxCreateTexture("res/textures/dxLibs/closeC.png")
	self.textures.toggleON = dxCreateTexture("res/textures/dxLibs/toggleON.png")
	self.textures.toggleOFF = dxCreateTexture("res/textures/dxLibs/toggleOFF.png")
	self.textures.sliderToggle = dxCreateTexture("res/textures/dxLibs/sliderToggle.png")
	self.textures.unknown = dxCreateTexture("res/textures/misc/unknown.png")
	self.textures.starN = dxCreateTexture("res/textures/misc/starN.png")
	self.textures.starA = dxCreateTexture("res/textures/misc/starA.png")
	self.textures.starS = dxCreateTexture("res/textures/misc/starS.png")
	self.textures.babyluigiMap = dxCreateTexture("res/textures/maps/babyluigiMap.png")
	self.textures.babyLuigiName = dxCreateTexture("res/textures/maps/babyLuigiName.png")
	self.textures.daisyMap = dxCreateTexture("res/textures/maps/daisyMap.png")
	self.textures.daisyName = dxCreateTexture("res/textures/maps/daisyName.png")
	self.textures.desertMap = dxCreateTexture("res/textures/maps/desertMap.png")
	self.textures.desertName = dxCreateTexture("res/textures/maps/desertName.png")
	self.textures.diddyMap = dxCreateTexture("res/textures/maps/diddyMap.png")
	self.textures.diddyName = dxCreateTexture("res/textures/maps/diddyName.png")
	self.textures.donkeyMap = dxCreateTexture("res/textures/maps/donkeyMap.png")
	self.textures.donkeyName = dxCreateTexture("res/textures/maps/donkeyName.png")
	self.textures.koopaMap = dxCreateTexture("res/textures/maps/koopaMap.png")
	self.textures.koopaName = dxCreateTexture("res/textures/maps/koopaName.png")
	self.textures.luigiMap = dxCreateTexture("res/textures/maps/luigiMap.png")
	self.textures.luigiName = dxCreateTexture("res/textures/maps/luigiName.png")
	self.textures.marioMap = dxCreateTexture("res/textures/maps/marioMap.png")
	self.textures.marioName = dxCreateTexture("res/textures/maps/marioName.png")
	self.textures.mini1Map = dxCreateTexture("res/textures/maps/mini1Map.png")
	self.textures.mini1Name = dxCreateTexture("res/textures/maps/mini1Name.png")
	self.textures.mini2Map = dxCreateTexture("res/textures/maps/mini2Map.png")
	self.textures.mini2Name = dxCreateTexture("res/textures/maps/mini2Name.png")
	self.textures.mini3Map = dxCreateTexture("res/textures/maps/mini3Map.png")
	self.textures.mini3Name = dxCreateTexture("res/textures/maps/mini3Name.png")
	self.textures.mini5Map = dxCreateTexture("res/textures/maps/mini5Map.png")
	self.textures.mini5Name = dxCreateTexture("res/textures/maps/mini5Name.png")
	self.textures.mini7Map = dxCreateTexture("res/textures/maps/mini7Map.png")
	self.textures.mini7Name = dxCreateTexture("res/textures/maps/mini7Name.png")
	self.textures.mini8Map = dxCreateTexture("res/textures/maps/mini8Map.png")
	self.textures.mini8Name = dxCreateTexture("res/textures/maps/mini8Name.png")
	self.textures.nokonokoMap = dxCreateTexture("res/textures/maps/nokonokoMap.png")
	self.textures.nokonokoName = dxCreateTexture("res/textures/maps/nokonokoName.png")
	self.textures.patapataMap = dxCreateTexture("res/textures/maps/patapataMap.png")
	self.textures.patapataName = dxCreateTexture("res/textures/maps/patapataName.png")
	self.textures.peachMap = dxCreateTexture("res/textures/maps/peachMap.png")
	self.textures.peachName = dxCreateTexture("res/textures/maps/peachName.png")
	self.textures.rainbowMap = dxCreateTexture("res/textures/maps/rainbowMap.png")
	self.textures.rainbowName = dxCreateTexture("res/textures/maps/rainbowName.png")
	self.textures.snowMap = dxCreateTexture("res/textures/maps/snowMap.png")
	self.textures.snowName = dxCreateTexture("res/textures/maps/snowName.png")
	self.textures.waluigiMap = dxCreateTexture("res/textures/maps/waluigiMap.png")
	self.textures.waluigiName = dxCreateTexture("res/textures/maps/waluigiName.png")
	self.textures.warioMap = dxCreateTexture("res/textures/maps/warioMap.png")
	self.textures.warioName = dxCreateTexture("res/textures/maps/warioName.png")
	self.textures.yoshiMap = dxCreateTexture("res/textures/maps/yoshiMap.png")
	self.textures.yoshiName = dxCreateTexture("res/textures/maps/yoshiName.png")
	
	self.fonts = {}
	self.fonts.mario8 = dxCreateFont("res/fonts/SuperMario.ttf", 8, false, "cleartype")
	self.fonts.mario10 = dxCreateFont("res/fonts/SuperMario.ttf", 10, false, "cleartype")
	self.fonts.mario12 = dxCreateFont("res/fonts/SuperMario.ttf", 12, false, "cleartype")
	self.fonts.mario14 = dxCreateFont("res/fonts/SuperMario.ttf", 14, false, "cleartype")
	self.fonts.mario18 = dxCreateFont("res/fonts/SuperMario.ttf", 18, false, "cleartype")
	self.fonts.mario20 = dxCreateFont("res/fonts/SuperMario.ttf", 20, false, "cleartype")
	
	self.m_ToggleUserPanel = bind(self.toggleUserPanel, self)
	bindKey(getKeyToggleUserPanel(), "down", self.m_ToggleUserPanel)
	
	self.m_DisableUserPanel = bind(self.disableUserPanel, self)
	addEvent("MKCLOSEUSERPANEL", true)
	addEventHandler("MKCLOSEUSERPANEL", root, self.m_DisableUserPanel)
	
	self.isLoaded = self.renderTarget
end


function GUIManagerC:toggleUserPanel()
	if (self.userPanel) then
		self:disableUserPanel()
	else
		self:enableUserPanel()
	end
end


function GUIManagerC:enableUserPanel()
	if (not self.userPanel) then
		self.userPanel = new(GUIUserPanelC, self, self.dataManager)
	end
end


function GUIManagerC:disableUserPanel()
	if (self.userPanel) then
		delete(self.userPanel)
		self.userPanel = nil
	end
end


function GUIManagerC:update()
	if (self.isLoaded) then
		if (self.userPanel) then
			self.userPanel:update()
		end
	end
end


function GUIManagerC:getGUIResult()
	return self.renderTarget
end


function GUIManagerC:clear()
	unbindKey(getKeyToggleUserPanel(), "down", self.m_ToggleUserPanel)
	removeEventHandler("MKCLOSEUSERPANEL", root, self.m_DisableUserPanel)
	
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
	
	for index, texture in pairs(self.textures) do
		if (texture) then
			texture:destroy()
			texture = nil
		end
	end
	
	for index, font in pairs(self.fonts) do
		if (font) then
			font:destroy()
			font = nil
		end
	end
	
	self:disableUserPanel()
end


function GUIManagerC:destructor()
	self:clear()
	
	mainOutput("GUIManagerC was deleted.")
end
