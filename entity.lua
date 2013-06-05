entity = {}
entity.__index = balloon
image = ""

function entity:new( group,x,y )
    local self = {}
    self = display.newImageRect(image)
    self.x, self.y = x, -y
    self.rotation = 0
    group:insert( self)

    function Update(event)
    end

    Runtime:addEventListener( "enterFrame", Update )

    return self
end


