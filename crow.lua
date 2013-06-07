crow = {}
crow.__index = crow
local image = "img/CROW.png"

function crow:new(group, x, y)

	local self = {}
	self = display.newImage(image)
	print(image)
	self.x, self.y = x, -y
	self.speed = 100
	local bounding = { 0, 0, -8, 9, -16, 15, -29, 26, -16, 28, -16, 44, 19, 43, 19, 35, 32, 23, 19, 16, 18, 2 }

	physics.addBody(self, "kinematic", { density = 0, friction = 0.3, bounce = 0.5, radius = 32, shape = bounding })
	self.isFixedRotation = true
	self.linearDamping = BALLOON_DAMPING
	self:setLinearVelocity(self.speed, 0)

	self.rotation = 0
	group:insert(self)

	function Update(event)

		if (self.x > 320 + self.width) then
			self:setLinearVelocity(-self.speed, 0)
		elseif (self.x < -self.width) then
			self:setLinearVelocity(self.speed, 0)
		end

		image = "img/CROW_FACE_LEFT.png"
	end

	Runtime:addEventListener("enterFrame", Update)

	return self
end