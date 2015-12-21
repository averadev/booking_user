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
	
        local function callback(event)
            if ( event.isError ) then
				deleteLoadingLogin()
				native.showAlert( "Plantec Resident", event.isError, { "OK"})
            else
                local data = json.decode(event.response)
                if data.success then
					local items = data.items
					local residencial = data.residencial
					DBManager.insertResidencial(residencial)
					if #items == 1 then
						getMessageSignIn(data.message, 1)
						DBManager.updateUser(items[1].id, items[1].email, items[1].contrasena, items[1].nombre, items[1].apellido, items[1].condominioId)
						DBManager.insertCondominium(items)
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
	
	RestManager.deletePlayerIdOfUSer = function()
	
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/deletePlayerIdOfUSer/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/condominioId/"..settings.condominioId
		--url = url.."/playerId/"..urlencode('hola')
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					local items = data.items
					
					getMessageSignIn(data.message, 1)
					timeMarker = timer.performWithDelay( 1000, function()
						deleteMessageSignIn()
						SignOut2()
					end, 1 )
					
                else
					getMessageSignIn(data.message, 2)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteMessageSignIn()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
	
	end
	
	--obtiene la info del ultimo guardia en turno
	RestManager.getLastGuard = function()
	
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getLastGuard/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/condominioId/"..settings.condominioId
	
        local function callback(event)
            if ( event.isError ) then
				paintGuardDefault()
            else
                local data = json.decode(event.response)
                if data.success then
					if data.items then
						local items = data.items
						setElementGuard(items)
					else
						paintGuardDefault()
					end
                else
					paintGuardDefault()
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
				native.showAlert( "Plantec Resident", "Error con el servidor", { "OK"})
            else
                local data = json.decode(event.response)
				if data.success then
					createNotBubble(data.items, data.items2)
                else
                   native.showAlert( "Plantec Resident", "Error con el servidor", { "OK"})
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
				RestManager.getMessageUnRead()
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
                    native.showAlert( "Plantec Resident", data.message, { "OK"})
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
					local items = data.items
					setItemsNotiAdmin(items)
                else
					native.showAlert( "Plantec Resident", data.message, { "OK"})
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
	
	--obtiene el mensaje de visitante por id
	RestManager.deleteMsgVisit = function(visitId)
		local encoded = json.encode( visitId, { indent = true } )
		
		getLoadingLogin(400, "Cargando...")
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/deleteMsgVisit/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idMSG/".. urlencode(encoded)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					refreshMessageVisit()
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--obtiene el mensaje de visitante por id
	RestManager.deleteMsgAdmin = function(adminId)
	
		local encoded = json.encode( adminId, { indent = true } )
		
		getLoadingLogin(400, "Cargando...")
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/deleteMsgAdmin/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idMSG/".. urlencode(encoded)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					refreshMessageAdmin()
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--envia el mensaje de sugerencia
	RestManager.sendSuggestion = function(subject,message)
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/saveSuggestion/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/subject/".. urlencode(subject)
		url = url.."/message/".. urlencode(message)
	
        local function callback(event)
            if ( event.isError ) then
				getMessageSignIn("Error al enviar el mensaje", 2)
				messageSent(1)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						getMessageSignIn(data.message, 1)
						messageSent(2)
					else
						getMessageSignIn("Error al enviar el mensaje", 2)
						messageSent(1)
					end
				else
					getMessageSignIn("Error al enviar el mensaje", 2)
					messageSent(1)
				end
            end
			deleteLoadingLogin()
			timeMarker = timer.performWithDelay( 2000, function()
				deleteMessageSignIn()
			end, 1 )
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