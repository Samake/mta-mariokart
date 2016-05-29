--[[
	Name: 1Modeler
	Filename: Modeler.lua
	Author: Sam@ke
--]]

local mapID = 15050
local maxObjects = 10
local lodDistance = 250

addEventHandler("onClientResourceStart", resourceRoot, 
function(resource)
	
	for i = 1, maxObjects do
		objectTexture = engineLoadTXD("models/koopa.txd")
		objectModel = engineLoadDFF("models/koopa" .. i .. ".dff", mapID + i)
		objectCol = engineLoadCOL("models/koopa" .. i .. ".col")
		
		engineImportTXD(objectTexture, mapID + i)
		engineReplaceModel(objectModel, mapID + i)
		engineReplaceCOL(objectCol, mapID + i)
		
		if (not objectTexture) then
			outputChatBox("Load texture " .. i .. " failed!")
		end
		
		if (not objectModel) then
			outputChatBox("Load model " .. i .. " failed!")
		end
		
		if (not objectCol) then
			outputChatBox("Load col " .. i .. " failed!")
		end
		
		if (objectTexture) and (objectModel) and (objectCol) then
			outputChatBox("Object " .. i .. " loaded!")
		end
	end

	
	for i, object in pairs(getElementsByType("object")) do
		if isElement(object) then
			for j = mapID, mapID + maxObjects - 2, 1 do
				if (getElementModel(object) == j) then
					local lodX, lodY, lodZ = getElementPosition(object)
					local lodObject = createObject(j, lodX, lodY, lodZ, 0, 0, 0, true)
					setLowLODElement(object, lodObject)
					engineSetModelLODDistance(j, lodDistance)
					setElementDoubleSided(object, true)
					outputChatBox("Lod for object " .. j .. " was set!")
				end
			end
		end
	end
end)