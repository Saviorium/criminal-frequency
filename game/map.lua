Street          = require "game.street"
Intersection    = require "game.intersection"
Police          = require "game/police"
PlayerCrew      = require "game/playercrew"
PoliceStation   = require "game/policestation"
DonutHouse      = require "game/donuthouse"
Bank            = require "game/bank"

local Map = {}

Map.intersections = {
    highgrave_maple_i    = Intersection(234, 467),
    maple_grandave_i    = Intersection(362, 467),
    mailroad_baker_brookwood_i = Intersection(119, 289),
    highgrave_mailroad_i   = Intersection(118, 350),
    daniels_baker_grandave_i   = Intersection(363, 289),
    brookwood_nails_i   = Intersection(119, 107),
    daniels_fair_i    = Intersection(265, 191),
    nails_fair_i   = Intersection(272, 51)
}

Map.streets = {
    maple     = Street(Map.intersections.highgrave_maple_i,          Map.intersections.maple_grandave_i,           "Maple St.",      130),
    highgrave = Street(Map.intersections.highgrave_maple_i,          Map.intersections.highgrave_mailroad_i,       "High Grave St.", 173),
    mailroad  = Street(Map.intersections.highgrave_mailroad_i,       Map.intersections.mailroad_baker_brookwood_i, "Mail Road St.",  65),
    baker     = Street(Map.intersections.mailroad_baker_brookwood_i, Map.intersections.daniels_baker_grandave_i,   "Baker St.",      240),
    grandave  = Street(Map.intersections.maple_grandave_i,           Map.intersections.daniels_baker_grandave_i,   "Grand ave.",     178),
    daniels   = Street(Map.intersections.daniels_baker_grandave_i,   Map.intersections.daniels_fair_i,             "Daniels St.",    138),
    brookwood = Street(Map.intersections.mailroad_baker_brookwood_i, Map.intersections.brookwood_nails_i,          "Brookwood St.",  182),
    nails     = Street(Map.intersections.brookwood_nails_i,          Map.intersections.nails_fair_i,               "Nails St.",      130),
    fair      = Street(Map.intersections.daniels_fair_i,             Map.intersections.nails_fair_i,               "Fair St.",       114)
}

Map.objects = {
    PlayerCrew = PlayerCrew(Map.streets.highgrave, 0.4, "GangBang", 7),
    Police_1   = Police(Map.streets.nails, 0.5, "Alpha 1", 8),
    Police_2   = Police(Map.streets.grandave, 0.5, "Bravo 5", 8),
    PoliceStation = PoliceStation(Map.streets.nails, 0.5, "BWPD"),
    Bank = Bank(Map.streets.highgrave, 0.4, "Arthur's Gold Bank"),
    DonutHouse = DonutHouse(Map.streets.baker, 0.6, "Donut's Hole")
}

Map.routes = {
    policeToBank = {
        direction = 1,
        streets = { Map.streets.highgrave, Map.streets.maple, Map.streets.grandave, Map.streets.daniels, Map.streets.fair, Map.streets.nails },
        destination = Map.objects.Bank
    },
    policeToDonuts = {
        direction = 1,
        streets = { Map.streets.baker, Map.streets.grandave },
        destination = Map.objects.DonutHouse
    }
}

Map.objects.Police_1:setStateRandom()
Map.objects.Police_2:setRoute(Map.routes.policeToDonuts)

function Map.update(dt)
    for id, object in pairs(Map.objects) do
        object:update( dt )
    end
end

return Map