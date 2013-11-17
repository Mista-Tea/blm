--[[--------------------------------------------------------------------------------
				blm ranks - sql
----------------------------------------------------------------------------------]]

--[[	Changelog -- Added July 27th, 2013

]]

blm.util.PrintT( "Running server/sql.lua" )

/**--------------------------------------------------------------------------------*
 *----------------------------- Namespace Tables ----------------------------------*
 *-------------------------------------------------------------------------------**/

local 	ranks	  = blm.ranks or {}
	ranks.sql = ranks.sql or {}

/**--------------------------------------------------------------------------------*
 *--------------------------- Namespace Variables ---------------------------------*
 *-------------------------------------------------------------------------------**/

ranks.sql.IsEstablished = ranks.sql.IsEstablished or false
ranks.sql.RetryAttempts = 4

/**--------------------------------------------------------------------------------*
 *------------------------------ Local Variables ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local GREEN = Color(0,255,0)
local RED   = Color(255,0,0)

/**--------------------------------------------------------------------------------*
 *---------------------------- Localized Globals ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local sql   	 = sql
local Query 	 = sql.Query
local QueryValue = sql.QueryValue

local TableExists = sql.TableExists

local string = string
local format = string.format

local hook = hook

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/
function ranks.sql.SetupTable( name, isReloading )
	if ( ranks.sql.IsEstablished and !isReloading ) then return; end
	
	local success = false

	blm.util.PrintT( "\t[BLM - SQL] Checking for SQLite '" .. name .. "' database..." )
	
	if ( TableExists( name ) ) then
		blm.util.PrintT( "\t[SUCCESS] '" .. name .. "' database found!", GREEN )
		success = true
	else
		blm.util.PrintT( "\t[FAILURE] No " .. name .. " SQLite database found -- creating new database...", RED )
		local result = Query( "CREATE TABLE " .. name .. " ( SteamID varchar(100) PRIMARY KEY, Level tinyint, Class varchar(255) )" )

		if ( TableExists( name ) ) then
			blm.util.PrintT( "\t[BLM - SQL] " .. name .. " database created successfully!", GREEN )
			success = true
		else
			blm.util.PrintT( "\t[FAILURE] " .. name .. " database could not be created!", RED )
		end
	end
	
	if ( success ) then
		ranks.sql.IsEstablished = true
		hook.Call( "BL2M.DatabaseInitialized", GAMEMODE )
	end
end
ranks.sql.SetupTable( "blm", ranks.sql.IsEstablished )
--[[------------------------------------------------------------------------------]]
function ranks.sql.Query( QUERY )
	local result = Query( QUERY )
	
	return result
end