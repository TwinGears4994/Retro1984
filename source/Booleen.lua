--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/Retro1984
]]
function uLogicFLIP(_bool)
    if _bool then
        return false
    else
        return true
    end
end

function ufullSCRN()
    if fullSCRN then
        modes = love.window.getFullscreenModes()
        --table.sort(modes, function(a, b) return a.width*a.height < b.width*b.height end)
        WINDOW_WIDTH = modes[1].width
        WINDOW_HEIGHT = modes[1].height
        love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
        love.window.setFullscreen(true)
        return true
    else
        --GOING TO NEED OBJECT/IMAGE SIZE *2
        WINDOW_WIDTH = 454 *2   --240 *2
        WINDOW_HEIGHT = 454     --240
        love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
        love.window.setFullscreen(false)
        return false
    end
end

function buttonSwap(_button)
    if _button == "x" then   --BLUE
        return false, false, true
--        elseif button == "y" then   --YELLOW
--            joyYAlpha
    elseif _button == "a" then   --GREEN
        return false, true, false
    elseif _button == "b" then   --RED
        return true, false, false
    end
end