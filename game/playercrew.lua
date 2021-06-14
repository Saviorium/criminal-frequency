Class = require "lib.hump.class"
Vector = require "lib.hump.vector"
Entity = require "game.entity"

PlayerCrew = Class {
    __includes = Entity,
    init = function(self, street, position, name, default_speed)
        Entity.init(self, street, position, default_speed, 0.3, 0.7)
        self.name  = name
        self.state = "waiting for start"
        self.default_speed = default_speed
        self.speed = 0
        self.direction = 1
		self.route = {street}
		self.money = 0
    end
}

function PlayerCrew:update(dt)
    if not dt then return end
	if self.state ~= 'stay' then
        if self.state == 'goto' and self:isColliding(self.route.destination) then
            self:stopMoving()
            return
        end
        self.position = self.position + ((dt * objects_on_table.Clock:get_time_coeff()) * self.speed) / self.street.length
        if self.position < 0.3 or self.position > 0.7 then
            self:handleIntersection()
        end
	end
	

	if self.state == "ambushing" then
		if self.time_to_leave <= 0 then
			if self.money == 0 then self.money = 3000000 end
			self:ask_about_direction()
		else 
			self.time_to_leave = self.time_to_leave - (dt * objects_on_table.Clock:get_time_coeff())
		end
	elseif self.state == "stay" then
		if self.time_to_sneak then
			if self.time_to_sneak <= 0 then
				self.state = "hidden"
				objects_on_table.TV:set_blink("off")
				objects_on_table.Walkie_talkie:put_message('We are hidden now and are waiting for your command.', 5)
			else 
				self.time_to_sneak = self.time_to_sneak -(dt * objects_on_table.Clock:get_time_coeff())
			end
		end
	elseif self.state == "changing direction" then
		if self.time_to_leave <= 0 then
   	 		self.state = "random"
			objects_on_table.TV:set_blink("on")
   	 		self.speed = self.maxSpeed * self.direction
		else 
			self.time_to_leave = self.time_to_leave -(dt * objects_on_table.Clock:get_time_coeff())
		end
	end
	if self.position < 0 or self.position > 1 then
		self:gotoStreet( self.target_street, self.target_intersection )
		if self.target_street.start == self.target_intersection then self.direction = 1 end
		if self.target_street.ending == self.target_intersection then self.direction = 1 end
   	 	self.state = "random"
    end
end

function PlayerCrew:get_palayer_callback()
	if self.state == "waiting for start" then
		self:start_mission()
	elseif self.state == "ambushing" then
		self:force_out()
	elseif self.state == "waiting for order" then
		self:change_path()
	elseif self.state == "changing direction" then
		self:change_direction()
		self.time_to_leave = 0
	elseif self.state == "random" or self.state == "driving" then
		self:sneak()
	elseif self.state == "hidden" then
		self:ask_about_direction()
	elseif self.state == "in prison" then 
		StateManager.switch(states.end_game, screen_lose)
	elseif self.state == 'escaped' then
		StateManager.switch(states.end_game, screen_win)
	end
end

function PlayerCrew:start_mission()
	objects_on_table.Walkie_talkie:put_message('We started to break in, call us if police near.', 5)
	self.state = "ambushing"
	self.time_to_leave = 30
end

function PlayerCrew:force_out()
	objects_on_table.Walkie_talkie:put_message('Ok, bro. Guys we need to pack this up and leave.', 5)
	if self.time_to_leave > 5 then
		self.money = math.ceil((30 - self.time_to_leave) * 100000)
		self.time_to_leave = 5
	end 
end

function PlayerCrew:getTime()
	return string.format("%.2f", objects_on_table.Clock:get_time() - 7100)
end

function PlayerCrew:change_path( street )
	objects_on_table.Walkie_talkie:put_message('Turning on '..self.change_street.name, 5)
	self.target_street = self.change_street
	self.state = "driving"
end

function PlayerCrew:change_direction()
	objects_on_table.Walkie_talkie:put_message('Going in oposite way.', 5)
   	self.direction = -self.direction
end

function PlayerCrew:sneak()
	objects_on_table.Walkie_talkie:put_message('Tssh, quiet.', 5)
    Entity.stopMoving(self)
	self.time_to_sneak = 5
end

function PlayerCrew:ask_about_direction()
	objects_on_table.Walkie_talkie:put_message('Should we go in the opposite direction?', 5)
	self.state = "changing direction"
	self.time_to_leave = 3
end

function Entity:getRandomStreet()
    streets = Entity:getStreetsForNextIntersection(self)
    return streets[love.math.random(table.getn(streets))]
end

function PlayerCrew:ask_about_change_path()
	objects_on_table.Walkie_talkie:put_message('Should we go to '..self.change_street.name..'?', 5)
	self.state = "waiting for order"
end

function PlayerCrew:handleIntersection()
    self.target_intersection = self.position > 0.5 and self.street.ending or self.street.start

    if self.target_intersection == Map.intersections.nails_fair_i and self.state ~= 'escaped' then
    	self.state = 'escaped'
    	self.speed = 0
		objects_on_table.TV:set_blink("blink")
		objects_on_table.Walkie_talkie:put_message('We did it, team! Good job!\nWe got ' .. self.money .. '$ and escaped in ' .. self:getTime() .. ' minutes.', 5)
    end
    if self.state == 'random' then
        self:getRandomStreet()
    end
end

function PlayerCrew:getRandomStreet()
    streets = self:getStreetsForNextIntersection()
	if table.getn(streets) > 1 then
		self.change_street = streets[2]
		self:ask_about_change_path()
	end
	self.target_street = streets[1]
end

function PlayerCrew:get_caught()
    self.state = 'in prison'
    self.speed = 0
	objects_on_table.TV:set_blink("red")
end


return PlayerCrew
