fonts 			= require "data.fonts"
tracks 			= require "data/sound/tracks"
EM 				  = require "game/event_manager"
Radio   		= require "game/radio"
Walkie_talkie   = require "game/walkie_talkie"
Clock   		= require "game/clock"
Map     		= require "game/map"
Police  		= require "game/police"
PlayerCrew  = require "game/playercrew"
TextLine  	= require "game/textline"
TV 				  = require "game/tv"
Gamestate   = require "lib.hump.gamestate"
require 'love.audio'
require 'love.math'
require 'conf'
--require "map"

local game = {}
loaded_tracks = {}
track_index = 1
background_image = love.graphics.newImage('data/graphics/background.png')
objects_on_table = {Clock 			   = Clock			    (260, 165, 110, 45 , scale,{r = 255, g = 0  , b = 0  }, 7100, 0.5),
          					TV				     = TV			        (37 , 120, 155, 120, scale,{r = 255, g = 0  , b = 0  }, love.graphics.newImage('data/graphics/map.png')),
          					Radio 			   = Radio			    (247, 215, 190, 55 , scale,{r = 255, g = 0  , b = 0  }, 0.04, 0.5, 100.0, 10, 0.1, 0.1),
          					Walkie_talkie  = Walkie_talkie	(215, 205, 45 , 60 , scale,{r = 255, g = 255, b = 255}),
          					TextLine 		   = TextLine		    (5  , 277, 460, 20 , scale,{r = 255, g = 0  , b = 0  })}

function game:enter() -- Запускается при запуске приложения
	love.graphics.setFont(fonts.numbers)
	background_image:setFilter("nearest", "nearest")
end

function game:mousepressed(x, y)
    EM.mouse_click()
end

function game:wheelmoved(x, y)
    objects_on_table.Radio:set_frequency(y)
end

function game:keypressed( key ) -- кнопка нажата
	if key == "right" then
        objects_on_table.Radio:set_frequency(1)
    end
    if key == "left" then
       objects_on_table.Radio:set_frequency(-1)
    end
end

function game:draw() -- отрисовка каждый кадр?
	love.graphics.setColor(255, 255, 255)
    for id, object in pairs(objects_on_table) do
		object:draw()
	end
end

function game:update( dt ) -- Каждый кадр
  EM.update()
  for id, object in pairs(objects_on_table) do
	 object:update( dt )
  end  
  
  Map.update(dt)
end

return game