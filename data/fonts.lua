local fonts = {
	numbers = love.graphics.newFont("data/fonts/CursedTimerUlil-Aznm.ttf", 24 * scale), -- https://www.fontspace.com/heaven-castro/cursed-timer-ulil Freeware
	char    = love.graphics.newFont("data/fonts/CustomFontTtf12H20-mLWya.ttf", 16 * scale) 
}
fonts.numbers:setFilter( "nearest", "nearest" )
fonts.char:setFilter( "nearest", "nearest" )
return fonts