--[[
	Filename: dxToggleC.lua
	Authors: Sam@ke
--]]

dxToggleC = {}

function dxToggleC:constructor(parent, toggleProperties)

	self.parent = parent
	self.baseProperties = toggleProperties
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.id = self.baseProperties.id
	self.type = "TOGGLE"
	self.x = 0
	self.y = 0
	self.width = self.baseProperties.width or 0
	self.height = self.baseProperties.height or 0
	self.line = self.baseProperties.line or 1
	self.row = self.baseProperties.row or 1
	self.r = self.baseProperties.r or 255
	self.g = self.baseProperties.g or 255
	self.b = self.baseProperties.b or 255
	self.alpha = self.baseProperties.alpha or 255
	self.subPixelPositioning = self.baseProperties.subPixelPositioning or true
	self.postGUI = self.baseProperties.postGUI or true
	self.state = self.baseProperties.state or "true"
	self.text = self.baseProperties.text or ""
	self.alignX = self.baseProperties.alignX or "left"
	self.font = self.baseProperties.font or "default-bold"
	self.fontSize = self.baseProperties.fontSize or 1
	self.textLength = string.len(self.text)
	self.textColorR = self.baseProperties.textColorR or 255
	self.textColorG = self.baseProperties.textColorG or 255
	self.textColorB = self.baseProperties.textColorB or 255
	self.textHighLightColorR = self.baseProperties.textHighLightColorR or 255
	self.textHighLightColorG = self.baseProperties.textHighLightColorG or 255
	self.textHighLightColorB = self.baseProperties.textHighLightColorB or 0
	self.toggleON = self.baseProperties.textures.toggleON
	self.toggleOFF = self.baseProperties.textures.toggleOFF
	self.informationText = self.baseProperties.informationText
	
	self.isAbleToToggle = "false"
	
	self.cursorX, self.cursorY = nil, nil
	
	self.m_OnClientClick = bind(self.onClientClick, self)
	addEventHandler("onClientClick", root, self.m_OnClientClick)
	
	self.isComplete = 	self.parent 
						and self.id 
						and self.toggleON 
						and self.toggleOFF
	
	--mainOutput("Toggle " .. self.id .. " was created.")
end


function dxToggleC:update()
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
		self.toggleWidth = self.height * 2
		self.toggleHeight = self.height
		self.toggleX = (self.x + self.width) - self.toggleWidth
		self.toggleY = self.y

		if (self.cursorX > self.x) and (self.cursorX < self.x + self.width) then
			if (self.cursorY > self.y) and (self.cursorY < self.y + self.height) then
				self.isAbleToToggle = "true"
			else
				self.isAbleToToggle = "false"
			end
		else
			self.isAbleToToggle = "false"
		end
		
		if (self.isAbleToToggle == "true") then
			self.textColorCurrentR = self.textHighLightColorR
			self.textColorCurrentG = self.textHighLightColorG
			self.textColorCurrentB = self.textHighLightColorB
			
			self.parent:setInformationText(self.informationText)
		else
			self.textColorCurrentR = self.textColorR
			self.textColorCurrentG = self.textColorG
			self.textColorCurrentB = self.textColorB
		end
		
		if (self.state == "true") then
			self.toggleTex = self.toggleON 
		elseif (self.state == "false") then
			self.toggleTex = self.toggleOFF
		else
			self.toggleTex = self.toggleON 
		end
		
		-- // TEXT // --
		dxDrawText(removeHEXColorCode(self.text), self.x + 1, self.y + 1, (self.x + self.width) - self.toggleWidth + 1, self.y + self.height + 1, tocolor(0, 0, 0, self.alpha), self.fontSize, self.font, self.alignX, "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		dxDrawText(self.text, self.x, self.y, (self.x + self.width) - self.toggleWidth, self.y + self.height, tocolor(self.textColorCurrentR, self.textColorCurrentG, self.textColorCurrentB, self.alpha), self.fontSize, self.font, self.alignX, "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		-- // TOGGLE // --
		dxDrawImage(self.toggleX, self.toggleY, self.height * 1.8, self.height * 0.9, self.toggleTex, 0, 0, 0, tocolor(255, 255, 255, self.alpha), self.postGUI)
	end
end


function dxToggleC:onClientClick(button, state)
	if (self.isAbleToToggle == "true") then
		if (button == "left") and (state == "down") then
			if (self.state == "true") then
				self.state = "false"
			elseif (self.state == "false") then
				self.state = "true"
			end
			
			triggerEvent("MKTRIGGERUSERPANELEVENT", root, self.id, self.type, self.state)
			
			playSoundFrontEnd(8)
		end
	end
end


function dxToggleC:destructor()

	removeEventHandler("onClientClick", root, self.m_OnClientClick)
	
	--mainOutput("Toggle " .. self.id .. " was destroyed.")
end