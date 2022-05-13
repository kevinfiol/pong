local Object = require 'lib.classic'
local mishape = require 'lib.mishape'

local GameObject = Object:extend()

function GameObject:new(area, x, y)
    self.area = area
    self.x, self.y = x, y
    self.width = 1
    self.height = 1
    self.dead = false
end

function GameObject:update(dt)
end

function GameObject:draw()
end

function GameObject:destroy()
    self.dead = true
    self.area = nil
end

function GameObject:schema(schema, custom_map)
    if not DEBUG then return end -- define DEBUG in conf.lua
    local validator = mishape(schema, custom_map)

    local res = validator(self)
    if not res.ok then
        local error_string = '[mishape]: Schema Errors have occured:\n\t'
        for _, v in ipairs(res.errors) do
            error_string = error_string .. v .. '\n\t'
        end

        error(error_string)
    end
end

function GameObject:middle()
    return (self.x + self.width / 2), (self.y + self.height / 2)
end

return GameObject