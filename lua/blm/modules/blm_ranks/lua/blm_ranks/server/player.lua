--[[--------------------------------------------------------------------------------
				blm ranks - player
----------------------------------------------------------------------------------]]

--[[	Changelog -- Added July 27th, 2013

]]

blm.util.PrintT( "Running server/player.lua" )

/**--------------------------------------------------------------------------------*
 *----------------------------- Namespace Tables ----------------------------------*
 *-------------------------------------------------------------------------------**/

local 	ranks		= blm.ranks
	ranks.player 	= ranks.player or {}
	ranks.hooks  	= ranks.hooks  or {}
		
	ranks.default 	= { Level = 1, Class = "Newcomer" }
	ranks.players 	= ranks.players or {}

/**--------------------------------------------------------------------------------*
 *---------------------------- Localized Globals ----------------------------------*
 *-------------------------------------------------------------------------------**/

local string = string
local format = string.format

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/

util.AddNetworkString( "BLM_Ranks_PlayerRank" )
 
function ranks.hooks.PlayerInitialSpawn( ply )
	local nick = ply:Nick()
	local sid  = ply:SteamID()

	local pdata = ranks.sql.Query( format("SELECT * FROM blm WHERE SteamID = %q", sid) )

	if ( !pdata ) then 
		blm.util.Print( format("[BLM - SQL] Found new player %q (%s) -- inserting into database.", nick, sid ) )
		ranks.player.Setup( ply, ranks.default )
		ranks.sql.Query( format("INSERT INTO blm VALUES ( %q, '%u', %q )", sid, ranks.default.Level, ranks.default.Class) )
	else
		blm.util.Print( format("[BLM - SQL] Found returning player %q (%s).", nick, sid ) )
		ranks.player.Setup( ply, pdata[1] )
	end
	
	timer.Simple( 1, function()
		net.Start( "BLM_Ranks_PlayerRank" )
			net.WriteEntity( ply )
			net.WriteUInt(   ply.blm.pdata.Level, 8 )
			net.WriteString( ply.blm.pdata.Class )
		net.Broadcast()
	end )
end
hook.Add( "PlayerInitialSpawn", "blm_ranks_setupplayer", ranks.hooks.PlayerInitialSpawn )
--[[------------------------------------------------------------------------------]] 
function ranks.player.Setup( ply, tbl )
	ply.blm = ply.blm or {}
	ply.blm.pdata = tbl
	
	ranks.players[ ply:SteamID() ] = { Level = tbl.Level, Class = tbl.Class }
end
--[[------------------------------------------------------------------------------]]
function ranks.hooks.PlayerDisconnected( ply )
	if ( ranks.players[ ply:SteamID() ] ) then 
		ranks.players[ ply:SteamID() ] = nil
	end
end
hook.Add( "PlayerDisconnected", "blm_ranks_removeplayer", ranks.hooks.PlayerDisconnected )
--[[------------------------------------------------------------------------------]]

util.AddNetworkString( "BLM_Ranks_SyncRanks" )
	
function ranks.player.SyncRanks( ply )
	if ( !ranks.players ) then return; end
	
	net.Start( "BLM_Ranks_SyncRanks" )
		net.WriteTable( ranks.players )
	net.Send( ply )
end

net.Receive( "BLM_Ranks_SyncRanks", function( len, ply )
	ranks.player.SyncRanks( ply )
end )