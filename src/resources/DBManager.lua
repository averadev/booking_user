--Include sqlite
local dbManager = {}

	require "sqlite3"
	local path, db
    local lfs = require "lfs"

	--Open rackem.db.  If the file doesn't exist it will be created
	local function openConnection( )
        local pathBase = system.pathForFile(nil, system.DocumentsDirectory)
        if findLast(pathBase, "/data/data") > -1 then
            local newFile = pathBase:gsub("/app_data", "") .. "/databases/booking_user.db"
            local fhd = io.open( newFile )
            if fhd then
                fhd:close()
            else
                local success = lfs.chdir(  pathBase:gsub("/app_data", "") )
                if success then
                    lfs.mkdir( "databases" )
                end
            end
            db = sqlite3.open( newFile )
        else
            db = sqlite3.open( system.pathForFile("booking_user.db", system.DocumentsDirectory) )
        end
	end

	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end
	 
	--Handle the applicationExit event to close the db
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end

    -- Find substring
    function findLast(haystack, needle)
        local i=haystack:match(".*"..needle.."()")
        if i==nil then return -1 else return i-1 end
    end

	--obtiene los datos del admin
	dbManager.getSettings = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--obtiene los datos de los condominios
	dbManager.getCondominiums = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM condominios;") do
			result[#result + 1] = row
		end
		closeConnection( )
		if #result > 0 then
			return result
		else
			return 1
		end
	end
	
	--obtiene los datos del condominio por id
	dbManager.getCondominiumById = function(id)
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM condominios where id = '" .. id .. "';") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--obtiene los datos de la residencial
	dbManager.getResidencial = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM residencial;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--actualiza los datos del admin
    dbManager.updateUser = function(idApp, email, password, name, apellido, condominio)
		openConnection( )
        local query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', name = '"..name.."', apellido = '"..apellido.."', condominioId = '"..condominio.."';"
        db:exec( query )
		closeConnection( )
	end
	
	--inserta los datos del condominio
	dbManager.insertCondominium = function(items)
		openConnection( )
			for i = 1, #items, 1 do
				local query = "INSERT INTO condominios VALUES ('" .. items[i].condominioId .."', '" .. items[i].id .."', '" .. items[i].nameCondominious .."');"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--inserta los datos del condominio
	dbManager.updateCondominioUser = function(condominio, idUser)
		openConnection( )
        local query = "UPDATE config SET  idApp = '"..idUser.."', condominioId = '"..condominio.."';"
        db:exec( query )
		closeConnection( )
	end
	
	--inserta los datos del condominio
	dbManager.insertResidencial = function(items)
		openConnection( )
			for i = 1, #items, 1 do
				local query = "INSERT INTO residencial VALUES ('" .. items[i].id .."', '" .. items[i].nombre .."', '" .. items[i].telAdministracion .."', '" .. items[i].telCaseta .."', '" .. items[i].telLobby .."');"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--limpia la tabla de admin, guardia y condominio
    dbManager.clearUser = function()
        openConnection( )
        query = "UPDATE config SET idApp = 0, email = '', password = '', name = '', apellido = '', condominioId = 0;"
        db:exec( query )
		query = "delete from condominios;"
        db:exec( query )
		query = "delete from residencial;"
        db:exec( query )
		closeConnection( )
    end

	--Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, email TEXT, password TEXT, name TEXT, apellido TEXT, "..
					" condominioId INTEGER, url TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS condominios (id INTEGER, idUser INTEGER, nombre TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS residencial (id INTEGER, nombre TEXT, telAdministracion TEXT, telCaseta TEXT, telLobby TEXT);"
		db:exec( query )

        -- Return if have connection
		for row in db:nrows("SELECT idApp, condominioId FROM config;") do
            closeConnection( )
            if row.idApp == 0  or row.condominioId == 0 then
                return false
            else
                return true
            end
		end
		
        -- Populate config
		query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://geekbucket.com.mx/booking/');"
		--query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://localhost:8080/booking/');"
		
		db:exec( query )
    
		closeConnection( )
    
        return false
	end
	

	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )
    

return dbManager