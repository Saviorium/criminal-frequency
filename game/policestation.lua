Class = require "lib.hump.class"
Vector = require "lib.hump.vector"
Entity = require "game.entity"

PoliceStation = Class {
    __includes = Entity,
    init = function(self, street, position, name)
        Entity.init(self, street, position, 0)
        self.name = name
        self.isAlarmed = false
        self.timer_to_send_forces = 0
    end
}

function PoliceStation:update( dt )
    if self.timer_to_send_forces < 0 and self.isAlarmed and not Map.objects.Swat then
        self:spawn_swat()
    else
        self.timer_to_send_forces = self.timer_to_send_forces - (dt * objects_on_table.Clock:get_time_coeff())
    end
end

function PoliceStation:change_alarm()
    self.isAlarmed = not self.isAlarmed
    self.timer_to_send_forces = 10
    Map.objects.Police_2:setStateRandom()
    objects_on_table.Radio:put_message('Police official frequency', 'Attention all units! Bank robbery at ' .. Map.objects.Bank.name .. '! Sending reinforcment unit.', 5, 10)
end

function PoliceStation:spawn_swat()
    swat = Police(Map.streets.nails, 0.5, "Delta "..love.math.random(10), 6)
    swat:setRoute(Map.routes.policeToBank)
    Map.objects.Swat = swat
    objects_on_table.Radio:put_message('Police official frequency', 'This is ' .. self.name .. ': SWAT unit dispatched!', 5, 10)
end

function PoliceStation:isAlarm()
    return self.isAlarmed
end

return PoliceStation
