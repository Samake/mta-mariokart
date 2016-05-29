--[[
	Filename: ShaderWaterC.lua
	Author: Sam@ke
--]]

ShaderWaterC = {}

function ShaderWaterC:constructor(parent)
	mainOutput("ShaderWaterC was loaded.")
	
	self.shaderManager = parent
	
	self.effectRange = 700
	
	self.r, self.g, self.b = 1, 1, 1
	self.waterBrightness = 0.6
	self.waterAlpha = 0.7
	self.flowSpeed = 1.5
	self.fogStart = 600
	self.fogEnd = 700
	self.refractionStrength = 0.4
	self.specularSize = 8
	self.waterShiningPower = 2.0;
	self.waterTexture = dxCreateTexture("res/textures/env/waterTexture.tga")
	self.waterNormalTexture = dxCreateTexture("res/textures/env/waterNormal.png")
	self.waterTextures = {"waterclear256", "yoshiWater1"}
	
	self.waterShader, self.waterTec = dxCreateShader("res/shaders/water.fx", 0, self.effectRange, false, "world")
	
	if (self.waterShader) then	
		
		for _, texture in ipairs(self.waterTextures) do
			self.waterShader:applyToWorldTexture(texture)
		end
	else
		mainOutput("ERROR: Watershader was NOT created! Use /debugscript 3 for further details.")
		self:Delete()
	end
end


function ShaderWaterC:update()
	if (self.waterShader) then
		self.sunColor = self.shaderManager:getSunColor()
		self.shadowColor = self.shaderManager:getShadowColor()
		self.ambientColor = self.shaderManager:getAmbientColor()
		self.sunPos = self.shaderManager:getSunPosition()

		self.waterShader:setValue("waterTexture", self.waterTexture)
		self.waterShader:setValue("waterNormal", self.waterNormalTexture)
		self.waterShader:setValue("waterColor", self.ambientColor)
		self.waterShader:setValue("flowSpeed", self.flowSpeed)
		self.waterShader:setValue("fogStart", self.fogStart)
		self.waterShader:setValue("fogEnd", self.fogEnd)
		self.waterShader:setValue("refractionStrength", self.refractionStrength)
		self.waterShader:setValue("sunPos", self.sunPos)
		self.waterShader:setValue("sunColor", self.sunColor)
		self.waterShader:setValue("specularSize", self.specularSize)
		self.waterShader:setValue("waterShiningPower", self.waterShiningPower)
		self.waterShader:setValue("waterBrightness", self.waterBrightness)
		self.waterShader:setValue("waterAlpha", self.waterAlpha)
	end
end


function ShaderWaterC:destructor()
	if (self.waterShader) then
		self.waterShader:destroy()
		self.waterShader = nil
	end
	
	if (self.waterTexture) then
		self.waterTexture:destroy()
		self.waterTexture = nil
	end
	
	if (self.waterNormalTexture) then
		self.waterNormalTexture:destroy()
		self.waterNormalTexture = nil
	end
	
	mainOutput("ShaderWaterC was deleted.")
end