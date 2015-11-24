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

local itemsGuard

local lastY  = 0

local labelNumCondo

----elementos

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function setElementGuard(item)

	if #item > 0 then
		itemsGuard = item[1]
		
		loadImageGuard()
	end
	
end

function loadImageGuard()

	--print(itemsGuard.foto)
	
	local nameImg
	local extImg
	for k, v in string.gmatch( itemsGuard.foto, "(%w+).(%w+)" ) do
		nameImg = k
		extImg = v
	end

	-- Listener de la carga de la imagen del servidor
	local function loadImageListener( event )
		if ( event.isError ) then
			native.showAlert( "Go Deals", "Network error :(", { "OK"})
		else
			event.target.alpha = 0
			itemsGuard.foto = "imgGuardTurn." .. extImg
			buildItemGuardTurn()
		end
	end
		-- Descargamos de la nube
		display.loadRemoteImage( settings.url..itemsGuard.path..itemsGuard.foto, 
		"GET", loadImageListener, "imgGuardTurn." .. extImg, system.TemporaryDirectory )

end

function buildItemGuardTurn()

	lastY = lastY + 25

	local labelNameUserHome = display.newText( {   
        x = intW/2, y = lastY,
		width = 400,
        text = "En servicio: " .. itemsGuard.nombre .. " " .. itemsGuard.apellidos,  font = fontLatoRegular, fontSize = 17, align = "center",
	})
	labelNameUserHome:setFillColor( 0 )
	homeScreen:insert(labelNameUserHome)
	
	lastY = lastY + 25
	
	local bgPhoto = display.newRect( intW/2, lastY, 300, 350 )
	bgPhoto.anchorY = 0
	bgPhoto.anchorY = 0
	bgPhoto:setFillColor( 205/255, 205/255, 205/255 )
	homeScreen:insert(bgPhoto)
	
	local bgPhoto2 = display.newRect( intW/2, lastY + 3, 294, 344 )
	bgPhoto2.anchorY = 0
	bgPhoto2.anchorY = 0
	bgPhoto2:setFillColor( 1 )
	homeScreen:insert(bgPhoto2)
	
	--RestManager.getLastGuard()
	
	local imgPhotoGuard = display.newImage( itemsGuard.foto, system.TemporaryDirectory )
	--local imgPhotoGuard = display.newImage( "img/bgk/fotoGuard.jpeg" )
	imgPhotoGuard.anchorY = 0
	imgPhotoGuard.x= intW/2
	imgPhotoGuard.y = lastY + 3
	imgPhotoGuard.width = 294
	imgPhotoGuard.height = 344
	homeScreen:insert( imgPhotoGuard )

end

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
	
	local bgRectGreen = display.newRect( 148, h + 65, 4, 49 )
	bgRectGreen.anchorX = 0
	bgRectGreen.anchorY = 0
	bgRectGreen:setFillColor( 0, 148/255, 49/255 ) 
	homeScreen:insert(bgRectGreen)
	
	local imgNumCondo = display.newImage( "img/btn/icono-condo.png" )
	imgNumCondo.anchorX = 0
	imgNumCondo.anchorY = 0
	imgNumCondo.x= 5
	imgNumCondo.y = h + 65
	homeScreen:insert( imgNumCondo )
	
	local condoInfo = DBManager.getCondominiumById(settings.condominioId)
	
	labelNumCondo  = display.newText( {   
         x = 100, y = h + 88,
		width = 100, align = 'center',
        text = condoInfo.nombre,  font = fontLatoBold, fontSize = 22,
	})
	labelNumCondo:setFillColor( 0 )
	homeScreen:insert(labelNumCondo)
	
	local lineMenu = display.newRect( 0, h + 65 + 48, display.contentWidth, 1 )
	lineMenu.anchorX = 0
	lineMenu.anchorY = 0
	lineMenu:setFillColor( 236/255, 236/255, 236/255 )
	homeScreen:insert(lineMenu)
	
	local header = Header:new()
    homeScreen:insert(header)
    header.y = h
    header:buildToolbar()
	
	local residencial = DBManager.getResidencial()
	local telAdministracion, telCaseta, telLobby
	--residencial.telAdministracion
	--residencial.telCaseta
	--residencial.telLobby
	if residencial ~= 0 then
		telAdministracion = residencial[1].telAdministracion
		telCaseta = residencial[1].telCaseta
		telLobby = residencial[1].telLobby
	else
		telAdministracion = "000000000"
		telCaseta = "000000000"
		telLobby = "000000000"
	end
	
	lastY = h + 135
	
	local borderRight = display.newRect( 48, lastY, 8, 440 )
	borderRight.anchorY = 0
		borderRight:setFillColor( {
           type = 'gradient',
           color1 = { .2, .2, .2, .4 }, 
           color2 = { .8, .8, .8, .1 },
           direction = "left"
		   
	})
	homeScreen:insert(borderRight)
	
	local borderDown= display.newRect( intW/2, lastY + 438, 380, 8 )
	borderDown.anchorY = 0
		borderDown:setFillColor( {
           type = 'gradient',
           color1 = { .2, .2, .2, .4 }, 
           color2 = { .8, .8, .8, .1 },
           direction = "down"
		   
	})
	homeScreen:insert(borderDown)
	
	local bgRectWhiteGuard = display.newRoundedRect( intW/2, lastY, 380, 440, 8 )
	bgRectWhiteGuard.anchorY = 0
	bgRectWhiteGuard:setFillColor( 1 )
	homeScreen:insert(bgRectWhiteGuard)
	
	
	lastY =  lastY + 465
	
	local borderRight2 = display.newRect( 48, lastY + 6, 8, 120 )
	borderRight2.anchorY = 0
		borderRight2:setFillColor( {
           type = 'gradient',
           color1 = { .2, .2, .2, .4 }, 
           color2 = { .8, .8, .8, .1 },
           direction = "left"
		   
	})
	homeScreen:insert(borderRight2)
	
	local borderDown2 = display.newRect( intW/2, lastY + 128, 370, 8 )
	borderDown2.anchorY = 0
		borderDown2:setFillColor( {
           type = 'gradient',
           color1 = { .2, .2, .2, .4 }, 
           color2 = { .8, .8, .8, .1 },
           direction = "down"
		   
	})
	homeScreen:insert(borderDown2)
	
	local paint = {
		type = "gradient",
		color1 = { 10/255, 49/255, 82/255 },
		color2 = { 4/255, 35/255, 63/255},
		direction = "down"
	}
	
	local bgRectBluePhone = display.newRoundedRect( intW/2, lastY, 380, 130, 8 )
	bgRectBluePhone.anchorY = 0
	bgRectBluePhone:setFillColor( 1 )
	bgRectBluePhone.fill = paint
	homeScreen:insert(bgRectBluePhone)
	
	local imgInfoPhone = display.newImage( "img/btn/icono-tel.png" )
	imgInfoPhone.anchorX = 0
	imgInfoPhone.anchorY = 0
	imgInfoPhone.x= 95
	imgInfoPhone.y = lastY + 7
	homeScreen:insert( imgInfoPhone )
	
	labelInfoPhone  = display.newText( {   
         x = intW/2 + 30, y = lastY + 32,
        text = "TELÉFONOS IMPORTANTES",  font = fontLatoBold, fontSize = 16,
	})
	labelInfoPhone:setFillColor( 1 )
	homeScreen:insert(labelInfoPhone)
	
	lastY = lastY + 40
	
	labelPhoneAdmin  = display.newText( {   
         x = intW/2, y = lastY + 32,
		 width = 340,
        text = "Administración: " .. telAdministracion,  font = fontLatoRegular, fontSize = 14,
	})
	labelPhoneAdmin:setFillColor( 1 )
	homeScreen:insert(labelPhoneAdmin)
	
	lastY = lastY + 20
	
	labelPhoneCaseta  = display.newText( {   
         x = intW/2, y = lastY + 32,
		 width = 340,
        text = "Caseta:             " .. telCaseta,  font = fontLatoRegular, fontSize = 14,
	})
	labelPhoneCaseta:setFillColor( 1 )
	homeScreen:insert(labelPhoneCaseta)
	
	lastY = lastY + 20
	
	labelPhoneLobby  = display.newText( {
         x = intW/2, y = lastY + 32,
		 width = 340,
        text = "Lobby:               " .. telLobby,  font = fontLatoRegular, fontSize = 14,
	})
	labelPhoneLobby:setFillColor( 1 )
	homeScreen:insert(labelPhoneLobby)
	
	lastY = h + 135
	RestManager.getLastGuard()
	
	--local labelPhoneAdmin
	
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