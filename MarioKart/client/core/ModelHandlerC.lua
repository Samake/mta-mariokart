--[[
	Filename: ModelHandlerC.lua
	Authors: Sam@ke
--]]

ModelHandlerC = {}


function ModelHandlerC:constructor(parent)

	mainOutput("ModelHandlerC was loaded.")
	
	self.mainClass = parent

	self.models = {}
	-- // Skins // --
	self.models[101] = {id = 190, pathTXD = "res/models/skins/Peach.txd", pathDFF = "res/models/skins/Peach.dff", pathCOL = nil} -- peach

	-- // Vehicles // --
	self.models[201] = {id = 602, pathTXD = "res/models/karts/kart.txd", pathDFF = "res/models/karts/kart.dff", pathCOL = nil} -- kart mario
	
	-- // Models // --
	self.models[301] = {id = 1851, pathTXD = "res/models/skybox.txd", pathDFF = "res/models/skybox.dff", pathCOL = nil} -- skybox
	self.models[302] = {id = 2215, pathTXD = "res/models/item.txd", pathDFF = "res/models/item.dff", pathCOL = "res/models/item.col"} -- item pickup good
	self.models[303] = {id = 2216, pathTXD = "res/models/item.txd", pathDFF = "res/models/itemBad.dff", pathCOL = "res/models/item.col"} -- item pickup bad
	self.models[304] = {id = 2217, pathTXD = "res/models/item.txd", pathDFF = "res/models/itemInner.dff", pathCOL = "res/models/item.col"} -- item pickup inner
	self.models[305] = {id = 2218, pathTXD = "res/models/coin.txd", pathDFF = "res/models/coin.dff", pathCOL = nil} -- coin
	
	self:init()
end


function ModelHandlerC:init()

	for index, modelInfo in pairs(self.models) do
		if (modelInfo) then
			if (modelInfo.id) then
				if (modelInfo.pathTXD) then
					local texture = engineLoadTXD(modelInfo.pathTXD)
					engineImportTXD(texture, modelInfo.id)
				end
				
				if (modelInfo.pathDFF) then
					local model = engineLoadDFF(modelInfo.pathDFF)
					engineReplaceModel(model, modelInfo.id)
				end
				
				if (modelInfo.pathCOL) then
					local col = engineLoadCOL(modelInfo.pathCOL)
					engineReplaceCOL(col, modelInfo.id)
				end
			end
		end
	end
end


function ModelHandlerC:destructor()
	
	mainOutput("ModelHandlerC was deleted.")
end
