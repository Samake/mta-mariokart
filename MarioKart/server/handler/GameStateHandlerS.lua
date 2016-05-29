--[[
	Filename: GameStateHandlerS.lua
	Author: Sam@ke
--]]

GameStateHandlerS = {}

function GameStateHandlerS:constructor(parent)
	mainOutput("GameStateHandlerS was loaded.")

	self.mainClass = parent
	
	self.startTime = 5000
	self.gameState = "idle"

	self:init()
end


function GameStateHandlerS:init()
	self.m_StartServer = bind(self.startServer, self)
	self.m_PauseServer = bind(self.pauseServer, self)
	
	setTimer(self.m_StartServer, self.startTime, 1)
end


function GameStateHandlerS:startServer()
	self.gameState = "loadMap"
	
	
	--[[for index, player in pairs(getElementsByType("player")) do
		if (player) and (isElement(player)) then
			triggerEvent("Client:requestFiles", player, player)
		end
	end]]
end


function GameStateHandlerS:updateFast()

end


function GameStateHandlerS:updateSlow()
	triggerEvent("MKUPDATEGAMESTATE", root, self.gameState)
end


function GameStateHandlerS:pauseServer()
	self.gameState = "idle"
end


function GameStateHandlerS:destructor()

	mainOutput("GameStateHandlerS was deleted.")
end
