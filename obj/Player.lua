local lume = require 'lib.lume'
local baton = require 'lib.baton'
local vars = require 'vars'

local Paddle = require 'obj.Paddle'
local Ball = require 'obj.Ball'

local Player = Paddle:extend()

function Player:new(area, x, y, opts)
    opts = opts or {}
    Player.super.new(self, area, x, y, opts)

    self.input = baton.new({
        controls = {
            shoot = { 'mouse:1' }
        }
    })

    self:schema({
        input = 'table'
    })
end

function Player:update(dt)
    Player.super.update(self, dt)
    self.y = (vars.mouse.y / vars.sy) - self.height / 2

    self.input:update()
    self:shoot(dt)
end

function Player:draw()
    Player.super.draw(self)
end

function Player:shoot(dt)
    if self.input:pressed('shoot') then
        local x = self.x + self.width
        local y = self.y + (self.height / 2) - (Ball.static.HEIGHT / 2)
        local vector_x, vector_y = lume.vector(0, 0.05)

        self.area:queue({
            Ball(self.area, x, y, {
                vector = { x = vector_x, y = vector_y }
            })
        })
    end
end

function Player:destroy()
    self.input = nil
end

return Player