local lume = require 'lib.lume'
local utils = require 'engine.utils'
local vector = require 'engine.vector'
local GameObject = require 'engine.GameObject'
local Enum = require 'enum'

local Ball = GameObject:extend()

Ball.static = {
    WIDTH = 6,
    HEIGHT = 6,
    SPEED = 3,
    MAX_SPEED = 30,
    SPEED_INCREMENT = 0.025
}

function Ball:new(area, x, y, opts)
    opts = opts or {}
    Ball.super.new(self, area, x, y)

    self.collision = { class = Enum.Collision.Class.Projectile }
    self.width = opts.width or Ball.static.WIDTH
    self.height = opts.height or Ball.static.HEIGHT
    self.speed = opts.speed or Ball.static.SPEED
    self.vector = opts.vector or { x = 0, y = 0 }
    self.onDestroy = opts.onDestroy or GameObject.static.noop

    self:schema({
        x = 'number',
        y = 'number',
        width = 'number',
        height = 'number',
        world = 'table|nil',
        onDestroy = 'function',
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

        -- check for any corrections from bump
        x, y, cols = self.world:move(self, x, y, function(_, other)
            if other.collision.class == Enum.Collision.Class.Projectile then
                return false
            end

            return 'bounce'
        end)

        -- set corrected x,y from bump
        self.x = x
        self.y = y

        -- check for collisions from bump
        if #cols > 0 then
            self.speed = math.min(self.speed + Ball.static.SPEED_INCREMENT, Ball.static.MAX_SPEED)
            local normal = cols[1].normal
            local v = vector.reflect(self.vector, normal)
            self.vector.x = v.x
            self.vector.y = v.y

            local add_randomness = lume.randomchoice({ true, true, false })
            if add_randomness then
                local weight = lume.random(-0.80, 0.80)

                if v.x == 0 then
                    self.vector.x = v.x + weight
                elseif v.y == 0 then
                    self.vector.y = v.y + weight
                else
                    weight = lume.random(-0.10, 0.10)
                    local axis = lume.randomchoice({ 'x', 'y' })
                    self.vector[axis] = v[axis] + weight
                end
            end
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
    self.onDestroy()
    self.width = nil
    self.height = nil
    self.vector = nil
    Ball.super.destroy(self)
end

return Ball