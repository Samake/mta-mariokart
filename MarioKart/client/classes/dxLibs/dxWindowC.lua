--[[
	Filename: dxWindowC.lua
	Authors: Sam@ke
--]]

dxWindowC = {}

function dxWindowC:constructor(parent)

	self.parent = parent
	self.id = ""
	self.title = "New Window"
	self.titleBar = "true"
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.cursorX, self.cursorY = nil, nil
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	self.color = tocolor(15, 15, 15, 220)
	self.titleColor = tocolor(200, 190, 60, 220)
	self.titleBarColor = tocolor(35, 35, 35, 220)
	self.borderSize = 0
	self.borderColor = tocolor(0, 0, 0, 0)
	self.fontSize = 1
	self.fonts = self.parent.fonts
	self.textures = self.parent.textures
	self.subPixelPositioning = false
	self.postGUI = false
	
	self.titleBarContrast = 15
	
	self.tabs = {}
	self.tabBGNormalColor = tocolor(45, 45, 45, 150)
	self.tabBGHighlightColor = tocolor(95, 95, 95, 150)
	self.tabBGSelectedColor = tocolor(45, 45, 95, 150)
	self.tabNormalColor = tocolor(95, 95, 95, 220)
	self.tabHighlightColor = tocolor(95, 220, 95, 220)
	self.tabSelectedColor = tocolor(95, 95, 220, 220)
	
	self.isCursorOnTabs = "false"
	
	self.currentTab = 0
	self.selectedTab = nil
	
	self:init()

end


function dxWindowC:init()
	self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	self.animationClass = new(AnimationsC, self, 2000, "InOutElastic", "false")
	
	self.windowArea = {}
	self.windowArea.x = 0
	self.windowArea.y = 0
	self.windowArea.w = 0
	self.windowArea.h = 0
	
	self.titleArea = {}
	self.titleArea.x = 0
	self.titleArea.y = 0
	self.titleArea.w = 0
	self.titleArea.h = 0
	
	self.tabArea = {}
	self.tabArea.x = 0
	self.tabArea.y = 0
	self.tabArea.w = 0
	self.tabArea.h = 0
	
	self.contentArea = {}
	self.contentArea.x = 0
	self.contentArea.y = 0
	self.contentArea.w = 0
	self.contentArea.h = 0
	
	self.isLoaded = 	self.id 
						and self.renderTarget
						and self.animationClass
						and self.screenWidth
						and self.screenHeight 
						and self.x 
						and self.y 
						and self.width 
						and self.height
						and self.fonts
						and self.windowArea
						and self.titleArea
						and self.tabArea
						and self.contentArea
	
	self.m_OnClientClick = bind(self.onClientClick, self)
	addEventHandler("onClientClick", root, self.m_OnClientClick)
end



function dxWindowC:update()
	if (self.isLoaded) then
		self.cFontSize = self.fontSize * self.animationClass:getFactor()
		self.cursorX, self.cursorY = getCursorPosition()
		self.cursorX = self.cursorX * self.screenWidth
		self.cursorY = self.cursorY * self.screenHeight
		
		self.animationClass:update()
		
		self.windowArea.x = self.x
		self.windowArea.y = self.y * self.animationClass:getFactor()
		self.windowArea.w = self.width * self.animationClass:getFactor()
		self.windowArea.h = self.height * self.animationClass:getFactor()
		
		self.titleArea.x = self.x
		self.titleArea.y = self.y * self.animationClass:getFactor()
		self.titleArea.w = self.width * self.animationClass:getFactor()
		
		if (self.titleBar == "true") then
			self.titleArea.h = dxGetFontHeight(self.cFontSize, self.fonts.mario10) * 1.2
		else
			self.titleArea.h = 0
		end
		
		self.tabArea.x = self.x
		self.tabArea.y = self.titleArea.y + self.titleArea.h
		self.tabArea.w = self.width * self.animationClass:getFactor()
		
		if (self.titleBar == "true") then
			self.tabArea.h = dxGetFontHeight(self.cFontSize, self.fonts.mario12) * 2
		else
			self.tabArea.h = dxGetFontHeight(self.cFontSize, self.fonts.mario12) * 3
		end
		
		self.tabArea.s = self.tabArea.w / #self.tabs

		self.contentArea.x = self.x
		self.contentArea.y = self.tabArea.y + self.tabArea.h
		self.contentArea.w = self.width * self.animationClass:getFactor()
		self.contentArea.h = (self.height - self.titleArea.h - self.tabArea.h) * self.animationClass:getFactor()
	
		dxSetRenderTarget(self.renderTarget, true)
		
		--dxDrawRectangle(self.windowArea.x, self.windowArea.y, self.windowArea.w, self.windowArea.h, tocolor(255, 0, 0, 255), self.postGUI, self.subPixelPositioning)
		--dxDrawRectangle(self.titleArea.x, self.titleArea.y, self.titleArea.w, self.titleArea.h, tocolor(255, 255, 0, 255), self.postGUI, self.subPixelPositioning)
		--dxDrawRectangle(self.tabArea.x, self.tabArea.y, self.tabArea.w, self.tabArea.h, tocolor(0, 255, 0, 255), self.postGUI, self.subPixelPositioning)
		--dxDrawRectangle(self.contentArea.x, self.contentArea.y, self.contentArea.w, self.contentArea.h, tocolor(0, 0, 255, 255), self.postGUI, self.subPixelPositioning)

		-- // WINDOW // --
		dxDrawRectangle(self.windowArea.x, self.windowArea.y, self.windowArea.w, self.windowArea.h, self.color, self.postGUI, self.subPixelPositioning)
		
		-- // TitleBar // --
		if (self.titleBar == "true") then
			dxDrawRectangle(self.titleArea.x, self.titleArea.y, self.titleArea.w, self.titleArea.h, self.titleBarColor, self.postGUI, self.subPixelPositioning)
		
			-- // Title // --
			if (self.title) then
				dxDrawText(self.title, self.titleArea.x, self.titleArea.y, self.titleArea.x + self.titleArea.w, self.titleArea.y + self.titleArea.h, self.titleColor, self.cFontSize, self.fonts.mario10, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
		end
		
		-- // BORDER // --
		if (self.borderSize > 0) then
			dxDrawLine(self.windowArea.x, self.windowArea.y, self.windowArea.x + self.windowArea.w, self.windowArea.y, self.borderColor, self.borderSize, self.postGUI)
			dxDrawLine(self.windowArea.x + self.windowArea.w, self.windowArea.y, self.windowArea.x + self.windowArea.w, self.windowArea.y + self.windowArea.h, self.borderColor, self.borderSize, self.postGUI)
			dxDrawLine(self.windowArea.x + self.windowArea.w, self.windowArea.y + self.windowArea.h, self.windowArea.x, self.windowArea.y + self.windowArea.h, self.borderColor, self.borderSize, self.postGUI)
			dxDrawLine(self.windowArea.x, self.windowArea.y + self.windowArea.h, self.windowArea.x, self.windowArea.y, self.borderColor, self.borderSize, self.postGUI)
		end
		
		-- // update tab content // --)	
		for index, tab in pairs(self.tabs) do
			if (tab) then
				self.tx = self.tabArea.x + (self.tabArea.s * tab.id) - self.tabArea.s
				
				-- // update cursor infos // --
				if (self.cursorX > self.tx) and (self.cursorX < (self.tx + self.tabArea.s)) then
					if (self.cursorY > self.tabArea.y) and (self.cursorY < (self.tabArea.y + self.tabArea.h)) then
						self.selectedTab = tab.id
					else
						self.selectedTab = nil
					end
				end
				
				-- // tab icon + text // --
				if (tab.id == self.currentTab) then
					if (tab.id == self.selectedTab) then
						dxDrawRectangle(self.tx, self.tabArea.y, self.tabArea.s,self.tabArea.h, self.tabBGHighlightColor, self.postGUI, self.subPixelPositioning)
					end
					
					dxDrawRectangle(self.tx, self.tabArea.y, self.tabArea.s, self.tabArea.h, self.tabBGSelectedColor, self.postGUI, self.subPixelPositioning)
					dxDrawText(tab.name, self.tx, self.tabArea.y, self.tx + self.tabArea.s, self.tabArea.y + self.tabArea.h, self.tabSelectedColor, self.cFontSize * 0.8, self.fonts.mario20, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
					
					if (tab.class.logo) then
						dxDrawImage(self.tx + (self.tabArea.h * 0.5), self.tabArea.y, self.tabArea.h, self.tabArea.h, tab.class.logo, 0, 0, 0, self.tabSelectedColor, self.postGUI)
					end
				else
					if (tab.id == self.selectedTab) then
						dxDrawRectangle(self.tx, self.tabArea.y, self.tabArea.s, self.tabArea.h, self.tabBGHighlightColor, self.postGUI, self.subPixelPositioning)
						dxDrawText(tab.name, self.tx, self.tabArea.y, self.tx + self.tabArea.s, self.tabArea.y + self.tabArea.h, self.tabHighlightColor, self.cFontSize * 0.8, self.fonts.mario20, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
						
						if (tab.class.logo) then
							dxDrawImage(self.tx + (self.tabArea.h * 0.5), self.tabArea.y, self.tabArea.h, self.tabArea.h, tab.class.logo, 0, 0, 0, self.tabHighlightColor, self.postGUI)
						end
					else
						dxDrawRectangle(self.tx, self.tabArea.y, self.tabArea.s, self.tabArea.h, self.tabBGNormalColor, self.postGUI, self.subPixelPositioning)
						dxDrawText(tab.name, self.tx, self.tabArea.y, self.tx + self.tabArea.s, self.tabArea.y + self.tabArea.h, self.tabNormalColor, self.cFontSize * 0.8, self.fonts.mario20, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
						
						if (tab.class.logo) then
							dxDrawImage(self.tx + (self.tabArea.h * 0.5), self.tabArea.y, self.tabArea.h, self.tabArea.h, tab.class.logo, 0, 0, 0, self.tabNormalColor, self.postGUI)
						end
					end
				end
			end
		end
		
		-- // update tab content // --
		if (self.tabs[self.currentTab]) then
			self.tabs[self.currentTab].class:update()
		end

		dxSetRenderTarget()
		
		dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.renderTarget)
	end
end


function dxWindowC:onClientClick(button, state)
	if (self.isLoaded) then
		if (button == "left") and (state == "down") then
			if (self.selectedTab) then
				self.currentTab = self.selectedTab
			end
		end
	end
end


function dxWindowC:addTab(tabName, tabClass)
	if (tabName) and (tabClass) then
		local id = self:getTabID()
		
		if (not self.tabs[id]) then
			self.tabs[id] = {}
			self.tabs[id].id = id
			self.tabs[id].name = tabName
			self.tabs[id].class = tabClass
			self.currentTab = id
		end
	end
end


function dxWindowC:removeTab(tabClassIN)
	if (tabClassIN) then
		for index, tab in pairs(self.tabs) do
			if (tab.class == tabClassIN) then
				tab = nil
			end
		end
	end
end


function dxWindowC:getTabID()
	for index, tab in pairs(self.tabs) do
		if (not tab) then
			return index
		end
	end
	
	return #self.tabs + 1
end


function dxWindowC:getID()
	return self.id
end


function dxWindowC:setID(value)
	if (value) then
		self.id = value
	end
end


function dxWindowC:getTitleBar()
	return self.titleBar
end


function dxWindowC:setTitleBar(value)
	if (value) then
		self.titleBar = value
	end
end


function dxWindowC:getTitle()
	return self.title
end


function dxWindowC:setTitle(value)
	if (value) then
		self.title = value
	end
end


function dxWindowC:getTitleColor()
	return self.titleColor
end


function dxWindowC:setTitleColor(r, g, b, a)
	if (r) and (g) and (b) and (a) then
		self.titleColor = tocolor(r, g, b, a)
	end
end


function dxWindowC:getTitleBarColor()
	return self.titleBarColor
end


function dxWindowC:setTitleBarColor(r, g, b, a)
	if (r) and (g) and (b) and (a) then
		self.titleBarColor = tocolor(r, g, b, a)
	end
end


function dxWindowC:getPosition()
	return self.x, self.y
end

function dxWindowC:setPosition(x, y)
	if (x) and (y) then
		self.x = x
		self.y = y
	end
end


function dxWindowC:getSize()
	return self.width, self.height
end


function dxWindowC:setSize(w, h)
	if (w) and (h) then
		self.width = w
		self.height = h
	end
end


function dxWindowC:getColor()
	return self.color
end


function dxWindowC:setColor(r, g, b, a)
	if (r) and (g) and (b) and (a) then
		self.color = tocolor(r, g, b, a)
		
		local tr, tg, tb

		if ((r - self.titleBarContrast) >= 0) then
			tr = r - self.titleBarContrast
		else
			tr = r + self.titleBarContrast
		end
		
		if ((g - self.titleBarContrast) >= 0) then
			tg = g - self.titleBarContrast
		else
			tg = g + self.titleBarContrast
		end
		
		if ((b - self.titleBarContrast) >= 0) then
			tb = b - self.titleBarContrast
		else
			tb = b + self.titleBarContrast
		end
		
		self.titleBarColor = tocolor(tr, tg, tb, a)
	end
end


function dxWindowC:getBorderSize()
	return self.borderSize
end


function dxWindowC:setBorderSize(value)
	if (value) then
		self.borderSize = value
	end
end


function dxWindowC:getBorderColor()
	return self.borderColor
end


function dxWindowC:setBorderColor(r, g, b, a)
	if (r) and (g) and (b) and (a) then
		self.borderColor = tocolor(r, g, b, a)
	end
end


function dxWindowC:getFontSize()
	return self.fontSize
end


function dxWindowC:setFontSize(value)
	if (value) then
		self.fontSize = value
	end
end


function dxWindowC:getFont()
	return self.fonts.mario14
end


function dxWindowC:setFont(value)
	if (value) then
		self.fonts.mario14 = value
	end
end


function dxWindowC:getSubPixelPositioning()
	return self.subPixelPositioning
end


function dxWindowC:setSubPixelPositioning(value)
	if (value) then
		self.subPixelPositioning = value
	end
end


function dxWindowC:getPostGUI()
	return self.postGUI
end


function dxWindowC:setPostGUI(value)
	if (value) then
		self.postGUI = value
	end
end


function dxWindowC:isCursorInside()
	if (self.cursorX < self.x) or (self.cursorX > self.x + self.width) then return false end
	if (self.cursorY < self.y) or (self.cursorY > self.y + self.height) then return false end
	
	return true
end


function dxWindowC:clear()
	removeEventHandler("onClientClick", root, self.m_OnClientClick)
		
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
	
	if (self.animationClass) then
		delete(self.animationClass)
		self.animationClass = nil
	end
	
	for index, tab in pairs(self.tabs) do
		if (tab) then
			tab = nil
		end
	end
end


function dxWindowC:destructor()
	self:clear()
end