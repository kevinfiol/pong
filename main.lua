local vars = require 'vars'
local RoomManager = require 'engine.RoomManager'
local Camera = require 'lib.camera'
local baton = require 'lib.baton'

local rooms
local debug_input
camera = Camera() -- global camera

local resize = function(s)
    love.window.setMode(s * vars.gw, s * vars.gh)
    vars.sx, vars.sy = s, s
end

function init()
    -- first room
    rooms:goToRoom('Room_1')
end

function love.load()
    if arg[#arg] == "-debug" then
        require("mobdebug").start()
    end

    if DEBUG then
        debug_input = baton.new({
            controls = {
                reset = { 'key:r' }
            }
        })
    end

    vars.mouse.x, vars.mouse.y = love.mouse.getPosition()

    rooms = RoomManager()

    -- scale window
    resize(2)

    -- adjust filter mode and line style for pixelated look
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    init()
end

function love.update(dt)
    if DEBUG then
        -- file hotswap
        require('lib.lurker').update()
        debug_input:update()

        if debug_input:pressed('reset') then
            init()
        end
    end

    if rooms.current_room then
        rooms.current_room:update(dt)
    end

    camera:update(dt)
    vars.mouse.x, vars.mouse.y = love.mouse.getPosition()
end

function love.draw()
    if rooms.current_room then
        rooms.current_room:draw()
    end
end
