Class = require "lib.hump.class"
Vector = require "lib.hump.vector"
Entity = require "game.entity"

DonutHouse = Class {
    __includes = Entity,
    init = function(self, street, position, name)
        Entity.init(self, street, position, 0)
        self.name = name
    end
}

function DonutHouse:update( dt )

end

return DonutHouse
