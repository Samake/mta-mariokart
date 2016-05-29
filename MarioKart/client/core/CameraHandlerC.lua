--[[
	Name: MTA:Mario Kart
	Filename: CameraHandlerC.lua
	Author: Sam@ke
--]]

CameraHandlerC = {}

function CameraHandlerC:constructor(parent)
	mainOutput("CameraHandlerC was loaded.")
	
	self.mainClass = parent
	self.player = getLocalPlayer()
	self.roll = 0
	self.fov = 92
	self.distance = 6.5
	self.angle = 180
	self.vehicleCam = "off"
	self.camDirection = "forward"
	self.camHeight = 2.6
	self.maxCamHeight = 10
	self.camHeightModifier = 0
	self.camModifyingSpeed = 0.35
	
	self.cprx = 0
	self.cpry = 0
	
	self.m_LookBackward = bind(self.lookBackward, self)
	bindKey(getKeyLookBack(), "down", self.m_LookBackward)
	
	self.m_LookForward = bind(self.lookForward, self)
	bindKey(getKeyLookBack(), "up", self.m_LookForward)
end


function CameraHandlerC:update()
	if (self.player:isInVehicle() == true) then
		setCameraClip(true, false)
		self.vehicleCam = "on"
		
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
		self.px, self.py, self.pz = self.playerPos.x, self.playerPos.y, self.playerPos.z
		self.prx, self.pry, self.prz = self.playerRot.x, self.playerRot.y, self.playerRot.z
		
		if (self.prx > self.cprx) then
			self.cprx = self.cprx + 0.1
		elseif (self.prx < self.cprx) then
			self.cprx = self.cprx - 0.1
		end
		
		if (self.pry > self.cpry) then
			self.cpry = self.cpry + 0.1
		elseif (self.pry < self.cpry) then
			self.cpry = self.cpry - 0.1
		end

		if (self.camDirection == "forward") then
			self.x, self.y, self.z = getAttachedPosition(self.px, self.py, self.pz, self.cprx / 25, self.cpry / 25, self.prz, self.distance, self.angle, self.camHeight)
			setCameraMatrix(self.x, self.y, self.z + self.camHeightModifier, self.px, self.py, self.pz + self.camHeight / 1.4, self.roll, self.fov)
		elseif (self.camDirection == "backward") then
			self.x, self.y, self.z = getAttachedPosition(self.px, self.py, self.pz, self.prx, self.pry, self.prz, self.distance / 1.2, 0, self.camHeight)
			setCameraMatrix(self.x, self.y, self.z + self.camHeightModifier, self.px, self.py, self.pz + self.camHeight / 1.4, self.roll, self.fov)
		end
		
		if (isLineOfSightClear(self.x, self.y, self.z, self.px, self.py, self.pz + self.camHeight / 2, true, true, true, true, true, false, false, nil) == false) then
			self.camHeightModifier = self.camHeightModifier + self.camModifyingSpeed
			if (self.camHeightModifier >= self.maxCamHeight) then
				self.camHeightModifier = self.maxCamHeight
			end
		else
			self.camHeightModifier = self.camHeightModifier - self.camModifyingSpeed
			
			if (self.camHeightModifier <= 0) then
				self.camHeightModifier = 0
			end
		end
	else
		if (self.vehicleCam == "on") then
			setCameraTarget(self.player)
			self.vehicleCam = "off"
		end
	end
end


function CameraHandlerC:lookBackward()
	self.camDirection = "backward"
end


function CameraHandlerC:lookForward()
	self.camDirection = "forward"
end


function CameraHandlerC:destructor()
	unbindKey(getKeyLookBack(), "down", self.m_LookBackward)
	unbindKey(getKeyLookBack(), "up", self.m_LookForward)

	mainOutput("CameraHandlerC was deleted.")
end