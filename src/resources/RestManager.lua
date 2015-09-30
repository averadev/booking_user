--Include sqlite
local RestManager = {}
	require('src.BuildItem')
	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')
	
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
	
        local function callback(event)
            if ( event.isError ) then
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