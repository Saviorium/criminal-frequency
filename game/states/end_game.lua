require 'love.audio'
require 'love.math'
require 'conf'
--require "map"

local end_of_game = {}

screen_win = love.graphics.newImage('data/graphics/screen-win.png')
screen_lose = love.graphics.newImage('data/graphics/game-over.png')

function end_of_game:enter() -- Запускается при запуске приложения
	love.graphics.setFont(fonts.numbers)
  if Map.objects.PlayerCrew.state == 'in prison' then
    image = screen_lose
  else
    image = screen_win
  end
	image:setFilter("nearest", "nearest")
end

function end_of_game:draw()
	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(image,
                     0,
                     0, 
                     0, 
                     scale, 
                     scale )
end

function end_of_game:update( dt )
end

return end_of_game