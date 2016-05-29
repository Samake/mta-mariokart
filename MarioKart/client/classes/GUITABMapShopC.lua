--[[
	Filename: GUITABMapShopC.lua
	Authors: Sam@ke
--]]

GUITABMapShopC = {}


function GUITABMapShopC:constructor(parent, window, dataManager)
	mainOutput("GUITABMapShopC was loaded.")

	self.userPanel = parent
	self.window = window
	self.dataManager = dataManager

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.scaleFactor = (1 / 1080) * self.screenHeight
	
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	self.lineSize = 0
	self.rowWidth = 0
	
	self.mapRotation = 0
	self.mapRotationSpeed = 0.5

	self.fonts = self.window.fonts
	self.fontSize = self.window.cFontSize or 1
	self.fontColor = tocolor(220, 220, 220, 220)
	self.postGUI = self.window.postGUI or false
	self.subPixelPositioning = self.window.subPixelPositioning or false
	
	self.contentAdded = "false"
	self.contentList = {}
	self.maps = nil
	
	self:init()
end


function GUITABMapShopC:init()
	self.logo = dxCreateTexture("res/textures/icons/mapshop_icon.png")
	
	self.isLoaded = self.userPanel and self.window and self.dataManager and self.logo and self.fonts and self.fontSize
end


function GUITABMapShopC:addContent()
	if (self.contentAdded == "false") and (self.isLoaded) then
		
		local gridListProperties = {}
		gridListProperties.id = "MAPLIST"
		gridListProperties.screenWidth = self.width
		gridListProperties.screenHeight = self.height
		gridListProperties.width = self.rowWidth * 0.9
		gridListProperties.height = self.height * 0.9
		gridListProperties.row = 1
		gridListProperties.font = self.fonts.mario12
		gridListProperties.fontSize = self.fontSize
		gridListProperties.textColorR = 220
		gridListProperties.textColorG = 220
		gridListProperties.textColorB = 220
		gridListProperties.textHighLightColorR = 95
		gridListProperties.textHighLightColorG = 220
		gridListProperties.textHighLightColorB = 95
		gridListProperties.textSelectColorR = 95
		gridListProperties.textSelectColorG = 95
		gridListProperties.textSelectColorB = 220

		if (not self.contentList.mapGridList) then
			self.contentList.mapGridList = new(dxGridListC, self, gridListProperties)
		end
		
		
		self.maps = self.dataManager:getAllMaps()
		
		if (self.maps) then
			for index, mapName in pairs(self.maps) do
				self.contentList.mapGridList:addEntry(mapName)
			end
		end
		
		--// for testing only //--
		for i = 1, 20, 1 do
			self.contentList.mapGridList:addEntry("PLACEHOLDER_" .. i)
		end
	
		local voteProperties = {}
		voteProperties.id = "VOTE"
		voteProperties.x = self.x
		voteProperties.y = self.y
		voteProperties.width = self.rowWidth * 0.9
		voteProperties.height = self.height * 0.9
		voteProperties.row = 2
		voteProperties.line = 7
		voteProperties.maxVotes = 10
		voteProperties.value = 6

		if (not self.contentList.votePad) then
			self.contentList.votePad = new(dxVoteC, self, voteProperties)
		end
		
		local labelProperties = {}
		labelProperties.id = "LABELPLAYED"
		labelProperties.x = self.x
		labelProperties.y = self.y
		labelProperties.width = self.rowWidth * 0.9
		labelProperties.height = self.height * 0.9
		labelProperties.row = 2
		labelProperties.line = 7
		
		if (not self.contentList.playedLabel) then
			self.contentList.playedLabel = new(dxLabelC, self, labelProperties)
		end
		
		self.contentAdded = "true"
	end
end


function GUITABMapShopC:update()
	
	if (self.isLoaded) then
		self.x = self.window.contentArea.x
		self.y = self.window.contentArea.y
		self.width = self.window.contentArea.w
		self.height = self.window.contentArea.h
		self.lineSize = self.height / 20
		self.fontSize = self.window.cFontSize
		self.rowWidth = self.width / 2
		self.xFirstRow = self.x + (self.rowWidth * 0)
		self.xSecondRow = self.x + (self.rowWidth * 1)
		
		self.settings = self.dataManager:getServerStats()
		
		if (self.settings) then
			self.mapStats = self.settings.mapStats
			self.mapVotes = self.settings.votes
		end
		
		self:addContent()
				
		-- // bg // --
		dxDrawImage(self.x + (self.width * 0.5) - (self.height * 0.5), self.y, self.height, self.height, self.logo, 0, 0, 0, tocolor(95, 95, 95, 24), self.postGUI)	
		
		-- // first row // --

		
		-- // second row // --
		
		if (self.contentList.mapGridList) then
			self.mapName = self.contentList.mapGridList:getSelectedEntry()
		else
			self.mapName = nil
		end

		self.srx = self.xSecondRow + self.lineSize
		self.sry = self.y + self.lineSize
		self.srWidth = self.rowWidth - self.lineSize * 2
		self.srHeight = self.height - self.lineSize * 2
		
		-- // bg // --
		dxDrawRectangle(self.srx, self.sry, self.srWidth, self.srHeight, tocolor(5, 5, 5, 150), self.postGUI, self.subPixelPositioning)	
		 
		if (not self.mapName) then
			if (self.maps) then
				self.mapName = self.maps[1]
			else
				self.mapName = "UNKNOWN"
			end
		end
		
		if (self.mapName) then
			local mapNameTexture, mapTexture = self:getMapTextures(self.mapName)
			
			self.mapRotation = self.mapRotation + self.mapRotationSpeed
			
			if (self.mapRotation > 360) then
				self.mapRotation = 0
			end
	
			-- // map // --
			if (mapTexture) then
				self.mapX = self.srx + self.srWidth * 0.1
				self.mapY = self.sry
				self.mapW = self.srHeight * 0.35
				self.mapH = self.srHeight * 0.35
				
				dxDrawImage(self.mapX, self.mapY, self.mapW, self.mapH, mapTexture, self.mapRotation, 0, 0, tocolor(255, 255, 255, 200), self.postGUI)	
			end
			
			-- // mapname // --
			if (mapNameTexture) then
				
				self.mapNameX = self.srx + self.srWidth * 0.45
				self.mapNameY = self.sry
				self.mapNameW = self.srWidth * 0.35
				self.mapNameH = self.srHeight * 0.35
				
				dxDrawImage(self.mapNameX, self.mapNameY, self.mapNameW, self.mapNameH, mapNameTexture, 0, 0, 0, tocolor(255, 255, 255, 200), self.postGUI)	
			end
		
			-- // votes // --
			if (self.mapVotes) then
				if (self.mapVotes[self.mapName]) then
					self.contentList.votePad.value = math.ceil(self.mapVotes[self.mapName] - 0.5)
				else
					self.contentList.votePad.value = 0
				end
			else
				self.contentList.votePad.value = 0
			end
			
			-- // map played // --
			self.currentLine = 9
			self.tmpX = self.srx + 15
			self.tmpY = self.y + self.lineSize * self.currentLine
			
			if (self.mapStats) then
				if (self.mapStats[self.mapName]) then
					if (self.mapStats[self.mapName].played) then
						self.playedTimes = self.mapStats[self.mapName].played
					end
				else
					self.playedTimes = 0
				end
			else
				self.playedTimes = 0
			end
			
			dxDrawText("#EEEEEEPlayed: #8888EE" .. self.playedTimes .. " #EEEEEEtimes!", self.tmpX, self.tmpY, self.tmpX + self.rowWidth, self.tmpY + self.lineSize, self.fontColor, self.fontSize, self.fonts.mario12, "left", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
		
		end
	
		for index, contentClass in pairs(self.contentList) do 
			if (contentClass) then
				contentClass:update()
			end
		end
		
	end
end


function GUITABMapShopC:getMapTextures(mapName)
	if (mapName) then
		if (self.userPanel.guiManager) then
			self.textures = self.userPanel.guiManager.textures
		
			if (mapName == "[Balloon]Mini1_GC") then
				return self.textures.mini1Name, self.textures.mini1Map
			elseif (mapName == "[Balloon]Mini2_GC") then
				return self.textures.mini2Name, self.textures.mini2Map
			elseif (mapName == "[Balloon]Mini3_GC") then
				return self.textures.mini3Name, self.textures.mini3Map
			elseif (mapName == "[Balloon]Mini5_GC") then
				return self.textures.mini5Name, self.textures.mini5Map
			elseif (mapName == "[Balloon]Mini7_GC") then
				return self.textures.mini7Name, self.textures.mini7Map
			elseif (mapName == "[Balloon]Mini8_GC") then
				return self.textures.mini8Name, self.textures.mini8Map
			elseif (mapName == "[Race]Baby_GC") then
				return self.textures.babyLuigiName, self.textures.babyluigiMap
			elseif (mapName == "[Race]Diddy_GC") then
				return self.textures.diddyName, self.textures.diddyMap
			elseif (mapName == "[Race]Koopa_GC") then
				return self.textures.koopaName, self.textures.koopaMap
			elseif (mapName == "[Race]Luigi_GC") then
				return self.textures.luigiName, self.textures.luigiMap
			elseif (mapName == "[Race]Mario_GC") then
				return self.textures.marioName, self.textures.marioMap
			elseif (mapName == "[Race]Peach_GC") then
				return self.textures.peachName, self.textures.peachMap
			elseif (mapName == "[Race]Waluigi_GC") then
				return self.textures.waluigiName, self.textures.waluigiMap
			elseif (mapName == "[Race]Wario_GC") then
				return self.textures.warioName, self.textures.warioMap
			elseif (mapName == "[Race]Yoshi_GC") then
				return self.textures.yoshiName, self.textures.yoshiMap
			else
				return self.textures.unknown, self.textures.unknown
			end
		end
	end
	
	return nil, nil
end


function GUITABMapShopC:clear()
	if (self.logo) then
		self.logo:destroy()
		self.logo = nil
	end
	
	for index, contentClass in pairs(self.contentList) do 
		if (contentClass) then
			delete(contentClass)
			contentClass = nil
		end
	end
end


function GUITABMapShopC:destructor()
	self:clear()
	
	mainOutput("GUITABMapShopC was deleted.")
end
