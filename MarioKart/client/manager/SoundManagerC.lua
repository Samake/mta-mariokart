--[[
	Filename: SoundManagerC.lua
	Authors: Sam@ke
--]]

SoundManagerC = {}

function SoundManagerC:constructor(parent)
	mainOutput("SoundManagerC was loaded.")
	
	self.mainClass = parent
	self.ambientVolume = 0.085
	self.effectSoundDistance = 25
	self.effectSoundVolume = 0.5
	
	self.worldSounds = {}
	self.worldSounds[1] = {group = 2, index = 2} -- metal scratching of boots object
	
	self:disableWorldSounds()
	
	self.m_PlayAmbientSound = bind(self.playAmbientSound, self)
	addEvent("MKPLAYAMBIENTSOUND", true)
	addEventHandler("MKPLAYAMBIENTSOUND", root, self.m_PlayAmbientSound)
	
	self.m_PlayEffectSound = bind(self.playEffectSound, self)
	addEvent("MKPLAYEFFECTSOUND", true)
	addEventHandler("MKPLAYEFFECTSOUND", root, self.m_PlayEffectSound)
	
end


function SoundManagerC:enableWorldSounds()
	for index, worldsound in pairs(self.worldSounds) do
		if (worldsound) then
			setWorldSoundEnabled(worldsound.group, worldsound.index, true)
		end
	end
end


function SoundManagerC:disableWorldSounds()
	for index, worldsound in pairs(self.worldSounds) do
		if (worldsound) then
			setWorldSoundEnabled(worldsound.group, worldsound.index, false)
		end
	end
end


function SoundManagerC:playAmbientSound(path, loop)
	if (path) then
		local sound = playSound(path, loop)
		sound:setVolume(self.ambientVolume)
	end
end


function SoundManagerC:playEffectSound(soundProperties)
	if (soundProperties) then
		local sound = playSound3D(soundProperties.path, soundProperties.x, soundProperties.y, soundProperties.z, soundProperties.loop)
		sound:setVolume(self.effectSoundVolume)
		sound:setMaxDistance(self.effectSoundDistance)
	end
end


function SoundManagerC:clear()
	for index, sound in pairs(getElementsByType("sound")) do
		if (sound) then
			sound:destroy()
			sound = nil
		end
	end
end


function SoundManagerC:destructor()
	self:clear()
	self:enableWorldSounds()
	
	removeEventHandler("MKPLAYAMBIENTSOUND", root, self.m_PlayAmbientSound)
	removeEventHandler("MKPLAYEFFECTSOUND", root, self.m_PlayEffectSound)
	
	mainOutput("SoundManagerC was deleted.")
end