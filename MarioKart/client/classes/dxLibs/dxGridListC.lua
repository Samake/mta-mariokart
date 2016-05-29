--[[
	Filename: dxGridListC.lua
	Authors: Sam@ke
--]]

dxGridListC = {}

function dxGridListC:constructor(parent, listProperties)

	self.parent = parent
	self.baseProperties = listProperties
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.id = self.baseProperties.id
	self.type = "GRIDLIST"
	self.x = 0
	self.y = 0
	self.width = self.baseProperties.width or 0
	self.height = self.baseProperties.height or 0
	self.row = self.baseProperties.row or 1
	self.alpha = self.baseProperties.alpha or 255
	self.subPixelPositioning = self.baseProperties.subPixelPositioning or true
	self.postGUI = self.baseProperties.postGUI or true
	self.font = self.baseProperties.font or "default-bold"
	self.fontSize = self.baseProperties.fontSize or 1
	self.textColorR = self.baseProperties.textColorR or 255
	self.textColorG = self.baseProperties.textColorG or 255
	self.textColorB = self.baseProperties.textColorB or 255
	self.textHighLightColorR = self.baseProperties.textHighLightColorR or 0
	self.textHighLightColorG = self.baseProperties.textHighLightColorG or 255
	self.textHighLightColorB = self.baseProperties.textHighLightColorB or 0
	self.textSelectColorR = self.baseProperties.textSelectColorR or 0
	self.textSelectColorG = self.baseProperties.textSelectColorG or 0
	self.textSelectColorB = self.baseProperties.textSelectColorB or 255
	
	self.isAbleToScroll = "false"
	self.isAbleToSelect = "false"
	self.selectedItem = nil
	self.currentItem = nil
	
	self.cursorX, self.cursorY = nil, nil
	self.scrollOffsetY = 0
	self.scrollPosition = 0
	self.maxListSize = 2000
	self.shownMaps = 18
	
	self.scrollBarWidth = self.width * 0.02
	self.scrollBarHeight = 0
	
	self.listEntries = {}
					
	self:init()
	
	--mainOutput("GridList " .. self.id .. " was created.")
end


function dxGridListC:init()

	self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.maxListSize, true)
	
	self.m_OnClientClick = bind(self.onClientClick, self)
	addEventHandler("onClientClick", root, self.m_OnClientClick)
	
	self.m_OnClientScrollUP = bind(self.onClientScrollUP, self)
	bindKey("mouse_wheel_up", "both", self.m_OnClientScrollUP)

	self.m_OnClientScrollDOWN = bind(self.onClientScrollDOWN, self)
	bindKey("mouse_wheel_down", "both", self.m_OnClientScrollDOWN)
	
	self.isComplete = self.parent and self.id and self.renderTarget
end


function dxGridListC:update()
	if (self.isComplete) then
		self.cursorX, self.cursorY = getCursorPosition()
		self.cursorX, self.cursorY = getCursorPosition()
		self.cursorX = self.cursorX * self.screenWidth
		self.cursorY = self.cursorY * self.screenHeight
		
		self.fontSize = self.parent.fontSize
		self.lineSize = self.parent.lineSize
		
		if (self.row == 1) then
			self.x = self.parent.xFirstRow + 15
		elseif (self.row == 2) then
			self.x = self.parent.xSecondRow + 15
		end
		
		if (#self.listEntries < 18) then
			self.shownMaps = #self.listEntries
		end
			
		self.y = self.parent.y + self.lineSize
		self.maxScrollSize = (#self.listEntries - self.shownMaps) * self.lineSize
		
		if (self.cursorX > self.x) and (self.cursorX < self.x + self.width) then
			if (self.cursorY > self.y) and (self.cursorY < self.y + self.height) then
				self.isAbleToScroll = "true"
			else
				self.isAbleToScroll = "false"
			end
		else
			self.isAbleToScroll = "false"
		end
		
		dxSetRenderTarget(self.renderTarget, true)
			
			local x, y = 0, 0
			
			-- // bg all // --
			dxDrawRectangle( x, y, self.screenWidth, self.maxListSize, tocolor(5, 5, 5, 150), false, self.subPixelPositioning)
		
			self.selectedItem = nil
			
			for index, mapname in pairs(self.listEntries) do
				if (mapname) then
					local y = y + self.lineSize * (index - 1)
					
					if (index%2 ~= 0) then
						dxDrawRectangle(x, y, self.screenWidth, self.lineSize, tocolor(35, 35, 35, 150), false, self.subPixelPositioning)
					end
					
					if (self.cursorX > self.x) and (self.cursorX < self.x + self.width) then
						if (self.cursorY >  self.y + y - self.scrollOffsetY) and (self.cursorY <  self.y + (y + self.lineSize - self.scrollOffsetY)) then
							self.isAbleToSelect = "true"
							self.selectedItem = mapname
						else
							self.isAbleToSelect = "false"
						end
					else
						self.isAbleToSelect = "false"
					end
					
					if (self.isAbleToSelect == "true") then
						self.textColorCurrentR = self.textHighLightColorR
						self.textColorCurrentG = self.textHighLightColorG
						self.textColorCurrentB = self.textHighLightColorB
					else
						self.textColorCurrentR = self.textColorR
						self.textColorCurrentG = self.textColorG
						self.textColorCurrentB = self.textColorB
					end
					
					if (self.currentItem == mapname) then
						self.textColorCurrentR = self.textSelectColorR
						self.textColorCurrentG = self.textSelectColorG
						self.textColorCurrentB = self.textSelectColorB
					end

					-- // mapNames // --
					dxDrawText(mapname, x + 1, y + 1, x + self.screenWidth + 1, y + self.lineSize + 1, tocolor(0, 0, 0, self.alpha), self.fontSize, self.font, "left", "center", false, false, false, true, self.subPixelPositioning, 0, 0, 0)
					dxDrawText(mapname, x, y, x + self.screenWidth, y + self.lineSize, tocolor(self.textColorCurrentR, self.textColorCurrentG, self.textColorCurrentB, self.alpha), self.fontSize, self.font, "left", "center", false, false, false, true, self.subPixelPositioning, 0, 0, 0)
				end
			end
			
		dxSetRenderTarget()
		
		dxDrawImageSection(self.x, self.y, self.width, self.height, 0, self.scrollOffsetY, self.width, self.height, self.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), self.postGUI)					
	
		-- // scrollbar // --
		dxDrawRectangle((self.x + self.width) - self.scrollBarWidth, self.y, self.scrollBarWidth, self.height, tocolor(45, 45, 45, 200), self.postGUI, self.subPixelPositioning)
		
		if (#self.listEntries > 18) then
			self.scrollBarHeight = self.height * (1 / #self.listEntries) * self.shownMaps
			self.scrollPosition = (1 / self.maxScrollSize) * self.scrollOffsetY
			self.scrollY = self.y + ((self.height - self.scrollBarHeight) * self.scrollPosition)
			
			if (self.scrollY >= self.y + self.height - self.scrollBarHeight) then
				self.scrollY = self.y + self.height - self.scrollBarHeight
			end
			
			dxDrawRectangle((self.x + self.width) - self.scrollBarWidth, self.scrollY, self.scrollBarWidth, self.scrollBarHeight, tocolor(90, 90, 90, 200), self.postGUI, self.subPixelPositioning)
		end
	end
end


function dxGridListC:onClientScrollUP(button, state)
	if (self.isAbleToScroll == "true") then
		self.scrollOffsetY = self.scrollOffsetY - self.lineSize
		
		if (self.scrollOffsetY <= 0) then
			self.scrollOffsetY = 0
		end
	end
end


function dxGridListC:onClientScrollDOWN(button, state)
	if (self.isAbleToScroll == "true") then
		self.scrollOffsetY = self.scrollOffsetY + self.lineSize
		
		if (self.scrollOffsetY >= self.maxScrollSize) then
			self.scrollOffsetY = self.maxScrollSize
		end
	end
end


function dxGridListC:onClientClick(button, state)
	if (button == "left") and (state == "down") then
		if (self.isAbleToScroll == "true") then
			if (self.selectedItem) then
				self.currentItem = self.selectedItem
			end
		end
	end
end


function dxGridListC:addEntry(entry)
	if (entry) then
		local id = self:getFreeID()
		
		if (not self.listEntries[id]) then
			self.listEntries[id] = entry
		end
	end
end


function dxGridListC:deleteEntry(id)
	if (id) then
		if (self.listEntries[id]) then
			self.listEntries[id] = nil
		end
	end
end


function dxGridListC:getEntry(id)
	if (id) then
		if (self.listEntries[id]) then
			return self.listEntries[id]
		end
	end
end


function dxGridListC:getSelectedEntry()
	return self.currentItem
end


function dxGridListC:getFreeID()
	for index, entry in pairs(self.listEntries) do
		if (not entry) then
			return index
		end
	end
	
	return #self.listEntries + 1
end


function dxGridListC:clear()

	removeEventHandler("onClientClick", root, self.m_OnClientClick)
	unbindKey("mouse_wheel_up", "both", self.m_OnClientScrollUP)
	unbindKey("mouse_wheel_down", "both", self.m_OnClientScrollDOWN)
	
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
end


function dxGridListC:destructor()

	self:clear()
	
	--mainOutput("GridList " .. self.id .. " was destroyed.")
end