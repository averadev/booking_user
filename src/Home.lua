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

local settings = DBManager.getSettings()

--variables
local homeScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont
local fontLatoBold, fontLatoLight, fontLatoRegular
local environment = system.getInfo( "environment" )
if environment == "simulator" then
	fontLatoBold = native.systemFontBold
	fontLatoLight = native.systemFont
	fontLatoRegular = native.systemFont
else
	fontLatoBold = "Lato-Bold"
	fontLatoLight = "Lato-Light"
	fontLatoRegular = "Lato-Regular"
end

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

--obtenemos el homeScreen de la escena
function getScreenH()
	return homeScreen
end

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(homeScreen)
	
	local bgHome = display.newRect( 0, h, intW, intH )
	bgHome.anchorX = 0
	bgHome.anchorY = 0
	bgHome:setFillColor( 245/255, 245/255, 245/255 )
	homeScreen:insert(bgHome)
	
	local bgRectWhite = display.newRect( 0, h + 65, intW, 49 )
	bgRectWhite.anchorX = 0
	bgRectWhite.anchorY = 0
	bgRectWhite:setFillColor( 1 )
	homeScreen:insert(bgRectWhite)
	
	local lineMenu = display.newRect( 0, h + 65 + 48, display.contentWidth, 1 )
	lineMenu.anchorX = 0
	lineMenu.anchorY = 0
	lineMenu:setFillColor( 236/255, 236/255, 236/255 )
	homeScreen:insert(lineMenu)
	
	local header = Header:new()
    homeScreen:insert(header)
    header.y = h
    header:buildToolbar()
	
	local lastY = h + 150
	
	local labelWelcomeHome = display.newText( {   
         x = intW/2, y = lastY,
		width = 400,
        text = "Bienvenido",  font = fontLatoBold, fontSize = 22,
	})
	labelWelcomeHome:setFillColor( 0 )
	homeScreen:insert(labelWelcomeHome)
	
	lastY = lastY + 35
	
	local labelInfoHome = display.newText( {   
        x = intW/2, y = lastY,
		width = 400,
        text = "Actualmente se encuentra en servicio:",  font = fontLatoRegular, fontSize = 18,
	})
	labelInfoHome:setFillColor( 0 )
	homeScreen:insert(labelInfoHome)
	
	lastY = lastY + 75
	
	local labelNameUserHome = display.newText( {   
        x = intW/2, y = lastY,
		width = 400,
        text = settings.name .. " " .. settings.apellido,  font = fontLatoRegular, fontSize = 24, align = "center",
	})
	labelNameUserHome:setFillColor( 0 )
	homeScreen:insert(labelNameUserHome)
	
	lastY = lastY + 35
	
	local bgPhoto = display.newRect( intW/2, lastY, 300, 350 )
	bgPhoto.anchorY = 0
	bgPhoto.anchorY = 0
	bgPhoto:setFillColor( 1 )
	bgPhoto:setStrokeColor( 205/255, 205/255, 205/255 )
	bgPhoto.strokeWidth = 4
	homeScreen:insert(bgPhoto)
	
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