-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- visita
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
require('src.Header')
local composer = require( "composer" )
local widget = require( "widget" )
local Globals = require('src.resources.Globals')
local scene = composer.newScene()

--variables
local visitScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos
local svVisit

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function getBuildVisitItem( event )
	
	lastY = 30
	
	--svVisit
	local labelDate = display.newText( {
        text = "03 de septiembre del 2015",
        x = 452/2 + 20, y = lastY,
        width = 452,
        font = fontDefault, fontSize = 20, align = "left"
    })
    labelDate:setFillColor( .58 )
    svVisit:insert( labelDate )
	
	local labelDateTime = display.newText( {
        text = "11:40 am",
        x = 452/2 - 20, y = lastY,
        width = 452,
        font = fontDefault, fontSize = 20, align = "right"
    })
    labelDateTime:setFillColor( .58 )
    svVisit:insert( labelDateTime )
	
	lastY = 100
	
	local imgVisit = display.newImage( "img/btn/iconUserVisit.png" )
	imgVisit.y = lastY
	imgVisit.x = 70
	imgVisit.height = 80
	imgVisit.width = 90
    svVisit:insert(imgVisit)
	
	local labelVisit = display.newText( {
        text = "Julia Gutierrez",
        x = 280, y = lastY,
        width = 300,
        font = fontDefault, fontSize = 26, align = "left"
    })
    labelVisit:setFillColor( 0 )
    svVisit:insert( labelVisit )
	
	lastY = lastY + 80
	
	local textoMensage = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
	
	local labelInfo = display.newText( {
        text = textoMensage,
		x = 452/2, y = lastY,
		width = 452 - 50,
        font = fontDefault, fontSize = 24, align = "left"
    })
    labelInfo:setFillColor( 0 )
    svVisit:insert( labelInfo )
	
	labelInfo.y = lastY + labelInfo.height / 2
	
	lastY = lastY + labelInfo.height + 100
	
	svVisit:setScrollHeight(lastY)
	
	
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )
	
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
	
	--[[local maxShapeMsg = display.newRect( intW/2, h + header.height + 14 , 452 , intH - ( h + header.height) - 28 )
	maxShapeMsg.anchorY = 0
    maxShapeMsg:setFillColor( 1 )
	visitScreen:insert( maxShapeMsg )]]
	
	svVisit = widget.newScrollView
	{
		top =  h + header.height + 14,
		left = 14,
		width = 452,
		height = intH - ( h + header.height) - 28,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	visitScreen:insert(svVisit)
	
	getBuildVisitItem()
	
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