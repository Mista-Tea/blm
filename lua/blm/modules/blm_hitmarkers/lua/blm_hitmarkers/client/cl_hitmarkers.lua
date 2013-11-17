------------------------------------------------------------------------------------------------------------------
--      		 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      	 	 	--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PLACEHOLDER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
--				 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	  	  		--
------------------------------------------------------------------------------------------------------------------

--[[	Changelog -- Added July 27th, 2013

]]

blm.util.PrintT( "Running client/cl_hitmarkers.lua" )

/**--------------------------------------------------------------------------------*
 *	------------------------------------------- NAMESPACE TABLES ----------------------------------------------  *
 *-------------------------------------------------------------------------------**/

local hitmarkers 		 = blm.hitmarkers
	  hitmarkers.hooks   = hitmarkers.hooks  or {}
	  hitmarkers.damage  = hitmarkers.damage or {}
	  
/**--------------------------------------------------------------------------------*
 *------------------------------ Local Variables ----------------------------------*
 *-------------------------------------------------------------------------------**/
	  
local BITS = 16
local MAX_NUMBER = 2 ^ BITS
local LeftOrRight = true

/**--------------------------------------------------------------------------------*
 *---------------------------- Localized Globals ----------------------------------*
 *-------------------------------------------------------------------------------**/
 
local cam 		= cam
local Start3D2D = cam.Start3D2D
local End3D2D   = cam.End3D2D

local draw 				 = draw
local RoundedBox 		 = draw.RoundedBox
local SimpleTextOutlined = draw.SimpleTextOutlined
 
local surface    = surface
local CreateFont = surface.CreateFont

local math  = math
local Rand  = math.Rand
local Clamp = math.Clamp

local Color  = Color
local Vector = Vector

local timer	  = timer
local IsValid = IsValid
local hook 	  = hook
local SysTime = SysTime
local net	  = net

/**--------------------------------------------------------------------------------*
 *------------------------------- BLM FUNCTIONS -----------------------------------*
 *-------------------------------------------------------------------------------**/

local emitter = ParticleEmitter( Vector(0,0,0), false ) 

net.Receive( "BL2Damage", function( len )
	local ply = net.ReadEntity()
	local dmg = net.ReadUInt( BITS )
	local r = net.ReadUInt( 8 )
	local g = net.ReadUInt( 8 )
	local b = net.ReadUInt( 8 )
	
	if ( !IsValid( ply ) ) then return; end
	
	local TIME = SysTime()
	
	hitmarkers.damage[ ply ] = hitmarkers.damage[ ply ] or {}
	hitmarkers.damage[ ply ][ TIME ] = { 
		X = Rand( -10, 10 ), 
		Y = Rand( 0, 25 ), 
		X_INC = ( LeftOrRight and Rand( 0, 0.25 ) ) or Rand( -0.25, 0 ),
		Y_INC = Rand( -0.01, 0 ), 
		ALPHA = 255,
		Damage = dmg,
		Side = LeftOrRight,
		Crit = ( dmg > 50 ),
		Pos = ply:GetPos(),
		Size = 0.5,
		Color = Color( r, g, b )
	}
	
	LeftOrRight = !LeftOrRight
	
	timer.Create( "bl2Damage"..TIME, 1.5, 1, function()
		if ( !IsValid( ply ) ) then hitmarkers.damage[ ply ]  		 = nil
		else						hitmarkers.damage[ ply ][ TIME ] = nil
		end
	end )

	--if ( !ply.Emitter ) then 
		ply.Emitter = emitter:Add( "effects/blood_core", ply:GetPos() + Vector(0,0,math.Rand(40,50)) )
		if ( ply.Emitter ) then
			ply.Emitter:SetColor( r,g,b )
			ply.Emitter:SetDieTime( 1 )
			ply.Emitter:SetLifeTime( 0 )
			ply.Emitter:SetStartSize( 30 )
			ply.Emitter:SetEndSize( 10 )
			ply.Emitter:SetAngles( Angle(math.Rand(0,360), math.Rand(0,360), math.Rand(0,360)) )
			emitter:Finish()
		end
	--end
end )
--[[--------------------------------------------------------------------------------]]

CreateFont( "DamageFontCrit", {font = "Trebuchet24", size = 40, weight = 800 } )
CreateFont( "DamageFont",  	  {font = "Trebuchet24", size = 36, weight = 700 } )

function hitmarkers.hooks.PostPlayerDraw( ply )
	if ( !IsValid( ply ) ) 			  then return; end
	if ( LocalPlayer() == ply ) 	  then return; end
	if ( !hitmarkers.damage[ ply ] )  then return; end
	
	local ang = (ply:GetPos() - LocalPlayer():GetPos()):Angle()
		  ang:RotateAroundAxis( ang:Forward(), 90 )
		  ang:RotateAroundAxis( ang:Right(),   90 )
		  
	local height_offset = Vector( 0,0, 80 )

	for TIME, tbl in pairs( hitmarkers.damage[ ply ] ) do 
		local pos = tbl.Pos + ang:Up() + height_offset
		Start3D2D( pos, Angle( 0, ang.y, ang.R ), tbl.Size )
			local col = tbl.Color
			local R, G, B = col.r, col.g, col.b
			
			if ( tbl.Crit ) then SimpleTextOutlined( "CRITICAL!", "DamageFontCrit",  -tbl.X, tbl.Y / 1.5, Color(255,0,0,tbl.ALPHA), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0, tbl.ALPHA) ) end
			SimpleTextOutlined( tbl.Damage, "DamageFont", tbl.X, tbl.Y, Color(R,G,B, tbl.ALPHA), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0, tbl.ALPHA) )

			tbl.Y = tbl.Y + tbl.Y_INC

			if ( SysTime() - TIME <  0.5 ) then	
				tbl.Y_INC = tbl.Y_INC - Rand( 0.0025, 0.005 )
			else								
				tbl.Y_INC = tbl.Y_INC + Rand( 0.0025, 0.01 )
				tbl.Size = Clamp( tbl.Size - 0.001, 0.01, tbl.Size )
				tbl.X_INC = tbl.X_INC + ( tbl.X_INC / 500 )
			end
			tbl.X = tbl.X + tbl.X_INC
		End3D2D()
	end
end
hook.Add( "PostPlayerDraw", "BLM_Hitmarkers_DrawDamage", hitmarkers.hooks.PostPlayerDraw )