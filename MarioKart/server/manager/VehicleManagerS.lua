--[[
	Filename: VehicleManagerS.lua
	Authors: Sam@ke
--]]

VehicleManagerS = {}


function VehicleManagerS:constructor(parent)
	mainOutput("VehicleManagerS was loaded.")

	self.mainClass = parent

	self.vehicleStats = {}
	
	self.vehicleStats[602] = {	
				mass = 150, 
				turnMass = 6.5, 
				dragCoeff = 9.1, 
				centerOfMass = {0.0, -0.09, -0.04},
				percentSubmerged = 45,
				tractionMultiplier = 2.5,
				tractionLoss = 0.6,
				tractionBias = 0.35,
				numberOfGears = 5,
				maxVelocity = 290,
				engineAcceleration = 20,
				engineInertia = 3.8,
				driveType = "awd",
				engineType = "petrol",
				brakeDeceleration = 15,
				brakeBias = 0.5,
				ABS = true,
				steeringLock = 25,
				suspensionForceLevel = 0.72,
				suspensionDamping = 1.2,
				suspensionHighSpeedDamping = 0.5,
				suspensionUpperLimit = -10.1,
				suspensionLowerLimit = 10.1,
				suspensionFrontRearBias = 0.45,
				suspensionAntiDiveMultiplier = 0,
				seatOffsetDistance = 0.3,
				collisionDamageMultiplier = 0.1,
				monetary = 100}
	
	self.m_SetConfig = bind(self.setConfig, self)
	addEvent("MKSETVEHICLECONFIG", true)
	addEventHandler("MKSETVEHICLECONFIG", root, self.m_SetConfig)
end


function VehicleManagerS:setConfig(vehicle)
	if (isElement(vehicle)) then
		local model = vehicle:getModel()
		
		if (self.vehicleStats[model]) then
			local config = self.vehicleStats[model]
			
			if (config) then
				for param, value in pairs(config) do
					setVehicleHandling(vehicle, tostring(param), value)
				end
			end
		end
	end
end


function VehicleManagerS:getConfig(id)
	if (id) then
		if (self.vehicleStats[id]) then
			return self.vehicleStats[id]
		end
	end
	
	return nil
end


function VehicleManagerS:destructor()
	removeEventHandler("MKSETVEHICLECONFIG", root, self.m_SetConfig)
	
	mainOutput("VehicleManagerS was deleted.")
end
