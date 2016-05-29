--[[
	Filename: DebugClassS.lua
	Author: Sam@ke
--]]

DebugClassS = {}

function DebugClassS:constructor(parent)

	self.coreClass = parent

	mainOutput("DebugClassS was loaded.")
end


function DebugClassS:updateFast()

end


function DebugClassS:updateSlow()

end


function DebugClassS:destructor()

	mainOutput("DebugClassS was stopped.")
end
