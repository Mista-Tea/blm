------------------------------------------------------------------------------------------------------------------
--      		 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      	 	 	--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PLACEHOLDER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
------------------------------------------------------------------------------------------------------------------

--[[	Changelog -- Added July 27th, 2013

]]

blm.util.PrintT( "Running server/player.lua" )

/**--------------------------------------------------------------------------------*
 *	------------------------------------------- NAMESPACE TABLES ----------------------------------------------  *
 *-------------------------------------------------------------------------------**/
 
local hitmarkers = blm.hitmarkers
	  hitmarkers.player = hitmarkers.player or {}
	  hitmarkers.hooks  = hitmarkers.hooks  or {}

/**--------------------------------------------------------------------------------*
 *---------------------------- Localized Globals ----------------------------------*
 *-------------------------------------------------------------------------------**/
	  
local string = string
local format = string.format

local timer = timer
local hook = hook

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/
function hitmarkers.hooks.PlayerSpawn( ply )
	local SID = ply:SteamID()
	
	local currHealth = ply:Health()
	local maxHealth = ply:GetMaxHealth()
	
	ply.blmMaxHealth = ( maxHealth >= currHealth and maxHealth ) or currHealth

	timer.Create( "Health_"..SID, 0.5, 0, function()
		if ( !ply or !ply:IsValid() ) then timer.Destroy( "Health_"..SID ) return; end
		
		if 	   ( ply.blmMaxHealth < ply:Health() ) then ply.blmMaxHealth = ply:Health()
		elseif ( ply.blmMaxHealth <= 0 ) 		  then ply.blmMaxHealth = 0.1 			end
				
		ply:SetNWInt( "MaxHealth", ply.blmMaxHealth )
	end )
end
hook.Add( "PlayerSpawn", "BLM_Hitmarkers_PlayerSpawn", hitmarkers.hooks.PlayerSpawn )