local lume = require 'lib.lume'
local GameObject = require 'engine.GameObject'

local Ball = GameObject:extend()

Ball.static = {
    WIDTH = 6,
    HEIGHT = 6,
    SPEED = 1
}

function Ball:new(area, x, y, opts)
    opts = opts or {}
    Ball.super.new(self, area, x, y)

    self.collision = { class = 'projectile' }
    self.width = opts.width or Ball.static.WIDTH
    self.height = opts.height or Ball.static.HEIGHT
    self.speed = opts.speed or Ball.static.SPEED
    self.vector = opts.vector or { x = 0, y = 0 }

    self:schema({
        x = 'number',
        y = 'number',
        width = 'number',
        height = 'number',
        world = 'table|nil',
        collision = {
            class = 'string'
        },
        vector = {
            x = 'number',
            y = 'number'
        }
    })
end

function Ball:update(dt)
    if self.world then
        local x = self.x + (self.speed * self.vector.x)
        local y = self.y + (self.speed * self.vector.y)
        local cols
        local len

        x, y, cols = self.world:move(self, x, y, function(item, other)
            return 'bounce'
        end)

        self.x = x
        self.y = y

        if #cols > 0 then
            -- local col = cols[1]
            -- local normal = col.normal
            -- inspect(normal)

            -- local vx, vy = lume.vector(math.pi, 0.05)
            -- self.vector.x = vx
            -- self.vector.y = vy

            -- print('col')
            -- local vector = cols[1].bounce
            -- self.vector.x = vector.x
            -- self.vector.y = vector.y
        end
    end
end

function Ball:draw()
    love.graphics.rectangle(
        'line',
        self.x,
        self.y,
        self.width,
        self.height
    )
end

function Ball:destroy()
    self.width = nil
    self.height = nil
    self.vector = nil
end

return Ball