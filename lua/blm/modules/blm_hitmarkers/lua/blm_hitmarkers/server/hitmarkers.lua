------------------------------------------------------------------------------------------------------------------
--      		 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      	 	 	--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PLACEHOLDER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
------------------------------------------------------------------------------------------------------------------

--[[	Changelog -- Added July 27th, 2013

]]

blm.util.PrintT( "Running server/hitmarkers.lua" )

/**--------------------------------------------------------------------------------*
 *	------------------------------------------- NAMESPACE TABLES ----------------------------------------------  *
 *-------------------------------------------------------------------------------**/
 
local hitmarkers  		 = blm.hitmarkers
	  hitmarkers.entity  = hitmarkers.entity  or {}
	  hitmarkers.weapons = hitmarkers.weapons or {}
	  hitmarkers.hooks   = hitmarkers.hooks   or {}

/**--------------------------------------------------------------------------------*
 *------------------------------ Local Variables ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local BITS = 16
local MAX_NUMBER = 2 ^ BITS

/**--------------------------------------------------------------------------------*
 *---------------------------- Localized Globals ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local IsValid = IsValid
local IsEntity = IsEntity
local hook = hook
local util = util

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/
function hitmarkers.RegisterWeapon( WEAPON )
	hitmarkers.weapons[ WEAPON.Name ] = WEAPON
end
--[[--------------------------------------------------------------------------------]]
util.AddNetworkString( "BL2Damage" )

function hitmarkers.hooks.EntityTakeDamage( ent, damageInfo ) 
	if ( !IsValid( ent ) or !ent:IsPlayer() ) then return; end
	
	local dmg 	  = damageInfo:GetDamage()
	local inf 	  = damageInfo:GetInflictor()
	local dmgEnum = damageInfo:GetDamageType()
	
	if ( IsEntity( inf ) ) then
		if ( inf:IsPlayer() ) then
			inf = inf:GetActiveWeapon():GetClass()
		else
			inf = inf:GetClass()
		end
	else
		inf = damageInfo:GetAmmoType()
	end
	
	local WEAPON = hitmarkers.weapons[ inf ]
	local COLOR  = ( WEAPON and WEAPON.Color ) or Color(255,255,255)
	
	net.Start( "BL2Damage" )
		net.WriteEntity( ent )
		net.WriteUInt( math.Clamp( dmg, 0, MAX_NUMBER ), BITS )
		net.WriteUInt( COLOR.r, 8 )
		net.WriteUInt( COLOR.g, 8 )
		net.WriteUInt( COLOR.b, 8 )
	net.Broadcast()
end 
hook.Add( "EntityTakeDamage", "BLM_Hitmarkers_EntityTakeDamage", hitmarkers.hooks.EntityTakeDamage )