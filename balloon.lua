balloon = {}
balloon.__index = balloon
--local balloon = display.newImageRect("img/BALLOON_64X64.png", 90, 90)

function balloon:new( group )
    local self = {}
    self = display.newImageRect("img/BALLOON_64X64.png", 90, 90)
    self.x, self.y = 160, -100
    self.rotation = 0

    physics.addBody( self, { density=BALLOON_DENSITY, friction=0.3, bounce=0.5, radius = 32 } )
    self.isFixedRotation  = true
    self.linearDamping = BALLOON_DAMPING
    group:insert( self)

    function pushBalloon(event)
        self:applyForce(0,-(BALLOON_FORCE),balloon.x,balloon.y)
    end

    Runtime:addEventListener( "touch", pushBalloon )

    return self
end


