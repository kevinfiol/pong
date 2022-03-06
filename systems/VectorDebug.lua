local Object = require 'lib.classic'

local VectorDebug = Object:extend()

local LINE_MAGNITUDE = 10

function VectorDebug:init()
end

function VectorDebug:update(dt)
end

function VectorDebug:draw()
    for _, e in ipairs(self.pool.groups.vectored.entities) do
        local x, y = e:middle()
        love.graphics.line(x, y, (x + e.vector.x * LINE_MAGNITUDE), (y + e.vector.y * LINE_MAGNITUDE))
    end
end

return VectorDebug