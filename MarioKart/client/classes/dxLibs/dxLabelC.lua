--[[
	Filename: dxLabelC.lua
	Authors: Sam@ke
--]]

dxLabelC = {}

function dxLabelC:constructor(parent, labelProperties)

	self.window = parent
	self.baseProperties = labelProperties
	
	self.id = self.baseProperties.id
	self.screenWidth = self.baseProperties.screenWidth
	self.screenHeight = self.baseProperties.screenHeight
	self.x = self.baseProperties.x
	self.y = self.baseProperties.y
	self.width = self.baseProperties.width
	self.height = self.baseProperties.height
	self.textColorR = self.baseProperties.textColorR or 255
	self.textColorG = self.baseProperties.textColorG or 255
	self.textColorB = self.baseProperties.textColorB or 255
	self.alpha = self.baseProperties.alpha or 255
	self.subPixelPositioning = self.baseProperties.subPixelPositioning or false
	self.postGUI = self.baseProperties.postGUI or false
	self.text = self.baseProperties.text or ""
	self.alignX = self.baseProperties.alignX or "center"
	self.font = self.baseProperties.font or "default-bold"
	self.fontSize = self.baseProperties.fontSize or 1
	
	self.isComplete = self.id and self.screenWidth and self.screenHeight and self.x and self.y and self.width and self.height
	
	mainOutput("Label " .. self.id .. " was created.")
end


function dxLabelC:update()
	if (self.isComplete) then
		-- // TEXT // --
		dxDrawText(removeHEXColorCode(self.text), self.x + 1, self.y + 1, self.x + self.width + 1, self.y + self.height + 1, tocolor(0, 0, 0, self.alpha), self.fontSize, self.font, self.alignX, "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.textColorR, self.textColorG, self.textColorB, self.alpha), self.fontSize, self.font, self.alignX, "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
	end
end


function dxLabelC:setText(text)
	if (text) then
		self.text = text
	end
end


function dxLabelC:destructor()

	mainOutput("Label " .. self.id .. " was destroyed.")
end