--[[--------------------------------------------------------------------------------
				blm hitmarkers - enums
----------------------------------------------------------------------------------]]

--[[	Changelog -- Added July 27th, 2013

]]

blm.util.PrintT( "Running shared/enums.lua" )

/**--------------------------------------------------------------------------------*
 *----------------------------- Namespace Tables ----------------------------------*
 *-------------------------------------------------------------------------------**/

local hitmarkers 				  = blm.hitmarkers
	  hitmarkers.enums 			  = hitmarkers.enums 		  	or {}
	  hitmarkers.enums.ToOriginal = hitmarkers.enums.ToOriginal or {}
	  hitmarkers.enums.ToModified = hitmarkers.enums.ToModified or {}

/**--------------------------------------------------------------------------------*
 *	------------------------------------------- LOCAL TABLES --------------------------------------------------  *
 *-------------------------------------------------------------------------------**/
	  
local BaseDamageEnums = {
	DMG_GENERIC 			=	0,
	DMG_CRUSH 			=	1,
	DMG_BULLET 			=	2,
	DMG_SLASH 			=	4,
	DMG_BURN 			=	8,
	DMG_VEHICLE 			=	17,
	DMG_FALL 			=	32,
	DMG_BLAST 			=	64,
	DMG_CLUB 			=	128,
	DMG_SHOCK 			=	256,
	DMG_SONIC 			=	512,
	DMG_ENERGYBEAM 	 		= 	1024,
	DMG_PREVENT_PHYSICS_FORCE 	= 	2048,
	DMG_NEVERGIB 			=	4098,
	DMG_ALWAYSGIB 			=	8194,
	DMG_DROWN 			=	16384,
	DMG_PARALYZE 			=	32768,
	DMG_NERVEGAS 			=	65536,
	DMG_POISON 			=	131072,
	DMG_RADIATION 			=	262144,
	DMG_DROWNRECOVER 		= 	524288,
	DMG_ACID			= 	1048576,	
	DMG_SLOWBURN 			=	2097152,
	DMG_REMOVENORAGDOLL 		=	4194304,
	DMG_PHYSGUN 			=	8388608,
	DMG_PLASMA 			=	16777216,
	DMG_AIRBOAT 			=	33554432,
	DMG_DISSOLVE 			=	67108864,
	DMG_BLAST_SURFACE		= 	134217792,
	DMG_DIRECT 			=	268435456,
	DMG_BUCKSHOT 			=	536875010,
}

/**--------------------------------------------------------------------------------*
 *------------------------------ Local Variables ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local INDEX = 1

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/
function hitmarkers.enums.Setup()
	for alias, number in pairs( BaseDamageEnums ) do
		hitmarkers.enums.ToOriginal[ INDEX ]  = number
		hitmarkers.enums.ToModified[ number ] = INDEX
		INDEX = INDEX + 1
	end
end
hitmarkers.enums.Setup()