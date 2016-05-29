--[[
	Filename: GUITABStatisticsC.lua
	Authors: Sam@ke
--]]

GUITABStatisticsC = {}


function GUITABStatisticsC:constructor(parent, window, dataManager)
	mainOutput("GUITABStatisticsC was loaded.")

	self.userPanel = parent
	self.window = window
	self.dataManager = dataManager

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.scaleFactor = (1 / 1080) * self.screenHeight

	self.fonts = self.window.fonts
	self.fontSize = self.window.cFontSize or 1
	self.postGUI = self.window.postGUI or false
	self.subPixelPositioning = self.window.subPixelPositioning or false
	
	self:init()
end


function GUITABStatisticsC:init()
	self.logo = dxCreateTexture("res/textures/icons/statistics_icon.png")
	
	self.isLoaded = self.userPanel and self.window and self.dataManager and self.logo and self.fonts and self.fontSize
end


function GUITABStatisticsC:update()
	
	if (self.isLoaded) then
		self.x = self.window.contentArea.x
		self.y = self.window.contentArea.y
		self.width = self.window.contentArea.w
		self.height = self.window.contentArea.h
		self.lineSize = self.height / 20
	end
		
	self.isLoaded = self.isLoaded and self.x and self.y and self.width and self.height
	
	if (self.isLoaded) then
		self.rowWidth = self.width / 3
		self.xFirstRow = self.x + (self.rowWidth * 0)
		self.xSecondRow = self.x + (self.rowWidth * 1)
		self.xThirdRow = self.x + (self.rowWidth * 2)

				
		-- // bg // --
		dxDrawImage(self.x + (self.width * 0.5) - (self.height * 0.5), self.y, self.height, self.height, self.logo, 0, 0, 0, tocolor(95, 95, 95, 24), self.postGUI)
			
		-- // first row // --
		self.tx = self.xFirstRow + 5
		self.ty = self.y + (self.height * 0.1)
		dxDrawText("Statistics...", self.tx, self.ty, self.tx + self.rowWidth, self.ty + self.lineSize, tocolor(200, 200, 200, 200), self.fontSize, self.fonts.mario14, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
	
		-- // second row // --
		
		-- // third row // --
	end
end


function GUITABStatisticsC:clear()
	if (self.logo) then
		self.logo:destroy()
		self.logo = nil
	end
end


function GUITABStatisticsC:destructor()
	self:clear()
	
	mainOutput("GUITABStatisticsC was deleted.")
end
