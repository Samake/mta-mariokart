--[[
	Filename: ShaderCoinsC.lua
	Author: Sam@ke
--]]

ShaderCoinsC = {}

function ShaderCoinsC:constructor(shaderManager)
	mainOutput("ShaderCoinsC was loaded.")
	
	self.shaderManager = shaderManager
	
	self.effectRange = 500
	self.textureSize = 64
	self.bumpMapFactor = 1.2
	self.ambientIntensity = 0.8
	self.diffuseIntensity = 0.72
	self.specularIntensity = 9
	self.specularSize = 8
	
	self.coinShader = dxCreateShader("res/shaders/coin.fx", 0, self.effectRange, false, "object")
	
	self.isLoaded = self.shaderManager and self.coinShader
	
	if (self.isLoaded) then	
		self.coinShader:applyToWorldTexture("coin")
	else
		mainOutput("ERROR || Shader coins was NOT created! Use `/debugscript 3` for further details.")
	end
end


function ShaderCoinsC:update()
	if (self.isLoaded) then
		self.sunColor = self.shaderManager:getSunColor()
		self.ambientColor = self.shaderManager:getAmbientColor()
		self.sunPos = self.shaderManager:getSunPosition()
		
		self.coinShader:setValue("sunPos", self.sunPos)
		self.coinShader:setValue("sunColor", self.sunColor)
		self.coinShader:setValue("ambientColor", self.ambientColor)
		self.coinShader:setValue("textureSize", self.textureSize)
		self.coinShader:setValue("bumpMapFactor", self.bumpMapFactor)
		self.coinShader:setValue("ambientIntensity", self.ambientIntensity)
		self.coinShader:setValue("diffuseIntensity", self.diffuseIntensity)
		self.coinShader:setValue("specularIntensity", self.specularIntensity)
		self.coinShader:setValue("specularSize", self.specularSize)
	end
end


function ShaderCoinsC:destructor()
	
	if (self.coinShader) then
		self.coinShader:destroy()
		self.coinShader = nil
	end
	
	mainOutput("ShaderCoinsC was deleted.")
end