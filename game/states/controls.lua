require 'love.audio'
require 'love.math'
require 'conf'
--require "map"

local controls = {}

controls_image = love.graphics.newImage('data/graphics/controls.png')

function controls:enter() -- Запускается при запуске приложения
	love.graphics.setFont(fonts.numbers)
  image = controls_image
	image:setFilter("nearest", "nearest")
  self.timer = 10
end

function controls:draw()
	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(image,
                     0,
                     0, 
                     0, 
                     scale, 
                     scale )
end

function controls:update( dt )
end

function controls:mousepressed(x, y)
    StateManager.switch( states.game ) 
end

return controls