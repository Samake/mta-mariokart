--[[
	Name: 1Modeler
	Filename: Modeler.lua
	Author: Sam@ke
--]]

local mapID = 15050
local maxObjects = 4

addEventHandler("onClientResourceStart", resourceRoot, 
function(resource)
	
	for i = 1, maxObjects do
		objectTexture = engineLoadTXD("models/mini3.txd")
		objectModel = engineLoadDFF("models/mini3" .. i .. ".dff", mapID + i)
		objectCol = engineLoadCOL("models/mini3" .. i .. ".col")
		
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
			for j = mapID, mapID + maxObjects, 1 do
				if (getElementModel(object) == j) then
					local lodX, lodY, lodZ = getElementPosition(object)
					local lodRX, lodRY, lodRZ = getElementRotation(object) 
					local lodObject = createObject(j, lodX, lodY, lodZ, lodRX, lodRY, lodRZ, true)
					setLowLODElement(object, lodObject)
					engineSetModelLODDistance(j, 100)
					setElementDoubleSided(object, true)
				end
			end
		end
	end
end)