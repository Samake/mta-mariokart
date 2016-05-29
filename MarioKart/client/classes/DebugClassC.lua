--[[
	Filename: DebugClassC.lua
	Author: Sam@ke
--]]

DebugClassC = {}

function DebugClassC:constructor(parent)

	self.mainClass = parent
	self.player = getLocalPlayer()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.scaleFactor = (1 /1080) * self.screenHeight

	self.width = self.screenWidth * 0.8
	self.height = self.screenHeight * 0.8
	
	self.fontSize = 1.5 * self.scaleFactor
	self.lineSize = 25 * self.scaleFactor
	
	self.postGUI = true
	self.subPixelPositioning = true
	self.font = "default-bold"

	self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)

	self.isLoaded = self.renderTarget and self.mainClass and self.mainClass.dataManager
	
	mainOutput("DebugClassC was loaded.")
end


function DebugClassC:update()

	self.isLoaded = self.renderTarget and self.mainClass and self.mainClass.dataManager
	
	self.serverStats = self.mainClass.dataManager:getServerStats()
	
	if (self.isLoaded) and (self.serverStats) then
		self.startX = (self.screenWidth * 0.5) - (self.width * 0.5)
		self.startY = (self.screenHeight * 0.5) - (self.height * 0.5)
		
		self.firstColumnX = (self.screenWidth * 0.5) - (self.width * 0.45)
		self.secondColumnX = (self.screenWidth * 0.5) - (self.width * 0.2)
		self.thirdColumnX = (self.screenWidth * 0.5) + (self.width * 0.05)
		self.fourthColumnX = (self.screenWidth * 0.5) + (self.width * 0.3)
		
		dxSetRenderTarget(self.renderTarget, true)
		
		-- // Background // --
		dxDrawRectangle(self.startX, self.startY, self.width, self.height, tocolor(15, 15, 15, 180), self.postGUI, self.subPixelPositioning)
		
		-- // MainTitle // --
		local x, y = self.screenWidth * 0.5, self.startY + self.lineSize
		dxDrawText("#EECC22MK Debugscreen v0.1", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize * 1.5, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		-- // Titles // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 3
		dxDrawText("#8888EECore", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		local x, y = self.secondColumnX, self.startY + self.lineSize * 3
		dxDrawText("#8888EEElements", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)	
		
		local x, y = self.thirdColumnX, self.startY + self.lineSize * 3
		dxDrawText("#8888EEStats", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		local x, y = self.fourthColumnX, self.startY + self.lineSize * 3
		dxDrawText("#8888EEShaders", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		-- // Vertical Line // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 4
		dxDrawLine(x - 5, y, (x + self.width * 0.9) + 5, y, tocolor(200, 200, 200, 200), 1, self.postGUI)
		
		
		-- // FIRST COLUM // --
		
		-- // MySQL Connection // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 5
		
		if (self.serverStats.hasMySQLConnection) then
			if (self.serverStats.hasMySQLConnection == "true") then
				dxDrawText("#EEEEEEMySQL Connection || #22EE22" .. self.serverStats.hasMySQLConnection, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEMySQL Connection || #EE2222" .. self.serverStats.hasMySQLConnection, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
		else
			dxDrawText("#EEEEEEMySQL Connection || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // GameState // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 6
		
		if (self.serverStats.gameState) then
			dxDrawText("#EEEEEEGameState || #EEEE22" .. self.serverStats.gameState, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEGameState || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Internal MapManager // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 7
		
		if (self.serverStats.isInternalMapManager) then
			if (self.serverStats.isInternalMapManager == "true") then
				dxDrawText("#EEEEEEInternalMapManager || #22EE22" .. self.serverStats.isInternalMapManager, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEInternalMapManager || #EE2222" .. self.serverStats.isInternalMapManager, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
		else
			dxDrawText("#EEEEEEInternalMapManager || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // External MapManager // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 8
		
		if (self.serverStats.isExternalMapManager) then
			if (self.serverStats.isExternalMapManager == "true") then
				dxDrawText("#EEEEEEExternalMapManager || #22EE22" .. self.serverStats.isExternalMapManager, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEExternalMapManager || #EE2222" .. self.serverStats.isExternalMapManager, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
		else
			dxDrawText("#EEEEEEExternalMapManager || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // MapCount // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 9
		
		if (self.serverStats.mapCount) then
			dxDrawText("#EEEEEEAvailable Maps || #22EE22" .. self.serverStats.mapCount, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEAvailable Maps || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		
		-- // MapLoader // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 10
		
		if (self.serverStats.isMapLoader) then
			if (self.serverStats.isMapLoader == "true") then
				dxDrawText("#EEEEEEMapLoader || #22EE22" .. self.serverStats.isMapLoader, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEMapLoader || #EE2222" .. self.serverStats.isMapLoader, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
		else
			dxDrawText("#EEEEEEMapLoader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Current Map // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 11
		
		if (self.serverStats.currentMapName) then
			dxDrawText("#EEEEEECurrent map || #22EE22" .. self.serverStats.currentMapName, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEECurrent map || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Previous Map // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 12
		
		if (self.serverStats.previousMapName) then
			dxDrawText("#EEEEEEPrevious map || #22EE22" .. self.serverStats.previousMapName, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEPrevious map || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Next Map // --
		local x, y = self.firstColumnX, self.startY + self.lineSize * 13
		
		if (self.serverStats.nextMapName) then
			dxDrawText("#EEEEEENext map || #22EE22" .. self.serverStats.nextMapName, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEENext map || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // SECOND COLUM // --
		
		-- // Players // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 5
		
		if (self.serverStats.playerCount) then
			dxDrawText("#EEEEEEPlayers || S: #22EE22" .. self.serverStats.playerCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("player"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEPlayers || S: #FF8833UNKNOWN #EEEEEEC: #22EE22" .. #getElementsByType("player"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Vehicles // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 6
		
		if (self.serverStats.vehicleCount) then
			dxDrawText("#EEEEEEVehicles || S: #22EE22" .. self.serverStats.vehicleCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("vehicle"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEVehicles || S: #FF8833UNKNOWN #EEEEEEC: #22EE22" .. #getElementsByType("vehicle"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Objects // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 7
		
		if (self.serverStats.objectCount) then
			dxDrawText("#EEEEEEObjects || S: #22EE22" .. self.serverStats.objectCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("object"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEObjects || S: #FF8833UNKNOWN #EEEEEEC: #22EE22" .. #getElementsByType("object"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Colshapes // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 8
		
		if (self.serverStats.colCount) then
			dxDrawText("#EEEEEEColshapes || S: #22EE22" .. self.serverStats.colCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("colshape"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEColshapes || S: #FF8833UNKNOWN #EEEEEEC: #22EE22" .. #getElementsByType("colshape"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Sounds // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 9
		
		if (self.serverStats.soundCount) then
			dxDrawText("#EEEEEESounds || S: #22EE22" .. self.serverStats.soundCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("sound"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEESounds || S: #FF8833UNKNOWN #EEEEEEC: #22EE22" .. #getElementsByType("sound"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Effects // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 10
		
		if (self.serverStats.effectCount) then
			dxDrawText("#EEEEEEEffects || S: #22EE22" .. self.serverStats.effectCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("effect"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEEffects || S: #FF8833UNKNOWN #EEEEEEC: #22EE22" .. #getElementsByType("effect"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Timer // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 11
		
		if (self.serverStats.timerCount) then
			dxDrawText("#EEEEEETimer|| S: #22EE22" .. self.serverStats.timerCount .. " #EEEEEEC: #22EE22" .. #getTimers(), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEETimer || S: #FF8833UNKNOWN #EEEEEEC: #22EE22" .. #getElementsByType("sound"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Player spawns // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 12
		
		if (self.serverStats.playerSpawnCount) then
			dxDrawText("#EEEEEEPlayer Spawns || S: #22EE22" .. self.serverStats.playerSpawnCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("spawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEPlayer Spawns || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("spawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Respawn Points // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 13
		
		if (self.serverStats.respawnCount) then
			dxDrawText("#EEEEEERespawn Points || S: #22EE22" .. self.serverStats.respawnCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("respawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEERespawn Points || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("respawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Respawn areas // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 14
		
		if (self.serverStats.respawnAreasCount) then
			dxDrawText("#EEEEEERespawn areas || S: #22EE22" .. self.serverStats.respawnAreasCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("respawnArea"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEERespawn areas || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("respawnArea"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Item Spawns // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 15
		
		if (self.serverStats.itemSpawnCount) then
			dxDrawText("#EEEEEEItem Spawns || S: #22EE22" .. self.serverStats.itemSpawnCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("itemspawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEItem Spawns || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("itemspawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Coin Spawns // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 16
		
		if (self.serverStats.coinSpawnCount) then
			dxDrawText("#EEEEEECoin Spawns || S: #22EE22" .. self.serverStats.coinSpawnCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("coinspawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEECoin Spawns || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("coinspawnpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Checkpoints // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 17
		
		if (self.serverStats.checkpointCount) then
			dxDrawText("#EEEEEECheckpoints || S: #22EE22" .. self.serverStats.checkpointCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("checkpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEECheckpoints || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("checkpoint"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Finish // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 18
		
		if (self.serverStats.finishCount) then
			dxDrawText("#EEEEEEFinish || S: #22EE22" .. self.serverStats.finishCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("finish"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEFinish || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("finish"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // Boostfields // --
		local x, y = self.secondColumnX, self.startY + self.lineSize * 19
		
		if (self.serverStats.boostfieldCount) then
			dxDrawText("#EEEEEEBoostfields || S: #22EE22" .. self.serverStats.boostfieldCount .. " #EEEEEEC: #22EE22" .. #getElementsByType("boostfield"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEBoostfields || S: #FF8833UNKNOWN" .. " #EEEEEEC: #22EE22" .. #getElementsByType("boostfield"), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // THIRD COLUM // --
		
		-- // FPS // --
		local x, y = self.thirdColumnX, self.startY + self.lineSize * 5
		
		if (self.mainClass.dataManager:getFPS()) then
			dxDrawText("#EEEEEEFPS || #22EE22" .. self.mainClass.dataManager:getFPS(), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEFPS || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // PING // --
		local x, y = self.thirdColumnX, self.startY + self.lineSize * 6
		
		if (self.mainClass.dataManager:getPing()) then
			dxDrawText("#EEEEEEPing || #22EE22" .. self.mainClass.dataManager:getPing(), x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		else
			dxDrawText("#EEEEEEPing || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		-- // FOURTH COLUM // --
		
		-- // shadermander // --
		if (self.mainClass.renderClass) then
			
			-- // blur shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 5
		
			if (self.mainClass.renderClass.blurShaderEnabled == "true") then
				dxDrawText("#EEEEEEBlur Shader || #22EE22" .. self.mainClass.renderClass.blurShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEBlur Shader || #EE2222" .. self.mainClass.renderClass.blurShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
		end
		
		-- // shadermander // --
		if (self.mainClass.shaderManager) then
		
			-- // water shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 6
		
			if (self.mainClass.shaderManager.waterShaderEnabled == "true") then
				dxDrawText("#EEEEEEWater Shader || #22EE22" .. self.mainClass.shaderManager.waterShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEWater Shader || #EE2222" .. self.mainClass.shaderManager.waterShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // boost field shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 7
			
			if (self.mainClass.shaderManager.boostFieldShaderEnabled == "true") then
				dxDrawText("#EEEEEEBoostField Shader || #22EE22" .. self.mainClass.shaderManager.boostFieldShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEBoostField Shader || #EE2222" .. self.mainClass.shaderManager.boostFieldShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // ambient light shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 8
			
			if (self.mainClass.shaderManager.ambientLightShaderEnabled == "true") then
				dxDrawText("#EEEEEEAmbientLight Shader || #22EE22" .. self.mainClass.shaderManager.ambientLightShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEAmbientLight Shader || #EE2222" .. self.mainClass.shaderManager.ambientLightShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // dof shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 9
			
			if (self.mainClass.shaderManager.dofShaderEnabled == "true") then
				dxDrawText("#EEEEEEDoF Shader || #22EE22" .. self.mainClass.shaderManager.dofShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEDoF Shader || #EE2222" .. self.mainClass.shaderManager.dofShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // item shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 10
			
			if (self.mainClass.shaderManager.itemShaderEnabled == "true") then
				dxDrawText("#EEEEEEItem Shader || #22EE22" .. self.mainClass.shaderManager.itemShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEItem Shader || #EE2222" .. self.mainClass.shaderManager.itemShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // coin shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 11
			
			if (self.mainClass.shaderManager.coinShaderEnabled == "true") then
				dxDrawText("#EEEEEECoin Shader || #22EE22" .. self.mainClass.shaderManager.coinShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEECoin Shader || #EE2222" .. self.mainClass.shaderManager.coinShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // skybox shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 12
			
			if (self.mainClass.shaderManager.skyBoxShaderEnabled == "true") then
				dxDrawText("#EEEEEESkybox Shader || #22EE22" .. self.mainClass.shaderManager.skyBoxShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEESkybox Shader || #EE2222" .. self.mainClass.shaderManager.skyBoxShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // sun shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 13
			
			if (self.mainClass.shaderManager.sunShaderEnabled == "true") then
				dxDrawText("#EEEEEESun Shader || #22EE22" .. self.mainClass.shaderManager.sunShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEESun Shader || #EE2222" .. self.mainClass.shaderManager.sunShaderEnabled, x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
		else
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 5
			dxDrawText("#EEEEEEBlur Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 6
			dxDrawText("#EEEEEEWater Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 7
			dxDrawText("#EEEEEEBoostField Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 8
			dxDrawText("#EEEEEEAmbientLight Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 9
			dxDrawText("#EEEEEEDoF Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 10
			dxDrawText("#EEEEEEItem Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 11
			dxDrawText("#EEEEEECoin Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 12
			dxDrawText("#EEEEEESkybox Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 13
			dxDrawText("#EEEEEESun Shader || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		end
		
		
		-- // renderClass // --
		if (self.mainClass.renderClass) then
			
			-- // pictrue quality shader // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 14
			
			if (self.mainClass.renderClass.pictureQualityShader) then
				dxDrawText("#EEEEEEPictureQuality Shader || #22EE22true" , x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			else
				dxDrawText("#EEEEEEPictureQuality Shader || #EE2222false", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			end
			
			-- // saturation // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 15
			dxDrawText("#EEEEEESaturation || #22EE22" .. self.mainClass.renderClass.currentSaturation , x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			-- // brightness // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 16
			dxDrawText("#EEEEEEBrightness || #22EE22" .. self.mainClass.renderClass.currentBrightness , x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			-- // contrast // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 17
			dxDrawText("#EEEEEEContrast || #22EE22" .. self.mainClass.renderClass.currentContrast , x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
			-- // blur // --
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 18
			dxDrawText("#EEEEEEBlur || #22EE22" .. self.mainClass.renderClass.currentBlur , x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		else
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 14
			dxDrawText("#EEEEEEPictureQuality || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 15
			dxDrawText("#EEEEEESaturation || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 16
			dxDrawText("#EEEEEEBrightness || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 17
			dxDrawText("#EEEEEEContrast || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
			local x, y = self.fourthColumnX, self.startY + self.lineSize * 18
			dxDrawText("#EEEEEEBlur || #FF8833UNKNOWN", x, y, x, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		end
		
		dxSetRenderTarget()
		
		dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.renderTarget)
		
	end
end


function DebugClassC:destructor()

	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end

	mainOutput("DebugClassC was stopped.")
end
