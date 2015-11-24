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
local groupASvContent = display.newGroup()
local groupABtnSvContent = display.newGroup()

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
local svContent

local itemsAdmin

local noLeidoA = {}

local idDeleteA = {}

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--obtenemos el homeScreen de la escena
function getScreenMA()
	return NotiMessageScreen
end

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

	yMain = 10

	svContent:insert(groupASvContent)
	svContent:insert(groupABtnSvContent)
	
	groupABtnSvContent.alpha = 0
	
	local bgBtnDeleteAdmin = display.newRoundedRect( 290, yMain + 30, 170, 60, 5 )
	bgBtnDeleteAdmin.anchorX = 0
	--bgMessage.anchorY = 0
	bgBtnDeleteAdmin:setFillColor( 0, 80/255, 0 )
	groupABtnSvContent:insert(bgBtnDeleteAdmin)
	
	local paint = {
			type = "gradient",
			color1 = { 0, 135/255, 0/255 },
			color2 = { 0, 91/255, 0 },
			direction = "down"
	}
	
	local btnDeleteAdmin = display.newRoundedRect( 293, yMain + 30, 164, 54, 5 )
	btnDeleteAdmin.anchorX = 0
	--bgMessage.anchorY = 0
	btnDeleteAdmin.fill = paint
	btnDeleteAdmin:setFillColor( 1 )
	groupABtnSvContent:insert(btnDeleteAdmin)
	btnDeleteAdmin:addEventListener( 'tap', deleteAdmin )
	
	local txtBtnDeleteAdmin = display.newText( {
		text = "Borrar\nseleccionados",
		x = 375, y = yMain + 30,
		font = fontLatoRegular, fontSize = 18, align = "center"
	})
	txtBtnDeleteAdmin:setFillColor( 1 )
	groupABtnSvContent:insert(txtBtnDeleteAdmin)
	
	for y = 1, #itemsAdmin, 1 do
	
			idDeleteA[y] = 0
	
			itemsAdmin[y].posc = y
	
			local message = Message:new()
			groupASvContent:insert(message)
			message:build(itemsAdmin[y])
			message.y = yMain
			message.id = itemsAdmin[y].idXref
			message.posci = y
			message.pocY = yMain
			message:addEventListener('tap', markReadAdmin)
			
			--[[local imgMsg = display.newImage( "img/btn/message01.png" )
			imgMsg.x= -177
			container:insert(imgMsg)]]
			
            if itemsAdmin[y].leido == "0" then
				noLeidoA[y] =  display.newImage( "img/btn/mensaje-nvo.png" )
			else
				noLeidoA[y] =  display.newImage( "img/btn/mensaje-leido.png" )
            end
			noLeidoA[y].x = 110
			noLeidoA[y].y = yMain + 60
			groupASvContent:insert(noLeidoA[y])
            yMain = yMain + 110
		--[[end]]
    end
	
	svContent:setScrollHeight(yMain)
	
end


function markReadAdmin( event )
	
	event.target:removeEventListener('tap', markReadAdmin)
	
	if noLeidoA[event.target.posci] then
		noLeidoA[event.target.posci]:removeSelf()
		noLeidoA[event.target.posci] =  display.newImage( "img/btn/mensaje-leido.png" )
		noLeidoA[event.target.posci].x = 110
		noLeidoA[event.target.posci].y = event.target.pocY + 60
		svContent:insert(noLeidoA[event.target.posci])
	end
	
	RestManager.markMessageRead( event.target.id, 1 )
	RestManager.getMessageUnRead()
	
end

--muestra y/o oculta el boton de eliminar visitas
function showBtnDeleteAdmin(isTrue, isActive, idVisit, posc)

	--print(posc)
	
	if isTrue then
		groupASvContent.y = 60
		groupABtnSvContent.alpha = 1
		svContent:setScrollHeight(yMain + 60)
	else
		groupASvContent.y = 0
		groupABtnSvContent.alpha = 0
		svContent:setScrollHeight(yMain)
	end
	if isActive then
		idDeleteA[posc] = idVisit
	else
		idDeleteA[posc] = 0
	end
	
end

--elimina las visitas selecionadas
function deleteAdmin( event )
	--table.remove(idDeleteA,2)
	local adminDelete = {}
	for i= 1, #idDeleteA, 1 do
		if idDeleteA[i] ~= 0 then
			adminDelete[#adminDelete + 1] = idDeleteA[i]
		end
	end
	RestManager.deleteMsgAdmin(adminDelete)
	return true
end

function refreshMessageAdmin()
	
	groupASvContent:removeSelf();
	groupABtnSvContent:removeSelf();
	groupASvContent = display.newGroup()
	groupABtnSvContent = display.newGroup()
	RestManager.getMessageToAdmin()
	
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
	bgMessage:setFillColor( 245/255, 245/255, 245/255 )
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