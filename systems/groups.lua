local Enum = require 'enum'

return {
    [Enum.Collision.Key] = {
        filter = Enum.Collision.RequiredProps
    },
    projectile = {
        filter = { 'speed', 'vector' }
    },
    vectored = {
        filter = { 'vector' }
    }
}