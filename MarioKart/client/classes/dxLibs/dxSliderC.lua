--[[
	Filename: dxSliderC.lua
	Authors: Sam@ke
--]]

dxSliderC = {}

function dxSliderC:constructor(parent, toggleProperties)

	self.parent = parent
	self.baseProperties = toggleProperties
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.id = self.baseProperties.id
	self.type = "SLIDER"
	self.x = 0
	self.y = 0
	self.width = self.baseProperties.width or 0
	self.height = self.baseProperties.height or 0
	self.line = self.baseProperties.line or 1
	self.row = self.baseProperties.row or 1
	self.alpha = self.baseProperties.alpha or 255
	self.subPixelPositioning = self.baseProperties.subPixelPositioning or true
	self.postGUI = self.baseProperties.postGUI or true
	self.text = self.baseProperties.text or ""
	self.value = math.round(self.baseProperties.value / 100, 1) or math.round(0.5, 1)
	self.font = self.baseProperties.font or "default-bold"
	self.fontSize = self.baseProperties.fontSize or 1
	self.textLength = string.len(self.text)
	self.textColorR = self.baseProperties.textColorR or 255
	self.textColorG = self.baseProperties.textColorG or 255
	self.textColorB = self.baseProperties.textColorB or 255
	self.textHighLightColorR = self.baseProperties.textHighLightColorR or 255
	self.textHighLightColorG = self.baseProperties.textHighLightColorG or 255
	self.textHighLightColorB = self.baseProperties.textHighLightColorB or 0
	self.sliderToggle = self.baseProperties.textures.sliderToggle
	self.informationText = self.baseProperties.informationText
	
	self.isAbleToSlide = "false"
	
	self.cursorX, self.cursorY = nil, nil
	
	self.m_OnClientClick = bind(self.onClientClick, self)
	addEventHandler("onClientClick", root, self.m_OnClientClick)
	
	self.isComplete = 	self.parent 
						and self.id 
						and self.sliderToggle 
	
	--mainOutput("Slider " .. self.id .. " was created.")
end


function dxSliderC:update()
	if (self.isComplete) then
		self.cursorX, self.cursorY = getCursorPosition()
		self.cursorX, self.cursorY = getCursorPosition()
		self.cursorX = self.cursorX * self.screenWidth
		self.cursorY = self.cursorY * self.screenHeight
		
		self.width = self.parent.rowWidth * 0.9
		self.height = self.parent.lineSize
		
		if (self.row == 1) then
			self.x = self.parent.xFirstRow + 15
		elseif (self.row == 2) then
			self.x = self.parent.xSecondRow + 15
		elseif (self.row == 3) then
			self.x = self.parent.xThirdRow + 15
		end

		self.y = self.parent.y + self.parent.lineSize * self.line
		self.fontSize = self.parent.fontSize
		self.sliderWidth = self.width
		self.sliderHeight = self.height
		self.sliderX = self.x + (self.width * tonumber(self.value)) - (self.height * 0.9) * 0.5
		self.sliderY = self.y + self.parent.lineSize

		if (self.cursorX > self.x) and (self.cursorX < self.x + self.width) then
			if (self.cursorY > self.y) and (self.cursorY < self.y + self.height * 2) then
				self.isAbleToSlide = "true"
			else
				self.isAbleToSlide = "false"
			end
		else
			self.isAbleToSlide = "false"
		end
		
		if (self.isAbleToSlide == "true") then
			self.textColorCurrentR = self.textHighLightColorR
			self.textColorCurrentG = self.textHighLightColorG
			self.textColorCurrentB = self.textHighLightColorB
			
			self.parent:setInformationText(self.informationText)
			
			if (getKeyState("mouse1")) then
				self:calculateValue()
			end
		else
			self.textColorCurrentR = self.textColorR
			self.textColorCurrentG = self.textColorG
			self.textColorCurrentB = self.textColorB
		end
		
		-- // TEXT // --
		
		dxDrawText("min", self.x + (self.height * 0.5) + 1, self.y + 1, self.x + self.width + 1, self.y + self.height + 1, tocolor(0, 0, 0, self.alpha), self.fontSize * 0.7, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		dxDrawText("min", self.x + (self.height * 0.5), self.y, self.x + self.width, self.y + self.height, tocolor(self.textColorCurrentR, self.textColorCurrentG, self.textColorCurrentB, self.alpha), self.fontSize * 0.7, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		dxDrawText("max", self.x + (self.height * 0.5) + 1, self.y + 1, self.x + self.width + 1, self.y + self.height + 1, tocolor(0, 0, 0, self.alpha), self.fontSize * 0.7, self.font, "right", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		dxDrawText("max", self.x + (self.height * 0.5), self.y, self.x + self.width, self.y + self.height, tocolor(self.textColorCurrentR, self.textColorCurrentG, self.textColorCurrentB, self.alpha), self.fontSize * 0.7, self.font, "right", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		dxDrawText(removeHEXColorCode(self.text) .. ": " .. self.value, self.x + 1, self.y + 1, self.x + self.width + 1, self.y + self.height + 1, tocolor(0, 0, 0, self.alpha), self.fontSize, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		dxDrawText(self.text .. ": " .. self.value, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(self.textColorCurrentR, self.textColorCurrentG, self.textColorCurrentB, self.alpha), self.fontSize, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		-- // SLIDER // --
		self.r1x = self.x
		self.r1y = self.sliderY + self.height * 0.2
		self.r1width = self.sliderWidth * tonumber(self.value)
		
		dxDrawRectangle(self.x, self.r1y, self.sliderWidth, self.height * 0.5, tocolor(90, 90, 90, 255), self.postGUI, self.subPixelPositioning)
		dxDrawRectangle(self.r1x, self.r1y, self.r1width, self.height * 0.5, tocolor(90, 90, 200, 255), self.postGUI, self.subPixelPositioning)
		
		dxDrawImage(self.sliderX, self.sliderY, self.height * 0.9, self.height * 0.9, self.sliderToggle, 0, 0, 0, tocolor(255, 255, 255, self.alpha), self.postGUI)
	end
end


function dxSliderC:calculateValue()
	local minX = self.x
	local maxX =  self.x + self.sliderWidth
	local range = math.abs(maxX - minX)
	
	self.value = math.round(((100 / range) * (self.cursorX - minX)) / 100, 1)
	
	triggerEvent("MKTRIGGERUSERPANELEVENT", root, self.id, self.type, self.value)
end


function dxSliderC:setValue(valueIN)
	if (valueIN) then
		self.value = math.round(valueIN / 100, 1)
	end
end



function dxSliderC:getValue()
	return tonumber(self.value)
end


function dxSliderC:onClientClick(button, state)
	if (self.isAbleToSlide == "true") then
		if (button == "left") and (state == "down") then
			self:calculateValue()
		end
	end
end


function dxSliderC:destructor()

	removeEventHandler("onClientClick", root, self.m_OnClientClick)
	
	--mainOutput("Slider " .. self.id .. " was destroyed.")
end