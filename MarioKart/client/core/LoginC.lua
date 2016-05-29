--[[
	Filename: LoginC.lua
	Author: Sam@ke
--]]


LoginC = {}


function LoginC:constructor(parent)
	mainOutput("LoginC was loaded.")
	
	self.parent = parent
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.resource = getThisResource()
	self.resourceName = self.resource:getName()
	self.loginPage = "http://mta/" .. self.resourceName .. "/cef/html/login.html"

	self:init()
end


function LoginC:init()
	self.m_OnClientBrowserCreated = bind(self.onClientBrowserCreated, self)
	addEventHandler("onClientBrowserCreated", root, self.m_OnClientBrowserCreated)
	
	self.guiBrowser = guiCreateBrowser(0, 0, self.screenWidth * 0.4, self.screenHeight * 0.4, true, false, false)
	self.browser = guiGetBrowser(self.guiBrowser)
end


function LoginC:onClientBrowserCreated()
	if (not self.browser) then
		self.browser = guiGetBrowser(source)
	end
	
	self.browser:loadURL(self.loginPage)
	showCursor(true)
end


function LoginC:clear()
	removeEventHandler("onClientBrowserCreated", root, self.m_OnClientBrowserCreated)
	
	if (self.browser) then
		self.browser:destroy()
		self.browser = nil
	end
	
	showCursor(false)
end


function LoginC:destructor()
	
	self:clear()
	
	mainOutput("LoginC was deleted.")
end