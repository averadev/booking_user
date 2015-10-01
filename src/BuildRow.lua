
--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

---------------------------------------------------------------------------------
-- MESSAGE
---------------------------------------------------------------------------------
Message = {}
local assigned = 0
function Message:new()
    -- Variables
    local self = display.newGroup()
	
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
		
		local imgMsg = display.newImage( "img/btn/message01.png" )
		imgMsg.x= -177
        container:insert(imgMsg)
		
		 local txtFecha = display.newText( {
			text = item.dia .. ", " .. item.fechaFormat,
            x = -15, y = -35,
            width = 450,
            font = "Lato-Regular", fontSize = 12, align = "right",
        })
        txtFecha:setFillColor( 0 )
        container:insert(txtFecha)

        -- Agregamos textos
        local txtPartner0 = display.newText( {
            text = "DE: ",     
            x = 45, y = -17,
            width = 340,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtPartner0:setFillColor( 0 )
        container:insert(txtPartner0)
		
        local txtPartner = display.newText( {
            --text = item.partner,
			text = item.nombreAdmin .. " " .. item.apellidosAdmin,
            x = 55, y = -17,
            width = 300,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtPartner:setFillColor( 0 )
        container:insert(txtPartner)
        
        local txtTitle0 = display.newText( {
			text = "Asunto: ",
            x = 45, y = 7,
            width = 340, height = 0,
            font = "Lato-Bold", fontSize = 15, align = "left"
        })
        txtTitle0:setFillColor( 0 )
        container:insert(txtTitle0)

        local txtInfo = display.newText( {
            text = item.asunto:sub(1,35).."...",
            x = 35, y = 30, width = 320,
            font = "Lato-Light", fontSize = 14, align = "left"
        })
        txtInfo:setFillColor( .3 )
        container:insert(txtInfo)
        
        local btnForward = display.newImage( "img/btn/btnForward.png" )
        btnForward:translate( 200, 18)
        container:insert( btnForward )
        
    end

    return self
end

Visit = {}
local assigned = 0
function Visit:new()
    -- Variables
    local self = display.newGroup()
	
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
		
		local imgVisit = display.newImage( "img/btn/iconUserVisit.png" )
		imgVisit.x= -177
		imgVisit.y = 12
		imgVisit.height = 80
		imgVisit.width = 90
        container:insert(imgVisit)

        -- Agregamos textos
		
		local txtFecha = display.newText( {
           -- text = item.fechaFormat,
			text = item.dia .. " " .. item.fechaFormat,
            x = 5, y = -40,
            width = 400,
            font = "Lato-Bold", fontSize = 12, align = "left"
        })
        txtFecha:setFillColor( 0 )
        container:insert(txtFecha)
		
		 local txtHora = display.newText( {
           -- text = item.fechaFormat,
			text = item.hora,
            x = 200, y = -40,
            width = 100,
            font = "Lato-Bold", fontSize = 12, align = "left"
        })
        txtHora:setFillColor( 0 )
        container:insert(txtHora)
        
        local txtVisit = display.newText( {
			text = item.nombreVisitante:sub(1,25).."...",
            x = 25, y = 0,
            width = 300,
            font = "Lato-Bold", fontSize = 22, align = "left"
        })
        txtVisit:setFillColor( 0 )
        container:insert(txtVisit)

        local txtInfo = display.newText( {
            --text = item.detail:sub(1,42).."...",
			text = item.motivo:sub(1,45).."...",
            x = 35, y = 32, width = 320,
            font = "Lato-Light", fontSize = 16, align = "left"
        })
        txtInfo:setFillColor( .3 )
        container:insert(txtInfo)
        
        local btnForward = display.newImage( "img/btn/btnForward.png" )
        btnForward:translate( 200, 18)
        container:insert( btnForward )
        
    end

    return self
end