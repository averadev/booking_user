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
local NotiVisitScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
local svContent

local itemsVisit

local noLeido = {}

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--obtenemos el homeScreen de la escena
function getScreenMV()
	return NotiVisitScreen
end

function setItemsNotiVisit( items )
	if #items > 0 then
		itemsVisit = items
		buildVisitItems()
		deleteLoadingLogin()
	else
		getNoContent(svContent,'En este momento no cuentas con mensajes')
		deleteLoadingLogin()
	end
end

function buildVisitItems()
	
	yMain = 40
	
	for y = 1, #itemsVisit, 1 do
       --[[ if elements[y].tipo == "3" then
            if not isMessage then 
                isMessage = true
                yMain = 0 
            end]]
            
			local visit = Visit:new()
			svContent:insert(visit)
			visit:build(itemsVisit[y])
			visit.y = yMain
			visit.id = itemsVisit[y].id
			visit.posci = y
			
            if itemsVisit[y].leido == "0" then
				visit:addEventListener('tap', markRead)
                noLeido[y] = display.newRect( 0, h, 5, 120 )
                noLeido[y].x = 12
                noLeido[y].y = yMain + 60
                noLeido[y]:setFillColor( .18, .59, 0 )
                svContent:insert(noLeido[y])
            end
            yMain = yMain + 130
		--[[end]]
    end
	
	svContent:setScrollHeight(yMain)
	
end

function markRead( event )

	event.target:removeEventListener('tap', markRead)
	
	if noLeido[event.target.posci] then
		noLeido[event.target.posci]:removeSelf()
	end
	
	RestManager.markMessageRead( event.target.id, 2 )
	RestManager.getMessageUnRead()
	
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(NotiVisitScreen)
	
	local bgMessage = display.newRect( 0, h, intW, intH )
	bgMessage.anchorX = 0
	bgMessage.anchorY = 0
	bgMessage:setFillColor( 245/255, 245/255, 245/255 )
	NotiVisitScreen:insert(bgMessage)
	
	local header = Header:new()
    NotiVisitScreen:insert(header)
    header.y = h
    header:buildToolbar()
	header:buildNavBar("Visitas")
	
	svContent = widget.newScrollView
	{
		top = h + header.height,
		left = 0,
		width = intW,
		height = intH - (h + header.height),
		horizontalScrollDisabled = true,
		--backgroundColor = { 245/255, 245/255, 245/255 }
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	NotiVisitScreen:insert(svContent)
	
	--buildVisitItems()
	RestManager.getMessageToVisit()
	
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