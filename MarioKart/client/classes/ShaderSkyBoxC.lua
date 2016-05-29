--[[
	Filename: ShaderSkyBoxC.lua
	Author: Sam@ke
--]]

ShaderSkyBoxC = {}

function ShaderSkyBoxC:constructor(parent)
	mainOutput("ShaderSkyBoxC was loaded.")
	
	self.shaderManager = parent
	
	self.skyBoxModelID = 1851
	self.skyBoxSize = 4.2
	self.effectRange = 0
	self.skyTextureID = 1
	self.brightness = 0.5

	self.x, self.y, self.z = getCameraMatrix()
	self.skyBoxObject = createObject(self.skyBoxModelID, self.x, self.y, self.z)
	self.skyBoxShader = dxCreateShader("res/shaders/skybox.fx", 0, self.effectRange, false, "object")
	
	self.isLoaded = self.shaderManager and self.skyBoxObject and self.skyBoxShader
	
	if (self.isLoaded) then	
		self.skyBoxShader:applyToWorldTexture("sky01", self.skyBoxObject)
		self.skyBoxObject:setDoubleSided(true)
		self.skyBoxObject:setScale(self.skyBoxSize)
	else
		mainOutput("ERROR: Shader skybox wasn´t created! Use `/debugscript 3` for further details.")
	end
end


function ShaderSkyBoxC:update()
	if (self.isLoaded) then
		self.x, self.y, self.z = getCameraMatrix()
		
		self.skyBoxObject:setPosition(self.x, self.y, self.z)
		
		self.skyBoxShader:setValue("brightness",  self.brightness)
		
		if (self.shaderManager.skyBoxID) then
			if (self.shaderManager.skyBoxID == 1) then
				self.skyBoxShader:setValue("skyTexture", self.shaderManager.skyTextureNight)
			elseif (self.shaderManager.skyBoxID == 2) then
				self.skyBoxShader:setValue("skyTexture",  self.shaderManager.skyTextureDay)
			end
		end
	end
end


function ShaderSkyBoxC:destructor()
	
	if (self.skyBoxObject) then
		self.skyBoxObject:destroy()
		self.skyBoxObject = nil
	end
	
	if (self.skyBoxShader) then
		self.skyBoxShader:destroy()
		self.skyBoxShader = nil
	end
	
	mainOutput("ShaderSkyBoxC was deleted.")
end