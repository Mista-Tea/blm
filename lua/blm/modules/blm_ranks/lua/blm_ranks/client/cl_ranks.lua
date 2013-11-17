

--[[	Changelog -- Added July 27th, 2013

]]

blm.util.PrintT( "Running client/cl_ranks.lua" )

/**--------------------------------------------------------------------------------*
 *----------------------------- Namespace Tables ----------------------------------*
 *-------------------------------------------------------------------------------**/

local ranks 	    = blm.ranks
	  ranks.players = ranks.players or {}
	  ranks.hooks   = ranks.hooks   or {}
	  
/**--------------------------------------------------------------------------------*
 *------------------------------ Local Variables ----------------------------------*
 *-------------------------------------------------------------------------------**/
	  
local BITS = 16
local MAX_NUMBER = 2 ^ BITS
local LeftOrRight = true

local BAR_W = 500
local BAR_H = 40

local BAR_X = 0
local BAR_Y = 0

/**--------------------------------------------------------------------------------*
 *---------------------------- Localized Globals ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local cam 		= cam
local Start3D2D = cam.Start3D2D
local End3D2D   = cam.End3D2D

local draw 				 = draw
local RoundedBox 		 = draw.RoundedBox
local SimpleTextOutlined = draw.SimpleTextOutlined

local math  = math
local Rand  = math.Rand
local Clamp = math.Clamp

local Color  = Color
local Vector = Vector

local IsValid = IsValid
local hook = hook
local net = net

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/
hook.Add( "InitPostEntity", "BLM_Ranks_SyncRanks", function()
	net.Start( "BLM_Ranks_SyncRanks" )
	net.SendToServer()
end )

net.Receive( "BLM_Ranks_SyncRanks", function( len )
	local ranks = net.ReadTable()
	for _, ply in pairs( player.GetAll() ) do
		local rank = ranks[ ply:SteamID() ]
		ply.blm      = ply.blm or {}
		ply.blm.rank = rank
	end
end )
--[[--------------------------------------------------------------------------------]] 
net.Receive( "BLM_Ranks_PlayerRank", function( len )
	local ply   = net.ReadEntity()
	local level = net.ReadUInt( 8 )
	local class = net.ReadString()
	
	ply.blm = ply.blm or {}
	ply.blm.rank = { Level = level, Class = class }
	ranks.players[ ply:SteamID() ] = { Level = level, Class = class }
end )
--[[--------------------------------------------------------------------------------]]

surface.CreateFont( "BLM_Class", { font = "coolvetica", size = 80, weight = 500 } )
surface.CreateFont( "BLM_Level", { font = "coolvetica", size = 120, weight = 500 } )

function ranks.hooks.PostPlayerDraw( ply )
	
	if ( !IsValid( ply ) ) 		     then return; end
	if ( LocalPlayer() == ply )  	 then return; end
	if ( !ply.blm or !ply.blm.rank ) then return; end
	
	local ang = (ply:GetPos() - LocalPlayer():GetPos()):Angle()
		  ang:RotateAroundAxis( ang:Forward(), 90 )
		  ang:RotateAroundAxis( ang:Right(),   90 )
	
	local height_offset = Vector( 0,0, 80 )
	local pos = ply:GetPos() + ang:Up() + height_offset
	
	local BAR_X = (BAR_W / 2)
	
	Start3D2D( pos, Angle( 0, ang.y, ang.R ), 0.05 )
		RoundedBox( 4, -BAR_X, 0, BAR_W, BAR_H, Color(5,5,5) )
		local healthBarSize = Clamp( BAR_W * ( ply:Health() / Clamp( ply:GetNWInt("MaxHealth"), 0.1, 100 ) ), 0, BAR_W )
		RoundedBox( 0, -BAR_X + 5, 7, healthBarSize - 10, BAR_H - 14, Color(225,25,25) )
		RoundedBox( 0, -BAR_X + 5, 7, healthBarSize - 10, BAR_H - BAR_H + 5, Color(255,50,50) )
		SimpleTextOutlined( "Badass Psycho", "BLM_Class", -BAR_X + 8, 85, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,   8, Color(0,0,0) )
		SimpleTextOutlined( "23", "BLM_Level", -BAR_X - 60, 75, 	 Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 8, Color(0,0,0) )
	End3D2D()
end
hook.Add( "PostPlayerDraw", "blm_ranks_drawhitmarkers", ranks.hooks.PostPlayerDraw )

function ranks.hooks.HudPaint()
	
end
hook.Add( "HUDPaint", "blm_ranks_drawexp", ranks.hooks.HUDPaint )