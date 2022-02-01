require("dump")
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

end


function lovr.draw()
    local delta = lovr.timer.getDelta()
end