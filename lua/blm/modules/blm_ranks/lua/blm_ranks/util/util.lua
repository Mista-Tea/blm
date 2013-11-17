--[[--------------------------------------------------------------------------------
				    util
----------------------------------------------------------------------------------]]

--[[	Changelog -- Added July 27th, 2013

]]

/**--------------------------------------------------------------------------------*
 *----------------------------- Namespace Tables ----------------------------------*
 *-------------------------------------------------------------------------------**/

blm.util = blm.util or {}
blm.util.initializers = blm.util.initializers or {}
 
/**--------------------------------------------------------------------------------*
 *--------------------------- Namespace Variables ---------------------------------*
 *-------------------------------------------------------------------------------**/

blm.util.INCLUDE   = 0x00
blm.util.CLIENT = 0x01
blm.util.SHARED    = 0x10
 
/**--------------------------------------------------------------------------------*
 *------------------------------- Local Tables ------------------------------------*
 *-------------------------------------------------------------------------------**/
 
local AddFile = {}
AddFile[ blm.util.INCLUDE ]	= include
AddFile[ blm.util.CLIENT ]	= AddCSLuaFile
AddFile[ blm.util.SHARED ]	= function( filePath ) include( filePath ) AddCSLuaFile( filePath ) end

/**--------------------------------------------------------------------------------*
 *------------------------------ Local Variables ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local GRAY  = Color(200,200,200)
local GREEN = Color(0,255,0)

/**--------------------------------------------------------------------------------*
 *---------------------------- Localized Globals ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local MsgC = MsgC
local Color = Color

local file = file
local Find = file.Find

local string = string
local Explode = string.Explode

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/
function blm.util.Print( text, col )
	MsgC( GRAY, " | " ) 
	MsgC( col or GRAY, (text or "") .. "\n" )
end

function blm.util.PrintT( text, col )
	MsgC( GRAY, " | " ) 
	MsgC( col or GRAY, "\t" .. (text or "") .. "\n" )
end
--[[------------------------------------------------------------------------------]]
function blm.util.PrintError( location, err )
	MsgC( Color(255,0,0), " | ERROR -- BLM." .. location .. ": " .. err .. "\n" )
end
--[[------------------------------------------------------------------------------]]
function blm.util.IncludeDir( dir, flag )

	local files, folders = Find( dir .. "/*", "LUA", "nameasc" ) 

	if ( (!files or !files[1]) and (!folders or !folders[1]) ) then return; end

	for _, FILE in pairs( files ) do
		local filePath = ( dir .. "/" .. FILE )

		AddFile[ flag ]( filePath )
	end
	
	for i, FOLDER in pairs( folders ) do
		blm.util.IncludeDir( dir .. "/" .. FOLDER, flag )
	end
end
--[[------------------------------------------------------------------------------]]
function blm.util.LoadModules( dir, flag )
	local _, MODULES = Find( dir .. "/*", "LUA", "nameasc" )
	
	if ( !MODULES ) then blm.util.printFailure( "No modules were found in '../lua/blm/modules'!" ) return; end
	
	for _, MODULE in pairs( MODULES ) do
		blm.util.Print( "Found module '"..MODULE.."'", GREEN )
		blm.util.IncludeDir( dir .. "/" .. MODULE .. "/lua/autorun", flag )
		
		if ( !blm.util.CurrentModule ) then continue; end
		blm.util.initializers[ blm.util.CurrentModule ]()
	end
end
--[[------------------------------------------------------------------------------]]
function blm.util.AddModuleInitializer( name, func )
	blm.util.initializers[ name ] = func
	blm.util.CurrentModule = name
end
--[[ -------------------------------------------------------------------------------
/**
 *	If supplied the value from 'debug.getinfo(1).short_src', this will return the relative
 *	 directory that the calling file resides in, ignoring the file's name, 
 *	 its current folder, and the first 3 folders.
 *
 *	For example, if given "addons/blm/lua/blm/modules/blm_hitmarkers/lua/autorun/init.lua", 
 *	 it will return	-->	"blm/modules/blm_hitmarkers/lua/"
 *
 *	The whole purpose of doing this is so that we can dynamically load modules in the /modules/ folder.
 *	 These modules can by copied directly out of /modules/ and 
 *	 placed into garrysmod/addons/ and they will still run!
 **/
 ------------------------------------------------------------------------------ --]]
function blm.util.GetRelativePath( debugSource )
	local relativePath = ""
	local directories = Explode( "/", debugSource )

	for I = 1, #directories do
		if ( I > 3 ) then -- skip the first 3 directories, "addons/ADDON/lua"
			if ( I < #directories - 1 ) then	-- skip the last 2 directories, "autorun/FILE.lua"
				relativePath = relativePath .. directories[I] .. "/"
			end
		end
	end
	
	return relativePath
end