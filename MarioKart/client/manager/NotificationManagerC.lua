--[[
	Filename: NotificationManagerC.lua
	Authors: Sam@ke
--]]

NotificationManagerC = {}


function NotificationManagerC:constructor(parent)
	mainOutput("NotificationManagerC was loaded.")

	self.mainClass = parent

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.scaleFactor = (1 /1080) * self.screenHeight
	
	self.font = dxCreateFont("res/fonts/SuperMario.ttf", 6, false, "cleartype")
	self.errorIcon = dxCreateTexture("res/textures/icons/errorIcon.png")
	self.warningIcon = dxCreateTexture("res/textures/icons/warningIcon.png")
	self.infoIcon = dxCreateTexture("res/textures/icons/infoIcon.png")
	self.readyIcon = dxCreateTexture("res/textures/icons/readyIcon.png")
	self.achievementIcon = dxCreateTexture("res/textures/icons/achievementIcon.png")
	
	self.notificationWidth = self.screenWidth * 0.15
	self.notificationHeight = self.screenHeight * 0.045
	
	self.x = self.screenWidth - self.notificationWidth - 15
	self.y = self.screenHeight * 0.2
	
	self.notificationLifeTime = 8000
	self.maxNotifications = 10
	
	self.postGUI = true
	self.subPixelPositioning = false
	
	self.notifications = {}

	self:init()
end


function NotificationManagerC:init()
	self.m_AddNotification = bind(self.addNotification, self)
	addEvent("MKADDNOTIFICATION", true)
	addEventHandler("MKADDNOTIFICATION", root, self.m_AddNotification)
	
	self.isLoaded = self.mainClass
end


function NotificationManagerC:addNotification(text, type)
	if (text) and (type) then
		local notificationSettings = {}
		notificationSettings.id = self:resortNotifications()
		notificationSettings.text = text
		
		if (type == "INFO") then
			notificationSettings.icon = self.infoIcon
			notificationSettings.bgR = 90
			notificationSettings.bgG = 90
			notificationSettings.bgB = 200
			notificationSettings.tR = 90
			notificationSettings.tG = 90
			notificationSettings.tB = 255
		elseif (type == "ERROR") then
			notificationSettings.icon = self.errorIcon
			notificationSettings.bgR = 200
			notificationSettings.bgG = 90
			notificationSettings.bgB = 90
			notificationSettings.tR = 255
			notificationSettings.tG = 90
			notificationSettings.tB = 90
		elseif (type == "WARNING") then
			notificationSettings.icon = self.warningIcon
			notificationSettings.bgR = 200
			notificationSettings.bgG = 200
			notificationSettings.bgB = 90
			notificationSettings.tR = 255
			notificationSettings.tG = 255
			notificationSettings.tB = 90
		elseif (type == "READY") then
			notificationSettings.icon = self.readyIcon
			notificationSettings.bgR = 90
			notificationSettings.bgG = 200
			notificationSettings.bgB = 90
			notificationSettings.tR = 90
			notificationSettings.tG = 255
			notificationSettings.tB = 90
		elseif (type == "ACHIEVEMENT") then
			notificationSettings.icon = self.achievementIcon
			notificationSettings.bgR = 200
			notificationSettings.bgG = 90
			notificationSettings.bgB = 200
			notificationSettings.tR = 255
			notificationSettings.tG = 90
			notificationSettings.tB = 255
		end

		notificationSettings.font = self.font
		notificationSettings.fontSize = self.scaleFactor * 2
		notificationSettings.startTime = getTickCount()
		notificationSettings.lifeTime = self.notificationLifeTime
		notificationSettings.x = self.x
		notificationSettings.y = self.y
		notificationSettings.width = self.notificationWidth
		notificationSettings.height = dxGetFontHeight(notificationSettings.fontSize * 2, self.font)
		notificationSettings.postGUI = self.postGUI
		notificationSettings.subPixelPositioning = self.subPixelPositioning
		
		self.notifications[notificationSettings.id] = new(NotificationC, self, notificationSettings)
	end
end


function NotificationManagerC:update()
	if (self.isLoaded) then
		for index, notificationClass in pairs(self.notifications) do
			if (notificationClass) then
				notificationClass:update()
			end
		end
	end
end


function NotificationManagerC:resortNotifications()
	self:deleteNotification(self.maxNotifications)
	
	for i = self.maxNotifications, 1, -1 do
		if (self.notifications[i]) then
			if (not self.notifications[i + 1]) then
				self.notifications[i]:changeID(i + 1)
				self.notifications[i + 1] = self.notifications[i]
				self.notifications[i] = nil
			end
		end
	end
	
	return 1
end


function NotificationManagerC:deleteNotification(id)
	if (id) then
		if (self.notifications[id]) then
			delete(self.notifications[id])
			self.notifications[id] = nil
		end
	end
end


function NotificationManagerC:clear()
	removeEventHandler("MKADDNOTIFICATION", root, self.m_AddNotification)
	
	for index, notificationClass in pairs(self.notifications) do
		if (notificationClass) then
			delete(notificationClass)
			notificationClass = nil
		end
	end
	
	if (self.font) then
		self.font:destroy()
		self.font = nil
	end
	
	if (self.errorIcon) then
		self.errorIcon:destroy()
		self.errorIcon = nil
	end
	
	if (self.warningIcon) then
		self.warningIcon:destroy()
		self.warningIcon = nil
	end
	
	if (self.readyIcon) then
		self.readyIcon:destroy()
		self.readyIcon = nil
	end
	
	if (self.achievementIcon) then
		self.achievementIcon:destroy()
		self.achievementIcon = nil
	end
	
	if (self.infoIcon) then
		self.infoIcon:destroy()
		self.infoIcon = nil
	end
end


function NotificationManagerC:destructor()
	
	self:clear()
	
	mainOutput("NotificationManagerC was deleted.")
end

local randomText = {}
randomText[1] = {text = "Test Nachricht", type = "INFO"}
randomText[2] = {text = "Test Fehler", type = "ERROR"}
randomText[3] = {text = "Test Warnung", type = "WARNING"}
randomText[4] = {text = "Test Ready", type = "READY"}
randomText[5] = {text = "Test Achievement", type = "ACHIEVEMENT"}

setTimer (function()
	local randomID = math.random(1, #randomText)
	triggerEvent("MKADDNOTIFICATION", root, randomText[randomID].text, randomText[randomID].type)
end, 2000, 0)
