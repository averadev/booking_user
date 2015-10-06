-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
require('src.BuildItem')
local widget = require( "widget" )
local composer = require( "composer" )
local Sprites = require('src.resources.Sprites')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local settings = DBManager.getSettings()

local scene = composer.newScene()

--variables
local loginScreen = display.newGroup()
local groupOptionCombo = display.newGroup()
local groupSign, groupSign2
local grpLoadingLogin

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"
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
--texto
local labelComboOpcionCity
local labelInfoLoginCondo
--native textField
local txtSignEmail, txtSignPassword
--scroll
local svOptionCombo

--btn
local btnSignLogin, btnContinueLogin

local dataCombo

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--evento de los textField
function onTxtFocusLogin( event )
	
	if ( event.phase == "began" ) then

    elseif ( event.phase == "ended" ) then

    elseif ( event.phase == "submitted" ) then
	
		if event.target.name == "email" then
			native.setKeyboardFocus(txtSignPassword)
		elseif event.target.name == "password" then
			native.setKeyboardFocus( nil )
			SignIn()
		end

    elseif event.phase == "editing" then

    end

end

--funcion de logeo
function SignIn()
	btnSignLogin:removeEventListener( 'tap', SignIn)
	btnSignLogin.alpha = .5
	if txtSignEmail.text ~= '' and txtSignPassword.text ~= '' then
		getLoadingLogin(600, "comprobando usuarios")
		RestManager.validateUser('conomia_alfredo@hotmail.com','123')
		--RestManager.validateUser(txtSignEmail.text,txtSignPassword.text)
	else
		
		getMessageSignIn("Campos vacios", 2)
		timeMarker = timer.performWithDelay( 2000, function()
			deleteLoadingLogin()
			deleteMessageSignIn()
			btnSignLogin:addEventListener( 'tap', SignIn)
			btnSignLogin.alpha = 1
		end, 1 )
	end
	
	--return true
end

function ContinueLogin( event )
	btnContinueLogin:removeEventListener( 'tap', ContinueLogin)
	btnContinueLogin.alpha = .5
	if labelComboOpcionCondo.id ~= 0 then
		getLoadingLogin(600, "Asignando el condominio")
		RestManager.setIdPlayerUser(labelComboOpcionCondo.id, labelComboOpcionCondo.idUser)
	else
		getMessageSignIn("Seleccione un condominio", 2)
		timeMarker = timer.performWithDelay( 2000, function()
			deleteLoadingLogin()
			deleteMessageSignIn()
			btnContinueLogin:addEventListener( 'tap', ContinueLogin)
			btnContinueLogin.alpha = 1
		end, 1 )
		
	end
	return true
end

function returnSingIn( event )
	DBManager.clearUser()
	--txtSignEmail.text = ''
	txtSignPassword.text = ''
	transition.to( groupSign2, { x = 480, time = 400, transition = easing.outExpo } )
	transition.to( groupSign, { x = 0, time = 400, transition = easing.outExpo } )
	return true
end 

function goToHomeLogin()
	btnSignLogin:addEventListener( 'tap', SignIn)
	btnSignLogin.alpha = 1
	composer.removeScene("src.Home")
	composer.gotoScene("src.Home")
end

function goToHomeLoginCondo()
	btnContinueLogin:addEventListener( 'tap', SignIn)
	btnContinueLogin.alpha = 1
	composer.removeScene("src.Home")
	composer.gotoScene("src.Home")
end

function goToSelectCondominiousLogin()
	settings = DBManager.getSettings()
	labelInfoLoginCondo.text = "Bienvenido " .. settings.name .. " " .. settings.apellido .. " antes de continuar, por favor selecciona el condominio con el que deseas accesar:"
	transition.to( groupSign, { x = -480, time = 400, transition = easing.outExpo } )
	transition.to( groupSign2, { x = 0, time = 400, transition = easing.outExpo } )
end

function errorLogin()
	btnSignLogin:addEventListener( 'tap', SignIn)
	btnSignLogin.alpha = 1
end

function errorLoginCondo()
	btnContinueLogin:addEventListener( 'tap', ContinueLogin )
	btnContinueLogin.alpha = 1
end
--[[function SignIn( event)
	composer.removeScene("src.Home")
	composer.gotoScene("src.Home")
end]]

--obtiene el valor del combobox
function getOptionComboCity( event )

	event.target:setFillColor( .6 )
	timeMarker = timer.performWithDelay( 100, function()
		event.target:setFillColor( 1 )
	
		labelComboOpcionCondo.id = event.target.id
		labelComboOpcionCondo.idUser = event.target.idUser
		labelComboOpcionCondo.text = event.target.name
		hideComboBoxCity()
	end, 1 )
	
	return true
end


--llena las optiones del combobox
function setOptionComboCity()

	local optionCombo = {}

	local lastY = 30
	
	for i = 1, #dataCombo, 1 do
		
		optionCombo[i] = display.newRect( svOptionCombo.contentWidth/2, lastY, 400, 80 )
		optionCombo[i]:setFillColor( 1 )
		optionCombo[i].strokeWidth = 2
		optionCombo[i]:setStrokeColor( 0 )
		optionCombo[i].name = dataCombo[i].nombre
		optionCombo[i].id = dataCombo[i].id
		optionCombo[i].idUser = dataCombo[i].idUser
		optionCombo[i].num = i
		svOptionCombo:insert(optionCombo[i])
		optionCombo[i]:addEventListener( 'tap', getOptionComboCity )
		
		local labelOpcion = display.newText( {
        text = dataCombo[i].nombre,     
        x = svOptionCombo.contentWidth/2, y = lastY, width = svOptionCombo.contentWidth - 40,
        font = fontDefault, fontSize = 28, align = "left"
		})
		labelOpcion:setFillColor( 0 )
		svOptionCombo:insert(labelOpcion)
		
		--optionCombo[i]:addEventListener( 'tap', hideComboBoxCity )
	
		lastY = lastY + 80
		
	end

	svOptionCombo:setScrollHeight(lastY - 40)
	
end

--inicializa el combobox
function showComboBoxCity( event )
	
	dataCombo = DBManager.getCondominiums()
	
	groupOptionCombo:toFront()
	
	--groupOptionCombo
	local bgOptionCombo = display.newRect( 0, h, intW, intH )
	bgOptionCombo.anchorX = 0
	bgOptionCombo.anchorY = 0
	bgOptionCombo:setFillColor( 0 )
	bgOptionCombo.alpha = .5
	groupOptionCombo:insert(bgOptionCombo)
	bgOptionCombo:addEventListener( 'tap', hideComboBoxCity )
	
	local heightScroll = 400
	if #dataCombo < 5 then
		heightScroll = 77 * #dataCombo
	end
	
	svOptionCombo = widget.newScrollView
	{
		x = intW/2,
		y = h + intH/2,
		width = 400,
		height = heightScroll,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = false,
		backgroundColor = { 1 }
	}
	groupOptionCombo:insert(svOptionCombo)
	--svOptionCombo:toFront()
	svOptionCombo:addEventListener( 'tap', noAction)
	
	setOptionComboCity()
	
end

--esconde el combobox de ciudad
function hideComboBoxCity( event )
	--txtSignEmail.x = intW/2 + 170
	--txtSignPassword.x = intW/2 + 170
	groupOptionCombo:removeSelf()
	groupOptionCombo = nil
	groupOptionCombo = display.newGroup()
	return true
end

--anula los atributos de tap y touch
function noAction( event )
	return true
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

function scene:create( event )

	screen = self.view
	
	screen:insert(loginScreen)
	
	groupSign = display.newGroup()
	screen:insert(groupSign)
	groupSign.x = 0
	
	groupSign2 = display.newGroup()
	screen:insert(groupSign2)
	groupSign2.x = 480
	
	if settings.idApp ~= 0 and settings.condominioId == 0 then
		groupSign.x = -480
		groupSign2.x = 0
	end
	
	local bgLogin = display.newImage( "img/bgk/fondo.png" )
	bgLogin.anchorX = 0
	bgLogin.anchorY = 0
	bgLogin.height = intH - h
	bgLogin.y = h
	loginScreen:insert(bgLogin)
	
	lastY = 60 + h
	
	local labelWelcomeLogin = display.newText( {   
        x = intW/2, y = lastY, 
        text = "¡BIENVENIDO!",  font = fontLatoBold, fontSize = 36
	})
	labelWelcomeLogin:setFillColor( 1 )
	groupSign:insert(labelWelcomeLogin)
	
	lastY = lastY + 90
	
	local labelWelcomeLogin = display.newText( {   
        x = intW/2, y = lastY, width = intW - 50,
        text = "Por favor introduce los datos proporcionados por tu administrador",  font = fontLatoLight, fontSize = 20, align = "center",
	})
	labelWelcomeLogin:setFillColor( 1 )
	groupSign:insert(labelWelcomeLogin)
	
	lastY = lastY + 75
	
	local bgFieldLogin = display.newRoundedRect( intW/2, lastY, intW - 80, 205, 10 )
	bgFieldLogin.anchorY = 0
	bgFieldLogin:setFillColor( 6/255, 58/255, 98/255 )
	bgFieldLogin.strokeWidth = 2
	bgFieldLogin:setStrokeColor( 54/255, 80/255, 131/255 )
	groupSign:insert(bgFieldLogin)
	
	--campo email
	
	lastY = lastY + 60 
	
	local bgTextFieldUser = display.newRoundedRect( intW/2, lastY, 340, 60, 5 )
	bgTextFieldUser:setFillColor( 1 )
	groupSign:insert(bgTextFieldUser)
	
	local imgTextFieldUser = display.newImage( "img/btn/icono-user.png" )
	imgTextFieldUser.y = lastY - 3
	imgTextFieldUser.x = 100
	groupSign:insert(imgTextFieldUser)
	
	txtSignEmail = native.newTextField( intW/2 + 10, lastY, 250, 60 )
    txtSignEmail.inputType = "email"
    txtSignEmail.hasBackground = false
	txtSignEmail.placeholder = "Email"
	txtSignEmail.name = "email"
	txtSignEmail:addEventListener( "userInput", onTxtFocusLogin )
	txtSignEmail:setReturnKey(  "next"  )
	txtSignEmail.size = 22
	groupSign:insert(txtSignEmail)
	
	-----campos password
	
	lastY = lastY + 85
	
	local bgTextFieldPassword = display.newRoundedRect( intW/2, lastY, 340, 60, 5 )
	bgTextFieldPassword:setFillColor( 1 )
	groupSign:insert(bgTextFieldPassword)
	
	local imgTextFieldPassword = display.newImage( "img/btn/icono-password.png" )
	imgTextFieldPassword.y = lastY
	imgTextFieldPassword.x = 100
	groupSign:insert(imgTextFieldPassword)
	
	txtSignPassword = native.newTextField( intW/2 + 10, lastY, 250, 60 )
    txtSignPassword.inputType = "password"
    txtSignPassword.hasBackground = false
	txtSignPassword.placeholder = "Password"
	txtSignPassword.name = "password"
	txtSignPassword:addEventListener( "userInput", onTxtFocusLogin )
	txtSignPassword:setReturnKey(  "go"  )
	txtSignPassword.isSecure = true
	txtSignPassword.size = 24
	groupSign:insert(txtSignPassword)
	
	-----botones---
	
	lastY = lastY + 120
	
	btnSignLogin = display.newRoundedRect( intW/2, lastY, 330, 60, 10 )
	btnSignLogin:setFillColor( 251/255, 1/255, 2/255 )
	btnSignLogin.strokeWidth = 2
	btnSignLogin:setStrokeColor( 186/255, 1/255, 1/255 )
	groupSign:insert(btnSignLogin)
	btnSignLogin:addEventListener( 'tap', SignIn)
	
	local txtSignLogin = display.newText( {   
        x = intW/2, y = lastY,
        text = "ENTRAR",  font = fontLatoRegular, fontSize = 30
	})
	txtSignLogin:setFillColor( 1 )
	groupSign:insert(txtSignLogin)
	
	------------------------------------------
	-- Muestra estos campos si detecta un usuario mas de una vez
	------------------------------------------
	--////////groupSign2///////////
	
	lastY = 150
	
	local textInfoLoginCondo = "Bienvenido " .. settings.name .. " " .. settings.apellido .. " antes de continuar, por favor selecciona el condominio con el que deseas accesar:"
	
	
	
	labelInfoLoginCondo = display.newText( {   
        x = intW/2, y = lastY, width = intW - 50,
        text = textInfoLoginCondo ,  font = fontLatoLight, fontSize = 20, align = "center",
	})
	labelInfoLoginCondo:setFillColor( 1 )
	groupSign2:insert(labelInfoLoginCondo)
	
	lastY = lastY + 75
	
	local bgFieldLogin = display.newRoundedRect( intW/2, lastY, intW - 80, 112, 10 )
	bgFieldLogin.anchorY = 0
	bgFieldLogin:setFillColor( 6/255, 58/255, 98/255 )
	bgFieldLogin.strokeWidth = 2
	bgFieldLogin:setStrokeColor( 54/255, 80/255, 131/255 )
	groupSign2:insert(bgFieldLogin)
	
	-- btn atras
	
	local imgArrowBack = display.newImage( "img/btn/seleccionOpcion-regresarTexto.png" )
	imgArrowBack.x = 30
	imgArrowBack.y = h + 40
	groupSign2:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnSingIn)
	
	local labelArrowBack = display.newText( {   
        x = 90, y = h + 40,
        text = "REGRESAR",  font = fontLatoBold, fontSize = 16
	})
	labelArrowBack:setFillColor( 1 )
	groupSign2:insert(labelArrowBack)
	labelArrowBack:addEventListener( 'tap', returnSingIn)
	
	
	lastY = lastY + 56
	
	--combobox condominio
	
	local bgComboCondo = display.newRoundedRect( intW/2, lastY, 340, 60, 5 )
	bgComboCondo:setFillColor( 1 )
	bgComboCondo.type = 2
	groupSign2:insert(bgComboCondo)
	bgComboCondo:addEventListener( 'tap', showComboBoxCity)
	
	local imgComboCondominio = display.newImage( "img/btn/registro-seleccionarCondo.png" )
	imgComboCondominio.y = lastY - 3
	imgComboCondominio.x = 100
	groupSign2:insert(imgComboCondominio)
	
	local imgArrowDownCondo = display.newImage( "img/btn/optionCondo.png" )
	imgArrowDownCondo.x = 385
	imgArrowDownCondo.y = lastY
	groupSign2:insert(imgArrowDownCondo)
	
	labelComboOpcionCondo = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2 + 15, y = lastY,
		width = 225,
        text = "Seleccionar condominio",  font = fontLatoRegular, fontSize = 18, align = "left"
	})
	labelComboOpcionCondo:setFillColor( 0 )
	labelComboOpcionCondo.id = 0
	labelComboOpcionCondo.idUser = 0
	groupSign2:insert(labelComboOpcionCondo)
	
	
	-----botones---
	
	lastY = lastY + 120
	
	btnContinueLogin = display.newRoundedRect( intW/2, lastY, 330, 60, 10 )
	btnContinueLogin:setFillColor( 251/255, 1/255, 2/255 )
	btnContinueLogin.strokeWidth = 2
	btnContinueLogin:setStrokeColor( 186/255, 1/255, 1/255 )
	groupSign2:insert(btnContinueLogin)
	btnContinueLogin:addEventListener( 'tap', ContinueLogin)
	
	local labelContinueLogin = display.newText( {   
        x = intW/2, y = lastY,
        text = "CONTINUAR",  font = fontLatoRegular, fontSize = 30
	})
	labelContinueLogin:setFillColor( 1 )
	groupSign2:insert(labelContinueLogin)
	
	--------------------------
	----label recuerdame
	
	lastY = intH - 50
	
	---label recordar contraseña
	local labelRemenberPassword = display.newText( {   
        x = intW/2, y = lastY,
        text = "Restrablecer contraseña",  font = fontLatoLight, fontSize = 26
	})
	labelRemenberPassword:setFillColor( 1 )
	loginScreen:insert(labelRemenberPassword)
	
	local lineRemenberPassword = display.newLine( 90, lastY + 15 , 390, lastY + 15 )
	lineRemenberPassword:setStrokeColor( 1 )
	lineRemenberPassword.strokeWidth = 2
	loginScreen:insert(lineRemenberPassword)

end

-- "scene:show()"
function scene:show( event )

end

-- "scene:hide()"
function scene:hide( event )

   local phase = event.phase

   if ( phase == "will" ) then
		if txtSignEmail then
			txtSignEmail:removeSelf()
			txtSignPassword:removeSelf()
			txtSignEmail = nil
			txtSignPassword = nil
		end
	end
   --[[elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end]]
end

-- "scene:destroy()"
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene