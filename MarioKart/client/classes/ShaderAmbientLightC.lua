--[[
	Filename: ShaderAmbientLightC.lua
	Author: Sam@ke
--]]

ShaderAmbientLightC = {}

function ShaderAmbientLightC:constructor(parent)
	mainOutput("ShaderAmbientLightC was loaded.")
	
	self.shaderManager = parent
	
	self.effectRange = 500
	
	self.textureSize = 256
	
	self.bumpMapFactorWorld = 0.35
	self.ambientIntensityWorld = 0.61
	self.diffuseIntensityWorld = 0.92
	self.specularIntensityWorld = 3.1
	self.specularSizeWorld = 8
	
	self.bumpMapFactorPeds = 0.15
	self.ambientIntensityPeds = 0.65
	self.diffuseIntensityPeds = 0.95
	self.specularIntensityPeds = 1.8
	self.specularSizePeds = 32
	
	self.bumpMapFactorVehicles = 0.55
	self.ambientIntensityVehicles = 0.58
	self.diffuseIntensityVehicles = 0.98
	self.specularIntensityVehicles = 6.5
	self.specularSizeVehicles = 16
	
	self.excludingTextures = 	{	"waterclear256",
									"*smoke*",
									"*particle*",
									"*cloud*",
									"*splash*",
									"*corona*",
									"*radar*",
									"*wgush1*",
									"*debris*",
									"*wjet4*",
									"*gun*",
									"*wake*",
									"*effect*",
									"*fire*",
									"muzzle_texture*",
									"*font*",
									"*icon*",
									"shad_exp",
									"*headlight*", 
									"*corona*",
									"sfnitewindow_alfa", 
									"sfnitewindows", 
									"monlith_win_tex", 
									"sfxref_lite2c",
									"dt_scyscrap_door2", 
									"white", 
									"casinolights*",
									"cj_frame_glass", 
									"custom_roadsign_text", 
									"dt_twinklylites",
									"vgsn_nl_strip", 
									"unnamed", 
									"white64", 
									"lasjmslumwin1",
									"pierwin05_law", 
									"nitwin01_la", 
									"sl_dtwinlights1", 
									"fist",
									"sphere",
									"*spark*",
									"glassmall",
									"*debris*",
									"wgush1",
									"wjet2",
									"wjet4",
									"beastie",
									"bubbles",
									"pointlight",
									"unnamed",
									"txgrass1_1", 
									"txgrass0_1", 
									"txgrass1_0",
									"item*",
									"undefined*",
									"turbo*",
									"coin*",
									"lava*",
									"ampelLight*",
									"sky*",
									"rccam92dirt64",
									"rccam92pot64"}

	self.ambientLightShaderWorld = dxCreateShader("res/shaders/ambientLight.fx", 0, self.effectRange, false, "world,object,other")
	self.ambientLightShaderPed = dxCreateShader("res/shaders/ambientLight.fx", 0, self.effectRange, false, "ped")
	self.ambientLightShaderVehicles = dxCreateShader("res/shaders/ambientLight.fx", 0, self.effectRange, false, "vehicle")
	
	self.isLoaded = self.shaderManager and self.ambientLightShaderWorld and self.ambientLightShaderPed and self.ambientLightShaderVehicles
	
	if (self.isLoaded) then		
		self.ambientLightShaderWorld:applyToWorldTexture("*")
		
		for _, texture in ipairs(self.excludingTextures) do
			self.ambientLightShaderWorld:removeFromWorldTexture(texture)
		end
		
		self.ambientLightShaderPed:applyToWorldTexture("*")
		self.ambientLightShaderVehicles:applyToWorldTexture("*")
	else
		mainOutput("ERROR: Shader dynamic light was NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderAmbientLightC:update()
	if (self.isLoaded) then
	
		self.sunColor = self.shaderManager:getSunColor()
		self.ambientColor = self.shaderManager:getAmbientColor()
		self.sunPos = self.shaderManager:getSunPosition()
		
		self.ambientLightShaderWorld:setValue("sunPos", self.sunPos)
		self.ambientLightShaderWorld:setValue("sunColor", self.sunColor)
		self.ambientLightShaderWorld:setValue("ambientColor", self.ambientColor)
		self.ambientLightShaderWorld:setValue("textureSize", self.textureSize)
		self.ambientLightShaderWorld:setValue("bumpMapFactor", self.bumpMapFactorWorld)
		self.ambientLightShaderWorld:setValue("ambientIntensity", self.ambientIntensityWorld)
		self.ambientLightShaderWorld:setValue("diffuseIntensity", self.diffuseIntensityWorld)
		self.ambientLightShaderWorld:setValue("specularIntensity", self.specularIntensityWorld)
		self.ambientLightShaderWorld:setValue("specularSize", self.specularSizeWorld)
		
		self.ambientLightShaderPed:setValue("sunPos", self.sunPos)
		self.ambientLightShaderPed:setValue("sunColor", self.sunColor)
		self.ambientLightShaderPed:setValue("ambientColor", self.ambientColor)
		self.ambientLightShaderPed:setValue("textureSize", self.textureSize)
		self.ambientLightShaderPed:setValue("bumpMapFactor", self.bumpMapFactorPeds)
		self.ambientLightShaderPed:setValue("ambientIntensity", self.ambientIntensityPeds)
		self.ambientLightShaderPed:setValue("diffuseIntensity", self.diffuseIntensityPeds)
		self.ambientLightShaderPed:setValue("specularIntensity", self.specularIntensityPeds)
		self.ambientLightShaderPed:setValue("specularSize", self.specularSizePeds)
	
		self.ambientLightShaderVehicles:setValue("sunPos", self.sunPos)
		self.ambientLightShaderVehicles:setValue("sunColor", self.sunColor)
		self.ambientLightShaderVehicles:setValue("ambientColor", self.ambientColor)
		self.ambientLightShaderVehicles:setValue("textureSize", self.textureSize)
		self.ambientLightShaderVehicles:setValue("bumpMapFactor", self.bumpMapFactorVehicles)
		self.ambientLightShaderVehicles:setValue("ambientIntensity", self.ambientIntensityVehicles)
		self.ambientLightShaderVehicles:setValue("diffuseIntensity", self.diffuseIntensityVehicles)
		self.ambientLightShaderVehicles:setValue("specularIntensity", self.specularIntensityVehicles)
		self.ambientLightShaderVehicles:setValue("specularSize", self.specularSizeVehicles)

	end
end


function ShaderAmbientLightC:destructor()

	if (self.ambientLightShaderWorld) then
		self.ambientLightShaderWorld:destroy()
		self.ambientLightShaderWorld = nil
	end
	
	if (self.ambientLightShaderPed) then
		self.ambientLightShaderPed:destroy()
		self.ambientLightShaderPed = nil
	end
	
	if (self.ambientLightShaderVehicles) then
		self.ambientLightShaderVehicles:destroy()
		self.ambientLightShaderVehicles = nil
	end

	mainOutput("ShaderAmbientLightC was deleted.")
end