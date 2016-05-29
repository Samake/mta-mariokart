--[[
	Filename: ShaderBlurC.lua
	Authors: Sam@ke
--]]

ShaderBlurC = {}


function ShaderBlurC:constructor(parent)

	mainOutput("ShaderBlurC was loaded.")
	
	self.shaderManager = parent
	self.screenWidth, self.screenHeight = guiGetScreenSize()

	self.blurStrength = 0

	self:init()
end


function ShaderBlurC:init()

	self.screenSource = dxCreateScreenSource(self.screenWidth, self.screenHeight)
	self.blurShader4x4 = dxCreateShader("res/shaders/blur.fx")
	self.renderTarget4x4 = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	self.blurShader8x8 = dxCreateShader("res/shaders/blur.fx")
	self.renderTarget8x8 = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)

	self.isLoaded = self.shaderManager and self.screenSource and self.blurShader4x4 and self.renderTarget4x4 and self.blurShader8x8 and self.renderTarget8x8

	if (not self.isLoaded) then
		mainOutput("ERROR || Couldn`t create dof shader. Please use ´/debugscript 3` for further details.")
	end
end


function ShaderBlurC:update()
	if (self.isLoaded) then
	
		if (not self.rawScene) then
			self.screenSource:update()
			self.rawScene = self.screenSource
		end
		
		self.blurShader4x4:setValue("screenSource", self.rawScene)
		self.blurShader4x4:setValue("screenSize", {self.screenWidth, self.screenHeight})
        self.blurShader4x4:setValue("blurStrength", self.blurStrength)
		
		dxSetRenderTarget(self.renderTarget4x4, true)
        dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.blurShader4x4)
		dxSetRenderTarget()
		
		self.blurShader8x8:setValue("screenSource", self.renderTarget4x4)
		self.blurShader8x8:setValue("screenSize", {self.screenWidth, self.screenHeight})
        self.blurShader8x8:setValue("blurStrength", self.blurStrength)
		
		dxSetRenderTarget(self.renderTarget8x8, true)
        dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.blurShader8x8)
		dxSetRenderTarget()
	end
end


function ShaderBlurC:setInput(value)
	if (value) then
		self.rawScene = value
	end
end


function ShaderBlurC:setBlurStrentgh(value)
	if (value) then
		self.blurStrength = value
	end
end


function ShaderBlurC:getResult()
	return self.renderTarget8x8
end


function ShaderBlurC:clear()
	if (self.screenSource) then
		self.screenSource:destroy()
		self.screenSource = nil
	end
	
	if (self.blurShader4x4) then
		self.blurShader4x4:destroy()
		self.blurShader4x4 = nil
	end
	
	if (self.blurShader8x8) then
		self.blurShader8x8:destroy()
		self.blurShader8x8 = nil
	end
	
	if (self.renderTarget4x4) then
		self.renderTarget4x4:destroy()
		self.renderTarget4x4 = nil
	end
	
	if (self.renderTarget8x8) then
		self.renderTarget8x8:destroy()
		self.renderTarget8x8 = nil
	end
end


function ShaderBlurC:destructor()
	self:clear()
	
	mainOutput("ShaderBlurC was deleted.")
end
