-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')

local isUser = DBManager.setupSquema()

display.setStatusBar( display.DarkStatusBar )

if not isUser then
	composer.gotoScene("src.Login")
else
	composer.gotoScene("src.Home")
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
			end
		end
	end
end

local OneSignal = require("plugin.OneSignal")
-- Uncomment SetLogLevel to debug issues.
-- OneSignal.SetLogLevel(4, 4)
OneSignal.Init("d55cca2a-694c-11e5-b9d4-c39860ec56cd", 368044900698, DidReceiveRemoteNotification)

function IdsAvailable(userID, pushToken)
    Globals.playerIdToken = userID
	print(userID)
end

OneSignal.IdsAvailableCallback(IdsAvailable)

OneSignal.EnableNotificationsWhenActive(true)