--[[
	Filename: LoginS.lua
	Author: Sam@ke
--]]


LoginS = {}


function LoginS:constructor(parent)
	mainOutput("LoginS was loaded.")
	
	self.parent = parent

	self:init()
end


function LoginS:init()
	
end


function LoginS:clear()

end

function LoginS:destructor()
	
	self:clear()
	
	mainOutput("LoginS was deleted.")
end