--[[
	Filename: XMLHandlerC.lua
	Author: Sam@ke
--]]


XMLHandlerC = {}


function XMLHandlerC:constructor(parent)
	mainOutput("XMLHandlerC was loaded.")
	
	self.parent = parent
	self.settingsFile = XML.load("files/settings/settings.xml")
	
	if (not self.settingsFile) then
		self.fileAvailableOnStart = false
		mainOutput("CLIENT || settings.xml not found. Create new settings file!")
		
		self.settingsFile = xmlCreateFile("files/settings/settings.xml", "settings")
		xmlSaveFile(self.settingsFile)
		
		self.settingsFile = XML.load("files/settings/settings.xml")
		
		if (not self.settingsFile) then
			mainOutput("CLIENT || Could´nt create settings.xml!")
		else
			self.settingsFile:unload()
		end
	else
		self.fileAvailableOnStart = true
	end
end


function XMLHandlerC:readFromXML(node)
	self.settingsFile = XML.load("files/settings/settings.xml")
	
	if (not self.settingsFile) then
		mainOutput("CLIENT || Could´nt read settings.xml!")
		return nil
	end
	
	self.node = self.settingsFile:findChild(node, 0)
	
	if (self.node) then
		self.nodeValue = self.node:getValue()
	else
		return nil
	end
	
	if (self.nodeValue) then
		return self.nodeValue
	else
		return nil
	end
	
	self.settingsFile:unload()
end


function XMLHandlerC:writeToXML(node, value)
	self.settingsFile = XML.load("files/settings/settings.xml")
	
	if (not self.settingsFile) then
		mainOutput("CLIENT || Could´nt read settings.xml!")
		return nil
	end
	
	self.node = self.settingsFile:findChild(node, 0)
	
	if (self.node) then
		self.node:setValue(tostring(value))
	else
		self.settingsFile:createChild(tostring(node))
		self.node = self.settingsFile:findChild(node, 0)
		self.node:setValue(tostring(value))
	end
	
	xmlSaveFile(self.settingsFile)
	--self.settingsFile:save() 
	self.settingsFile:unload()
end

function XMLHandlerC:destructor()
		
	mainOutput("XMLHandlerC was deleted.")
end