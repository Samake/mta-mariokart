--[[
	Filename: dxVoteC.lua
	Authors: Sam@ke
--]]

dxVoteC = {}

function dxVoteC:constructor(mapShop, voteProperties)

	self.mapShop = mapShop
	self.baseProperties = voteProperties
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.id = self.baseProperties.id
	self.type = "VOTE"
	self.x = self.baseProperties.x or 0
	self.y = self.baseProperties.y or 0
	self.width = self.baseProperties.width or 0
	self.height = self.baseProperties.height or 0
	self.row = self.baseProperties.row or 1
	self.line = self.baseProperties.line or 1
	self.maxVotes = self.baseProperties.maxVotes or 10
	self.value = self.baseProperties.line or 5
	self.alpha = self.baseProperties.alpha or 255
	self.subPixelPositioning = self.baseProperties.subPixelPositioning or true
	self.postGUI = self.baseProperties.postGUI or true
	
	self.voteGrids = {}
					
	self:init()
	
	--mainOutput("Vote " .. self.id .. " was created.")
end


function dxVoteC:init()

	self.m_OnClientClick = bind(self.onClientClick, self)
	addEventHandler("onClientClick", root, self.m_OnClientClick)
	
	for i = 1, self.maxVotes do 
		self.voteGrids[i] = {}
		self.voteGrids[i].isActive = "false"
	end
	
	self.isComplete = self.mapShop and self.id and self.voteGrids
end


function dxVoteC:update()
	if (self.isComplete) then
			
		self.textures = self.mapShop.textures
		
		self.cursorX, self.cursorY = getCursorPosition()
		self.cursorX, self.cursorY = getCursorPosition()
		self.cursorX = self.cursorX * self.screenWidth
		self.cursorY = self.cursorY * self.screenHeight
		
		self.fontSize = self.mapShop.fontSize
		self.lineSize = self.mapShop.lineSize
		self.height = self.lineSize
		
		self.gridWidth = self.height
		
		if (self.row == 1) then
			self.x = self.mapShop.xFirstRow + 25
		elseif (self.row == 2) then
			self.x = self.mapShop.xSecondRow + 25
		end
		
		self.x = (self.x + (self.width * 0.5))- (self.gridWidth * (self.maxVotes * 0.5))
		self.y = self.mapShop.y + self.lineSize * self.line
		
		if (self.textures) then
		
			self.currentVote = nil
			
			for i = 1, self.maxVotes do 
				if (self.voteGrids[i]) then
					if (i <= self.value) then
						self.voteGrids[i].isActive = "true"
					else
						self.voteGrids[i].isActive = "false"
					end
					
					local x = (self.x + self.gridWidth * (i - 1)) + ((self.gridWidth * 0.5) - (self.height * 0.5))
					local y = self.y
					
					if (self.cursorX > x) and (self.cursorX < x + self.gridWidth) then
						if (self.cursorY > y) and (self.cursorY < y + self.height) then
							self.isAbleToVote = "true"
						else
							self.isAbleToVote = "false"
						end
					else
						self.isAbleToVote = "false"
					end
					
					if (self.voteGrids[i].isActive == "true") then
						self.texture = self.textures.starA
					else
						self.texture = self.textures.starN
					end
					
					if (self.isAbleToVote == "true") then
						self.texture = self.textures.starS
						self.currentVote = i
					end
					
					if (self.texture) then
						dxDrawImage(x, y, self.gridWidth, self.height, self.texture, 0, 0, 0, tocolor(255, 255, 255, 255), self.postGUI)	
					end
				end
			end
		end
	end
end


function dxVoteC:onClientClick(button, state)
	if (button == "left") and (state == "down") then
		if (self.currentVote) then
			if (self.mapShop.mapName) then
				if (not string.find(self.mapShop.mapName, "PLACEHOLDER")) then
					triggerEvent("MKADDNOTIFICATION", root, "#EEEEEEYou voted " .. self.mapShop.mapName .. " #CCEE22" .. self.currentVote .. "#EEEEEE!", "READY")
					triggerServerEvent("MKONMAPVOTED", root, self.mapShop.mapName, self.currentVote)
				end
			end
		end
	end
end


function dxVoteC:clear()

	removeEventHandler("onClientClick", root, self.m_OnClientClick)
	
end


function dxVoteC:destructor()

	self:clear()
	
	--mainOutput("Vote " .. self.id .. " was destroyed.")
end