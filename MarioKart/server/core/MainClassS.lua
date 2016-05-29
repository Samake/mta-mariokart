--[[
	Filename: MainClassS.lua
	Authors: Sam@ke
--]]

local Instance = nil

MainClassS = {}


function MainClassS:constructor()
	self.appName = getMyResourceName()
	self.version = getMyResourceVersion()
	self.fpsLimit = getMyFPSLimit()
	self.serverUpdateFastInterVal = getServerUpdateFastInterVal()
	self.serverUpdateSlowInterVal = getServerUpdateSlowInterVal()

	mainOutput("SERVER || ***** " .. self.appName .. " was started! v" .. self.version .. " *****")
	mainOutput("MainClassS was loaded.")

	self:setServerParams()
	self:init()
end


function MainClassS:setServerParams()
	setFPSLimit(self.fpsLimit)
end

function MainClassS:setServerParams()
	for i = 550, 20000 do
		removeWorldModel(i, 10000, 0, 0, 0)
	end
end


function MainClassS:init()
	setHeatHaze(0)
	setRainLevel(0)
	setSunSize(0)
	setSunColor(255, 255, 255, 255, 255, 255)
	setMoonSize(0)
	setWindVelocity(0, 0, 0)
	setOcclusionsEnabled(false)
	setCloudsEnabled(false)
	setFogDistance(1000)
	setFarClipDistance (1200)
	
	self.m_UpdateFast = bind(self.updateFast, self)
	self.m_UpdateSlow = bind(self.updateSlow, self)

	if (not self.updateTimerFast) then
		self.updateTimerFast = setTimer(self.m_UpdateFast, self.serverUpdateFastInterVal, 0)
	end
	
	if (not self.updateTimerSlow) then
		self.updateTimerSlow = setTimer(self.m_UpdateSlow, self.serverUpdateSlowInterVal, 0)
	end
	
	if (not self.mapLoader) then
		-- // wont work at the moment // --
		--self.mapLoader = new(MapLoaderS, self)
	end
	
	if (not self.vehicleManager) then
		self.vehicleManager = new(VehicleManagerS, self)
	end

	if (not self.mapManager) then
		self.mapManager = new(MapManagerS, self)
	end

	if (not self.playerManager) then
		self.playerManager = new(PlayerManagerS, self)
	end

	if (not self.debugClass) then
		self.debugClass = new(DebugClassS, self)
	end

	if (not self.gameStateHandler) then
		self.gameStateHandler = new(GameStateHandlerS, self)
	end
	
	if (not self.waterManager) then
		self.waterManager = new(WaterManagerS, self)
	end
	
	if (not self.itemBlockManager) then
		self.itemBlockManager = new(ItemBlockManagerS, self)
	end
	
	if (not self.coinManager) then
		self.coinManager = new(CoinManagerS, self)
	end

	if (not self.dataManager) then
		self.dataManager = new(DataManagerS, self, self.playerManager)
	end
end


function MainClassS:updateFast()
	if (self.mapLoader) then
		self.mapLoader:updateFast()
	end
	
	if (self.mapManager) then
		self.mapManager:updateFast()
	end

	if (self.playerManager) then
		self.playerManager:updateFast()
	end

	if (self.debugClass) then
		self.debugClass:updateFast()
	end

	if (self.gameStateHandler) then
		self.gameStateHandler:updateFast()
	end

	if (self.dataManager) then
		self.dataManager:updateFast()
	end
	
	if (self.waterManager) then
		self.waterManager:updateFast()
	end
	
	if (self.itemBlockManager) then
		self.itemBlockManager:updateFast()
	end
	
	if (self.coinManager) then
		self.coinManager:updateFast()
	end
end


function MainClassS:updateSlow()
	if (self.mapManager) then
		self.mapManager:updateSlow()
	end

	if (self.playerManager) then
		self.playerManager:updateSlow()
	end

	if (self.debugClass) then
		self.debugClass:updateSlow()
	end

	if (self.gameStateHandler) then
		self.gameStateHandler:updateSlow()
	end

	if (self.dataManager) then
		self.dataManager:updateSlow()
	end
	
	if (self.itemBlockManager) then
		self.itemBlockManager:updateSlow()
	end
	
	if (self.coinManager) then
		self.coinManager:updateSlow()
	end
end


function MainClassS:clear()
	if (self.updateTimerFast) then
		self.updateTimerFast:destroy()
		self.updateTimerFast = nil
	end

	if (self.updateTimerSlow) then
		self.updateTimerSlow:destroy()
		self.updateTimerSlow = nil
	end

	if (self.vehicleManager) then
		delete(self.vehicleManager)
		self.vehicleManager = nil
	end
	
	if (self.mapManager) then
		delete(self.mapManager)
		self.mapManager = nil
	end

	if (self.playerManager) then
		delete(self.playerManager)
		self.playerManager = nil
	end

	if (self.debugClass) then
		delete(self.debugClass)
		self.debugClass = nil
	end

	if (self.gameStateHandler) then
		delete(self.gameStateHandler)
		self.gameStateHandler = nil
	end

	if (self.dataManager) then
		delete(self.dataManager)
		self.dataManager = nil
	end
	
	if (self.waterManager) then
		delete(self.waterManager)
		self.waterManager = nil
	end
	
	if (self.itemBlockManager) then
		delete(self.itemBlockManager)
		self.itemBlockManager = nil
	end
	
	if (self.coinManager) then
		delete(self.coinManager)
		self.coinManager = nil
	end
	
	setOcclusionsEnabled(true)
	setCloudsEnabled(true) 
	resetFarClipDistance()
	resetFogDistance()
	resetHeatHaze()
	resetMoonSize()
	resetRainLevel()
	resetSunColor()
	resetSunSize()
	resetWaterLevel()
	restoreAllWorldModels()
end


function MainClassS:resetServerParams()

end


function MainClassS:destructor()
	self:clear()
	self:resetServerParams()

	mainOutput("MainClassS was deleted.")
	mainOutput("SERVER || ***** " .. self.appName .. " was stopped! " .. self.version .. " *****")
end


addEventHandler("onResourceStart", resourceRoot,
function()
	Instance = new(MainClassS)
end)


addEventHandler("onResourceStop", resourceRoot,
function()
	if (Instance) then
		delete(Instance)
		Instance = nil
	end
end)
