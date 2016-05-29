--[[
	Filename: ShaderBoostFieldsC.lua
	Author: Sam@ke
--]]

ShaderBoostFieldsC = {}

function ShaderBoostFieldsC:constructor(parent)
	mainOutput("ShaderBoostFieldsC was loaded.")
	
	self.shaderManager = parent
	
	self.effectRange = 500
	self.scrollSpeed = 1.0
	
	self.boostFieldShader = dxCreateShader("res/shaders/boostfield.fx", 0, self.effectRange, false, "object")
	
	if (self.boostFieldShader) then	
		self.boostFieldShader:applyToWorldTexture("turbo")
	else
		mainOutput("ERROR: Shader boostfields was NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderBoostFieldsC:update()
	if (self.boostFieldShader) then
		self.boostFieldShader:setValue("scrollSpeed", self.scrollSpeed)
	end
end


function ShaderBoostFieldsC:destructor()
	if (self.boostFieldShader) then
		self.boostFieldShader:destroy()
		self.boostFieldShader = nil
	end

	mainOutput("ShaderBoostFieldsC was deleted.")
end