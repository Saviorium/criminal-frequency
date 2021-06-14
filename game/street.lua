Class = require "lib.hump.class"
Vector = require "lib.hump.vector"

Street = Class{
    init = function (self, start, ending, name, length)
        self.start = start
        self.ending = ending
        self.name = name
        self.length = length
    end
}

return Street
