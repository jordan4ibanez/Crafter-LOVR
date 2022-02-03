require("window")
require("mouse")
require("info")
require("dump")
require("camera")
require("chunkMeshBuilder")
require("map")

-- lua locals
local
lovr 
= 
lovr

local chunkMesh


function lovr.load(args)
    InitializeWindow()

    NewChunk(0, 0, "overworld")

    local chunkObject = GetChunk(0, 0)

    chunkMesh = BuildChunkMesh(chunkObject)

    -- chunkMesh:release()
    -- chunkMesh = nil

    DumpChunkTableKeys()
end

function lovr.update(dtime)
    PollMouse()

    -- print(dump(GetMousePos()))
end


local rotate = 0
function lovr.draw()

    lovr.graphics.push() -- White triangle
    lovr.graphics.setColor(1,1,1)
    lovr.graphics.translate(0, 0, -2)
    lovr.graphics.rotate(rotate, 0, 1, 0)
    chunkMesh:draw(0,0,0)
    lovr.graphics.pop()

    rotate = rotate + lovr.timer.getDelta()
end