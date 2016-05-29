--[[
	Filename: NotificationC.lua
	Authors: Sam@ke
--]]

NotificationC = {}


function NotificationC:constructor(parent, settings)
	self.notificationManager = parent
	
	self.id = settings.id
	self.text = settings.text
	self.icon = settings.icon
	self.bgR = settings.bgR
	self.bgG = settings.bgG
	self.bgB = settings.bgB
	self.tR = settings.tR
	self.tG = settings.tG
	self.tB = settings.tB
	self.font = settings.font
	self.fontSize = settings.fontSize
	self.startTime = settings.startTime
	self.lifeTime = settings.lifeTime
	self.x = settings.x
	self.y = settings.y
	self.width = settings.width
	self.height = settings.height
	self.mHeight = settings.height * 0.8
	self.postGUI = settings.postGUI
	self.subPixelPositioning = settings.subPixelPositioning
	
	self.bgAlpha = 75
	self.bgAlphaModifier = 0.25 * 0.75
	self.fgAlpha = 220
	self.fgAlphaModifier = 1.0 * 0.75
	
	
	self.shadowOffset = 1


	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.scaleFactor = (1 /1080) * self.screenHeight
	
	self:init()
	
	--mainOutput("NotificationC " .. self.id .. " was loaded.")
end


function NotificationC:init()
	self.animationClass = new(AnimationsC, self, 800, "InOutElastic", "false")
	
	self.isLoaded = self.notificationManager and self.text and self.font and self.icon and self.animationClass
end


function NotificationC:update()
	if (self.isLoaded) then
	
		self.bgAlpha = self.bgAlpha - self.bgAlphaModifier
		
		if (self.bgAlpha <= 0) then
			self.bgAlpha = 0
		end
		
		self.fgAlpha = self.fgAlpha - self.fgAlphaModifier
		
		if (self.fgAlpha <= 0) then
			self.fgAlpha = 0
		end
		
		self.animationFactor = self.animationClass:getFactor()
		
		if (self.animationFactor <= 0) then
			self.animationFactor = 0
		end
		
		self.cFontSize = self.fontSize * self.animationFactor
		self.cWidth = self.width * self.animationFactor
		self.cHeight = self.mHeight * self.animationFactor
		self.cBgAlpha = self.bgAlpha * self.animationFactor
		self.cFgAlpha = self.fgAlpha * self.animationFactor
	
		self.offSetY = self.y + (self.height * self.id - 1)
		
		-- // BG // --
		dxDrawRectangle(self.x, self.offSetY, self.cWidth, self.cHeight, tocolor(self.bgR, self.bgG, self.bgB, self.cBgAlpha), self.postGUI, self.subPixelPositioning)
		
		-- // ICON // --
		dxDrawImage(self.x + self.shadowOffset, self.offSetY + self.shadowOffset, self.cHeight, self.cHeight, self.icon, 0, 0, 0, tocolor(0, 0, 0, self.cFgAlpha), self.postGUI)
		dxDrawImage(self.x, self.offSetY, self.cHeight, self.cHeight, self.icon, 0, 0, 0, tocolor(255, 255, 255, self.cFgAlpha), self.postGUI)
		
		-- // TEXT // --
		self.infoX = self.x + self.cHeight
		self.infoWidth = self.cWidth - self.cHeight
		dxDrawText(removeHEXColorCode(self.text), self.infoX + self.shadowOffset, self.offSetY + self.shadowOffset, self.infoX + self.infoWidth + self.shadowOffset, self.offSetY + self.mHeight + self.shadowOffset, tocolor(0, 0, 0, self.cFgAlpha), self.cfontSize, self.font, "center", "center", false, false, self.postGUI, false, self.subPixelPositioning, 0, 0, 0)
		dxDrawText(self.text, self.infoX, self.offSetY, self.infoX + self.infoWidth, self.offSetY + self.cHeight, tocolor(self.tR, self.tG, self.tB, self.cFgAlpha), self.cfontSize, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		self.currentTimeStamp = getTickCount()
		
		if (self.currentTimeStamp > (self.startTime + self.lifeTime)) then
			self.notificationManager:deleteNotification(self.id)
		end
	end
end


function NotificationC:changeID(newID)
	if (newID) then
		self.id = newID
	end
end


function NotificationC:destructor()
	
	if (self.animationClass) then
		delete(self.animationClass)
		self.animationClass = nil
	end
	
	--mainOutput("NotificationC " .. self.id .. " was deleted.")
end
