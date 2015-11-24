local Globals = require('src.resources.Globals')

MenuLeft = {}

function MenuLeft:new()
	
    local DBManager = require('src.resources.DBManager')
	local RestManager = require('src.resources.RestManager')
	
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight
	--[[local rectCancun, rectPlaya
	local lineLeft = {}]]

	local selfL = display.newGroup()
   --[[ local grpCity = display.newGroup()
	local grpLanguage = display.newGroup()
	
	local rectCity = {}
	
	local rectLanguage = {}]]
	
	selfL.x = -480
	
	function selfL:builScreenLeft()
		
		local bgMenuLeft = display.newRect( 0, h, intW, intH )
		bgMenuLeft.anchorX = 0
        bgMenuLeft.anchorY = 0
		bgMenuLeft:setFillColor( 0 )
		bgMenuLeft.alpha = .5
		bgMenuLeft:addEventListener("tap",hideMenuLeft)
		bgMenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(bgMenuLeft)
		
		local paintMenu = {
			type = "gradient",
			color1 = { 243/255 },
			color2 = { 230/255 },
			direction = "right"
		}
		
		local MenuLeft = display.newRect( 0, 0 + h, 350, intH )
		MenuLeft.anchorX = 0
        MenuLeft.anchorY = 0
		MenuLeft:setFillColor( .1 )
		MenuLeft.alpha = 1
		MenuLeft.fill = paintMenu
		MenuLeft:addEventListener("tap",blockMenu)
		MenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeft)
        
        local imgLogo = display.newImage( "img/btn/logoSmall.png" )
        imgLogo.x = 165
        imgLogo.y = h + 90
        selfL:insert(imgLogo)
        
        -- Border Right
        local borderRight = display.newRect( 320, 0 + h, 60, intH )
        borderRight.anchorY = 0
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { 160/255, .3 }, 
            color2 = { 160/255, 0 },
            direction = "left"
        } ) 
        borderRight:setFillColor( 0, 0, 0 ) 
        selfL:insert(borderRight)
		
		builScreenLeftItems()
		
	end
	
	function builScreenLeftItems()
	
		local paintMenu = {
			type = "gradient",
			color1 = { 5/255, 27/255, 64/255 },
			color2 = { 7/255, 18/255, 48/255},
			direction = "right"
		}
		
		local bgSignOut = display.newRect( 0, intH-90 + h, 350, 90 )
		bgSignOut.anchorX = 0
        bgSignOut.anchorY = 0
		bgSignOut:setFillColor( 230/255 )
		bgSignOut.alpha = .01
		bgSignOut:addEventListener("tap", SignOut)
		selfL:insert(bgSignOut)
	
		local lineMenu1 = display.newRect( 0, intH - 89, 350, 2 )
        lineMenu1.anchorX = 0
        lineMenu1.anchorY = 0
        lineMenu1:setFillColor( 0, 148/255, 49/255 )
        selfL:insert(lineMenu1)
		
		local imgBtnSignOut = display.newImage( "img/btn/exit.png" )
		imgBtnSignOut.anchorX = 0
		imgBtnSignOut.anchorY = 0
        imgBtnSignOut.x= 20
        imgBtnSignOut.y = intH - 65
        selfL:insert( imgBtnSignOut )
		
		txtTitleSignOut = display.newText( {
			text = "Salir",
            x = 130, y = intH - 40,
			width = 400, align = "center",
            font = "Lato-Regular", fontSize = 32, 
        })
        txtTitleSignOut:setFillColor( 0, 30/255, 120/255 )
        selfL:insert(txtTitleSignOut)
		
	end
	
	function blockMenu( event )
		return true
	end
	
	return selfL
	
end



