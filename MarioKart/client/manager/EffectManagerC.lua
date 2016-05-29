--[[
	Filename: EffectManagerC.lua
	Authors: Sam@ke
--]]

EffectManagerC = {}

function EffectManagerC:constructor(parent)
	mainOutput("EffectManagerC was loaded.")
	
	self.mainClass = parent

	self.m_AddGlassFX = bind(self.addGlassFX, self)
	addEvent("MKADDGLASSFX", true)
	addEventHandler("MKADDGLASSFX", root, self.m_AddGlassFX)

end


function EffectManagerC:addGlassFX(effectProperties)
	if (effectProperties) then
		
		fxAddGlass(effectProperties.x, effectProperties.y, effectProperties.z, effectProperties.r, effectProperties.g, effectProperties.b, effectProperties.a, effectProperties.scale, effectProperties.count)
	end
end


function EffectManagerC:clear()
	for index, effect in pairs(getElementsByType("effect")) do
		if (effect) then
			effect:destroy()
			effect = nil
		end
	end
end


function EffectManagerC:destructor()
	self:clear()
	
	removeEventHandler("MKADDGLASSFX", root, self.m_AddGlassFX)

	mainOutput("EffectManagerC was deleted.")
end