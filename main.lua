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

print(isUser)

if not isUser then
	composer.gotoScene("src.Login")
else
	composer.gotoScene("src.Home")
end




