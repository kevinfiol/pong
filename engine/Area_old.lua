local Object = require 'lib.classic'

local Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    for i = #self.game_objects, 1, -1 do
        self.game_objects[i]:update(dt)

        if self.game_objects[i].dead then
            self.game_objects[i]:destroy()
            table.remove(self.game_objects, i)
        end
    end
end

-- draw gets called before update when a new object is added
function Area:draw()
    for _, game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end

function Area:destroy()
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:destroy()
        table.remove(self.game_objects, i)
    end

    self.game_objects = {}
    self.room = nil
end

function Area:addGameObjects(game_objects)
    for _, game_object in pairs(game_objects) do
        table.insert(self.game_objects, game_object)
    end
end

return Area