-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Message
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
local messageScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos
local svMessage

local idMSG

local itemAdmin

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function setItemsAdmin( item )
	
	itemAdmin = item
	getBuildMessageItem()
	deleteLoadingLogin()
	
end


function getBuildMessageItem( event )
	
	lastY = 30
	
	--svMessage
	local labelDate = display.newText( {
        text = itemAdmin.dia .. ", " .. itemAdmin.fechaFormat .. " " .. itemAdmin.hora,
        x = 452/2 - 20, y = lastY,
        width = 452,
        font = fontDefault, fontSize = 20, align = "right"
    })
    labelDate:setFillColor( .58 )
    svMessage:insert( labelDate )
	
	lastY = 100
	
	local imgMessage = display.newImage( "img/btn/message01.png" )
	imgMessage.y = lastY
	imgMessage.x = 75
	imgMessage.height = 60
	imgMessage.width = 70
    svMessage:insert(imgMessage)
	
	local labelSubject = display.newText( {
        text = "Asunto: \n" .. itemAdmin.asunto,
        x = 280, y = lastY,
        width = 300,
        font = fontDefault, fontSize = 20, align = "left"
    })
    labelSubject:setFillColor( 0 )
    svMessage:insert( labelSubject )
	
	lastY = lastY + 80
	
	local textoMensage = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
	
	local labelMessage = display.newText( {
        text = itemAdmin.mensaje,
		x = 452/2, y = lastY,
		width = 452 - 50,
        font = fontDefault, fontSize = 24, align = "left"
    })
    labelMessage:setFillColor( 0 )
    svMessage:insert( labelMessage )
	
	labelMessage.y = lastY + labelMessage.height / 2
	
	lastY = lastY + labelMessage.height + 100
	
	svMessage:setScrollHeight(lastY)
	
	
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	idMSG = event.params.id
	
	local screen = self.view
	
	screen:insert(messageScreen)
	
	local bgMessage = display.newRect( 0, h, intW, intH )
	bgMessage.anchorX = 0
	bgMessage.anchorY = 0
	bgMessage:setFillColor( 214/255, 226/255, 225/255 )
	messageScreen:insert(bgMessage)
	
	local header = Header:new()
    messageScreen:insert(header)
    header.y = h
    header:buildToolbar()
	header:buildNavBar("Mensaje")
	
	local maxShapeMsg = display.newRect( intW/2, h + header.height + 10 , 460 , intH - ( h + header.height) - 20 )
	maxShapeMsg.anchorY = 0
    maxShapeMsg:setFillColor( .84 )
	messageScreen:insert( maxShapeMsg )
	
	--[[local maxShapeMsg = display.newRect( intW/2, h + header.height + 14 , 452 , intH - ( h + header.height) - 28 )
	maxShapeMsg.anchorY = 0
    maxShapeMsg:setFillColor( 1 )
	messageScreen:insert( maxShapeMsg )]]
	
	svMessage = widget.newScrollView
	{
		top =  h + header.height + 14,
		left = 14,
		width = 452,
		height = intH - ( h + header.height) - 28,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	messageScreen:insert(svMessage)
	
	RestManager.getMessageToAdminById(idMSG)
	
	--getBuildMessageItem()
	
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