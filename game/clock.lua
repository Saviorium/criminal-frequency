tracks 	= require "data/sound/tracks"
Class = require "lib.hump.class"
Object = require "game.objects_on_table"

Clock = Class {
    __includes = Object,
    init = function(self, x, y, width, height, scale, text_color, start_time, time_coeff)
       Object.init(self, x, y, width, height, scale, text_color)
       self.time = start_time
       self.time_coeff = time_coeff
    end
}

function Clock:draw()
	love.graphics.setColor(self.text_color.r, self.text_color.g, self.text_color.b)
	local time = self:get_curdate()
	love.graphics.setFont(fonts.numbers)
	love.graphics.printf(string.format('%02d:%02d',time.hours,time.minutes), 
						 (self.x  + 10) * self.scale, 
						 (self.y  + 13) * self.scale,
						 100 * self.scale,
						 "left")
	love.graphics.setColor(255, 255, 255)
end

function Clock:update( dt )
	self.time = self.time + (dt * self.time_coeff)
end

function Clock:get_curdate()
	return {hours   = math.floor(self.time/60 - 24 * math.floor(self.time/60/24)),
		    minutes = math.floor(self.time-60 * math.floor(self.time/60))
		   }
end
function Clock:get_time()
	return self.time
end
function Clock:get_time_coeff()
	return self.time_coeff
end
return Clock