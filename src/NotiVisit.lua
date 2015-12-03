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
local groupSvContent = display.newGroup()
local groupBtnSvContent = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
local svContent

local itemsVisit

local noLeido = {}
local idDeleteV = {}

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
	
	svContent:insert(groupSvContent)
	svContent:insert(groupBtnSvContent)
	
	groupBtnSvContent.alpha = 0
	
	local bgBtnDelete = display.newRoundedRect( 290, yMain + 4, 170, 60, 5 )
	bgBtnDelete.anchorX = 0
	--bgMessage.anchorY = 0
	bgBtnDelete:setFillColor( 0, 80/255, 0  )
	groupBtnSvContent:insert(bgBtnDelete)
	
	local paint = {
			type = "gradient",
			color1 = { 0, 135/255, 0/255 },
			color2 = { 0, 91/255, 0 },
			direction = "down"
	}
	
	local btnDelete = display.newRoundedRect( 293, yMain + 4, 164, 54, 5 )
	btnDelete.anchorX = 0
	--bgMessage.anchorY = 0
	btnDelete.fill = paint
	btnDelete:setFillColor( 1 )
	groupBtnSvContent:insert(btnDelete)
	btnDelete:addEventListener( 'tap', deleteVisit )
	
	local txtBtnDelete = display.newText( {
		text = "Borrar",
		x = 375, y = yMain - 6,
		font = fontLatoRegular, fontSize = 18, align = "center"
	})
	txtBtnDelete:setFillColor( 1 )
	groupBtnSvContent:insert(txtBtnDelete)
	
	local txtBtnDelete2 = display.newText( {
		text = "seleccionados",
		x = 375, y = yMain + 14,
		font = fontLatoRegular, fontSize = 18, align = "center"
	})
	txtBtnDelete2:setFillColor( 1 )
	groupBtnSvContent:insert(txtBtnDelete2)
	
	for y = 1, #itemsVisit, 1 do
			idDeleteV[y] = 0
            itemsVisit[y].posc = y
			local visit = Visit:new()
			groupSvContent:insert(visit)
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
                groupSvContent:insert(noLeido[y])
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

--muestra y/o oculta el boton de eliminar visitas
function showBtnDeleteVisit(isTrue, isActive, idVisit, posc)

	--print(posc)
	
	if isTrue then
		groupSvContent.y = 55
		groupBtnSvContent.alpha = 1
		svContent:setScrollHeight(yMain + 60)
	else
		groupSvContent.y = 0
		groupBtnSvContent.alpha = 0
		svContent:setScrollHeight(yMain)
	end
	if isActive then
		idDeleteV[posc] = idVisit
	else
		idDeleteV[posc] = 0
	end
	
end

--elimina las visitas selecionadas
function deleteVisit( event )
	--table.remove(idDeleteV,2)
	local visitDelete = {}
	for i= 1, #idDeleteV, 1 do
		if idDeleteV[i] ~= 0 then
			visitDelete[#visitDelete + 1] = idDeleteV[i]
		end
	end
	RestManager.deleteMsgVisit(visitDelete)
	return true
end

--obtiene los mensajes de las visitas
function refreshMessageVisit()
	groupSvContent:removeSelf();
	groupBtnSvContent:removeSelf();
	groupSvContent = display.newGroup()
	groupBtnSvContent = display.newGroup()
	RestManager.getMessageToVisit()
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