local Object = require 'lib.classic'
local Wall = require 'obj.Wall'
local vars = require 'vars'

local Walls = Object:extend()

function Walls:new(area)
    self.objs = {}
    self.area = area

    self.area:queue({
        Wall(area, vars.gw, 0, { width = 1, height = vars.gh }),
        Wall(area, 0, 0, { width = 1, height = vars.gh }),
        Wall(area, 0, 0, { width = vars.gw, height = 1 }),
        Wall(area, 0, vars.gh, { width = vars.gw, height = 1 })
    })

    -- if tiled_map.layers and tiled_map.layers.collidables then
    --     local walls = tiled_map.layers.collidables

    --     for _, object in ipairs(walls.objects) do
    --         table.insert(
    --             self.objs,
    --             Wall(area, object.x, object.y, {
    --                 width = object.width,
    --                 height = object.height,
    --                 collision_class = 'Wall'
    --             })
    --         )
    --     end

    --     area:addGameObjects(self.objs)
    -- end
end

function Walls:destroy()
    self.area = nil
    self.objs = nil
end

return Walls
