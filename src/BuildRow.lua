
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
                params = { item = 1 }
            })
		end
    end
    
    -- Creamos la pantalla del menu
    --function self:build(isBg, item, image)
	function self:build()
        -- Generamos contenedor
        local container = display.newContainer( 480, 110 )
        container.x = 240
        container.y = 60
		--container.item = item
        self:insert( container )
		container:addEventListener( "tap", showMessage )

        local maxShape = display.newRect( 0, 0, 460, 100 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 96 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        --item.tipo  = "Message"
      --[[  image.alpha = 1
        image.x= -177
        --image.item = item
        container:insert( image )]]
		
		local imgMsg = display.newImage( "img/btn/message01.png" )
		imgMsg.x= -177
        container:insert(imgMsg)

        -- Agregamos textos
        local txtPartner0 = display.newText( {
            text = "DE: ",     
            x = 45, y = -25,
            width = 340,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtPartner0:setFillColor( 0 )
        container:insert(txtPartner0)
        
        local txtPartner = display.newText( {
            --text = item.partner,
			text = "Comercio",
            x = 55, y = -25,
            width = 300,
            font = "Lato-Bold", fontSize = 18, align = "left"
        })
        txtPartner:setFillColor( 0 )
        container:insert(txtPartner)
        
        local txtFecha = display.newText( {
           -- text = item.fechaFormat,
			text = "2015-09-03",
            x = 200, y = -30,
            width = 100,
            font = "Lato-Bold", fontSize = 12, align = "left"
        })
        txtFecha:setFillColor( 0 )
        container:insert(txtFecha)
        
        local txtTitle0 = display.newText( {
            --text = Globals.language.buildMSGSubject,
			text = "hola",
            x = 45, y = 0,
            width = 340, height = 0,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtTitle0:setFillColor( 0 )
        container:insert(txtTitle0)
        
        local txtTitle = display.newText( {
            --text = item.name,
			 text = "mensaje",
            x = 75, y = 0,
            width = 280, height = 0,
            font = "Lato-Bold", fontSize = 18, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtInfo = display.newText( {
            --text = item.detail:sub(1,42).."...",
			text = "hola s aaaaaa sdas as ...",
            x = 35, y = 25, width = 320,
            font = "Lato-Italic", fontSize = 14, align = "left"
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
                params = { item = 1 }
            })
		end
    end
    
    -- Creamos la pantalla del menu
    --function self:build(isBg, item, image)
	function self:build()
        -- Generamos contenedor
        local container = display.newContainer( 480, 130 )
        container.x = 240
        container.y = 60
		--container.item = item
        self:insert( container )
		container:addEventListener( "tap", showVisit )

        local maxShape = display.newRect( 0, 0, 460, 120 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 116 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        --item.tipo  = "Message"
      --[[  image.alpha = 1
        image.x= -177
        --image.item = item
        container:insert( image )]]
		
		local imgVisit = display.newImage( "img/btn/iconUserVisit.png" )
		imgVisit.x= -177
		imgVisit.y = 12
		imgVisit.height = 80
		imgVisit.width = 90
        container:insert(imgVisit)

        -- Agregamos textos
		
		local txtFecha = display.newText( {
           -- text = item.fechaFormat,
			text = "Viernes 14 de Agosto, 2015",
            x = 5, y = -40,
            width = 400,
            font = "Lato-Bold", fontSize = 12, align = "left"
        })
        txtFecha:setFillColor( 0 )
        container:insert(txtFecha)
		
		 local txtHora = display.newText( {
           -- text = item.fechaFormat,
			text = "11:40 am",
            x = 200, y = -40,
            width = 100,
            font = "Lato-Bold", fontSize = 12, align = "left"
        })
        txtHora:setFillColor( 0 )
        container:insert(txtHora)
        
        local txtVisit = display.newText( {
            --text = item.partner,
			text = "Julia Gutierrez",
            x = 25, y = 0,
            width = 300,
            font = "Lato-Bold", fontSize = 24, align = "left"
        })
        txtVisit:setFillColor( 0 )
        container:insert(txtVisit)

        local txtInfo = display.newText( {
            --text = item.detail:sub(1,42).."...",
			text = "Visita personal",
            x = 35, y = 32, width = 320,
            font = "Lato-Italic", fontSize = 16, align = "left"
        })
        txtInfo:setFillColor( .3 )
        container:insert(txtInfo)
        
        local btnForward = display.newImage( "img/btn/btnForward.png" )
        btnForward:translate( 200, 18)
        container:insert( btnForward )
        
    end

    return self
end