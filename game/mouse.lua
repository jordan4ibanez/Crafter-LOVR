local mouse = require("lovr-libraries.lovr-mouse")

local posX = 0
local posY = 0
local oldPosX = 0
local oldPosY = 0

function PollMouse()
    posX, posY = mouse.getPosition()
end

function GetMousePos()
    return{posX, posY}
end