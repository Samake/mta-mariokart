--[[
	Filename: SettingsS.lua
	Authors: Sam@ke
--]]

local fpsLimit = 60
local serverUpdateFastInterVal = 500
local serverUpdateSlowInterVal = 1000

local itemPickupRespawnTime = 8000

local dbName = "mariokart"
local dbHost = "127.0.0.1"
local dbUsername = "root"
local dbPassword = ""


-- // *********************************************************************************************************** // --


local resourceName = ""
local resourceVersion = ""


addEventHandler("onResourceStart", resourceRoot,
function(resource)
	resourceName = resource:getInfo("description")
	resourceVersion = resource:getInfo("version")
end)


function getMyResourceName()
	return resourceName
end

function getMyResourceVersion()
	return resourceVersion
end

function getMyFPSLimit()
	return fpsLimit
end

function getServerUpdateFastInterVal()
	return serverUpdateFastInterVal
end


function getServerUpdateSlowInterVal()
	return serverUpdateSlowInterVal
end

function getDBName()
	return dbName
end

function getDBHost()
	return dbHost
end

function getDBUsername()
	return dbUsername
end

function getDBPassword()
	return dbPassword
end

function getItemPickupRespawnTime()
	return itemPickupRespawnTime
end
