local objectID = 15050
local flowerObjectID = 15064
local maxObjects = 14
local lodDistance = 300

addEventHandler("onClientResourceStart", resourceRoot, 
function(resource)
	if (resource == getThisResource()) then
		for i = 1, maxObjects do
			objectTexture = engineLoadTXD("models/waluigi.txd")
			objectModel = engineLoadDFF("models/waluigi" .. i .. ".dff", objectID + i)
			objectCol = engineLoadCOL("models/waluigi" .. i .. ".col")
			
			engineImportTXD(objectTexture, objectID + i)
			engineReplaceModel(objectModel, objectID + i)
			engineReplaceCOL(objectCol, objectID + i)
			
			if (not objectTexture) then
				outputChatBox("Load texture " .. i .. " failed!")
			end
			
			if (not objectModel) then
				outputChatBox("Load model " .. i .. " failed!")
			end
			
			if (not objectCol) then
				outputChatBox("Load col " .. i .. " failed!")
			end
		end

		for i, object in pairs(getElementsByType("object")) do
			if isElement(object) then
				for j = objectID, objectID + maxObjects, 1 do
					if (getElementModel(object) == j) then
						local lodX, lodY, lodZ = getElementPosition(object)
						local lodRX, lodRY, lodRZ = getElementRotation(object) 
						local lodObject = createObject(j, lodX, lodY, lodZ, lodRX, lodRY, lodRZ, true)
						setLowLODElement(object, lodObject)
						engineSetModelLODDistance(j, lodDistance)
						setElementDoubleSided(object, true)
					end
				end
			end
		end
		
		local sound = playSound("sounds/waluigi.ogg", true)
		
		if (sound) then
			setSoundVolume(sound, 0.5)
		end
		
		createFlowers()
	end
end)

function createFlowers()
	flowers = {}
	for i = 1, 3 do
		flowers[i] = {	posX = nil,
						posY = nil,
						posZ = nil,
						flower = nil,
						direction = "forward"}
	end
	
	flowers[1].posX, flowers[1].posY, flowers[1].posZ = -3604.239, -4299.1279, 16.018
	flowers[1].flower = createObject (flowerObjectID, flowers[1].posX, flowers[1].posY, flowers[1].posZ, 0, 0, 0)
	flowers[1].flowerLOD = createObject (flowerObjectID, flowers[1].posX, flowers[1].posY, flowers[1].posZ, 0, 0, 0, true)
	
	flowers[2].posX, flowers[2].posY, flowers[2].posZ = -3504.0471, -4262.7412, 16.018
	flowers[2].flower = createObject (flowerObjectID, flowers[2].posX, flowers[2].posY, flowers[2].posZ, 0, 0, 180)
	flowers[2].flowerLOD = createObject (flowerObjectID, flowers[2].posX, flowers[2].posY, flowers[2].posZ, 0, 0, 180, true)
	
	flowers[3].posX, flowers[3].posY, flowers[3].posZ = -3724.342, -4261.2539, 16.503
	flowers[3].flower = createObject (flowerObjectID, flowers[3].posX, flowers[3].posY, flowers[3].posZ, 0, 0, 180)
	flowers[3].flowerLOD = createObject (flowerObjectID, flowers[3].posX, flowers[3].posY, flowers[3].posZ, 0, 0, 180, true)
	
	if (flowers[1].flower) and (flowers[1].flowerLOD) and (flowers[2].flower) and (flowers[2].flowerLOD) and (flowers[3].flower) and (flowers[3].flowerLOD) then
		setLowLODElement(flowers[1].flower, flowers[1].flowerLOD)
		setLowLODElement(flowers[2].flower, flowers[2].flowerLOD)
		setLowLODElement(flowers[3].flower, flowers[3].flowerLOD)
		engineSetModelLODDistance(flowerObjectID, lodDistance)
	end
end

local moveRange = 10
local moveStep1 = 0.2
local newY1 = 0
local moveStep2 = 0.1
local newY2 = 0
local moveStep3 = 0.3
local newY3 = 0

addEventHandler("onClientRender", root, 
function()
	if (flowers[1].flower) and (flowers[1].flowerLOD) then

		if (flowers[1].direction == "forward") then
			newY1 = newY1 + moveStep1
			
			if (newY1 >= moveRange) then
				flowers[1].direction = "backward"
			end
		elseif (flowers[1].direction == "backward") then
			newY1 = newY1 - moveStep1
			
			if (newY1 <= 0) then
				flowers[1].direction = "forward"
			end
		end
		
		setElementPosition(flowers[1].flower, flowers[1].posX, flowers[1].posY + newY1, flowers[1].posZ)
		setElementPosition(flowers[1].flowerLOD, flowers[1].posX, flowers[1].posY + newY1, flowers[1].posZ)
	end
	
	if (flowers[2].flower) and (flowers[2].flowerLOD) then
		if (flowers[2].direction == "forward") then
			newY2 = newY2 + moveStep2
			
			if (newY2 >= moveRange) then
				flowers[2].direction = "backward"
			end
		elseif (flowers[2].direction == "backward") then
			newY2 = newY2 - moveStep2
			
			if (newY2 <= 0) then
				flowers[2].direction = "forward"
			end
		end
		
		setElementPosition(flowers[2].flower, flowers[2].posX, flowers[2].posY + newY1, flowers[2].posZ)
		setElementPosition(flowers[2].flowerLOD, flowers[2].posX, flowers[2].posY + newY1, flowers[2].posZ)
	end
	
	if (flowers[3].flower) and (flowers[2].flowerLOD) then
		if (flowers[3].direction == "forward") then
			newY3 = newY3 + moveStep3
			
			if (newY3 >= moveRange) then
				flowers[3].direction = "backward"
			end
		elseif (flowers[3].direction == "backward") then
			newY3 = newY3 - moveStep3
			
			if (newY2 <= 0) then
				flowers[3].direction = "forward"
			end
		end
		
		setElementPosition(flowers[3].flower, flowers[3].posX, flowers[3].posY + newY1, flowers[3].posZ)
		setElementPosition(flowers[3].flowerLOD, flowers[3].posX, flowers[3].posY + newY1, flowers[3].posZ)
	end
end)