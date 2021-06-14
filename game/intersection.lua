Class = require "lib.hump.class"
Vector = require "lib.hump.vector"

Intersection = Class{
    init = function (self, x, y)
        self.position = Vector(x, y)
    end
}

return Intersection
