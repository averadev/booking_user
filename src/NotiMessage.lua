-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Message
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
require('src.Header')
require('src.BuildRow')
local composer = require( "composer" )
local widget = require( "widget" )
local Globals = require('src.resources.Globals')
local scene = composer.newScene()

--variables
local NotiMessageScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
local svContent

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function buildMensageItems( event)
	
	yMain = 40
	
	for y = 1, 3, 1 do
       --[[ if elements[y].tipo == "3" then
            if not isMessage then 
                isMessage = true
                yMain = 0 
            end]]
            
			local message = Message:new()
			svContent:insert(message)
			--message:build(true, elements[y], imageItems[y])
			message:build(true, "hola", "message01.png")
			message.y = yMain
			--message.id = elements[y].idRelacional
			message.id = 1
			message.posci = y
			--message:addEventListener('tap', markRead)
			
            --[[if elements[y].leido == "1" then
                noLeido[y] = display.newRect( 0, h, 2, 98 )
                noLeido[y].x = 10
                noLeido[y].y = yMain - 50
                noLeido[y]:setFillColor( .18, .59, 0 )
                svContent:insert(noLeido[y])
            end]]
            yMain = yMain + 110
		--[[end]]
    end
	
end


---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(NotiMessageScreen)
	
	local bgMessage = display.newRect( 0, h, intW, intH )
	bgMessage.anchorX = 0
	bgMessage.anchorY = 0
	bgMessage:setFillColor( 214/255, 226/255, 225/255 )
	NotiMessageScreen:insert(bgMessage)
	
	local header = Header:new()
    NotiMessageScreen:insert(header)
    header.y = h
    header:buildToolbar()
	header:buildNavBar("Mensajes")
	
	svContent = widget.newScrollView
	{
		top = h + header.height,
		left = 0,
		width = intW,
		height = intH - (h + header.height),
		horizontalScrollDisabled = true,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	NotiMessageScreen:insert(svContent)
	
	buildMensageItems()
	
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