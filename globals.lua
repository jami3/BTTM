
BALLOON_DENSITY = 0.1
BALLOON_DAMPING  = 1.8
BALLOON_FORCE = (300 * BALLOON_DENSITY ) * BALLOON_DAMPING
MAX_AIR = 1000

local function physicsToggle(event)

        if ( debugDraw ) and ( event.phase == "began" ) then
            physics.setDrawMode( "normal" )
            debugDraw = false
        elseif ( not debugDraw ) and ( event.phase == "began" ) then
	        physics.setDrawMode("debug")
            debugDraw = true
        end

end
