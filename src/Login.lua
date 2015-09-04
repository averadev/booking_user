-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

--variables
local loginScreen = display.newGroup()
local groupOptionCombo = display.newGroup()
local groupSign, groupSign2

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
--texto
local labelComboOpcionCity
--native textField
local txtSignEmail, txtSignPassword, txtSignNumCondo
--scroll
local svOptionCombo

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--funcion de logeo
function NextFieldLogin( event )
	transition.to( groupSign, { x = -480, time = 400, transition = easing.outExpo } )
	transition.to( groupSign2, { x = 0, time = 400, transition = easing.outExpo } )
	return true
end

function returnSingIn( event )
	transition.to( groupSign2, { x = 480, time = 400, transition = easing.outExpo } )
	transition.to( groupSign, { x = 0, time = 400, transition = easing.outExpo } )
	return true
end 

function SignIn( event)
	composer.removeScene("src.Home")
	composer.gotoScene("src.Home")
end

--obtiene el valor del combobox
function getOptionComboCity( event )

	if event.target.type == 1 then
		labelComboOpcionCity.id = event.target.id
		labelComboOpcionCity.text = event.target.name
	else
		labelComboOpcionCondo.id = event.target.id
		labelComboOpcionCondo.text = event.target.name
	end

	
	
	hideComboBoxCity()
	return true
end


--llena las optiones del combobox
function setOptionComboCity(typeCombo)

	local dataCombo
	if typeCombo == 1 then
		dataCombo = {'Cancun', 'Merida', 'Chetumal', 'Villahermosa', 'tuxtla', 'Narnia'}
	else
		dataCombo = {'Nayandei', 'Tortuga', 'Caracol'}
	end
	--local city = {'Cancun', 'Merida', 'Chetumal', 'Villahermosa', 'tuxtla', 'Narnia'}
	--local Condo = {'Nayandei', 'Tortuga', 'Caracol'}
	local optionCombo = {}

	local lastY = 30
	
	for i = 1, #dataCombo, 1 do
		
		optionCombo[i] = display.newRect( svOptionCombo.contentWidth/2, lastY, intW/2, 80 )
		optionCombo[i]:setFillColor( 1 )
		optionCombo[i].name = dataCombo[i]
		optionCombo[i].type = typeCombo
		optionCombo[i].id = i
		svOptionCombo:insert(optionCombo[i])
		optionCombo[i]:addEventListener( 'tap', getOptionComboCity )
		
		local labelOpcion = display.newText( {
        text = dataCombo[i],     
        x = svOptionCombo.contentWidth/2, y = lastY + 10, width = svOptionCombo.contentWidth - 40,
        font = fontDefault, fontSize = 28, align = "left"
		})
		labelOpcion:setFillColor( 0 )
		svOptionCombo:insert(labelOpcion)
		
		--optionCombo[i]:addEventListener( 'tap', hideComboBoxCity )
	
		lastY = lastY + 80
		
	end
	
	local lastY2 = 80
	
	for i = 1, #dataCombo, 1 do
	
		if i ~= #dataCombo then
		
			local lineOptioCombo = display.newLine( 0, lastY2, svOptionCombo.contentWidth, lastY2 )
			lineOptioCombo:setStrokeColor( 0 )
			lineOptioCombo.strokeWidth = 2
			svOptionCombo:insert(lineOptioCombo)
		
			lastY2 = lastY2 + 80
		
		end
		
	end	

end

--inicializa el combobox
function showComboBoxCity( event )

	--txtSignEmail.x = - intW
	--txtSignPassword.x = - intW
	txtSignNumCondo.x = - intW
	

	groupOptionCombo:toFront()
	
	--groupOptionCombo
	local bgOptionCombo = display.newRect( 0, h, intW, intH )
	bgOptionCombo.anchorX = 0
	bgOptionCombo.anchorY = 0
	bgOptionCombo:setFillColor( 0 )
	bgOptionCombo.alpha = .5
	groupOptionCombo:insert(bgOptionCombo)
	bgOptionCombo:addEventListener( 'tap', hideComboBoxCity )
	
	svOptionCombo = widget.newScrollView
	{
		x = intW/2,
		y = h + intH/2,
		width = 400,
		height = 400,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = true,
		backgroundColor = { 1 }
	}
	groupOptionCombo:insert(svOptionCombo)
	--svOptionCombo:toFront()
	svOptionCombo:addEventListener( 'tap', noAction)
	
	setOptionComboCity(event.target.type)
	

	
end

--esconde el combobox de ciudad
function hideComboBoxCity( event )
	--txtSignEmail.x = intW/2 + 170
	--txtSignPassword.x = intW/2 + 170
	txtSignNumCondo.x = intW/2
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
	
	groupSign2 = display.newGroup()
	screen:insert(groupSign2)
	groupSign2.x = 480
	
	local bgLogin = display.newRect( 0, h, intW, intH )
	bgLogin.anchorX = 0
	bgLogin.anchorY = 0
	bgLogin:setFillColor( 214/255, 226/255, 225/255 )
	loginScreen:insert(bgLogin)
	
	local imgLogo = display.newRect( intW/2, intH/2/3 + h, 150, 150 )
	imgLogo:setFillColor( 0 )
	loginScreen:insert(imgLogo)
	
	--campo email
	
	local lastY = intH/2.3
	
	local bgTextFieldUser = display.newRect( intW/2, lastY, 300, 50 )
	bgTextFieldUser:setFillColor( 1 )
	groupSign:insert(bgTextFieldUser)
	
	txtSignEmail = native.newTextField( intW/2, lastY, 300, 50 )
    txtSignEmail.inputType = "email"
    txtSignEmail.hasBackground = false
	txtSignEmail.placeholder = "Email"
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	txtSignEmail:setReturnKey(  "next"  )
	txtSignEmail.size = 22
	groupSign:insert(txtSignEmail)
	
	-----campos password
	
	lastY = intH/1.9
	
	local bgTextFieldPassword = display.newRect( intW/2, lastY, 300, 50 )
	bgTextFieldPassword:setFillColor( 1 )
	groupSign:insert(bgTextFieldPassword)
	
	txtSignPassword = native.newTextField( intW/2, lastY, 300, 50 )
    txtSignPassword.inputType = "password"
    txtSignPassword.hasBackground = false
	txtSignPassword.placeholder = "Password"
   -- txtSignPassword:addEventListener( "userInput", onTxtFocus )
	txtSignPassword:setReturnKey(  "go"  )
	txtSignPassword.isSecure = true
	txtSignPassword.size = 24
	groupSign:insert(txtSignPassword)
	
	-----botones---
	
	lastY = intH/1.55
	
	local btnContinueLogin = display.newRoundedRect( intW/2, lastY, 250, 60, 10 )
	btnContinueLogin:setFillColor( 0, 0, 1 )
	groupSign:insert(btnContinueLogin)
	btnContinueLogin:addEventListener( 'tap', NextFieldLogin)
	
	local ContinueLogin = display.newText( {   
        x = intW/2, y = lastY,
        text = "Continuar",  font = fontDefault, fontSize = 30
	})
	ContinueLogin:setFillColor( 1 )
	groupSign:insert(ContinueLogin)
	
	--combobox ciudad
	--btnSignLogin
	--////////groupSign2///////////
	
	local imgBackSingIn= display.newImage( "img/btn/arrowBack.png" )
	imgBackSingIn.x =  40
	imgBackSingIn.y = 30 + h
	imgBackSingIn.height = 60
	imgBackSingIn.width = 60
	groupSign2:insert(imgBackSingIn)
	imgBackSingIn:addEventListener( 'tap', returnSingIn )
	
	lastY = intH/2.3
	
	local bgComboCity = display.newRect( intW/2, lastY, 300, 50 )
	bgComboCity:setFillColor( 1 )
	bgComboCity.type = 1
	groupSign2:insert(bgComboCity)
	bgComboCity:setStrokeColor( 0 )
	bgComboCity.strokeWidth = 2
	bgComboCity:addEventListener( 'tap', showComboBoxCity)
	
	local lineLeftComboCity = display.newRect( intW/2 + 105, lastY, 2, 50 )
	lineLeftComboCity:setFillColor( 0 )
	groupSign2:insert(lineLeftComboCity)
	
	local imgArrowDownCombo = display.newImage( "img/btn/arrowDownCombo.png" )
	imgArrowDownCombo.x = intW/2 + 127
	imgArrowDownCombo.y = lastY + 1
	imgArrowDownCombo.height = 50
	imgArrowDownCombo.width = 50
	groupSign2:insert(imgArrowDownCombo)
	
	labelComboOpcionCity = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2 - 20, y = lastY,
		width = 200,
        text = "Seleccionar ciudad",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelComboOpcionCity:setFillColor( 0 )
	labelComboOpcionCity.id = 0
	groupSign2:insert(labelComboOpcionCity)
	
	lastY = intH/1.9
	
	--combobox condominio
	
	local bgComboCondo = display.newRect( intW/2, lastY, 300, 50 )
	bgComboCondo:setFillColor( 1 )
	bgComboCondo.type = 2
	groupSign2:insert(bgComboCondo)
	bgComboCondo:setStrokeColor( 0 )
	bgComboCondo.strokeWidth = 2
	bgComboCondo:addEventListener( 'tap', showComboBoxCity)
	
	local lineLeftComboCondo = display.newRect( intW/2 + 105, lastY, 2, 50 )
	lineLeftComboCondo:setFillColor( 0 )
	groupSign2:insert(lineLeftComboCondo)
	
	local imgArrowDownCondo = display.newImage( "img/btn/arrowDownCombo.png" )
	imgArrowDownCondo.x = intW/2 + 127
	imgArrowDownCondo.y = lastY + 1
	imgArrowDownCondo.height = 50
	imgArrowDownCondo.width = 50
	groupSign2:insert(imgArrowDownCondo)
	
	labelComboOpcionCondo = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2 - 20, y = lastY,
		width = 225, height = 25,
        text = "Seleccionar condominio",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelComboOpcionCondo:setFillColor( 0 )
	labelComboOpcionCondo.id = 0
	groupSign2:insert(labelComboOpcionCondo)
	
	------num condominio
	
	lastY = intH/1.6
	
	local bgTextFieldNumCondo = display.newRect( intW/2, lastY, 300, 50 )
	bgTextFieldNumCondo:setFillColor( 1 )
	groupSign2:insert(bgTextFieldNumCondo)
	
	txtSignNumCondo= native.newTextField( intW/2, lastY, 300, 50 )
    txtSignNumCondo.inputType = "number"
	txtSignNumCondo.placeholder = "Num. condominio"
    txtSignNumCondo.hasBackground = false
   -- txtSignPassword:addEventListener( "userInput", onTxtFocus )
	txtSignPassword:setReturnKey(  "go"  )
	txtSignNumCondo.size = 24
	groupSign2:insert(txtSignNumCondo)
	
	-----botones---
	
	lastY = intH/1.35
	
	local btnSignLogin = display.newRoundedRect( intW/2, lastY, 250, 60, 10 )
	btnSignLogin:setFillColor( 0, 0, 1 )
	groupSign2:insert(btnSignLogin)
	btnSignLogin:addEventListener( 'tap', SignIn)
	
	local labelSignLogin = display.newText( {   
        x = intW/2, y = lastY,
        text = "Entrar",  font = fontDefault, fontSize = 30
	})
	labelSignLogin:setFillColor( 1 )
	groupSign2:insert(labelSignLogin)
	
	--------------------------
	----label recuerdame
	
	lastY = intH - 50
	
	---label recordar contraseña
	local labelRemenberPassword = display.newText( {   
        x = intW/2, y = lastY,
        text = "Restrablecer contraseña",  font = fontDefault, fontSize = 26
	})
	labelRemenberPassword:setFillColor( 0 )
	loginScreen:insert(labelRemenberPassword)
	
	local lineRemenberPassword = display.newLine( 90, lastY + 15 , 390, lastY + 15 )
	lineRemenberPassword:setStrokeColor( 0 )
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
			txtSignNumCondo:removeSelf()
			txtSignEmail = nil
			txtSignPassword = nil
			txtSignNumCondo = nil
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