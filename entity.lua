entity = {}
entity.__index = entity
local image = ""

function entity:new( group,x,y )
    local instance = {group=group,x=x,y=y}
    setmetatable(instance, { __index = self})
    return instance
end


