--[[
	Filename: ShaderItemsC.lua
	Author: Sam@ke
--]]

ShaderItemsC = {}

function ShaderItemsC:constructor(shaderManager)
	mainOutput("ShaderItemsC was loaded.")
	
	self.shaderManager = shaderManager
	
	self.effectRange = 500
	self.bumpMapFactor = 0.008
	self.brightness = 0.9
	self.alpha = 0.7
	self.ambientIntensity = 0.8
	self.specularSize = 32
	self.specularIntensity = 2.8
	
	self.itemShader = dxCreateShader("res/shaders/item.fx", 0, self.effectRange, false, "object")
	
	self.isLoaded = self.shaderManager and self.itemShader
	
	if (self.isLoaded) then	
		self.itemShader:applyToWorldTexture("item01")
		self.itemShader:applyToWorldTexture("item05")
	else
		mainOutput("ERROR || Shader items was NOT created! Use `/debugscript 3` for further details.")
	end
end


function ShaderItemsC:update()
	if (self.isLoaded) then
		self.sunColor = self.shaderManager:getSunColor()
		self.ambientColor = self.shaderManager:getAmbientColor()
		self.sunPos = self.shaderManager:getSunPosition()

		self.itemShader:setValue("brightness", self.brightness)
		self.itemShader:setValue("alpha", self.alpha)
		self.itemShader:setValue("sunColor", self.sunColor)
		self.itemShader:setValue("ambientColor", self.ambientColor)
		self.itemShader:setValue("sunPos", self.sunPos)
		self.itemShader:setValue("ambientIntensity", self.ambientIntensity)
		self.itemShader:setValue("specularSize", self.specularSize)
		self.itemShader:setValue("bumpMapFactor", self.bumpMapFactor)
		self.itemShader:setValue("specularIntensity", self.specularIntensity)
	end
end


function ShaderItemsC:destructor()
	
	if (self.itemShader) then
		self.itemShader:destroy()
		self.itemShader = nil
	end
	
	mainOutput("ShaderItemsC was deleted.")
end