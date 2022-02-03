local xMax = 16;
local yMax = 128;
local ystride = xMax
local zstride = xMax * yMax


local function __index_to_pos(index)
    index = index - 1
    local z = math.floor( index / zstride)
    index = index % zstride
    local y = math.floor( index / ystride)
    index = index % ystride
    local x = math.floor(index)
    -- Returns a Tuple
    return x, y, z;
end

function BuildChunkMesh(chunk)
    local newChunkMesh
    -- This mesh is a single triangle
    newChunkMesh = lovr.graphics.newMesh({{"lovrPosition", "float", 3}, {"lovrNormal", "float", 3}}, 3, "fan", "static", false)

    local meshVertex = {}

    print("start " .. collectgarbage("count"))
    for i = 1, #chunk.blocks do
        local x,y,z = __index_to_pos(i)
        --print("x: " .. x .. " y: " .. y .. " z: " .. z)
    end
    print("end " .. collectgarbage("count"))


    meshVertex[#meshVertex + 1] = {0,0,0, 0,0,1}
    meshVertex[#meshVertex + 1] = {1,0,0, 0,0,1}
    meshVertex[#meshVertex + 1] = {0,1,0, 0,0,1}

    newChunkMesh:setVertices(meshVertex)
    
    return newChunkMesh
end