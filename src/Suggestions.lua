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
local grpSuggestion = display.newGroup()
--grupo de los elementos nativos 
local grpSubject = display.newGroup()
local grpMessage = display.newGroup()
local grpBtnSend = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
local txtSubject, txtMessage
local btnSendSuggestion

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
function getScreenS()
	return grpSuggestion
end

--envia la queja o sugerencias
function sendSendSuggestion( event )
	native.setKeyboardFocus( nil )
	if txtSubject.text ~='' and txtMessage.text ~= '' then
		getLoadingLogin(600,"Enviando...")
		btnSendSuggestion:removeEventListener( 'tap', sendSendSuggestion )
		RestManager.sendSuggestion(txtSubject.text,txtMessage.text)
	else
		NewAlert('Plantec Resident','Campos vacios',1)
		moveGrpTextField(1)
	end
	
	return true
end

--returna cuando se envia el mensaje
function messageSent(typeM)
	if typeM == 2 then
		txtSubject.text =''
		txtMessage.text = ''
	end
	btnSendSuggestion:addEventListener( 'tap', sendSendSuggestion )
end

--regresa los textField a su lugar con coordenada x
function moveGrpTextField(typeM)
	if typeM == 1 then
		grpSubject.x = -480
		grpMessage.x = -480
	else
		grpSubject.x = 0
		grpMessage.x = 0
	end
end

--evento del teclado
function onTxtFocusSuggestion( event )
	if ( event.phase == "began" ) then
		grpSubject.y = -50
		grpMessage.y = -70
		grpBtnSend.y = -90
	elseif ( event.phase == "ended" ) then
		grpSubject.y = 0
		grpMessage.y = 0
		grpBtnSend.y = 0
		native.setKeyboardFocus( nil )
	elseif ( event.phase == "submitted" ) then
		if event.target.name == "ASUNTO" then
			native.setKeyboardFocus( txtMessage )
		end
    elseif ( event.phase == "editing" ) then
		
    end
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(grpSuggestion)
	screen:insert(grpSubject)
	screen:insert(grpMessage)
	screen:insert(grpBtnSend)
	
	local bgMessage = display.newRect( 0, h, intW, intH )
	bgMessage.anchorX = 0
	bgMessage.anchorY = 0
	bgMessage:setFillColor( 245/255, 245/255, 245/255 )
	grpSuggestion:insert(bgMessage)
	
	local header = Header:new()
    grpSuggestion:insert(header)
    header.y = h
    header:buildToolbar()
	header:buildNavBar("Quejas y sugerencias")
	
	local bgTxtSubject = display.newRoundedRect( intW/2, 200 + h, 400, 60, 10 )
	bgTxtSubject:setFillColor( 1 )
	grpSubject:insert(bgTxtSubject)
	
	local bgTxtMessage = display.newRoundedRect( intW/2, 350 + h, 400, 180, 10 )
	bgTxtMessage:setFillColor( 1 )
	grpMessage:insert(bgTxtMessage)
	
	local paint = {
		type = "gradient",
		color1 = { 10/255, 49/255, 82/255 },
		color2 = { 4/255, 35/255, 63/255},
		direction = "down"
	}
	
	btnSendSuggestion = display.newRoundedRect( intW/2, 500 + h, 200, 60, 10 )
	btnSendSuggestion:setFillColor( 1 )
	btnSendSuggestion.fill = paint
	btnSendSuggestion:addEventListener( 'tap', sendSendSuggestion )
	grpBtnSend:insert(btnSendSuggestion)
	
	local labelSendSuggestion = display.newText( {   
        x = intW/2, y = 500 + h,
        text = "Enviar",  font = fontLatoBold, fontSize = 26
	})
	labelSendSuggestion:setFillColor( 1 )
	grpBtnSend:insert(labelSendSuggestion)
	
	
	
end

-- "scene:show()"
function scene:show( event )
	Globals.scene[#Globals.scene + 1] = composer.getSceneName( "current" )
	
	if not txtSubject then
		txtSubject = native.newTextField( intW/2, 200 + h, 400, 60 )
		txtSubject.inputType = "default"
		txtSubject.hasBackground = false
		txtSubject.placeholder = "ASUNTO"
		txtSubject.name = "ASUNTO"
		txtSubject:addEventListener( "userInput", onTxtFocusSuggestion )
		txtSubject:setReturnKey( "next" )
		txtSubject.size = 20
		grpSubject:insert(txtSubject)
	end
	
	if not txtMessage then
		txtMessage = native.newTextBox( intW/2, 350 + h, 400, 180 )
		txtMessage.isEditable = true
		txtMessage.hasBackground = false
		txtMessage.placeholder = "MENSAJE"
		txtMessage.name = "MENSAJE"
		txtMessage:addEventListener( "userInput", onTxtFocusSuggestion )
		txtMessage.size = 20
		grpMessage:insert(txtMessage)
	end
end

-- "scene:hide()"
function scene:hide( event )
	native.setKeyboardFocus( nil )
	if txtSubject then
		txtSubject:removeSelf()
		txtSubject = nil
	end
	
	if txtMessage then
		txtMessage:removeSelf()
		txtMessage = nil
	end
end

-- "scene:destroy()"
function scene:destroy( event )
	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene