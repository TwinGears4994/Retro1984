--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
--]]
function playSound( _file )
	--"Sounds" IS THE DEFAULT FOLDER WE WILL LOOK INTO
			local source = love.audio.newSource( "Sounds/".. _file, "static" )
			love.audio.play( source )
end