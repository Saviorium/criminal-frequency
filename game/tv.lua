tracks 	= require "data/sound/tracks"
Class = require "lib.hump.class"
Object = require "game.objects_on_table"

TV = Class {
    __includes = Object,
    init = function(self, x, y, width, height, scale, text_color, image)
       Object.init(self, x, y, width, height, scale, text_color)
       self.image = image
		image:setFilter("nearest", "nearest")
		self.spriteSheet:setFilter("nearest", "nearest")
		self.Blink =  peachy.new("data/graphics/dot.json", self.spriteSheet, "on" )
		self.Blink:setTag("blink")
    end,
    spriteSheet = love.graphics.newImage('data/graphics/dot.png')
}

function TV:draw()
	crew = Map.objects.PlayerCrew:getPoint()
	love.graphics.draw (self.image,
						self:get_piece_of_map( crew.x, crew.y ),
		                self.x * self.scale,
		                self.y * self.scale,
		                0,
		                self.scale,
		                self.scale)

    love.graphics.draw(background_image,
		               0,
		               0, 
		               0, 
		               self.scale, 
		               self.scale )
	self.Blink:draw((self.x + self.width/2 - 6) * self.scale, 
				    (self.y + self.height/2 - 6)  * self.scale,
				    0,
				    self.scale,
				    self.scale)
end


function TV:update( dt )
	self.Blink:update(dt)
end

function TV:set_blink( tag )
	self.Blink:setTag(tag)
end

function TV:get_piece_of_map( x, y )
	return love.graphics.newQuad( x - (self.width/2), y - (self.height/2), self.width, self.height, self.image:getDimensions())
end

return TV