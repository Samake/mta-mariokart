--[[
	Filename: AnimationsC.lua
	Author: Sam@ke, Krischkros, Jusonex
--]]

AnimationsC = {}

function AnimationsC:constructor(parent, time, type, isLoop)

	self.parent = parent
	self.time = time
	self.type = type
	self.isLoop = isLoop
	
	-- Linear, InQuad, OutQuad, InOutQuad, OutInQuad, InElastic, OutElastic, InOutElastic
	-- OutInElastic, InBack, OutBack, InOutBack, OutInBack, InBounce, OutBounce, InOutBounce
	-- OutInBounce, SineCurve, CosineCurve
	
	self.easingTable = {}
	self.easingTime = self.time
	self.easingTable.startTime = getTickCount()
	self.easingTable.endTime = self.easingTable.startTime + self.easingTime
	self.easingTable.easingFunction = self.type
	self.easingValue = 0
	
	self.m_Update = bind(self.update, self)
	addEventHandler("onClientPreRender", root, self.m_Update)
end


function AnimationsC:update()
	if (self.easingTable) then
		self.now = getTickCount()
		self.elapsedTime = self.now - self.easingTable.startTime
		self.duration = self.easingTable.endTime - self.easingTable.startTime
		self.progress = self.elapsedTime / self.duration
		self.easingValue = getEasingValue(self.progress, self.easingTable.easingFunction, 0.5, 1, 1.7)
				
		if (self.isLoop == "false") then
			if (self.easingValue >= 1) then
				--self.easingValue = 1
			end
		end
	end
end


function AnimationsC:reset()
	self.easingTable.startTime = getTickCount()
	self.easingTable.endTime = self.easingTable.startTime + self.easingTime
	self.easingValue = 0
end


function AnimationsC:getFactor()
	return self.easingValue
end


function AnimationsC:destructor()

	removeEventHandler("onClientPreRender", root, self.m_Update)
end