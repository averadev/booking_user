
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

---------------------------------------------------------------------------------
-- MESSAGE
---------------------------------------------------------------------------------
Message = {}
local assigned = 0
local contDeleteAdmin = 0
function Message:new()
    -- Variables
    local self = display.newGroup()
	local btnCheckInA
	function AssignedCoupon(item)
		assigned = item
	end
    
    function showMessage(event)
        local composer = require( "composer" )
        --Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		--hideSearch2()
		--deleteTxt()
		
        local current = composer.getSceneName( "current" )
		if current ~= "src.Message" then
            composer.removeScene( "src.Message" )
			composer.gotoScene( "src.Message", {
                time = 400,
                effect = "crossFade",
                params = { id = event.target.item.id }
            })
		end
    end
	
	function checkBoxDeleteA( event )
	
		local active
		if event.target.check == 0 then
			btnCheckInA.alpha = 1
			event.target.check = 1
			contDeleteAdmin = contDeleteAdmin + 1
			active = true
		else
			btnCheckInA.alpha = 0
			event.target.check = 0
			contDeleteAdmin = contDeleteAdmin - 1
			active = false
		end
		
		if contDeleteAdmin > 0 then
			showBtnDeleteAdmin(true, active, event.target.id, event.target.posc)
		else
			showBtnDeleteAdmin(false,active, event.target.id, event.target.posc)
		end
		
		return true
	end
    
    -- Creamos la pantalla del menu
    --function self:build(isBg, item, image)
	function self:build(item)
        -- Generamos contenedor
        local container = display.newContainer( 480, 110 )
        container.x = 240
        container.y = 60
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showMessage )

        local maxShape = display.newRect( 0, 0, 460, 100 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 96 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )
		
		 local txtFecha = display.newText( {
			text = item.dia .. ", " .. item.fechaFormat,
            x = -15, y = -35,
            width = 450,
            font = fontLatoRegular, fontSize = 12, align = "right",
        })
        txtFecha:setFillColor( 0 )
        container:insert(txtFecha)

        -- Agregamos textos
        local txtPartner0 = display.newText( {
            text = "DE: ",     
            x = 95, y = -17,
            width = 340,
            font = fontLatoBold, fontSize = 16, align = "left"
        })
        txtPartner0:setFillColor( 0 )
        container:insert(txtPartner0)
	
        local txtPartner = display.newText( {
            --text = item.partner,
			text = item.nombreAdmin .. " " .. item.apellidosAdmin,
            x = 105, y = -17,
            width = 300,
            font = fontLatoBold, fontSize = 16, align = "left"
        })
        txtPartner:setFillColor( 0 )
        container:insert(txtPartner)
        
        local txtTitle0 = display.newText( {
			text = "Asunto: ",
            x = 95, y = 7,
            width = 340, height = 0,
            font = fontLatoBold, fontSize = 15, align = "left"
        })
        txtTitle0:setFillColor( 0 )
        container:insert(txtTitle0)

        local txtInfo = display.newText( {
            text = item.asunto:sub(1,30).."...",
            x = 85, y = 30, width = 320,
            font = fontLatoLight, fontSize = 14, align = "left"
        })
        txtInfo:setFillColor( .3 )
        container:insert(txtInfo)
        
        local btnForward = display.newImage( "img/btn/btnForward.png" )
        btnForward:translate( 200, 18)
        container:insert( btnForward )
		
		local bgCheckA = display.newRect( -190, 0, 50, 50 )
        bgCheckA:setFillColor( 1 )
		bgCheckA.check = 0
		bgCheckA.id = item.idXref
		bgCheckA.posc = item.posc
        container:insert( bgCheckA )
		bgCheckA:addEventListener( 'tap', checkBoxDeleteA )
		
		local btnCheckOutA = display.newImage( "img/btn/select0.png" )
        btnCheckOutA:translate( -191, 0)
        container:insert( btnCheckOutA )
		
		btnCheckInA = display.newImage( "img/btn/select1.png" )
        btnCheckInA:translate( -188, -2)
		btnCheckInA.alpha = 0
        container:insert( btnCheckInA )
        
    end

    return self
end

Visit = {}
local assigned = 0
local contDeleteVisit = 0
function Visit:new()
    -- Variables
    local self = display.newGroup()
	local btnCheckIn
	
	function AssignedCoupon(item)
		assigned = item
	end
    
    function showVisit(event)
        local composer = require( "composer" )
        --Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		--hideSearch2()
		--deleteTxt()
		
        local current = composer.getSceneName( "current" )
		if current ~= "src.Visit" then
            composer.removeScene( "src.Visit" )
			composer.gotoScene( "src.Visit", {
                time = 400,
                effect = "crossFade",
                params = { id = event.target.item.id }
            })
		end
    end
	
	function checkBoxDelete( event )
		local active
		if event.target.check == 0 then
			btnCheckIn.alpha = 1
			event.target.check = 1
			contDeleteVisit = contDeleteVisit + 1
			active = true
		else
			btnCheckIn.alpha = 0
			event.target.check = 0
			contDeleteVisit = contDeleteVisit - 1
			active = false
		end
		
		if contDeleteVisit > 0 then
			showBtnDeleteVisit(true, active, event.target.id, event.target.posc)
		else
			showBtnDeleteVisit(false,active, event.target.id, event.target.posc)
		end
		
		return true
	end
    
    -- Creamos la pantalla del menu
    --function self:build(isBg, item, image)
	function self:build(item)
        -- Generamos contenedor
        local container = display.newContainer( 480, 130 )
        container.x = 240
        container.y = 60
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showVisit )

        local maxShape = display.newRect( 0, 0, 460, 120 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 116 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )
		
		local imgVisit = display.newImage( "img/btn/visitas.png" )
		imgVisit.x= -125
		imgVisit.y = 12
        container:insert(imgVisit)

        -- Agregamos textos
		
		local txtFecha = display.newText( {
           -- text = item.fechaFormat,
			text = item.dia .. " " .. item.fechaFormat,
            x = 5, y = -40,
            width = 400,
            font = fontLatoBold, fontSize = 12, align = "left"
        })
        txtFecha:setFillColor( 0 )
        container:insert(txtFecha)
		
		 local txtHora = display.newText( {
           -- text = item.fechaFormat,
			text = item.hora,
            x = 200, y = -40,
            width = 100,
            font = fontLatoBold, fontSize = 12, align = "left"
        })
        txtHora:setFillColor( 0 )
        container:insert(txtHora)
        
        local txtVisit = display.newText( {
			text = item.nombreVisitante:sub(1,20),
            x = 75, y = 0,
            width = 300,
            font = fontLatoBold, fontSize = 22, align = "left"
        })
        txtVisit:setFillColor( 0 )
        container:insert(txtVisit)

        local txtInfo = display.newText( {
            --text = item.detail:sub(1,42).."...",
			text = item.motivo:sub(1,40),
            x = 85, y = 32, width = 320,
            font = fontLatoLight, fontSize = 16, align = "left"
        })
        txtInfo:setFillColor( .3 )
        container:insert(txtInfo)
        
        local btnForward = display.newImage( "img/btn/btnForward.png" )
        btnForward:translate( 200, 18)
        container:insert( btnForward )
		
		local bgCheck = display.newRect( -190, 5, 50, 50 )
        bgCheck:setFillColor( 1 )
		bgCheck.check = 0
		bgCheck.id = item.id
		bgCheck.posc = item.posc
        container:insert( bgCheck )
		bgCheck:addEventListener( 'tap', checkBoxDelete )
		
		local btnCheckOut = display.newImage( "img/btn/select0.png" )
        btnCheckOut:translate( -191, 6)
        container:insert( btnCheckOut )
		
		btnCheckIn = display.newImage( "img/btn/select1.png" )
        btnCheckIn:translate( -189, 4)
		btnCheckIn.alpha = 0
        container:insert( btnCheckIn )
        
    end

    return self
end