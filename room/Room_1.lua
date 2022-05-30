local Object = require 'lib.classic'
local Area = require 'engine.Area'
local vars = require 'vars'

local Walls = require 'elements.Walls'
local Player = require 'obj.Player'
local Paddle = require 'obj.Paddle'
local Ball = require 'obj.Ball'

local Room_1 = Object:extend()

local PADDLE_HEIGHT = 28
local START_X_OFFSET = 10
local MAX_BALLS = 1

function Room_1:new()
    self.area = Area(require 'systems.groups', {
        require 'systems.OffscreenDeath',
        require 'systems.BumpCollision',
        DEBUG and require 'systems.VectorDebug' or {}
    })

    self.walls = Walls(self.area)
    self.canvas = love.graphics.newCanvas(vars.gw, vars.gh)
    self.ball = nil
    self.enemy = nil

    local ball_count = 0

    local removeBall = function()
        ball_count = math.max(ball_count - 1, 0)
        self.ball = nil
    end

    local shootBall = bind(self, function(bound, x, y, vector)
        if ball_count >= MAX_BALLS then return end
        self.ball = Ball(bound.area, x, y, { vector = vector, onDestroy = removeBall })

        bound.area:queue({ self.ball })
        ball_count = ball_count + 1
    end)

    local player = Player(self.area, 0 + START_X_OFFSET, vars.gh / 2 - (PADDLE_HEIGHT / 2), {
        shootBall = shootBall,
        height = PADDLE_HEIGHT
    })

    self.enemy = Paddle(self.area, vars.gw - 8 - START_X_OFFSET, vars.gh / 2 - (PADDLE_HEIGHT / 2), {
        height = PADDLE_HEIGHT
    })

    self.area:queue({
        player,
        self.enemy
    })
end

function Room_1:update(dt)
    if self.area then
        self.area:update(dt)

        if self.ball then
            self.enemy:setPosition({ y = self.ball.y })
        end
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

    self.walls:destroy()

    self.area:destroy()
    self.area = nil
end

return Room_1