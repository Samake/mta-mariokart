--[[
	Filename: ShaderSunC.lua
	Author: Sam@ke
--]]

ShaderSunC = {}

function ShaderSunC:constructor(parent)
	mainOutput("ShaderSunC was loaded.")
	
	self.shaderManager = parent
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.bwViewDistance = 4.5 -- default: 4.5
	self.sunSize = 0.06 -- default: 0.06
	
	self.godRayStrength = 0.9; -- default: 0.9
	self.godRayStartOffset = 0.525; -- default: 0.525
	self.godRayLength = 1.32 -- default: 1.32
	
	self.blurStrength = 5 -- default 5 blur factor of godrays
	
	self.lensDirtStrength = 0.8; -- default 0.8
	self.lensChromaStrength = 0.8; -- default 0.8
	
	self.finalResult = nil
	
	self:init()
end


function ShaderSunC:init()

	self.screenSource = dxCreateScreenSource(self.screenWidth, self.screenHeight)
	
	self.m_ToggleGodrayShader = bind(self.toggleGodrayShader, self)
	addEvent("MKTOGGLEGODRAYSHADER", true)
	addEventHandler("MKTOGGLEGODRAYSHADER", root, self.m_ToggleGodrayShader)
	
	self.m_ToggleLensFlareShader = bind(self.toggleLensFlareShader, self)
	addEvent("MKTOGGLELENSFLARESHADER", true)
	addEventHandler("MKTOGGLELENSFLARESHADER", root, self.m_ToggleLensFlareShader)
	
	self:createSunShader()
	
	if (self.shaderManager.godraysEnabled == "true") then
		self:createGodrayShader()
	end
	
	if (self.shaderManager.lensflareEnabled == "true") then
		self:createLensFlareShader()
	end
	
end


function ShaderSunC:createSunShader()

	self.renderTargetBW = dxCreateRenderTarget(self.screenWidth, self.screenHeight, false)
	self.renderTargetSO = dxCreateRenderTarget(self.screenWidth, self.screenHeight, false)

	self.blackWhiteShader = dxCreateShader("res/shaders/bw.fx")
	self.sunObjectShader = dxCreateShader("res/shaders/sun.fx")
	
	self.isLoaded = self.shaderManager and self.screenSource and self.renderTargetBW and self.renderTargetSO and self.blackWhiteShader and self.sunObjectShader
end


function ShaderSunC:deleteSunShader()
	
	if (self.renderTargetBW) then
		self.renderTargetBW:destroy()
		self.renderTargetBW = nil
	end
	
	if (self.renderTargetSO) then
		self.renderTargetSO:destroy()
		self.renderTargetSO = nil
	end
	
	if (self.blackWhiteShader) then
		self.blackWhiteShader:destroy()
		self.blackWhiteShader = nil
	end
	
	if (self.sunObjectShader) then
		self.sunObjectShader:destroy()
		self.sunObjectShader = nil
	end
end


function ShaderSunC:toggleGodrayShader(state)
	if (state) then
		if (state == "true") then
			self:createGodrayShader()
		elseif (state == "false") then
			self:deleteGodrayShader()
		end
	end
end


function ShaderSunC:createGodrayShader()
	self.renderTargetGB = dxCreateRenderTarget(self.screenWidth, self.screenHeight, false)
	self.renderTargetBL = dxCreateRenderTarget(self.screenWidth, self.screenHeight, false)
	
	self.godRayBaseShader = dxCreateShader("res/shaders/godRayBase.fx")
	self.blurShader = dxCreateShader("res/shaders/blur.fx")
	
	self.shaderManager.godraysEnabled = "true"
end


function ShaderSunC:deleteGodrayShader()
	if (self.renderTargetGB) then
		self.renderTargetGB:destroy()
		self.renderTargetGB = nil
	end
	
	if (self.renderTargetBL) then
		self.renderTargetBL:destroy()
		self.renderTargetBL = nil
	end
	
	if (self.godRayBaseShader) then
		self.godRayBaseShader:destroy()
		self.godRayBaseShader = nil
	end
	
	if (self.blurShader) then
		self.blurShader:destroy()
		self.blurShader = nil
	end
	
	self.shaderManager.godraysEnabled = "false"
end


function ShaderSunC:toggleLensFlareShader(state)
	if (state) then
		if (state == "true") then
			self:createLensFlareShader()
		elseif (state == "false") then
			self:deleteLensFlareShader()
		end
	end
end


function ShaderSunC:createLensFlareShader()
	self.renderTargetLF = dxCreateRenderTarget(self.screenWidth, self.screenHeight, false)
	
	self.lensFlareShader = dxCreateShader("res/shaders/lensflares.fx")
	self.lensFlareDirt = dxCreateTexture("res/textures/env/lensflare_dirt.png")
	self.lensFlareChroma = dxCreateTexture("res/textures/env/lensflare_chroma.png")
	
	self.shaderManager.lensflareEnabled = "true"
end


function ShaderSunC:deleteLensFlareShader()
	if (self.renderTargetLF) then
		self.renderTargetLF:destroy()
		self.renderTargetLF = nil
	end
	
	if (self.lensFlareShader) then
		self.lensFlareShader:destroy()
		self.lensFlareShader = nil
	end
	
	if (self.lensFlareDirt) then
		self.lensFlareDirt:destroy()
		self.lensFlareDirt = nil
	end
	
	if (self.lensFlareChroma) then
		self.lensFlareChroma:destroy()
		self.lensFlareChroma = nil
	end
	
	self.shaderManager.lensflareEnabled = "false"
end



function ShaderSunC:update()
	if (self.isLoaded) then
		self.screenSource:update()
		
		self.finalResult = self.screenSource
		
		self.sunColor = self.shaderManager:getSunColor()
		
		local sx, sy, sz = unpack(self.shaderManager:getSunPosition())
		self.sunScreenX, self.sunScreenY = getScreenFromWorldPosition(sx, sy, sz, 0.1, true)
		
		if (self.sunScreenX) and (self.sunScreenY) then
			self.blackWhiteShader:setValue("screenSource", self.screenSource)
			self.blackWhiteShader:setValue("viewDistance", self.bwViewDistance)
			
			dxSetRenderTarget(self.renderTargetBW, true)
			dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.blackWhiteShader)
			dxSetRenderTarget()
			
			self.sunObjectShader:setValue("bwSource", self.renderTargetBW)
			self.sunObjectShader:setValue("sunPos", {(1 / self.screenWidth) * self.sunScreenX, (1 / self.screenHeight) * self.sunScreenY})
			self.sunObjectShader:setValue("sunSize", self.sunSize)
			
			dxSetRenderTarget(self.renderTargetSO, true)
			dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.sunObjectShader)
			dxSetRenderTarget()
			
			self.finalResult = self.renderTargetSO
			
			if (self.shaderManager.godraysEnabled == "true") then
				if (self.godRayBaseShader) and (self.renderTargetGB) and (self.blurShader) and (self.renderTargetBL) then
					self.godRayBaseShader:setValue("sunLight", self.finalResult)
					self.godRayBaseShader:setValue("sunPos", {(1 / self.screenWidth) * self.sunScreenX, (1 / self.screenHeight) * self.sunScreenY})
					self.godRayBaseShader:setValue("godRayStrength", 1.0 - self.godRayStrength)
					self.godRayBaseShader:setValue("godRayStartOffset", 1.0 - self.godRayStartOffset)
					self.godRayBaseShader:setValue("godRayLength", 1.0 - self.godRayLength)
					self.godRayBaseShader:setValue("screenSize", {self.screenWidth, self.screenHeight})
					
					dxSetRenderTarget(self.renderTargetGB, true)
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.godRayBaseShader)
					dxSetRenderTarget()
					
					self.blurShader:setValue("screenSource", self.renderTargetGB)
					self.blurShader:setValue("screenSize", {self.screenWidth, self.screenHeight})
					self.blurShader:setValue("blurStrength", self.blurStrength)
					
					dxSetRenderTarget(self.renderTargetBL, true)
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.blurShader)
					dxSetRenderTarget()
					
					self.finalResult = self.renderTargetBL
				end
			end
			
			if (self.shaderManager.lensflareEnabled == "true") then
				if (self.lensFlareShader) and (self.lensFlareDirt) and (self.lensFlareChroma) then
					self.lensFlareShader:setValue("sunLight", self.finalResult)
					self.lensFlareShader:setValue("lensDirt", self.lensFlareDirt)
					self.lensFlareShader:setValue("lensChroma", self.lensFlareChroma)
					self.lensFlareShader:setValue("sunColor", self.sunColor)
					self.lensFlareShader:setValue("sunPos", {(1 / self.screenWidth) * self.sunScreenX, (1 / self.screenHeight) * self.sunScreenY})

					dxSetRenderTarget(self.renderTargetLF, true)
					dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.lensFlareShader)
					dxSetRenderTarget()
				
					self.finalResult = self.renderTargetLF
				end
			end
		else
			dxSetRenderTarget(self.renderTargetSO, true)
			dxSetRenderTarget()
			
			self.finalResult = self.renderTargetSO
		end
	end
end


function ShaderSunC:getResult()
	return self.finalResult
end


function ShaderSunC:clear()
	
	removeEventHandler("MKTOGGLEGODRAYSHADER", root, self.m_ToggleGodrayShader)
	removeEventHandler("MKTOGGLELENSFLARESHADER", root, self.m_ToggleLensFlareShader)
	
	if (self.screenSource) then
		self.screenSource:destroy()
		self.screenSource = nil
	end
	
	self:deleteSunShader()
	self:deleteGodrayShader()
	self:deleteLensFlareShader()
end


function ShaderSunC:destructor()
	
	self:clear()
	
	mainOutput("ShaderSunC was deleted.")
end