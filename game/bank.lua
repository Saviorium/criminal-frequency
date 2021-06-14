Class = require "lib.hump.class"
Vector = require "lib.hump.vector"
Entity = require "game.entity"

Bank = Class {
    __includes = Entity,
    init = function(self, street, position, name)
        Entity.init(self, street, position, 0)
        self.name = name
        self.isGuarded = true
        self.timer_to_change = 30
    end
}

function Bank:update( dt )
	if not Map.objects.PoliceStation:isAlarm() then
		if Map.objects.PlayerCrew.state ~= 'waiting for start' and self.isGuarded and not self.timer_to_alarm then
			self.timer_to_alarm = 10
	    	objects_on_table.Radio:put_message('Bank security frequency', 'There is a robbery. Call the cops!', 3, 5)
	    end
	    if self.timer_to_alarm then
			if self.timer_to_alarm < 0 then
				Map.objects.PoliceStation:change_alarm()
				self.timer_to_alarm = 9999
		    else
		    	self.timer_to_alarm = self.timer_to_alarm - (dt * objects_on_table.Clock:get_time_coeff())
		    end
		end
	end
    if self.timer_to_change < 0 then
    	self:change_guard()
    	self.timer_to_change = 30
    else
    	self.timer_to_change = self.timer_to_change - (dt * objects_on_table.Clock:get_time_coeff())
    end
    
end

function Bank:get_message_guard_off()
	n = love.math.random(3)
	if n == 1 then return 'Want some sle-aa-z-z-z-z' end
	if n == 2 then return 'I need to get some coffee. One sec...' end
	return 'I need to get some coffee. One sec...'
end

function Bank:change_guard()
    self.isGuarded = not self.isGuarded
    if self.isGuarded then
    	objects_on_table.Radio:put_message('Bank security frequency', 'Going to duty', 3, 10)
    else
		objects_on_table.Radio:put_message('Bank security frequency', self:get_message_guard_off(), 3, 10)
    end
end

return Bank
