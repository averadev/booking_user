-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- visita
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
require('src.Header')
require('src.BuildItem')
local composer = require( "composer" )
local widget = require( "widget" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local scene = composer.newScene()

--variables
local visitScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local fxAccept = audio.loadSound( "fx/accept.wav")
local fxCancel = audio.loadSound( "fx/cancel.wav")

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
local svVisit, idMSG, itemVisit, svH, grpDetail, grpNew

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--obtenemos el homeScreen de la escena
function getScreenV()
	return visitScreen
end

function setItemsVisit(item)
	
	itemVisit = item
	getBuildVisitItem()
	deleteLoadingLogin()
	
end

function getAccess(event)
    local t = event.target
    if t.access then
        audio.play( fxAccept )
        RestManager.updateVisitAction(idMSG, 2)
    else
        audio.play( fxCancel )
        RestManager.updateVisitAction(idMSG, 3)
    end
    transition.to( grpNew, { alpha = 0, time = 400 })
    transition.to( grpDetail, { y = 0 - 60, time = 400, delay = 200 })
    
end

function getBuildVisitItem( event )
	
	lastY = 30
    
    grpDetail = display.newGroup()
    svVisit:insert(grpDetail)
    
    if itemVisit.action == '0' then
        grpNew = display.newGroup()
        svVisit:insert(grpNew)
        
        local bgCancel = display.newRect( 2, 2, 223, 60 )
        bgCancel.anchorX = 0
        bgCancel.anchorY = 0
        bgCancel:setFillColor( .7, 0, 0 )
        bgCancel.access = false
		bgCancel:addEventListener("tap", getAccess)
        grpNew:insert(bgCancel)
        
        local lblCancel = display.newText( {
            text = "Negar Acceso",
            x = 112, y = 30, width = 220,
            font = fontLatoBold, fontSize = 20, align = "center"
        })
        grpNew:insert( lblCancel )
        
        local bgAccept = display.newRect( 226, 2, 223, 60 )
        bgAccept.anchorX = 0
        bgAccept.anchorY = 0
        bgAccept:setFillColor( 0,150/255,43/255 )
        bgAccept.access = true
		bgAccept:addEventListener("tap", getAccess)
        grpNew:insert(bgAccept)
        
        local lblAccept = display.newText( {
            text = "Aceptar Acceso",
            x = 337, y = 30, width = 220,
            font = fontLatoBold, fontSize = 20, align = "center"
        })
        grpNew:insert( lblAccept )
        
        lastY = 90
    end
	
	local labelDate = display.newText( {
        text = itemVisit.fechaFormat,
        x = 452/2 + 20, y = lastY,
        width = 452,
        font = fontLatoLight, fontSize = 20, align = "left"
    })
    labelDate:setFillColor( .58 )
    grpDetail:insert( labelDate )
	
	local labelDateTime = display.newText( {
        text = itemVisit.hora,
        x = 452/2 - 20, y = lastY,
        width = 452,
        font = fontLatoLight, fontSize = 20, align = "right"
    })
    labelDateTime:setFillColor( .58 )
    grpDetail:insert( labelDateTime )
	
	lastY = lastY + 70
	
	local imgVisit = display.newImage( "img/btn/visitas.png" )
	imgVisit.y = lastY
	imgVisit.x = 70
    grpDetail:insert(imgVisit)
	
	local labelVisit = display.newText( {
        text = itemVisit.nombreVisitante,
        x = 280, y = lastY,
        width = 300,
        font = fontLatoBold, fontSize = 26, align = "left"
    })
    labelVisit:setFillColor( 0 )
    grpDetail:insert( labelVisit )
	
	lastY = lastY + 80
	
	local labelInfo = display.newText( {
        text = itemVisit.motivo,
		x = 452/2, y = lastY,
		width = 452 - 50,
        font = fontLatoRegular, fontSize = 24, align = "left"
    })
    labelInfo:setFillColor( 0 )
    grpDetail:insert( labelInfo )
	
	labelInfo.y = lastY + labelInfo.height / 2
	
	lastY = lastY + labelInfo.height + 100
	svVisit:setScrollHeight(lastY)
	
	
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )
	
	idMSG = event.params.id
	
	local screen = self.view
	
	screen:insert(visitScreen)
	
	local bgVisit = display.newRect( 0, h, intW, intH )
	bgVisit.anchorX = 0
	bgVisit.anchorY = 0
	bgVisit:setFillColor( 214/255, 226/255, 225/255 )
	visitScreen:insert(bgVisit)
	
	local header = Header:new()
    visitScreen:insert(header)
    header.y = h
    header:buildToolbar()
	header:buildNavBar("Visita")
	
	local maxShapeMsg = display.newRect( intW/2, h + header.height + 10 , 460 , intH - ( h + header.height) - 20 )
	maxShapeMsg.anchorY = 0
    maxShapeMsg:setFillColor( .84 )
	visitScreen:insert( maxShapeMsg )
	
	svVisit = widget.newScrollView
	{
		top =  h + header.height + 14,
		left = 14,
		width = 452,
		height = intH - ( h + header.height) - 28,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
		--backgroundColor = { 44/255, 106/255, 158/255 }
	}
	visitScreen:insert(svVisit)
    
	RestManager.getMessageToVisitById(idMSG)
	
	--getBuildVisitItem()
	
end

-- "scene:show()"
function scene:show( event )
	Globals.scene[#Globals.scene + 1] = composer.getSceneName( "current" )
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