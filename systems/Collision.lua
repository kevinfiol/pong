local bump = require 'lib.bump'
local Object = require 'lib.classic'

local Collision = Object:extend()

function Collision:init()
    self.world = bump.newWorld(64)
end

function Collision:addToGroup(group_name, e)
    if group_name == 'collider' then
        e.world = self.world
        self.world:add(e, e.x, e.y, e.width, e.height)
    end
end

function Collision:update()
    for _, e in ipairs(self.pool.groups.collider.entities) do
        if e.dead then
            self.world:remove(e)
        else
            self.world:update(e, e.x, e.y, e.width, e.height)
        end
    end
end

return Collision