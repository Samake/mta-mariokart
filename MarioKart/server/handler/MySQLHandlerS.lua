--[[
	Filename: MySQLHandlerS.lua
	Author: Multi, Sam@ke
--]]

MySQLHandlerS = {}

function MySQLHandlerS:constructor(parent)
	mainOutput("MySQLHandlerS was loaded.")

	self.coreClass = parent
	self.queryAttemps = -1

	self.typ = "mysql"
	self.database = getDBName()
	self.host = getDBHost()
	self.username = getDBUsername()
	self.password = getDBPassword()
	self.datachar = "share=1"

	self:establishConnection()
	
	if (self.dbConnection) then
		outputServerLog("New MySQL-Connection was created successfully!")
	else
		outputServerLog("MySQL-Connection failed!")
	end
end


function MySQLHandlerS:establishConnection()
	if (not self.dbConnection) then
		self.dbConnection = dbConnect(self.typ or "mysql", "dbname=".. self.database ..";host=".. self.host, self.username, self.password, self.datachar)
	end
end


function MySQLHandlerS:getAllMapVotes()
	self:establishConnection()
	
	if (self.dbConnection) then
		local tempQuery = self.dbConnection:query("SELECT * FROM mapvotes")
		local poll = tempQuery:poll(self.queryAttemps)

		return poll
	end
	
	return nil
end


function MySQLHandlerS:getMapVotes(mapName)
	if (mapName) and (self.dbConnection) then
		self:establishConnection()
		
		local tempQuery = self.dbConnection:query("SELECT * FROM mapvotes WHERE mapname = ?", mapname)	
		local poll = tempQuery:poll(self.queryAttemps)

		return poll
	end
	
	return nil
end


function MySQLHandlerS:getAllMapStats()
	self:establishConnection()
	
	if (self.dbConnection) then
		local tempQuery = self.dbConnection:query("SELECT * FROM toptimes")
		local poll = tempQuery:poll(self.queryAttemps)

		return poll
	end
	
	return nil
end


function MySQLHandlerS:getMapStats(mapName)
	if (mapName) and (self.dbConnection) then
		self:establishConnection()

		local tempQuery = self.dbConnection:query("SELECT * FROM toptimes WHERE mapname = ?", mapname)
		local poll = tempQuery:poll(self.queryAttemps)

		return poll
	end
	
	return nil
end


function MySQLHandlerS:saveMapStats(mapName, mapStats)
	if (mapName) and (mapStats) then
		self:establishConnection()
		
		if (self.dbConnection) then
			self.dbConnection:exec("START TRANSACTION;")

			local tempQuery = self.dbConnection:query("SELECT * FROM toptimes WHERE mapname = ?", mapname)
			local poll = tempQuery:poll(self.queryAttemps)

			if (#poll < 1) then
				local result = self.dbConnection:exec("INSERT toptimes SET mapname = '".. mapName .."'")
				--result = self.dbConnection:exec("INSERT `toptimes` SET `mapname` = `?`", mapname)
			end
			
			if (result ~= false) then
				for key, value in pairs(mapStats) do 
					result = self.dbConnection:exec("UPDATE toptimes SET " .. key .. " = '" .. value .. "' WHERE mapname = '" .. mapName .. "'")
					--result = self.dbConnection:exec("UPDATE `toptimes` SET `?` = `?` WHERE `mapname` = `?`", key, value, mapname)
					if (result == false) then
						self.dbConnection:exec("ROLLBACK;")
						return false
					end
				end
			end
			
			self.dbConnection:exec("COMMIT;")
			return true
		end
		
		return false
	end
end


function MySQLHandlerS:saveMapVotes(mapVotesTable)
	if (mapVotesTable) then
		self:establishConnection()
		
		if (self.dbConnection) then
			self.dbConnection:exec("START TRANSACTION;")
			
			for index, mapVote in pairs(mapVotesTable) do
				if (mapVote) then
					if (mapVote.map) and (mapVote.player) and (mapVote.value) then
						if (mapVote.map:len() > 0) and (mapVote.player:len() > 0) and (mapVote.value > 0) then
							local tempQuery = self.dbConnection:query("SELECT `mapname` FROM mapvotes WHERE mapname = ? AND player = ?", mapVote.map, mapVote.player)
							local poll = tempQuery:poll(self.queryAttemps)
							local result = false
							
							if (#poll > 0) then
								result = self.dbConnection:exec("UPDATE mapvotes SET vote = ? WHERE mapname = ? AND player = ?", mapVote.value, mapVote.map, mapVote.player)
							else
								result = self.dbConnection:exec("INSERT INTO mapvotes (mapname, player, vote) VALUES (?,?,?)", mapVote.map, mapVote.player, mapVote.value)
							end
							
							if (result == false) then
								self.dbConnection:exec("ROLLBACK;")
								break
							end	
						end
					end
				end
			end
			
			self.dbConnection:exec("COMMIT;")
			return true
		end
		
		return false
	end
end


function MySQLHandlerS:destructor()

	if (self.dbConnection) then
		self.dbConnection:destroy()
		self.dbConnection = nil
	end

	mainOutput("MySQLHandlerS was deleted.")
end