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

print(isUser)

if not isUser then
	composer.gotoScene("src.Login")
else
	composer.gotoScene("src.Home")
end

function DidReceiveRemoteNotification(message, additionalData, isActive)
    if (additionalData) then
        if (additionalData.discount) then
            native.showAlert( "Discount!", message, { "OK" } )
            -- Take user to your app store
        elseif (additionalData.actionSelected) then -- Interactive notification button pressed
            native.showAlert("Button Pressed!", "ButtonID:" .. additionalData.actionSelected, { "OK"} )
        end
    else
        native.showAlert("OneSignal Message", message, { "OK" } )
    end
end

local OneSignal = require("plugin.OneSignal")
-- Uncomment SetLogLevel to debug issues.
-- OneSignal.SetLogLevel(4, 4)
OneSignal.Init("d55cca2a-694c-11e5-b9d4-c39860ec56cd", 368044900698, DidReceiveRemoteNotification)

function IdsAvailable(userID, pushToken)
    Globals.playerIdToken = userID
end

OneSignal.IdsAvailableCallback(IdsAvailable)


