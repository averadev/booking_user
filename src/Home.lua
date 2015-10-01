-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
require('src.Header')
local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
--local widget = require( "widget" )
local scene = composer.newScene()

--variables
local homeScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------



---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

function shoa()
	composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft" })
end

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(homeScreen)
	
	local bgHome = display.newImage( "img/bgk/fondo.png" )
	bgHome.anchorX = 0
	bgHome.anchorY = 0
	bgHome.height = intH - h
	bgHome.y = h
	homeScreen:insert(bgHome)
	--bgLogin:addEventListener( 'tap', shoa )
	
	local header = Header:new()
    homeScreen:insert(header)
    header.y = h
    header:buildToolbar()
	
end

-- "scene:show()"
function scene:show( event )
	Globals.scene[1] = composer.getSceneName( "current" )
end

-- "scene:hide()"
function scene:hide( event )
   local phase = event.phase
   --phase == "will"
   --phase == "did"
end

-- "scene:destroy()"
function scene:destroy( event )
	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene