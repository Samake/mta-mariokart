--[[
	Filename: ShaderDoFC.lua
	Authors: Sam@ke
--]]

ShaderDoFC = {}


function ShaderDoFC:constructor(parent)

	mainOutput("ShaderDoFC was loaded.")
	
	self.shaderManager = parent
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.blurStrength = 6
	
	self.distance = 0

	self:init()
end


function ShaderDoFC:init()

	self.screenSource = dxCreateScreenSource(self.screenWidth, self.screenHeight)
	self.blurShader4x4 = dxCreateShader("res/shaders/blur.fx")
	self.renderTarget4x4 = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	self.blurShader8x8 = dxCreateShader("res/shaders/blur.fx")
	self.renderTarget8x8 = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	self.blurShader16x16 = dxCreateShader("res/shaders/blur.fx")
	self.renderTarget16x16 = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	self.renderTargetFinal = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	
	self.farPlaneShader = dxCreateShader("res/shaders/farPlane.fx")
	self.renderTargetFarPlane = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	
	self.dofShader = dxCreateShader("res/shaders/dof.fx")
	
	self.isLoaded = self.shaderManager and self.screenSource and self.blurShader4x4 and self.renderTarget4x4 and self.blurShader8x8 and self.renderTarget8x8 and self.blurShader16x16 and self.renderTarget16x16 and self.farPlaneShader and self.renderTargetFarPlane and self.dofShader and self.renderTargetFinal

	if (not self.isLoaded) then
		mainOutput("ERROR || Couldn`t create dof shader. Please use ´/debugscript 3` for further details.")
	end
end


function ShaderDoFC:update()
	if (self.isLoaded) then
	    self.screenSource:update()
				
		self.camX, self.camY, self.camZ = getCameraMatrix()
		
		self.playerPos = self.player:getPosition()
		self.viewDistance = getDistanceBetweenPoints3D(self.camX, self.camY, self.camZ, self.playerPos.x, self.playerPos.y, self.playerPos.z)
		
		self.distance = 10 - self.viewDistance
		 
		if (self.distance <= 0) then
			self.distance = 0
		end
		
		self.blurStrength = 6 - self.viewDistance / 2
		
		if (self.blurStrength <= 0) then
			self.blurStrength = 0
		end
		
		self.blurShader4x4:setValue("screenSource", self.screenSource)
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
		
		self.blurShader16x16:setValue("screenSource", self.renderTarget8x8)
		self.blurShader16x16:setValue("screenSize", {self.screenWidth, self.screenHeight})
        self.blurShader16x16:setValue("blurStrength", self.blurStrength)
		
		dxSetRenderTarget(self.renderTarget16x16, true)
        dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.blurShader16x16)
		dxSetRenderTarget()
		
		self.farPlaneShader:setValue("distance", self.distance)
		
		dxSetRenderTarget(self.renderTargetFarPlane, true)
        dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.farPlaneShader)
		dxSetRenderTarget()
		
		self.dofShader:setValue("screenSource", self.screenSource)
		self.dofShader:setValue("farPlane", self.renderTargetFarPlane)
		self.dofShader:setValue("blurredSource", self.renderTarget16x16)
		self.dofShader:setValue("screenSize", {self.screenWidth, self.screenHeight})

		dxSetRenderTarget(self.renderTargetFinal, true)
        dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.dofShader)
		dxSetRenderTarget()
		
	end
end


function ShaderDoFC:getDoFResult()
	return self.renderTargetFinal
end


function ShaderDoFC:getRawResult()
	return self.screenSource
end


function ShaderDoFC:clear()
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
	
	if (self.blurShader16x16) then
		self.blurShader16x16:destroy()
		self.blurShader16x16 = nil
	end
	
	if (self.farPlaneShader) then
		self.farPlaneShader:destroy()
		self.farPlaneShader = nil
	end
	
	if (self.renderTarget4x4) then
		self.renderTarget4x4:destroy()
		self.renderTarget4x4 = nil
	end
	
	if (self.renderTarget8x8) then
		self.renderTarget8x8:destroy()
		self.renderTarget8x8 = nil
	end
	
	if (self.renderTarget16x16) then
		self.renderTarget16x16:destroy()
		self.renderTarget16x16 = nil
	end
	
	if (self.renderTargetFarPlane) then
		self.renderTargetFarPlane:destroy()
		self.renderTargetFarPlane = nil
	end
	
	if (self.renderTargetFinal) then
		self.renderTargetFinal:destroy()
		self.renderTargetFinal = nil
	end
end


function ShaderDoFC:destructor()
	self:clear()
	
	mainOutput("ShaderDoFC was deleted.")
end
