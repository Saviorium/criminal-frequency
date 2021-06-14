fonts 			= require "data.fonts"
tracks 			= require "data/sound/tracks"
EM 				= require "game/event_manager"
Radio   		= require "game/radio"
Walkie_talkie   = require "game/walkie_talkie"
Clock   		= require "game/clock"
Map     		= require "game/map"
Police  		= require "game/police"
PlayerCrew  	= require "game/playercrew"
TextLine  		= require "game/textline"
TV 				= require "game/tv"
StateManager 	= require "lib.hump.gamestate"
require 'love.audio'
require 'love.math'
require 'conf'

loaded_tracks = {}
track_index = nil
background_image = nil
objects_on_table = {}

states = {game = require "game.states.game",
		  end_game = require "game.states.end_game",
		  controls = require "game.states.controls"}

function love.load() -- Запускается при запуске приложения
	love.window.setTitle("Criminal Frequency - LÖVE Jam 2020")
	StateManager.switch( states.controls )
end

function love.draw()
    StateManager.draw()
end

function love.update( dt ) -- Каждый кадр
    StateManager.update(dt)
end

function love.mousepressed(x, y)
	if StateManager.current().mousepressed then
		StateManager.current():mousepressed( x, y )
	end	
end

function love.wheelmoved( x, y )
	if StateManager.current().wheelmoved then
		StateManager.current():wheelmoved( x, y )
	end
end

function love.keypressed(key)
	if StateManager.current().keypressed then
		StateManager.current():keypressed(key)
	end
end
