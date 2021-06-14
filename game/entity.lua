Class = require "lib.hump.class"
Vector = require "lib.hump.vector"

Entity = Class {
    init = function(self, street, position, maxSpeed, left_border, right_border)
        self.street = street
        self.position = position
        self.name = "Unknown entity"
        self.speed = 0
        self.maxSpeed = maxSpeed
        self.state = "stay"
        self.route = nil
    end
}

function Entity:getQudrant()
    x = self:getPoint().x / 50
    y = self:getPoint().y / 50
    return string.char(97 + x) .. math.ceil(y)
end

function Entity:getPoint()
    return self.street.start.position + ( self.street.ending.position - self.street.start.position ) * self.position
end

function Entity:handleIntersection()
    intersection = self.position > 0.5 and self.street.ending or self.street.start

    if self.state == 'random' then
        street = self:getRandomStreet()
        self:gotoStreet(street, intersection)
    end
    if self.state == 'goto' then
        street = self:getNextStreetInRoute()
        self:gotoStreet(street, intersection)
    end
    if self.state == 'stay' then
    end
end

function Entity:setState(state)
    self.state = state
end

function Entity:setStateRandom()
    self:setState("random")
    direction = love.math.random(2) == 1 and 1 or -1
    self.speed = self.maxSpeed * direction
end

function Entity:setRoute(route)
    self.route = route
    street = self:getNextStreetInRoute()
    if street == self.street then
        self:setState('goto')
        self.speed = self.maxSpeed * self.route.direction
    end
end

function Entity:getRandomStreet()
    streets = self:getStreetsForNextIntersection()
    return streets[love.math.random(table.getn(streets))]
end

function Entity:getNextStreetInRoute()
    if self.route then 
        street = table.remove(self.route.streets)
    end
    if not street or not street.start or not street.ending then
        self.speed = 0
        print(self.name .. "cant find street to go to")
        return
    end
    return street
end

function Entity:getStreetsForNextIntersection()
    intersection = self.speed > 0 and self.street.ending or self.street.start
    local streets = {}
    local n = 0
    for id, street in pairs(Map.streets) do
        if ( street.start == intersection or street.ending == intersection ) and street ~= self.street then
            n = n + 1
            streets[n] = street
        end
    end
    return streets
end

function Entity:gotoStreet(street, fromIntersection)
    if not street or not fromIntersection then
        print(self.name .. " can't go to new street, entity stopped!")
        self:stopMoving()
        return
    end
    if street.start == fromIntersection then
        self.position = 0.01
        self.street = street
        if self.speed < 0 then self.speed = -self.speed end
    elseif street.ending == fromIntersection then
        self.position = 0.99
        self.street = street
        if self.speed > 0 then self.speed = -self.speed end
    else
        print("Can't go to " .. street.name .. " from " .. self.street.name .. ", entity stopped!")
        self:stopMoving()
    end
end

function Entity:stopMoving()
    self:setState('stay')
    self.speed = 0
end

function Entity:reverse()
    if self.state == 'random' then self.speed = -self.speed end
end

function Entity:isColliding(other)
    if self.street ~= other.street then
        return false
    else
        return math.abs( ( other.position - self.position ) * self.street.length ) < 20
    end
end

function Entity:update( dt )
    if not dt then return end
    if self.state ~= 'stay' then
        if self.state == 'goto' and self:isColliding(self.route.destination) then
            self:stopMoving()
        print(self.name .. " arrived to destination")
            return
        end
        self.position = self.position + ((dt * objects_on_table.Clock:get_time_coeff()) * self.speed) / self.street.length
        if self.position < 0 or self.position > 1 then
            self:handleIntersection()
        end
    end
end

return Entity
