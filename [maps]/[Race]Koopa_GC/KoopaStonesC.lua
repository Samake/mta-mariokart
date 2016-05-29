local objectID = 15060
local maxStones = 3
local mainSpeed = 100
local collissionSize = 3
local stompSize = 4
local lodDistance = 200

local Stones = {}
Stones[1] = {}
Stones[1].coords = {}
Stones[1].coords[1] = {x = -57.5195, y = -397.0664, z = 657.6593}
Stones[1].coords[2] = {x = -42.2619, y = -442.2524, z = 657.6570}
Stones[1].coords[3] = {x = -72.2175, y = -418.2641, z = 657.6560}

Stones[2] = {}
Stones[2].coords = {}
Stones[2].coords[1] = {x = -120.1518, y = -420.5087, z = 657.6614}
Stones[2].coords[2] = {x = -109.2646, y = -441.0756, z = 657.6614}
Stones[2].coords[3] = {x = -93.4489, y = -423.3671, z = 657.6565}

Stones[3] = {}
Stones[3].coords = {}
Stones[3].coords[1] = {x = -100.3564, y = -442.4833, z = 657.6605}
Stones[3].coords[2] = {x = -81.8974, y = -478.9492, z = 657.6545}
Stones[3].coords[3] = {x = -63.7529, y = -446.8256, z = 657.6677}

addEventHandler("onClientResourceStart", resourceRoot, 
function(resource)
	if (resource == getThisResource()) then
		for i = 1, maxStones do
			if (not Stones[i].object) then
				Stones[i].object = createObject (objectID, Stones[i].coords[1].x, Stones[i].coords[1].y, Stones[i].coords[1].z, 0, 0, 180)
				Stones[i].objectLOD = createObject (objectID, Stones[i].coords[1].x, Stones[i].coords[1].y, Stones[i].coords[1].z, 0, 0, 180, true)
				
				if (Stones[i].object) and (Stones[i].objectLOD) then
					setLowLODElement(Stones[i].object, Stones[i].objectLOD)
					engineSetModelLODDistance(objectID, lodDistance)
				end
				
				Stones[i].hasJob = "false"
				Stones[i].state = "idle"
				Stones[i].direction = "false"
				Stones[i].nextWaypoint = 2
			end
		end
	end
end)

addEventHandler("onClientRender", root, 
function()
	for i = 1, maxStones do
		if (Stones[i].object) and (Stones[i].objectLOD) then
			if (Stones[i].hasJob == "false") and (Stones[i].state == "idle") then
				if (Stones[i].coords[Stones[i].nextWaypoint]) then
				
					Stones[i].nextWaypoint = Stones[i].nextWaypoint + 1
					
					if (Stones[i].nextWaypoint > #Stones[i].coords) then
						Stones[i].nextWaypoint = 1
					end
					
					local bx, by, bz = getElementPosition(Stones[i].object)
					local distance = getDistanceBetweenPoints3D(bx, by, bz, Stones[i].coords[Stones[i].nextWaypoint].x, Stones[i].coords[Stones[i].nextWaypoint].y, Stones[i].coords[Stones[i].nextWaypoint].z)
					moveObject(Stones[i].object, mainSpeed * distance, Stones[i].coords[Stones[i].nextWaypoint].x, Stones[i].coords[Stones[i].nextWaypoint].y, Stones[i].coords[Stones[i].nextWaypoint].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
					moveObject(Stones[i].objectLOD, mainSpeed * distance, Stones[i].coords[Stones[i].nextWaypoint].x, Stones[i].coords[Stones[i].nextWaypoint].y, Stones[i].coords[Stones[i].nextWaypoint].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)				
				else
					local bx, by, bz = getElementPosition(Stones[i].object)
					local distance = getDistanceBetweenPoints3D(bx, by, bz, Stones[i].coords[1].x, Stones[i].coords[1].y, Stones[i].coords[1].z)
					moveObject(Stones[i].object, mainSpeed * distance, Stones[i].coords[1].x, Stones[i].coords[1].y, Stones[i].coords[1].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
					moveObject(Stones[i].objectLOD, mainSpeed * distance, Stones[i].coords[1].x, Stones[i].coords[1].y, Stones[i].coords[1].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
				end
				
				Stones[i].hasJob = "true"
				Stones[i].state = "moving"
			elseif (Stones[i].hasJob == "true") then
				if (Stones[i].state == "moving") then
					local x, y, z = getElementPosition(Stones[i].object)
					
					if (math.floor(x) == math.floor(Stones[i].coords[Stones[i].nextWaypoint].x)) and (math.floor(y) == math.floor(Stones[i].coords[Stones[i].nextWaypoint].y)) then
						Stones[i].state = "initStomp"
						Stones[i].direction = "down"
					end
				end
				
				if (Stones[i].state == "initStomp") and (Stones[i].direction == "down") then
					local x, y, z = getElementPosition(Stones[i].object)
					moveObject(Stones[i].object, mainSpeed * 2, x, y, z - stompSize, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
					moveObject(Stones[i].objectLOD, mainSpeed * 2, x, y, z - stompSize, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
					Stones[i].state = "doStomp"
				end
				
				if (Stones[i].state == "initResetStomp") and (Stones[i].direction == "up") then
					local x, y, z = getElementPosition(Stones[i].object)
					moveObject(Stones[i].object, mainSpeed * 2, x, y, z + stompSize, 0, 0, 0,  "Linear", 0.3, 1.0, 1.70158)
					moveObject(Stones[i].objectLOD, mainSpeed * 2, x, y, z + stompSize, 0, 0, 0,  "Linear", 0.3, 1.0, 1.70158)
					Stones[i].state = "resetStomp"
				end
				
				if (Stones[i].state == "doStomp") and (Stones[i].direction == "down") then
					local x, y, z = getElementPosition(Stones[i].object)
				
					if (math.floor(z) == math.floor(Stones[i].coords[Stones[i].nextWaypoint].z - stompSize)) then
						Stones[i].state = "initResetStomp"
						Stones[i].direction = "up"
					end
				elseif (Stones[i].state == "resetStomp") and (Stones[i].direction == "up") then
					local x, y, z = getElementPosition(Stones[i].object)
				
					if (math.floor(z) == math.floor(Stones[i].coords[Stones[i].nextWaypoint].z)) then
						Stones[i].hasJob = "false"
						Stones[i].state = "idle"
						Stones[i].direction = "false"
					end
				end
			end
		end
	end
end)