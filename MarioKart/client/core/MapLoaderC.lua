--[[
	Filename: MapLoaderC.lua
	Author: Multi, Sam@ke
--]]


MapLoaderC = {}


function MapLoaderC:constructor(parent)
	mainOutput("MapLoaderC was loaded.")
	
	self.mainClass = parent
	self.player = getLocalPlayer()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	
	self.scaleFactor = (1 / 1080) * self.screenHeight

	self.width = self.screenWidth * 0.25
	self.height = self.screenHeight * 0.1
	
	self.fontSize = 1.5 * self.scaleFactor
	self.lineSize = 20 * self.scaleFactor
	
	self.backroundColor = tocolor(15, 15, 15, 210)
	self.emptyBarColor = tocolor(55, 55, 55, 255)
	self.fileBarColor = tocolor(200, 55, 55, 255)
	self.allProcessBarColor = tocolor(55, 200, 55, 255)
	
	self.postGUI = true
	self.subPixelPositioning = true
	self.font = "default-bold"
	
	self.mainPath = "[maps]/"
	
	self.currentDownload = {}
	
	self:init()
end


function MapLoaderC:init()
	self.m_DoTransferFile = bind(self.doTransferFile, self)
	self.m_DownLoadStats = bind(self.downLoadStats, self)
	self.m_IsFileAlready = bind(self.isFileAlready, self)
	
	self.test = 0
	
	addEvent("Client:doTransferFile", true)
	addEventHandler("Client:doTransferFile", root, self.m_DoTransferFile)
	
	addEvent("Client:DrawTransfer", true)
	addEventHandler("Client:DrawTransfer", root, self.m_DownLoadStats)
	
	addEvent("Client:isFileAlready", true)
	addEventHandler("Client:isFileAlready", root, self.m_IsFileAlready)
	
end


function MapLoaderC:doTransferFile(file, path, attributes, bytes)
	if (file) and (path) and (attributes) and (bytes) then
		self.path = path:match(":(.*)")
		
		if (fileExists(self.mainPath .. self.path)) then
			self.file = fileOpen(self.mainPath .. self.path, false)
		else
			self.file = fileCreate(self.mainPath .. self.path)
		end
		
		if (self.file) then
			self.file:write(attributes)
			self.file:close()
			
			triggerServerEvent("Server:fileNextDownload", self.player, path);
		else
			outputChatBox("FALSE: " .. self.mainPath .. self.path)
		end
	end
end


function MapLoaderC:downLoadStats(downloadProgress, fullProgress, downloadPath, downloadSize)
	if (downloadProgress) and (fullProgress) and (downloadPath) and (downloadSize) then
        self.currentDownload.path = downloadPath
        self.currentDownload.progress = downloadProgress
		self.currentDownload.fullprogress = fullProgress
        self.currentDownload.size = downloadSize
		
		if (fullProgress > 99) then
			self.currentDownload = {}
		end
	end
end


function MapLoaderC:isFileAlready(filePath)
	if (filePath) then
		self.path = filePath:match(":(.*)")
		
		outputChatBox("1 || " .. filePath)
		outputChatBox("2 || " .. self.mainPath .. self.path)
		
        triggerServerEvent("Client:fileResult", self.player, fileExists(self.mainPath .. self.path), filePath)
	end
end


function MapLoaderC:update()
	if (self.currentDownload) and (self.renderTarget) then
		if (self.currentDownload.fullprogress) and (self.currentDownload.progress) and (self.currentDownload.size) and (self.currentDownload.path) then
			if (self.currentDownload.fullprogress < 100) then
				dxSetRenderTarget(self.renderTarget, true)
				
				local size = math.floor(self.currentDownload.size * self.currentDownload.progress / 100)
				
				-- // Background // --
				self.startX = (self.screenWidth * 0.5) - (self.width * 0.5)
				self.startY = self.screenHeight * 0.01
				
				dxDrawRectangle(self.startX, self.startY, self.width, self.height, self.backroundColor, self.postGUI, self.subPixelPositioning)
				
				-- // DL Informations // --
				local x, y = self.startX + self.width * 0.025, self.startY  + self.lineSize * 0
				
				dxDrawText("#000000File:  " .. self.currentDownload.path .. "\nSize:  " .. sizeFormat(size) .. " / " .. sizeFormat(self.currentDownload.size), x + 1, y + 1, x + 1, y + 1, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "top", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
				dxDrawText("#FFFFCCFile:  #22DDEE" .. self.currentDownload.path .. "\n#FFFFCCSize:  #22DDEE" .. sizeFormat(size) .. "#FFFFCC / #22DDEE" .. sizeFormat(self.currentDownload.size), x + 2, y, x + 2, y, tocolor(255, 255, 255, 255), self.fontSize, self.font, "left", "top", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)

				-- // File process // --
				local x, y = self.startX + self.width * 0.025, self.startY + self.lineSize * 2.5
				local barSize = (1 / self.currentDownload.size) * size
				
				dxDrawRectangle(x, y, self.width * 0.95, self.lineSize, self.emptyBarColor, true)
				dxDrawRectangle(x, y, (self.width * 0.95) * barSize, self.lineSize, self.fileBarColor, true)
				
				local x, y = self.screenWidth * 0.5, self.startY + self.lineSize * 2.5
				dxDrawText("#000000" .. math.floor(self.currentDownload.progress) .. "%", x + 1, y + 1, x + 1, (y + self.lineSize) + 1, tocolor(255, 255, 255, 255), self.fontSize, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
				dxDrawText("#EEEEEE" .. math.floor(self.currentDownload.progress) .. "%", x, y, x, y + self.lineSize, tocolor(255, 255, 255, 200), self.fontSize, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)

				-- // All process // --
				local x, y = self.startX + self.width * 0.025, self.startY + self.lineSize * 4
				local barSize = self.currentDownload.fullprogress / 100
				
				dxDrawRectangle(x, y, self.width * 0.95, self.lineSize, self.emptyBarColor, true)
				dxDrawRectangle(x, y, (self.width * 0.95) * barSize, self.lineSize, self.allProcessBarColor, true)
				
				local x, y = self.screenWidth * 0.5, self.startY + self.lineSize * 4
				dxDrawText("#000000" .. math.floor(self.currentDownload.fullprogress).."%", x + 1, y + 1, x + 1, (y + self.lineSize) + 1, tocolor(255, 255, 255, 255), self.fontSize, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
				dxDrawText("#EEEEEE" .. math.floor(self.currentDownload.fullprogress).."%", x, y, x, y + self.lineSize, tocolor(255, 255, 255, 200), self.fontSize, self.font, "center", "center", false, false, self.postGUI, true, self.subPixelPositioning, 0, 0, 0)
			
				dxSetRenderTarget()
				
				dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), self.postGUI)
			end
		end
	end
end


function MapLoaderC:clear()
	removeEventHandler("Client:doTransferFile", root, self.m_DoTransferFile)
	removeEventHandler("Client:DrawTransfer", root, self.m_DownLoadStats)
	removeEventHandler("Client:isFileAlready", root, self.m_IsFileAlready)
	
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
end


function MapLoaderC:destructor()
	self:clear()
	
	mainOutput("MapLoaderC was deleted.")
end