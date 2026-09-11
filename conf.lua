--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
function love.conf(t)
  t.window.width = 1080			--1920/480= 4 BOXES
  t.window.height = 480
  t.modules.joystick = false
  t.modules.physics = false
  t.version = "11.5"
  --t.identity = "RV-Events" --Stories" --".local/share/love/RV-Stories/Authors/"
  --  t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean)
  --t.window.fullscreen = false         -- Enable fullscreen (boolean) 1st
  t.window.fullscreentype = "desktop"
end
