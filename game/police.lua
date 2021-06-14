Class = require "lib.hump.class"
Vector = require "lib.hump.vector"
Entity = require "game.entity"

Police = Class {
    __includes = Entity,
    init = function(self, street, position, name, maxSpeed)
        Entity.init(self, street, position, maxSpeed)
        self.name = name
        self.state = "stay"
        self.nextReport = 0
        self.flud_cnt = 10
    end
}

function Police:sendReport()
    if not objects_on_table then return end
    local selfName = love.math.random(2) == 1 and "It's " .. self.name .. '. ' or self.name .. ' reporting in!'
    if self.state == 'random' then
        objects_on_table.Radio:put_message('Police official frequency', selfName .. ' Patrolling '..self:getQudrant(), 3, 5)
        self.nextReport = objects_on_table.Clock:get_time() + love.math.random(10, 20)
    end
    if self.state == 'goto' then
        if self.route then
            objects_on_table.Radio:put_message('Police official frequency', selfName .. ' Moving to location. Now at ' ..self:getQudrant(), 3, 5)
        end
        self.nextReport = objects_on_table.Clock:get_time() + love.math.random(20, 30)
    end
    if self.state == 'stay' then
        objects_on_table.Radio:put_message('Police official frequency', selfName .. ' Stationary at ' ..self:getQudrant(), 3, 5)
        self.nextReport = objects_on_table.Clock:get_time() + love.math.random(30, 50)
    end
end

function Police:setState(state)
    self.state = state
    if not objects_on_table then return end
    if self.state == 'random' then
        objects_on_table.Radio:put_message('Police official frequency', 'Roger! ' .. self.name .. ' Started patrolling', 3, 5)
        self.nextReport = objects_on_table.Clock:get_time() + love.math.random(10, 20)
    end
    if self.state == 'goto' then
        if self.route then
            objects_on_table.Radio:put_message('Police official frequency', 'Roger that! ' .. self.name .. ' Moving to ' .. self.route.destination.name, 3, 5)
        end
        self.nextReport = objects_on_table.Clock:get_time() + love.math.random(30, 50)
    end
    if self.state == 'stay' then
        objects_on_table.Radio:put_message('Police official frequency', self.name .. ' is stationed at ' .. self:getQudrant(), 3, 5)
        self.nextReport = objects_on_table.Clock:get_time() + love.math.random(30, 50)
    end
end


function Police:flud_in_chat( dt )
    if not Map.objects.PoliceStation:isAlarm() then
        if self.flud_cnt < 0 then
            self.flud_cnt = love.math.random(25)
            objects_on_table.Radio:put_message('Police unofficial frequency', self:get_flud(), 1, 7)    
        else
            self.flud_cnt = self.flud_cnt - (dt * objects_on_table.Clock:get_time_coeff())
        end
    end
end

function Police:get_flud()
    n = love.math.random(100)
    if n < 5 then return 'Yesterday saw a lot of nice girls at a cafe, come with me next time.' end
    if n < 10 then return 'Today I will break your record at the Jenkins shooting range' end
    if n < 20 then return 'The weather today is calm' end
    if n < 25 then return 'Alright, found the drunk driver, over' end
    if n < 40 then return 'I *** hate night shifts' end
    if n < 45 then return 'Who left that old pizza in my car?' end
    return ''
end

function Police:get_donuts_flud()
    n = love.math.random(4)
    if n == 1 then return 'Gonna take some more Donuts. So tasty.' end
    if n == 2 then return 'It\'s a good night to rest. I hope it ends soon and I will go to bed.' end
    if n == 3 then return 'Mmmm... doughnuts' end
    return 'Hey, Lebowski, do you want to come over?'
end

function Police:update( dt )
    Entity.update(self, dt)
    if self.nextReport < objects_on_table.Clock:get_time() then
        self:sendReport()
    end
    if self:isColliding(Map.objects.PlayerCrew) then
      if Map.objects.PlayerCrew.state ~= 'hidden' and Map.objects.PoliceStation:isAlarm() then
        Map.objects.PlayerCrew:get_caught()
        print("POLICE!!!")
        objects_on_table.Radio:put_message('Police official frequency', self.name .. ' reporting in! Suspect spotted! Proceeding to arrest', 5, 10)
        Map.objects.PoliceStation.isAlarmed = false
      end
    end

    self:flud_in_chat( dt )

    if self:isColliding(Map.objects.DonutHouse) and not Map.objects.PoliceStation:isAlarm() then
        if self.more_donut then
            if self.more_donut < 0 then
                self.more_donut = love.math.random(10,25)
                objects_on_table.Radio:put_message('Police unofficial frequency', self:get_donuts_flud(), 1, 7)    
            else
                self.more_donut = self.more_donut - (dt * objects_on_table.Clock:get_time_coeff())
            end
        else
            objects_on_table.Radio:put_message('Police unofficial frequency', 'I want to get some doughnuts, stop for a while', 5, 10)
            self.more_donut = love.math.random(10,25)
        end
    end 
end

return Police
