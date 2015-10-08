--Include sqlite
local RestManager = {}
	require('src.BuildItem')
	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local Globals = require('src.resources.Globals')
	local DBManager = require('src.resources.DBManager')
    
	local settings = DBManager.getSettings()
	
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end
	
	RestManager.validateUser = function(email, password)
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/validateUser/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
		url = url.."/playerId/"..urlencode(Globals.playerIdToken)
		--url = url.."/playerId/"..urlencode('adios')
	
        local function callback(event)
            if ( event.isError ) then
				deleteLoadingLogin()
				native.showAlert( "Booking", event.isError, { "OK"})
            else
                local data = json.decode(event.response)
                if data.success then
					local items = data.items
					if #items == 1 then
						getMessageSignIn(data.message, 1)
						DBManager.updateUser(items[1].id, items[1].email, items[1].contrasena, items[1].nombre, items[1].apellido, items[1].condominioId)
						timeMarker = timer.performWithDelay( 2000, function()
							deleteLoadingLogin()
							deleteMessageSignIn()
							goToHomeLogin()
						end, 1 )
					else
						getMessageSignIn(data.message, 1)
						DBManager.updateUser(items[1].id, items[1].email, items[1].contrasena, items[1].nombre, items[1].apellido, 0)
						DBManager.insertCondominium(items)
						timeMarker = timer.performWithDelay( 2000, function()
							deleteLoadingLogin()
							deleteMessageSignIn()
							goToSelectCondominiousLogin()
						end, 1 )
						
					end
					
					
                else
					getMessageSignIn(data.message, 2)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteLoadingLogin()
						deleteMessageSignIn()
						errorLogin()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.setIdPlayerUser = function(idCondo, idUser)
	
        local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/setIdPlayerUser/format/json"
        url = url.."/idApp/"..idUser
		url = url.."/playerId/"..urlencode(Globals.playerIdToken)
		--url = url.."/playerId/"..urlencode('hola')
		print(url)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					local items = data.items
					DBManager.updateCondominioUser(idCondo, idUser)
					getMessageSignIn(data.message, 1)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteLoadingLogin()
						deleteMessageSignIn()
						goToHomeLoginCondo()
					end, 1 )
					
					
                else
					getMessageSignIn(data.message, 2)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteLoadingLogin()
						deleteMessageSignIn()
						errorLoginCondo()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.signOut = function(password)
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/signOut/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/password/"..password
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					DBManager.clearUser()
					signOut()
                else
                    --native.showAlert( "Booking", data.message, { "OK"})
					NewAlert("Booking",data.message, 600, 200, 2000)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteNewAlert()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	--obtiene el numero de mensajes no leidos de visitas
	RestManager.getMessageUnRead = function()
	
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getMessageUnRead/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/condominium/"..settings.condominioId
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					createNotBubble(data.items, data.items2)
                else
                    --native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	
	end
	
	--marca el mesaje como leidos
	RestManager.markMessageRead = function(id, typeM)
		
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/markMessageRead/format/json"
        url = url.."/idApp/".. settings.idApp
        url = url.."/idMSG/".. id
		url = url.."/typeM/".. typeM
	
        local function callback(event)
            if ( event.isError ) then
            else
                
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--obtiene los mensajes de visitantes
	RestManager.getMessageToVisit = function()
		
		getLoadingLogin(400, "Cargando Mensajes")
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getMessageToVisit/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/condominium/"..settings.condominioId
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					local items = data.items
					setItemsNotiVisit(items)
                else
                   -- native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	
	end
	
	--obtiene el mensaje de visitante por id
	RestManager.getMessageToVisitById = function(id)
		
		getLoadingLogin(400, "Cargando Mensajes")
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getMessageToVisitById/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idMSG/".. id
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					local items = data.items
					setItemsVisit(items[1])
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--obtiene los mensajes de visitantes
	RestManager.getMessageToAdmin = function()
	
		print('hola')
		
		getLoadingLogin(400, "Cargando Mensajes")
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getMessageToAdmin/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/condominium/"..settings.condominioId
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					print('hola')
					local items = data.items
					setItemsNotiAdmin(items)
                else
                   -- native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	
	end
	
	--obtiene el mensaje de visitante por id
	RestManager.getMessageToAdminById = function(id)
		
		getLoadingLogin(400, "Cargando Mensajes")
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getMessageToAdminById/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idMSG/".. id
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					local items = data.items
					setItemsAdmin(items[1])
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--comprueba si existe conexion a internet
	function networkConnection()
		local netConn = require('socket').connect('www.google.com', 80)
		if netConn == nil then
			return false
		end
		netConn:close()
		return true
	end
	
return RestManager