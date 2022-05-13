local bump = require 'lib.bump'
local Object = require 'lib.classic'
local Enum = require 'enum'

local GROUP_NAME = Enum.Collision.Key
local CELL_SIZE = 64

local BumpCollision = Object:extend()

function BumpCollision:init()
    self.world = bump.newWorld(CELL_SIZE)
end

function BumpCollision:addToGroup(group_name, e)
    if group_name == GROUP_NAME then
        e.world = self.world
        self.world:add(e, e.x, e.y, e.width, e.height)
    end
end

function BumpCollision:update()
    for _, e in ipairs(self.pool.groups[GROUP_NAME].entities) do
        if e.dead then
            self.world:remove(e)
        else
            self.world:update(e, e.x, e.y, e.width, e.height)
        end
    end
end

return BumpCollision