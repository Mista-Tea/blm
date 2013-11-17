------------------------------------------------------------------------------------------------------------------
--      		 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      	 	 	--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PLACEHOLDER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
------------------------------------------------------------------------------------------------------------------

--[[	Changelog -- Added July 27th, 2013

]]

/**--------------------------------------------------------------------------------*
 *	------------------------------------------- NAMESPACE TABLES ----------------------------------------------  *
 *-------------------------------------------------------------------------------**/

blm 	  				= blm		 		 	  or {}
blm.ranks 				= blm.ranks 			  or {}
blm.ranks.IsInitialized = blm.ranks.IsInitialized or false

/**--------------------------------------------------------------------------------*
 *	------------------------------------------- BLM - LOAD MODULE ---------------------------------------------  *
 *-------------------------------------------------------------------------------**/
/**
 *	If supplied the value from 'debug.getinfo(1).short_src', this will return the relative
 *	 directory that the calling file resides in, ignoring the file's name, it's current folder, and the first 3 folders.
 *
 *	For example, if given "addons/blm/lua/blm/modules/blm_hitmarkers/lua/autorun/init.lua", 
 *	 it will return	-->			 		 "blm/modules/blm_hitmarkers/lua/"
 *
 *	The whole purpose of doing this is so that we can dynamically load modules in the /modules/ folder.
 *	 These modules can by copied directly out of /modules/ and placed into garrysmod/addons/ and they will still run!
 **/
function blm.GetRelativePath( debugSource )
	local relativePath = ""
	local directories = string.Explode( "/", debugSource )

	for I = 1, #directories do
		if ( I > 3 ) then -- skip the first 3 directories, "addons/ADDON/lua"
			if ( I < #directories - 1 ) then	-- skip the last 2 directories, "autorun/FILE.lua"
				relativePath = relativePath .. directories[I] .. "/"
			end
		end
	end
	
	return relativePath
end
--[[--------------------------------------------------------------------------------]]
local fullPath     = debug.getinfo(1).short_src
local modulePath   = blm.GetRelativePath( fullPath )	-- Retrieve the module's current relative path, such as "blm/modules/blm_hitmarkers/lua/"
local relativePath = modulePath .. "blm_ranks/"
--[[--------------------------------------------------------------------------------]]
function blm.ranks.Initialize( isReloading )
	if ( blm.ranks.IsInitialized and !isReloading ) then return; end
	
	if ( blm and blm.util ) then blm.util.PrintT( "Loading bundled module -- Borderlands Mod -- Player Ranks" ) 
	else							   print( " |\tLoading standalone module -- Borderlands Mod -- Player Ranks" ) end
	
	if ( SERVER ) then
		if ( !blm.util ) then
			include( relativePath .. "util/util.lua" )
			AddCSLuaFile( relativePath .. "util/util.lua" )
		end
			
		blm.util.IncludeDir( relativePath .. "server",  blm.util.INCLUDE )
		blm.util.IncludeDir( relativePath .. "shared",  blm.util.SHARED )
		blm.util.IncludeDir( relativePath .. "client",  blm.util.TO_CLIENT )
	end
	
	if ( CLIENT ) then
		if ( !blm.util ) then
			include( relativePath .. "util/util.lua" )
		end

		blm.util.IncludeDir( relativePath .. "client",  blm.util.INCLUDE )
		blm.util.IncludeDir( relativePath .. "shared",  blm.util.INCLUDE )
	end
	
	blm.ranks.IsInitialized = true
end
--hook.Add( "Initialize", "BLM_Ranks_Initialize", blm.ranks.Initialize )

--if ( blm.util ) then blm.util.AddModuleInitializer( "ranks", blm.ranks.Initialize ) end