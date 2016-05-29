local objectID = 15057
local mainSpeed = 2000
local collissionSize = 6
local lodDistance = 100
local currentTarget = 1

local ChainDog = {}
ChainDog.chainStart = {x = 103.3934, y = -204.3725, z = 600.2993}
ChainDog.idlePos = {x = 84.3560, y = -202.9833, z = 601.84862}
ChainDog.target = {}
ChainDog.target[1] = {x = 55.4061, y = -247.2050, z = 604.8926}
ChainDog.target[2] = {x = 50.0162, y = -208.4667, z = 602.7074}
ChainDog.target[3] = {x = 57.7110, y = -168.0068, z = 601.6325}
ChainDog.target[4] = {x = 76.8440, y = -145.8530, z = 601.5403}

addEventHandler("onClientResourceStart", resourceRoot, 
function(resource)
	if (resource == getThisResource()) then
		if (not ChainDog.object) then
			ChainDog.object = createObject (objectID, ChainDog.idlePos.x, ChainDog.idlePos.y, ChainDog.idlePos.z, 0, 0, 270)
			ChainDog.objectLOD = createObject (objectID, ChainDog.idlePos.x, ChainDog.idlePos.y, ChainDog.idlePos.z, 0, 0, 270, true)
			ChainDog.collissionShape = createColSphere(ChainDog.idlePos.x, ChainDog.idlePos.y, ChainDog.idlePos.z, collissionSize)
				
			if (ChainDog.object) and (ChainDog.objectLOD) and (ChainDog.collissionShape) then
				setLowLODElement(ChainDog.object, ChainDog.objectLOD)
				engineSetModelLODDistance(objectID, lodDistance)
				attachElements(ChainDog.collissionShape, ChainDog.object, 0, 0, 3.5)
				addEventHandler("onClientColShapeHit", ChainDog.collissionShape, hitChainDog)
			end
			
			ChainDog.hasJob = "false"
			ChainDog.state = "idle"
			ChainDog.direction = "false"
		end
	end
end)

addEventHandler("onClientRender", root, 
function()
	if (ChainDog.object) then
		local cdx, cdy, cdz = getElementPosition(ChainDog.object)
		local cdrx, cdry, cdrz = getElementRotation(ChainDog.object)
		local x, y, z = getAttachedPosition(cdx, cdy, cdz, cdrx, cdry, cdrz, 4, 0, 4)
		
		dxDrawLine3D(ChainDog.chainStart.x, ChainDog.chainStart.y, ChainDog.chainStart.z, x, y, z, tocolor(0, 0, 0, 255), 10)
	
		if (ChainDog.hasJob == "false") and (ChainDog.state == "idle") then
			ChainDog.nextTarget = ChainDog.target[currentTarget]
			
			currentTarget = currentTarget + 1
			
			if (currentTarget > 4) then
				currentTarget = 1
			end
			
			ChainDog.hasJob = "true"
			ChainDog.state = "rotate"
			ChainDog.direction = "false"
		end
		
		if (ChainDog.state == "initAttack") and (ChainDog.direction == "forward") then
			moveObject(ChainDog.object, mainSpeed / 3, ChainDog.nextTarget.x, ChainDog.nextTarget.y, ChainDog.nextTarget.z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
			moveObject(ChainDog.objectLOD, mainSpeed / 3, ChainDog.nextTarget.x, ChainDog.nextTarget.y, ChainDog.nextTarget.z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
			ChainDog.state = "attack"
			ChainDog.direction = "forward"
		end
		
		if (ChainDog.state == "initResetAttack") and (ChainDog.direction == "backward") then
			moveObject(ChainDog.object, mainSpeed, ChainDog.idlePos.x, ChainDog.idlePos.y, ChainDog.idlePos.z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
			moveObject(ChainDog.objectLOD, mainSpeed, ChainDog.idlePos.x, ChainDog.idlePos.y, ChainDog.idlePos.z, 0, 0, 0, "Linear", 0.3, 1.0, 1.70158)
			ChainDog.state = "resetAttack"
			ChainDog.direction = "backward"
		end
		
		if (ChainDog.state == "rotate") and (ChainDog.direction == "false") then
			local x, y, z = getElementPosition(ChainDog.object)
			local rx, ry, rz = getElementRotation(ChainDog.object)
			local rotation = findRotation(ChainDog.nextTarget.x, ChainDog.nextTarget.y, x, y)
			
			if (math.floor(rz) == math.floor(rotation)) then
				ChainDog.state = "initAttack"
				ChainDog.direction = "forward"
			elseif (math.floor(rz) < math.floor(rotation)) then
				setElementRotation(ChainDog.object, rx, ry, rz + 1)
				setElementRotation(ChainDog.objectLOD, rx, ry, rz + 1)
			elseif (math.floor(rz) > math.floor(rotation)) then
				setElementRotation(ChainDog.object, rx, ry, rz - 1)
				setElementRotation(ChainDog.objectLOD, rx, ry, rz - 1)
			end
		elseif (ChainDog.state == "attack") and (ChainDog.direction == "forward") then
			local x, y, z = getElementPosition(ChainDog.object)
		
			if (math.floor(x) == math.floor(ChainDog.nextTarget.x)) and (math.floor(y) == math.floor(ChainDog.nextTarget.y)) then
				ChainDog.state = "initResetAttack"
				ChainDog.direction = "backward"
			end
		elseif (ChainDog.state == "resetAttack") and (ChainDog.direction == "backward") then
			local x, y, z = getElementPosition(ChainDog.object)
		
			if (math.floor(x) == math.floor(ChainDog.idlePos.x)) and (math.floor(y) == math.floor(ChainDog.idlePos.y)) then
				ChainDog.hasJob = "false"
				ChainDog.state = "idle"
				ChainDog.direction = "false"
			end
		end
	end
end)

function hitChainDog(element)
	if (isElement(element)) and (getElementType(element) == "vehicle")then
		
		setElementSpeed(element, 5)
		local vx, vy, vz = getElementVelocity(element)
		setElementVelocity(element , vx, vy, vz + 0.4)
		local px, py, pz = getElementPosition(element)
		createExplosion(px, py, pz, 11, true, -1, false)
	end
end

addEventHandler("onClientResourceStop", resourceRoot, 
function(resource)
	if (resource == getThisResource()) then
		if (ChainDog.object) then
			destroyElement(ChainDog.object)
			ChainDog.object = nil
		end
		
		if (ChainDog.objectLOD) then
			destroyElement(ChainDog.objectLOD)
			ChainDog.objectLOD = nil
		end
		
		if (ChainDog.collissionShape) then
			removeEventHandler("onClientColShapeHit", ChainDog.collissionShape, hitChainDog)
			destroyElement(ChainDog.collissionShape)
			ChainDog.collissionShape = nil
		end
	end
end)

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