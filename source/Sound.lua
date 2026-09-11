--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
--]]
function playSound( _file )
	local _sound = love.audio.newSource( "Sounds/" .._file, "static" )
	love.audio.play( _sound )
end