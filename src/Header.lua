
---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
local Globals = require('src.resources.Globals')
local composer = require( "composer" )

Header = {}

local grpLoading

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
        end
	
	end
	
	function showVisit( event )
		
		if composer.getSceneName( "current" ) ~= "src.NotiVisit" then
            composer.removeScene("src.NotiVisit")
			composer.gotoScene( "src.NotiVisit", { time = 400, effect = "slideLeft" })
        end
		
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
			
			composer.gotoScene( previousScene, { time = 400, effect = "slideRight" })
			
		else
			Globals.scene = nil
			Globals.scene = {}
			storyboard.gotoScene( "src.Home", { time = 400, effect = "slideRight" })
        end
		
    end
	
    -- Creamos la el toolbar
    function self:buildToolbar(homeScreen)
         
        -- Incluye botones que de se ocultaran en la bus
        
        local toolbar = display.newRect( 0, 0, display.contentWidth, 80 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( .1 )
        self:insert(toolbar)
		
		local iconTool1 = display.newImage( "img/btn/iconMenu.png" )
        iconTool1:translate( 0, 40 )
		iconTool1.width = 50
		iconTool1.height = 50
		--iconTool1:addEventListener("tap",showMenuLeft)
        self:insert(iconTool1)
		
		local iconTool2 = display.newImage( "img/btn/iconNewspaper.png" )
        iconTool2:translate( 340, 40 )
		iconTool2.width = 45
		iconTool2.height = 45
		iconTool2:addEventListener( "tap",showMessage )
        self:insert(iconTool2)
		
		local iconTool3 = display.newImage( "img/btn/iconBell.png" )
        iconTool3:translate( 430, 40 )
		iconTool3.width = 45
		iconTool3.height = 45
		iconTool3:addEventListener("tap",showVisit)
        self:insert(iconTool3)
        
    end
    
    -- Creamos la pantalla del menu
    function self:buildNavBar(texto)
        
		local hWB = 20
        
        local menu = display.newRect( 0, 60 + hWB, display.contentWidth, 50 )
        menu.anchorX = 0
        menu.anchorY = 0
        menu:setFillColor( 1 )
        self:insert(menu)
        
       txtTitle = display.newText( {
            x = (display.contentWidth/2), y = 85 + hWB,
			width = 400, align = "center",
            font = "Lato-Hairline", fontSize = 22, text = texto
        })
        txtTitle:setFillColor( 0 )
        self:insert(txtTitle)

        local imgBtnBack = display.newImage( "img/btn/iconReturn.png" )
        imgBtnBack.anchorX = 0
        imgBtnBack.x= 25
        imgBtnBack.y = 85 + hWB
        imgBtnBack:addEventListener( "tap", returnScene )
        self:insert( imgBtnBack )
        
        local txtReturn = display.newText( {
            x = 90, y = 85 + hWB,
			width = 100, align = "center",
            font = "Lato-Bold", fontSize = 14, text = "Regresar"
        })
        txtReturn:setFillColor( 0 )
        self:insert(txtReturn)
		
		--[[local imgBtnHome = display.newImage( "img/btn/btnMenuHome.png" )
        imgBtnHome.x= 440
        imgBtnHome.y = 85 + hWB
		imgBtnHome:setFillColor( .5 )
        imgBtnHome:addEventListener( "tap", returnHome )
        self:insert( imgBtnHome )
        
        local bgGrad = display.newRect( 0, 105 + hWB, display.contentWidth, 5 )
        bgGrad.anchorX = 0
        bgGrad.anchorY = 0
        bgGrad:setFillColor( {
            type = 'gradient',
            color1 = { 1 }, 
            color2 = { .7 },
            direction = "bottom"
        } ) 
        self:insert(bgGrad)]]
        
    end
	
    return self
end