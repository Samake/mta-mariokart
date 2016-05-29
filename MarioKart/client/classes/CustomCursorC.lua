--[[
	Filename: CustomCursorC.lua
	Author: Sam@ke
--]]

CustomCursorC = {}

function CustomCursorC:constructor(parent)
	
	mainOutput("CustomCursorC was loaded.")
	
	self.mainClass = parent
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.cursorSize = self.screenHeight * 0.045
	self.alpha = 0
	self.cursorX, self.cursorY = 0, 0
	
	self.color = tocolor(255, 255, 255, self.alpha)
	
	self.postGUI = true

	self.cursorTexture = dxCreateTexture("res/textures/misc/cursorHand.png")
end


function CustomCursorC:update()
	if (isCursorShowing()) then
		setCursorAlpha(0)
		
		self.alpha = self.alpha + 25
		
		if (self.alpha >= 255) then
			self.alpha = 255
		end
	else
		self.alpha = self.alpha - 25
		
		if (self.alpha <= 0) then
			self.alpha = 0
		end	
	end
	
	if (getKeyState("mouse1")) then
		self.color = tocolor(255, 200, 55, self.alpha)
	else
		self.color = tocolor(255, 255, 255, self.alpha)
	end
	
	if (self.alpha >= 0) then
		self.cursorX, self.cursorY = getCursorPosition()
		if (self.cursorX) and (self.cursorY) then
			dxDrawImage(self.screenWidth * self.cursorX, self.screenHeight * self.cursorY, self.cursorSize, self.cursorSize, self.cursorTexture, 0, 0, 0, self.color, self.postGUI)
		end
	end
end


function CustomCursorC:destructor()

	if (self.cursorTexture) then
		self.cursorTexture:destroy()
		self.cursorTexture = nil
	end
	
	setCursorAlpha(255)
	
	mainOutput("CustomCursorC was deleted.")
end