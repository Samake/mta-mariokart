--[[
	Filename: VehicleS.lua
	Authors: Sam@ke
--]]

VehicleS = {}


function VehicleS:constructor(parent, vehicleStats)

	self.playerClass = parent
	
	self.id = vehicleStats.id
	self.vehicleID = vehicleStats.vehicleID
	self.player = vehicleStats.player
	self.x = vehicleStats.x
	self.y = vehicleStats.y
	self.z = vehicleStats.z
	self.rx = vehicleStats.rx
	self.ry = vehicleStats.ry
	self.rz = vehicleStats.rz

	self:init()

	mainOutput("SERVER || VehicleS was loaded! || ID: " .. self.id)
end


function VehicleS:init()
	if (not self.vehicle) then
		self.vehicle = createVehicle (self.vehicleID, self.x, self.y, self.z , self.rx, self.ry, self.rz, "MK")
	end	
	
	if (self.vehicle) and (self.player) then
		warpPedIntoVehicle(self.player, self.vehicle, 0)
		self.vehicle:setDamageProof(true)
		self.vehicle:setDoorsUndamageable(true)
		setVehicleOverrideLights(self.vehicle, 1)
		
		triggerEvent("MKSETVEHICLECONFIG", root, self.vehicle)
	end
end	


function VehicleS:updateFast()

end


function VehicleS:updateSlow()

end


function VehicleS:clear()
	if (self.vehicle) then
		self.vehicle:destroy()
		self.vehicle = nil
	end
end


function VehicleS:destructor()
	self:clear()

	mainOutput("SERVER || VehicleS was deleted! || ID: " .. self.id)
end