tracks 	= require "data/sound/tracks"
Class = require "lib.hump.class"
Object = require "game.objects_on_table"

Walkie_talkie = Class {
	__includes = Object
}

Walkie_talkie.Led_off = peachy.new("data/graphics/led.json", love.graphics.newImage("data/graphics/led.png"), "led-off")
Walkie_talkie.Led_on = peachy.new("data/graphics/led.json", love.graphics.newImage("data/graphics/led.png"), "led-on")
Walkie_talkie.Led = Radio.Led_off

Walkie_talkie.sound_sample = tracks.list_of_sounds.bip_on
Walkie_talkie.sound = nil
Walkie_talkie.timer = 1
Walkie_talkie.text = ''
Walkie_talkie.message_length = 0

Walkie_talkie.active_message={text = nil,
				  			  end_time = nil,
				  			  sound = nil
				 			 }

function Walkie_talkie:put_message( message, end_date)
	self.active_message = 	{text = message, 
							 end_date = end_date,
							 sound = tracks.list_of_sounds.bip_on
							}
	self.Led = self.Led_on
	self.sound_playing = tracks.play_sound( self.active_message.sound )
end

function Walkie_talkie:stop_message()
	if self.sound_playing:isPlaying() then
		self.sound_playing:stop()
	end
	self.Led = self.Led_off
	self.active_message = 	{text = nil,
							 end_date = nil,
					  		 sound = nil
					  		}
end

function Walkie_talkie:draw()
	if self.active_message.text then
		love.graphics.setColor(self.text_color.r, self.text_color.g, self.text_color.b)
		love.graphics.setFont(fonts.char)
		love.graphics.printf(self.active_message.text, 
						     0,
						     30 * self.scale,
						     love.graphics.getWidth(), 
						     "center")
		love.graphics.setColor(255, 255, 255)
	end
	self.Led:draw((self.x + 10) * self.scale, 
				  (self.y + 50 ) * self.scale,
				  0,
				  self.scale,
				  self.scale)
end

function Walkie_talkie:update( dt )
	self.Led:update(dt)
	if self.active_message.end_date then
		if self.active_message.end_date < 0 then
			self:stop_message()
		else
			self.active_message.end_date = self.active_message.end_date - (dt * objects_on_table.Clock:get_time_coeff())
		end	
	end
end

function Walkie_talkie:mouse_enter_event()
	if self.sound == nil then
		-- self.sound = tracks.play_sound( self.sound_sample )
	end
end

function Walkie_talkie:mouse_exit_event()
	if self.sound then
		self.sound:stop()
		self.sound = nil
	end
end

function Walkie_talkie:on_mouse_click()
	self.sound = tracks.play_sound( self.sound_sample )
	Map.objects.PlayerCrew:get_palayer_callback()
end

return Walkie_talkie