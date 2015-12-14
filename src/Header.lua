
---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
require('src.Menu')
local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

Header = {}

local grpLoading

local groupNoBubbleA, groupNoBubbleV
local txtNoBubbleA
local txtNoBubbleV
local totalBubbleA, totalBubbleV
local menuScreenLeft = nil

local btnBackFunction = false

local menuActive = false

function Header:new()
    -- Variables
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight
	
	local self = display.newGroup()
	
	function showMessage( event )
	
		if composer.getSceneName( "current" ) ~= "src.NotiMessage" then
            composer.removeScene("src.NotiMessage")
			composer.gotoScene( "src.NotiMessage", { time = 400, effect = "slideLeft" })
			moveNoBubbleLeft()
        end
	
	end
	
	function showVisit( event )
		
		if composer.getSceneName( "current" ) ~= "src.NotiVisit" then
            composer.removeScene("src.NotiVisit")
			composer.gotoScene( "src.NotiVisit", { time = 400, effect = "slideLeft" })
			moveNoBubbleLeft()
        end
		
	end
	
	--mostramos el menu izquierdo
	function showMenuLeft( event )
		
		if groupNoBubbleA then groupNoBubbleA.x = 500 end
		if groupNoBubbleV then groupNoBubbleV.x = 500 end
		local screen = getScreen()
		screen.alpha = .5
		transition.to( screen, { x = 350, time = 400, transition = easing.outExpo } )
		transition.to( menuScreenLeft, { x = 0, time = 400, transition = easing.outExpo } )
		screen = nil
		menuActive = true
		return true
	end
	
	--esconde el menuIzquierdo
	function hideMenuLeft( event )
		--modalActive = ""
		
		local screen = getScreen()
		screen.alpha = 1
		transition.to( menuScreenLeft, { x = -480, time = 400, transition = easing.outExpo } )
		transition.to( screen, { x = 0, time = 400, transition = easing.outExpo } )
		if groupNoBubbleA then 
			transition.to( groupNoBubbleA, { x = 0, time = 400, transition = easing.outExpo } )
		end
		if groupNoBubbleV then 
			transition.to( groupNoBubbleV, { x = 0, time = 400, transition = easing.outExpo } )
		end
		screen = nil
		menuActive = false
		return true
	end
	
	--obtenemos el grupo de cada escena
	function getScreen()
		local currentScene = composer.getSceneName( "current" )
		if currentScene == "src.Home" then
			return getScreenH()
		elseif currentScene == "src.NotiMessage" then
			return getScreenMA()
		elseif currentScene == "src.NotiVisit" then
			return getScreenMV()
		elseif currentScene == "src.Message" then
			return getScreenA()
		elseif currentScene == "src.Visit" then
			return getScreenV()
		end
		
	end
	
	function moveNoBubbleLeft()
		if groupNoBubbleA then 
			transition.to( groupNoBubbleA, { x = -480, time = 400, transition = easing.outExpo, onComplete=function()
					if groupNoBubbleA then
						groupNoBubbleA.x = 0
					end
				end
			})
		end
		if groupNoBubbleV then 
			transition.to( groupNoBubbleV, { x = -480, time = 400, transition = easing.outExpo, onComplete=function()
					if groupNoBubbleV then
						groupNoBubbleV.x = 0
					end
				end
			})
		end
	end
	
	function moveNoBubbleRight()
		if groupNoBubbleA then
			transition.to( groupNoBubbleA, { x = 500, time = 400, transition = easing.outExpo, onComplete=function()
					groupNoBubbleA.x = 0
				end
			})
		end
		
		if groupNoBubbleV then
			transition.to( groupNoBubbleV, { x = 500, time = 400, transition = easing.outExpo, onComplete=function()
					groupNoBubbleV.x = 0
				end
			})
		end
	end
	
	--crea las borbujas de mensajes no leidos
	function createNotBubble(totalA, totalV)
		
		totalBubbleA = totalA
		totalBubbleV = totalV
		
		if totalBubbleA > 0 then
		
			if not groupNoBubbleA then
			
				groupNoBubbleA = display.newGroup()
				groupNoBubbleA.y = h
			
				notBubble = display.newCircle( 360, 20, 10 )
				notBubble:setFillColor(.1,.5,.1)
				notBubble.strokeWidth = 2
				notBubble:setStrokeColor(.8)
				groupNoBubbleA:insert(notBubble)
				
				if txtNoBubbleA then txtNoBubbleA:removeSelf() txtNoBubbleA = nil end
			
				txtNoBubbleA = display.newText( {
					x = 361, y = 20,
					text = totalBubbleA, font = "Lato-Regular", fontSize = 12,
				})
				txtNoBubbleA:setFillColor( 1 )
				groupNoBubbleA:insert(txtNoBubbleA)
			
			else
				txtNoBubbleA.text = totalBubbleA
			end
		else
		
			if groupNoBubbleA then
				groupNoBubbleA:removeSelf()
				groupNoBubbleA = nil
			end
			
			
		
		end
		
		if totalBubbleV > 0 then
		
			if not groupNoBubbleV then
			
				groupNoBubbleV = display.newGroup()
				groupNoBubbleV.y = h
				--groupNoBubbleV.x = 300
				--groupNoBubble:insert(getScreen())
			
				notBubble = display.newCircle( 440, 17, 10 )
				notBubble:setFillColor(.1,.5,.1)
				notBubble.strokeWidth = 2
				notBubble:setStrokeColor(.8)
				groupNoBubbleV:insert(notBubble)
				
				if txtNoBubbleV then txtNoBubbleV:removeSelf() txtNoBubbleV = nil end
				
				txtNoBubbleV = display.newText( {
					x = 441, y = 17,
					text = totalBubbleV, font = "Lato-Regular", fontSize = 12,
				})
				txtNoBubbleV:setFillColor( 1 )
				--txtNoBubble:toFront()
				groupNoBubbleV:insert(txtNoBubbleV)
			
			else
				--txtNoBubbleV.text = totalBubbleV
			end
		else
		
			--[[txtNoBubbleV = display.newText( {
				x = 441, y = 17,
				text = "", font = "Lato-Regular", fontSize = 12,
			})
			txtNoBubbleV:setFillColor( 1 )]]
		
			if groupNoBubbleV then
				groupNoBubbleV:removeSelf()
				groupNoBubbleV = nil
			end
		
		end
		
	end
	
	--cierra la session del usuario
	function SignOut( event )
		
		RestManager.deletePlayerIdOfUSer()
		
		return true
		
	end
	
	function SignOut2( )
		
		hideMenuLeft()
		DBManager.clearUser()
		Globals.scene = nil
		Globals.scene = {}
		createNotBubble(0,0)
		composer.removeScene("src.Login")
		composer.gotoScene( "src.Login", { time = 400, effect = "slideLeft" })
		
		return true
		
	end
	
	---regresamos a la scena anterior
	function returnScene( event )
	
        -- Obtenemos escena anterior y eliminamos del arreglo
        if #Globals.scene > 2 then
			
            local previousScene = Globals.scene[#Globals.scene - 1]
			local currentScene = Globals.scene[#Globals.scene]
			
			if previousScene == currentScene then
				while previousScene == currentScene do
					previousScene = Globals.scene[#Globals.scene - 1]
					table.remove(Globals.scene, #Globals.scene)
				end
				
			else
				table.remove(Globals.scene, #Globals.scene)
				table.remove(Globals.scene, #Globals.scene)
			end
			
			moveNoBubbleRight()
			composer.gotoScene( previousScene, { time = 400, effect = "slideRight" })
			
		else
			moveNoBubbleRight()
			Globals.scene = nil
			Globals.scene = {}
			composer.gotoScene( "src.Home", { time = 400, effect = "slideRight" })
        end
		
    end
	
	function returnHome( event )
		moveNoBubbleRight()
		Globals.scene = nil
		Globals.scene = {}
		composer.gotoScene( "src.Home", { time = 400, effect = "slideRight" })
		
	end
	
    -- Creamos la el toolbar
    function self:buildToolbar(homeScreen)
         
        -- Incluye botones que de se ocultaran en la bus
		
		local paint = {
			type = "gradient",
			color1 = { 10/255, 49/255, 82/255 },
			color2 = { 4/255, 35/255, 63/255},
			direction = "down"
		}
        
        local toolbar = display.newRect( 0, 0, display.contentWidth, 63 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( 1 )
		toolbar.fill = paint
        self:insert(toolbar)
		
		local lineToolbar = display.newRect( 0, 63, display.contentWidth, 2 )
        lineToolbar.anchorX = 0
        lineToolbar.anchorY = 0
        lineToolbar:setFillColor( 246/255, 219/255, 0 )
        self:insert(lineToolbar)
		
		local iconTool1 = display.newImage( "img/btn/menu.png" )
        iconTool1:translate( 40, 30 )
		iconTool1:addEventListener("tap",showMenuLeft)
        self:insert(iconTool1)
		
		local iconTool2, iconTool3
		
		if composer.getSceneName( "current" ) == 'src.NotiMessage' or composer.getSceneName( "current" ) == 'src.Message' then
			iconTool2 = display.newImage( "img/btn/mensajes-selec.png" )
		else
			iconTool2 = display.newImage( "img/btn/mensajes-des.png" )
		end
        iconTool2:translate( 340, 35 )
		iconTool2:addEventListener( "tap",showMessage )
        self:insert(iconTool2)
		
		if composer.getSceneName( "current" ) == 'src.NotiVisit' or composer.getSceneName( "current" ) == 'src.Visit' then
			iconTool3 = display.newImage( "img/btn/alertas-selec.png" )
		else
			iconTool3 = display.newImage( "img/btn/alertas-des.png" )
		end
        iconTool3:translate( 430, 35 )
		iconTool3:addEventListener("tap",showVisit)
        self:insert(iconTool3)
		
		local lineIconTool2 = display.newLine( 299, 0, 299, 63 )
		lineIconTool2:setStrokeColor( 0 )
		lineIconTool2.strokeWidth = 1
		self:insert(lineIconTool2)
		
		local lineIconTool3 = display.newLine( 391, 0, 391, 63 )
		lineIconTool3:setStrokeColor( 0 )
		lineIconTool3.strokeWidth = 1
		self:insert(lineIconTool3)
		
		--creamos la pantalla del menu
		if menuScreenLeft == nil then
			menuScreenLeft = MenuLeft:new()
			menuScreenLeft:builScreenLeft()
		end
		
		RestManager.getMessageUnRead()
        
    end
    
    -- Creamos la pantalla del menu
    function self:buildNavBar(texto)
        
		local hWB = 20
        
        local menu = display.newRect( 0, 45 + hWB, display.contentWidth, 49 )
        menu.anchorX = 0
        menu.anchorY = 0
        menu:setFillColor( 1 )
        self:insert(menu)
		
		local lineMenu = display.newRect( 0, 45 + hWB + 48, display.contentWidth, 1 )
        lineMenu.anchorX = 0
        lineMenu.anchorY = 0
        lineMenu:setFillColor( 236/255, 236/255, 236/255 )
        self:insert(lineMenu)
        
       txtTitle = display.newText( {
            x = (display.contentWidth/2), y = 67 + hWB,
			width = 400, align = "center",
            font = "Lato-Light", fontSize = 22, text = texto
        })
        txtTitle:setFillColor( 0 )
        self:insert(txtTitle)

        local imgBtnBack = display.newImage( "img/btn/regresar.png" )
        imgBtnBack.anchorX = 0
        imgBtnBack.x= 10
        imgBtnBack.y = 68 + hWB
        imgBtnBack:addEventListener( "tap", returnScene )
        self:insert( imgBtnBack )
        
		--[[local txtReturn = display.newText( {
            x = 90, y = 67 + hWB,
			width = 100, align = "center",
            font = "Lato-Bold", fontSize = 14, text = "Regresar"
        })
        txtReturn:setFillColor( 0 )
        self:insert(txtReturn)]]
		
		local imgBtnHome = display.newImage( "img/btn/home.png" )
        imgBtnHome.x= 440
        imgBtnHome.y = 69 + hWB
		imgBtnHome:addEventListener( "tap", returnHome )
        self:insert( imgBtnHome )
        
    end
	
    return self
end

-- Return button Android Devices
local function onKeyEventBack( event )
	local phase = event.phase
	local keyName = event.keyName
	local platformName = system.getInfo( "platformName" )
	
	if( "back" == keyName and phase == "up" ) then
		if ( platformName == "Android" ) then
			
			local currentScene = composer.getSceneName( "current" )
			
			if menuActive == true then
				hideMenuLeft( 0 )
			elseif currentScene ~= "src.Home" then
				returnScene()
			else
				native.requestExit()
			end
			return true
		end
	end
	return false
end

if btnBackFunction == false then
	btnBackFunction = true
	Runtime:addEventListener( "key", onKeyEventBack )
end

----------------------------------------------
-------------Funciones------------------------
----------------------------------------------
