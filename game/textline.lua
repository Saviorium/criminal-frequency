tracks 	= require "data/sound/tracks"
Class = require "lib.hump.class"
Object = require "game.objects_on_table"

TextLine = Class {
    __includes = Object,
    init = function(self, x, y, width, height, scale, text_color)
       Object.init(self, x, y, width, height, scale, text_color)
    end
}

function TextLine:draw()
	love.graphics.setFont(fonts.char)
	if self.text then
		love.graphics.printf(self.text..'|', 
						     self.x		* self.scale,
						     self.y		* self.scale, 
						     self.width * self.scale, 
						     "right")
	end
end

function TextLine:check_width( curr_text )
	if curr_text then
		return string.len(curr_text) == 56
	end
end

function TextLine:get_printing_text( text )	
	self.text = text
end

return TextLine