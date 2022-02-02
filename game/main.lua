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
    NewChunk(0, 0, "overworld")
    
    local chunkObject = GetChunk(0, 0)

    chunkMesh = BuildChunkMesh(chunkObject)

    DumpChunkTableKeys()

end


function lovr.draw()

    lovr.graphics.push() -- White triangle
    lovr.graphics.setColor(1,1,1)
    lovr.graphics.translate(0, 0, -2)
    chunkMesh:draw(0,0,0)
    lovr.graphics.pop()

end