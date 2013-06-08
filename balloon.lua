balloon = {}
balloon.__index = balloon
local image = "img/BALLOON_64X64.png"
local air = MAX_AIR

function balloon:new(group, x, y)
	local self = {}
	self = display.newImageRect(image, 90, 90)
	self.x, self.y =x,y
	self.rotation = 0

	physics.addBody(self, { density = BALLOON_DENSITY, friction = 0.3, bounce = 0.5, radius = 32 })
	self.isFixedRotation = true
	self.linearDamping = BALLOON_DAMPING
	group:insert(self)

	function pushBalloon(event)
		self:applyForce(0, -(BALLOON_FORCE), balloon.x, balloon.y)
		air = air - 10
	end

	Runtime:addEventListener("touch", pushBalloon)

	return self
end


