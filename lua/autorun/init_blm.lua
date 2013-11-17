--[[--------------------------------------------------------------------------------
				    init_blm 
----------------------------------------------------------------------------------]]

--[[	Changelog -- Added July 27th, 2013

]]

/**--------------------------------------------------------------------------------*
 *----------------------------- NAMESPACE TABLES ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
blm 		  = blm 	      or {}
blm.IsInitialized = blm.IsInitialized or false

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local function PrintInit()
	print("\n")
	blm.util.Print( "Borderlands Mod v1.0 Initializing...", Color(0,255,0) )
	blm.util.Print()
end

/**-------------------------------------------------------------------------------**/
function blm.Initialize( isReloading )
	if ( blm.IsInitialized and !isReloading ) then return end

	if ( SERVER ) then
	
		include( "blm/util/util.lua" )
		AddCSLuaFile( "blm/util/util.lua" )
		PrintInit()
		blm.util.LoadModules( "blm/modules", blm.util.SHARED )
		
	elseif ( CLIENT ) then
	
		include( "blm/util/util.lua" )
		PrintInit()
		blm.util.LoadModules( "blm/modules", blm.util.INCLUDE )
		
	end
	
	blm.IsInitialized = true
end
hook.Add( "Initialize", "BLM_Initialize", blm.Initialize )