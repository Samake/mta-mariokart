--[[
	Filename: MapLoaderS.lua
	Author: Multi, Sam@ke
--]]

local classInstance = nil

MapLoaderS = {}

function MapLoaderS:constructor()
	mainOutput("MapLoaderS was loaded.")
	
	self.downLoadTables = {}
	self.allDownloadFilesTable = {}
	
	self.downloadSpeed = 1250000
	
	self:init()
end


function MapLoaderS:init()
	
	self.m_startDownload = bind(self.startDownload, self)
	self.m_CheckFileExistsResult = bind(self.checkFileExistsResult, self)
	self.m_RequestFiles = bind(self.requestFiles, self)
	self.m_FileNextDownload = bind(self.fileNextDownload, self)	
		
	addEvent("MKSTARTMAPDOWNLOAD" , true)
	addEventHandler("MKSTARTMAPDOWNLOAD" , root, self.m_startDownload)
	
	addEvent("Client:fileResult", true)
	addEventHandler("Client:fileResult", root, self.m_CheckFileExistsResult)
	
	addEvent("Client:requestFiles", true)
	addEventHandler("Client:requestFiles", root, self.m_RequestFiles)
	
	addEvent("Server:fileNextDownload", true)
	addEventHandler("Server:fileNextDownload", root, self.m_FileNextDownload)
end


function MapLoaderS:startDownload(resourceName)
	if (resourceName) then
		local resourceName = resourceName
		local resource = getResourceFromName(resourceName)
		
		if (resource) then
			local resourceFiles = getScriptsInResource(resource)
			
			if (resourceFiles) then
				for index, file in pairs(resourceFiles) do
					if (file) then
						local fileTable = {}
						fileTable.resourceName = resourceName
						fileTable.file = file
						
						table.insert(self.allDownloadFilesTable, fileTable)
					end
				end
			end
		end
	end
end


function MapLoaderS:updateFast()
	for player, dlTable in pairs(self.downLoadTables) do
		for downloadIndex, download in pairs(dlTable.Downloads) do
			if (download.IsFinished == "false") then
				self:fileTriggerToClient(player, download.Path, download.Attributes, download.Bytes)
				
				dlTable.Handlers = getLatentEventHandles(player)[#getLatentEventHandles(player)];
				
				if (dlTable.Handlers) then

					dlTable.Status = getLatentEventStatus(player, dlTable.Handlers);
					
					if (dlTable.Status) then
						local fullProgress =  100 - ((100 / #self.allDownloadFilesTable) * (#dlTable.Downloads - 1))
						
						triggerClientEvent(player, "Client:DrawTransfer", player, dlTable.Status.percentComplete, fullProgress, download.Path, download.Bytes)
					end
				end
				
				break
			end
		end
	end
end


function MapLoaderS:fileTriggerToClient(player, path, attrs, bytes)
	if (isElement(player)) and (path) and (attrs) and (bytes) then
		self.downLoadTables[player].Handlers = getLatentEventHandles(player)[#getLatentEventHandles(player)]
		
		if (not self.downLoadTables[player].Handlers) then
			local file = fileOpen(path);
					
			if (file) then
				triggerLatentClientEvent(player, "Client:doTransferFile", self.downloadSpeed, false, player, file, path, attrs, bytes);
				file:close()
			end
		end
	end
end


function MapLoaderS:fileNextDownload(path)
	for index, download in pairs(self.downLoadTables[source].Downloads) do
		if (download.Path == path) then
			download.IsFinished = "true"
			table.remove(self.downLoadTables[source].Downloads, index)
			break
		end
	end	
end


function MapLoaderS:requestFiles()
	for index, fileTable in ipairs(self.allDownloadFilesTable) do
		if (source) and (fileTable) then
			self:checkFileExistsAtClient(source, ":" .. fileTable.resourceName .. "/" .. fileTable.file)
		end
	end
end


function MapLoaderS:checkFileExistsAtClient(player, filePath)
	triggerClientEvent(player, "Client:isFileAlready", player, filePath);
end


function MapLoaderS:checkFileExistsResult(found, filePath)
	if (source) and isElement(source) then
		if (tostring(found) == "false") then
		
			if (not self.downLoadTables[source]) then
				self.downLoadTables[source] = {}
				self.downLoadTables[source].Downloads = {}
			end

			local dlTable = {}

			dlTable.Path = tostring(filePath)
			dlTable.Bytes = fileBytes(filePath)
			dlTable.Attributes = fileAttributes(filePath, dlTable.Bytes)
			dlTable.PercentageReady = 0
			dlTable.IsFinished = "false"
			
			table.insert(self.downLoadTables[source].Downloads, dlTable)
		end
	end
end

function MapLoaderS:destructor()
	self.downLoadTables = nil

	removeEventHandler("Client:fileResult", root, self.m_CheckFileExistsResult)
	removeEventHandler("Client:requestFiles", root, self.m_RequestFiles)
	removeEventHandler("Server:fileNextDownload", root, self.m_FileNextDownload)
	removeEventHandler("MKSTARTMAPDOWNLOAD" , root, self.m_startDownload)

	mainOutput("MapLoaderS was deleted.")
end