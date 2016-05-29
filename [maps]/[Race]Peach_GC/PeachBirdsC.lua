local birdObjectID = 15060
local maxBirds = 6
local mainSpeed = 100
local collissionSize = 3
local lodDistance = 100

local Birds = {}
Birds[1] = {}
Birds[1].coords = {}
Birds[1].coords[1] = {x = 195.2598, y = -576.0346, z = 597.2069}
Birds[1].coords[2] = {x = 147.9373, y = -541.7866, z = 595.8908}
Birds[1].coords[3] = {x = 226.9957, y = -525.5434, z = 597.0373}

Birds[2] = {}
Birds[2].coords = {}
Birds[2].coords[1] = {x = 235.4539, y = -485.9287, z = 597.07081}
Birds[2].coords[2] = {x = 170.4666, y = -481.7519, z = 595.72016}
Birds[2].coords[3] = {x = 209.9493, y = -414.8188, z = 597.06354}

Birds[3] = {}
Birds[3].coords = {}
Birds[3].coords[1] = {x = 175.9219, y = -389.7202, z = 596.30927}
Birds[3].coords[2] = {x = 125.5970, y = -410.1176, z = 594,6808}
Birds[3].coords[3] = {x = 130.7554, y = -368.1699, z = 597.23822}

Birds[4] = {}
Birds[4].coords = {}
Birds[4].coords[1] = {x = 139.6006, y = -521.6445, z = 595.2325}
Birds[4].coords[2] = {x = 169.5552, y = -511.7207, z = 595.9337}
Birds[4].coords[3] = {x = 179.4219, y = -582.3222, z = 597.2184}

Birds[5] = {}
Birds[5].coords = {}
Birds[5].coords[1] = {x = 100.2271, y = -235.6337, z = 597.0956}
Birds[5].coords[2] = {x = 103.5315, y = -192.5087, z = 595.3472}
Birds[5].coords[3] = {x = 153.6448, y = -205.8867, z = 597.4995}

Birds[6] = {}
Birds[6].coords = {}
Birds[6].coords[1] = {x = 163.6185, y = -193.9526, z = 598.7598}
Birds[6].coords[2] = {x = 138.8575, y = -149.3461, z = 596.0453}
Birds[6].coords[3] = {x = 172.2278, y = -128.8979, z = 597.6002}

addEventHandler("onClientResourceStart", resourceRoot, 
function(resource)
	if (resource == getThisResource()) then
		for i = 1, maxBirds do
			if (Birds[maxBirds]) then
				if (Birds[i].coords[2]) then
					Birds[i].rx = 0
					Birds[i].ry = 0
					Birds[i].rz = findRotation(Birds[i].coords[2].x, Birds[i].coords[2].y, Birds[i].coords[1].x, Birds[i].coords[1].y)
					Birds[i].object = createObject (birdObjectID, Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z, 0, 0, Birds[i].rz)
					Birds[i].objectLOD = createObject (birdObjectID, Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z, 0, 0, Birds[i].rz, true)
				else
					Birds[i].object = createObject (birdObjectID, Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z, 0, 0, 0)
					Birds[i].objectLOD = createObject (birdObjectID, Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z, 0, 0, 0, true)
				end
				
				if (Birds[i].object) and (Birds[i].objectLOD) then
					setLowLODElement(Birds[i].object, Birds[i].objectLOD)
					engineSetModelLODDistance(birdObjectID, lodDistance)
				
					Birds[i].collissionShape = createColSphere(Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z, collissionSize)
					
					if (Birds[i].collissionShape) then
						attachElements(Birds[i].collissionShape, Birds[i].object)
						addEventHandler("onClientColShapeHit", Birds[i].collissionShape, hitBird)
					end
				end
				
				if (Birds[i].coords[2]) then
					Birds[i].nextWaypoint = 2
				else
					Birds[i].nextWaypoint = 1
				end
				
				Birds[i].hasJob = "false"
			end
		end
	end
end)

addEventHandler("onClientRender", root, 
function()
	for i = 1, maxBirds do
		if (Birds[i].object) and (Birds[i].objectLOD) then
			if (Birds[i].hasJob == "false") then
				if (Birds[i].coords[Birds[i].nextWaypoint]) then
					local bx, by, bz = getElementPosition(Birds[i].object)
					local distance = getDistanceBetweenPoints3D(bx, by, bz, Birds[i].coords[Birds[i].nextWaypoint].x, Birds[i].coords[Birds[i].nextWaypoint].y, Birds[i].coords[Birds[i].nextWaypoint].z)
					moveObject(Birds[i].object, mainSpeed * distance, Birds[i].coords[Birds[i].nextWaypoint].x, Birds[i].coords[Birds[i].nextWaypoint].y, Birds[i].coords[Birds[i].nextWaypoint].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
					moveObject(Birds[i].objectLOD, mainSpeed * distance, Birds[i].coords[Birds[i].nextWaypoint].x, Birds[i].coords[Birds[i].nextWaypoint].y, Birds[i].coords[Birds[i].nextWaypoint].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)				
				else
					local bx, by, bz = getElementPosition(Birds[i].object)
					local distance = getDistanceBetweenPoints3D(bx, by, bz, Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z)
					moveObject(Birds[i].object, mainSpeed * distance, Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
					moveObject(Birds[i].objectLOD, mainSpeed * distance, Birds[i].coords[1].x, Birds[i].coords[1].y, Birds[i].coords[1].z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
				end
				
				Birds[i].hasJob = "true"
			elseif (Birds[i].hasJob == "true") then
				local bx, by, bz = getElementPosition(Birds[i].object)
				local brx, bry, brz = getElementRotation(Birds[i].object)
				local rotZ = findRotation(Birds[i].coords[Birds[i].nextWaypoint].x, Birds[i].coords[Birds[i].nextWaypoint].y, bx, by)

				if (Birds[i].rz < rotZ) then
					Birds[i].rz = Birds[i].rz + 4
					if (Birds[i].rz > 360) then
						Birds[i].rz = 0
					end
				elseif (Birds[i].rz > rotZ) then
					Birds[i].rz = Birds[i].rz - 4
					
					if (Birds[i].rz < 0) then
						Birds[i].rz = 360
					end
				end
				
				setElementRotation(Birds[i].object, Birds[i].rx, Birds[i].ry, Birds[i].rz)
				setElementRotation(Birds[i].objectLOD, Birds[i].rx, Birds[i].ry, Birds[i].rz)
			
				if (math.floor(bx) == math.floor(Birds[i].coords[Birds[i].nextWaypoint].x)) then
					Birds[i].nextWaypoint = Birds[i].nextWaypoint + 1
					
					if (Birds[i].nextWaypoint > #Birds[i].coords) then
						Birds[i].nextWaypoint = 1
					end
					
					Birds[i].hasJob = "false"
				end
			end
		end
	end
end)

function hitBird(element)
	if (isElement(element)) and (getElementType(element) == "vehicle")then
		
		setElementSpeed(element, 5)
		local vx, vy, vz = getElementVelocity(element)
		setElementVelocity(element , vx, vy, vz + 0.4)
		local px, py, pz = getElementPosition(element)
		createExplosion(px, py, pz, 11, true, -1, false)
	end
end

function getAttachedPosition(x, y, z, rx, ry, rz, distance, angleAttached, height)
 
    local nrx = math.rad(rx);
    local nry = math.rad(ry);
    local nrz = math.rad(angleAttached - rz);
    
    local dx = math.sin(nrz) * distance;
    local dy = math.cos(nrz) * distance;
    local dz = math.sin(nrx) * distance;
    
    local newX = x + dx;
    local newY = y + dy;
    local newZ = (z + height) - dz;
    
    return newX, newY, newZ;
end

function findRotation(x1, y1, x2, y2)
	local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
	
	if (t < 0) then 
		t = t + 360 
	end
	
	return t;
end

function setElementSpeed(element, speed)
	if (speed == nil) then speed = 0 end

	local acSpeed = getElementSpeed(element)
	if (acSpeed ~= false) and (acSpeed > 0) then
		local diff = tonumber(speed)/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element, x*diff,y*diff,z*diff)
	else
		setElementVelocity(element, 0, 0, 0)
	end
end

function getElementSpeed(element)
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		
		return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
	else
		return false
	end
end