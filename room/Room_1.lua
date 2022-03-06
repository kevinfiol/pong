local Object = require 'lib.classic'
local Area = require 'engine.Area'
local vars = require 'vars'

local Player = require 'obj.Player'
local Paddle = require 'obj.Paddle'

local Room_1 = Object:extend()
local PADDLE_HEIGHT = 28

function Room_1:new()
    self.area = Area({
        projectile = {
            filter = { 'speed', 'vector' }
        },
        collider = {
            filter = { 'collision' }
        },
        vectored = {
            filter = { 'vector' }
        }
    }, {
        require 'systems.OffscreenDeath',
        require 'systems.Collision',
        DEBUG and require 'systems.VectorDebug' or {}
    })

    self.canvas = love.graphics.newCanvas(vars.gw, vars.gh)

    local player = Player(self.area, 10, vars.gh / 2 - (PADDLE_HEIGHT / 2), {
        height = PADDLE_HEIGHT
    })

    local paddle = Paddle(self.area, 140, vars.gh / 2 - (PADDLE_HEIGHT / 2), {
        height = PADDLE_HEIGHT
    })

    self.area:queue({ player, paddle })
end

function Room_1:update(dt)
    if self.area then
        self.area:update(dt)
    end
end

function Room_1:draw()
    if self.area then
        love.graphics.setCanvas(self.canvas)
        love.graphics.clear()

        -- draw begin
        -- camera:attach(0, 0, vars.gw, vars.gh)
        self.area:draw()
        -- camera:detach()

        -- draw end
        love.graphics.setCanvas()
        love.graphics.draw(self.canvas, 0, 0, 0, vars.sx, vars.sy)
    end
end

function Room_1:destroy()
    self.canvas:release()
    self.canvas = nil

    self.area:destroy()
    self.area = nil
end

return Room_1