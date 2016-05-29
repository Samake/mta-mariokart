local teleportFadeTime = 0.2
local teleportDistance = 7.5
local teleportSize = 9
local teleports = {}

teleports[1] = {x = 32.135, y = 42.7236, z = 623.2493} -- down left
teleports[2] = {x = 6.7703, y = 45.5942, z = 630.4525} -- up left
teleports[3] = {x = 71.8506, y = 44.0303, z = 623.2493} -- down right
teleports[4] = {x = 97.1523, y = 44.8501, z = 630.4525} -- up right

addEventHandler("onResourceStart", resourceRoot, 
function(resource)
	if (resource == getThisResource()) then
		for i = 1, #teleports, 1 do
			teleports[i].porter = createColSphere(teleports[i].x, teleports[i].y, teleports[i].z, teleportSize)
			
			if (teleports[i].porter) then
				addEventHandler( "onColShapeHit", teleports[i].porter, onTeleportHit)
			end
		end
	end
end)

addEventHandler("onResourceStop", resourceRoot, 
function(resource)
	if (resource == getThisResource()) then
		for i = 1, #teleports, 1 do
			if (teleports[i].porter) then
				removeEventHandler( "onColShapeHit", teleports[i].porter, onTeleportHit)
				
				destroyElement(teleports[i].porter)
				teleports[i].porter = nil
			end
		end
	end
end)

function onTeleportHit(element, dimension)
	if (isElement(element)) and (getElementType(element) == "vehicle") then
		local player = getVehicleOccupant(element, 0)
		local vrx, vry, vrz = getElementRotation(element)
		local vx, vy, vz = getElementVelocity(element)
		
		if (player) then
			if (teleports[1].porter) and (teleports[2].porter) and (source == teleports[1].porter) then
				playerFadeOut(player)
				setElementVelocity(element, 0, 0, 0)
				local x, y, z = getAttachedPosition(teleports[2].x, teleports[2].y, teleports[2].z, 0, 0, 0, teleportDistance, 180, 0)
				setElementPosition(element, x, y, z)
				
				vrz = vrz + 180
				
				if (vrz > 360) then vrz = vrz - 360 end
				
				setElementRotation(element, vrx, vry, vrz)
				setElementVelocity(element, -vx, -vy, -vz)
				playerFadeIn(player)
			elseif (teleports[1].porter) and (teleports[2].porter) and (source == teleports[2].porter) then
				playerFadeOut(player)
				setElementVelocity(element, 0, 0, 0)
				local x, y, z = getAttachedPosition(teleports[1].x, teleports[1].y, teleports[1].z, 0, 0, 0, teleportDistance, 180, 0)
				setElementPosition(element, x, y, z)
				
				vrz = vrz + 180
				
				if (vrz > 360) then vrz = vrz - 360 end
				
				setElementRotation(element, vrx, vry, vrz)
				setElementVelocity(element, -vx, -vy, -vz)
				playerFadeIn(player)				
			elseif (teleports[3].porter) and (teleports[4].porter) and (source == teleports[3].porter) then
				playerFadeOut(player)
				setElementVelocity(element, 0, 0, 0)
				local x, y, z = getAttachedPosition(teleports[4].x, teleports[4].y, teleports[4].z, 0, 0, 0, teleportDistance, 180, 0)
				setElementPosition(element, x, y, z)
				
				vrz = vrz + 180
				
				if (vrz > 360) then vrz = vrz - 360 end
				
				setElementRotation(element, vrx, vry, vrz)
				setElementVelocity(element, -vx, -vy, -vz)
				playerFadeIn(player)
			elseif (teleports[3].porter) and (teleports[4].porter) and (source == teleports[4].porter) then
				playerFadeOut(player)
				setElementVelocity(element, 0, 0, 0)
				local x, y, z = getAttachedPosition(teleports[3].x, teleports[3].y, teleports[3].z, 0, 0, 0, teleportDistance, 180, 0)
				setElementPosition(element, x, y, z)
				
				vrz = vrz + 180
				
				if (vrz > 360) then vrz = vrz - 360 end
				
				setElementRotation(element, vrx, vry, vrz)
				setElementVelocity(element, -vx, -vy, -vz)
				playerFadeIn(player)
			end
		end
	end
end

function playerFadeOut(player)
	if (player) and (isElement(player)) then
		fadeCamera(player, false, teleportFadeTime)
	end
end

function playerFadeIn(player)
	if (player) and (isElement(player)) then
		fadeCamera(player, true, teleportFadeTime)
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