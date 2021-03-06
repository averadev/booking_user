-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')

display.setStatusBar( display.DarkStatusBar )

local isUser = DBManager.setupSquema()

if not isUser then
	composer.gotoScene("src.Login")
else
	composer.gotoScene("src.Home")
	--composer.gotoScene("src.Suggestions")
end

function DidReceiveRemoteNotification(message, additionalData, isActive)
    if isActive then
		system.vibrate()
		--[[local RestManager = require('src.resources.RestManager')
		RestManager.getNotificationsUnRead()
		require('src.Header')
		alertNewNotifications()
		system.vibrate()]]
		
	else
		if (additionalData) then
			if additionalData.type == "1" then
				local RestManager = require('src.resources.RestManager')
				
				composer.gotoScene( "src.Visit", {
					params = { id = additionalData.id }
				})
				RestManager.markMessageRead(additionalData.id, 2)
				RestManager.getMessageUnRead()
				--storyboard.removeScene( "src.Home" )
			elseif additionalData.type == "2" then
			
				local RestManager = require('src.resources.RestManager')
				
				composer.gotoScene( "src.Message", {
					params = { id = additionalData.id }
				})
				RestManager.markMessageRead(additionalData.id, 1)
				RestManager.getMessageUnRead()
			
			end
		end
	end
end

local OneSignal = require("plugin.OneSignal")
-- Uncomment SetLogLevel to debug issues.
-- OneSignal.SetLogLevel(4, 4)
OneSignal.Init("d55cca2a-694c-11e5-b9d4-c39860ec56cd", 215994349515, DidReceiveRemoteNotification)

function IdsAvailable(userID, pushToken)
    Globals.playerIdToken = userID
	print(userID)
end

OneSignal.IdsAvailableCallback(IdsAvailable)

OneSignal.EnableNotificationsWhenActive(true)