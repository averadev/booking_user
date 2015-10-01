-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Message
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
require('src.Header')
require('src.BuildRow')
require('src.BuildItem')
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
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

local itemsAdmin

local noLeidoA = {}

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function setItemsNotiAdmin( items )
	
	if #items > 0 then
		itemsAdmin = items
		buildMensageItems()
		deleteLoadingLogin()
	else
		getNoContent(svContent,'En este momento no cuentas con mensajes')
		deleteLoadingLogin()
	end
	
end

function buildMensageItems( event)
	
	yMain = 40
	
	for y = 1, #itemsAdmin, 1 do
       --[[ if elements[y].tipo == "3" then
            if not isMessage then 
                isMessage = true
                yMain = 0 
            end]]
            
			local message = Message:new()
			svContent:insert(message)
			message:build(itemsAdmin[y])
			message.y = yMain
			message.id = itemsAdmin[y].idXref
			message.posci = y
			message:addEventListener('tap', markReadAdmin)
			
            if itemsAdmin[y].leido == "0" then
                noLeidoA[y] = display.newRect( 0, h, 5, 98 )
                noLeidoA[y].x = 12
                noLeidoA[y].y = yMain + 60
                noLeidoA[y]:setFillColor( .18, .59, 0 )
                svContent:insert(noLeidoA[y])
            end
            yMain = yMain + 110
		--[[end]]
    end
	
end


function markReadAdmin( event )
	
	event.target:removeEventListener('tap', markReadAdmin)
	
	if noLeidoA[event.target.posci] then
		noLeidoA[event.target.posci]:removeSelf()
	end
	
	RestManager.markMessageRead( event.target.id, 1 )
	RestManager.getMessageUnRead()
	
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
	
	RestManager.getMessageToAdmin()
	--buildMensageItems()
	
end

-- "scene:show()"
function scene:show( event )
	Globals.scene[#Globals.scene + 1] = composer.getSceneName( "current" )
end

-- "scene:hide()"
function scene:hide( event )
   local phase = event.phase
   deleteLoadingLogin()
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