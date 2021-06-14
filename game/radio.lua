tracks 	= require "data/sound/tracks"
Class = require "lib.hump.class"
peachy = require "lib.peachy.peachy"
Object = require "game.objects_on_table"

Radio = Class {
	__includes = Object,
	init = function(self, x, y, width, height, scale, text_color, timer_delay, accuracy, start_frequency, time_on_message, change_speed)
		Object.init(self, x, y, width, height, scale, text_color)
		self.timer_delay = timer_delay
		self.accuracy = accuracy 
		self.frequency = start_frequency
		self.time_on_message = time_on_message
		self.change_speed = change_speed
		
	end
}

Radio.Led_off = peachy.new("data/graphics/led.json", love.graphics.newImage("data/graphics/led.png"), "led-off")
Radio.Led_on = peachy.new("data/graphics/led.json", love.graphics.newImage("data/graphics/led.png"), "led-on")
Radio.Led = Radio.Led_off
Radio.sound_samples =  {tracks.list_of_sounds.police1,
						tracks.list_of_sounds.police2, 
						tracks.list_of_sounds.police3, 
						tracks.list_of_sounds.police4, 
						tracks.list_of_sounds.police5, 
						tracks.list_of_sounds.police6, 
						tracks.list_of_sounds.police7}

Radio.static_samples =  {tracks.list_of_sounds.radio_static,
						tracks.list_of_sounds.radio_static2, 
						tracks.list_of_sounds.radio_static3, 
						tracks.list_of_sounds.radio_static4}
Radio.sound = nil
Radio.timer = 1
Radio.text = ''
Radio.message_length = 0
Radio.channels = {
				police_off_freq = 	{
									name = 'Police official frequency',
									frequency = 100.5,
									queue = {},
									active_message={text = nil,
													  end_time = nil,
													  sound = nil
													 }
									},
				police_unoff_freq = {
									name = 'Police unofficial frequency',
									frequency = 96.8,
									queue = {},
									active_message={text = nil,
													  end_time = nil,
													  sound = nil
													 }
									},
				bank_sec_freq = 	{
									name = 'Bank security frequency',
									frequency = 91.2,
									queue = {},
									active_message={text = nil,
												  start_date = nil,
													  end_date = nil,
													  sound = nil
													 }
									}
			}

function Radio:get_sound()
	return Radio.sound_samples[math.floor(love.math.random(7))]
end

function Radio:set_frequency( df )
	if df > 0 and self.frequency < 110 then
    	self.frequency = self.frequency + df * self.change_speed
    end
    if df < 0 and self.frequency > 90 then
    	self.frequency = self.frequency + df * self.change_speed
    end
end

function Radio:put_message( channel, message, priority, date)
	for object_id, object in pairs(self.channels) do
		if object.name == channel then
			table.insert(object.queue, {text = message..' * * * ', 
										start_date = date,
										end_date = date + self.time_on_message, 
									    priority = priority, 
									    status = 'waiting'
									   }
						)
		end
	end 
end

function Radio:stop_message( object )
	if self.sound_playing then
		if self.sound_playing:isPlaying() then
			self.sound_playing:stop()
		end
	end
	self.Led = self.Led_off
	object.active_message = {text = nil,
					  		 sound = nil,
					  		 sound_status = nil
					  		}
end

function Radio:start_message( object, message )
	object.active_message = {text = message.text,
					  		 sound = self:get_sound(),
					  		 sound_status = 'wait'
					  		}
end

function Radio:get_next_symbol( frequency )
    for object_id, channel in pairs(self.channels) do
    	if channel.active_message.text then
			sym = string.sub( channel.active_message.text, 1, 1)
			channel.active_message.text = string.sub( channel.active_message.text, 2, string.len(channel.active_message.text))
		else
			sym = ' '
		end
    	if frequency < (channel.frequency + self.accuracy) and
    	   frequency > (channel.frequency - self.accuracy)  then
    	   	if channel.active_message.sound_status == 'wait' then
	    	   	self.sound_playing = tracks.play_sound( channel.active_message.sound )
				self.Led = self.Led_on
				channel.active_message.sound_status = 'activated'
			end 
    	   	return sym
    	end
    end 
    self.Led = self.Led_off
    local random = love.math.random(50)
    if random <= 4 then tracks.play_sound( Radio.static_samples[random] ) end
    random = love.math.random(5)
    return (random == 1) and '$' or ((random == 2) and '#' or ((random == 3) and '%' or ((random == 4) and '-' or '@')))
end

function Radio:get_text( curr_text, new_symbol)
	if objects_on_table.TextLine:check_width( curr_text ) and new_symbol then
		return string.sub( curr_text, 2, string.len(curr_text))..new_symbol
	else
		return curr_text..new_symbol
	end
end

function Radio:draw()
	love.graphics.setColor(self.text_color.r, self.text_color.g, self.text_color.b)
	love.graphics.setFont(fonts.numbers)
	love.graphics.printf(string.format('%.1f',self.frequency), 
						 (self.x + 5) * self.scale, 
						 (self.y + 15) * self.scale,
						 80 * self.scale,
						 "right")
	self.Led:draw((self.x + 138) * self.scale, 
				  (self.y - 25)  * self.scale,
				  0,
				  self.scale,
				  self.scale)
	love.graphics.setColor(255, 255, 255)
end

function Radio:update( dt )
	self.Led:update(dt)

	if self.timer < 0 then
	 	local symbol = self:get_next_symbol( self.frequency )
	 	self.text = self:get_text( self.text, symbol) 
    	objects_on_table.TextLine:get_printing_text( self.text )
    	self.timer  = self.timer_delay
	else
		self.timer = self.timer - (dt * objects_on_table.Clock:get_time_coeff())
	end

	for object_id, object in pairs(self.channels) do
    	if object.active_message.text and 
    	   string.len(object.active_message.text) == 0 
    	   then
    	   	self:stop_message( object )
    	   	self:get_next_message( object )
    	elseif object.active_message.text == nil then
    		self:get_next_message( object )
    	end
		for id, message in pairs(object.queue) do
	       if message.end_date < 0 then
				object.queue[id] = nil
				for index = id, table.getn(object.queue) do
						object.queue[index] = object.queue[index + 1]
				end
    	   else
    	   		message.end_date = message.end_date - (dt * objects_on_table.Clock:get_time_coeff())
    	   end
    	end 
    end 
end


function Radio:get_next_message( channel )
	if table.getn(channel.queue) > 0  then
	   	local cur_message = table.remove(channel.queue)
		table.sort(channel.queue, function( a, b ) return (b.priority > a.priority) or (b.priority == a.priority and b.start_date < a.start_date) end)
		self:start_message( channel, cur_message )
	end
end


function Radio:mouse_enter_event()
	if self.sound == nil then
		self.sound = tracks.play_sound( self:get_sound() )
	end
end

function Radio:mouse_exit_event()
	if self.sound then
		self.sound:stop()
		self.sound = nil
	end
end

return Radio