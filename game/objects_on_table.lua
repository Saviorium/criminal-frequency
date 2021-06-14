Class = require "lib.hump.class"

Object = Class {
    init = function(self, x, y, width, height, scale, text_color)
	    self.x 	 = x
		self.y 	 = y
		self.width  = width
		self.height = height
		self.scale = scale
		self.text_color = {r = text_color.r,
						    g = text_color.g, 
						    b = text_color.b
						   }
    end
}

Object.active_status = 'inactive'

function Object:draw()
end

function Object:update( dt )
end

function Object:mouse_enter_event()
end

function Object:mouse_exit_event()
end

function Object:get_collision( x, y)
	return 	self.x * self.scale  < x and 
			(self.x + self.width) * self.scale  > x and
			self.y * self.scale < y and 
			(self.y + self.height) * self.scale > y
end

function Object:set_status( status )
	self.active_status = status
end

function Object:get_status()
	return 	self.active_status
end

function Object:on_mouse_click()
end

return Object
