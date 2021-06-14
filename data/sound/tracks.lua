require 'love.audio'

local tracks = {}
-- https://freesound.org/people/crcavol/sounds/154654/
--bip_on.wav --https://freesound.org/people/JustinBW/sounds/70107/
--radio_static.wav --https://freesound.org/people/GowlerMusic/sounds/262267/
--tv_static.wav --https://freesound.org/people/Timbre/sounds/214757/
--1-11 1-10.wav --https://freesound.org/people/ERH/sounds/34419/
--police_talk_1.wav --https://freesound.org/people/Guardian2433/sounds/320351/
--police_talk_2.wav --https://freesound.org/people/Guardian2433/sounds/320351/
--police_talk_3.wav --https://freesound.org/people/Guardian2433/sounds/320351/
--police_talk_4.wav --https://freesound.org/people/Guardian2433/sounds/320351/
--police_talk_5.wav --https://freesound.org/people/Guardian2433/sounds/320351/
tracks.list_of_tracks = {}

tracks.list_of_sounds = {
	bip_on = {
		filepath = "data/sound/radio/bip_on.wav",
		loopPoint = 0,
		bpm = 160,
		volume = 0.1
	},
	tv_static = {
		filepath = "data/sound/radio/tv_static.wav",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	police1 = {
		filepath = "data/sound/radio/police1.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	police2 = {
		filepath = "data/sound/radio/police2.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	police3 = {
		filepath = "data/sound/radio/police3.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	police4 = {
		filepath = "data/sound/radio/police4.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	police5 = {
		filepath = "data/sound/radio/police5.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	police6 = {
		filepath = "data/sound/radio/police6.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	police7 = {
		filepath = "data/sound/radio/police7.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	policealarm = {
		filepath = "data/sound/radio/policealarm.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},

	radio_static = {
		filepath = "data/sound/radio/radio_static.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	radio_static2 = {
		filepath = "data/sound/radio/radio_static2.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	radio_static3 = {
		filepath = "data/sound/radio/radio_static3.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	},
	radio_static4 = {
		filepath = "data/sound/radio/radio_static4.ogg",
		loopPoint = 0,
		bpm = 160,
		volume = 0.01
	}
}

function tracks.set_next_track( index, loaded_tracks )
	loaded_tracks[index]:play()
	loaded_tracks[index]:on("end", tracks.set_next_track( index, loaded_tracks ))
	index = index + 1 
end

function tracks.play_sound( sound )
	source = love.audio.newSource( sound.filepath, 'static' )
	source:setVolume(sound.volume)
	source:play()
	return source
end


return tracks