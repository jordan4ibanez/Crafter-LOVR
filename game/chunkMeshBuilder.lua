local __width = 16;
local __depth = 128;
local __xCalc = __depth * __width
local __zCalc = __depth

-- Reconstructs 1D table point to 3D position
local function __index_to_pos(index)
    index = index - 1

    local x = math.floor(index / __xCalc)
    index = index % __xCalc

    local z = math.floor(index / __zCalc)
    index = index % __zCalc

    local y = math.floor(index)

    -- Returns a Tuple
    return x, y, z;
end

-- Deconstructs 3D position to 1D table point
local function __pos_to_index(x, y, z)
    -- Returns an integer
	return math.floor((z * __zCalc) + (x * __xCalc) + y + 1)
end

-- Builds a single block of the chunk's mesh
local function __buildCube(x, y, z, width, height, texturePointX, texturePointY, meshVertex, vertexCount, indices)
    -- meshVertex is table driven, it's pointer is being utilized here, no need for return
    -- NOTE: this was * x,  * y,  * z
    meshVertex[vertexCount + 1] = {0,1,0, 0,0,1}
    meshVertex[vertexCount + 2] = {0,0,0, 0,0,1}
    meshVertex[vertexCount + 3] = {1,0,0, 0,0,1}
    meshVertex[vertexCount + 4] = {1,1,0, 0,0,1}

    indices = {
        -- Tri 1
        vertexCount + 1, vertexCount + 2, vertexCount + 4,

        -- Tri 2
        vertexCount + 4, vertexCount + 2, vertexCount + 3
    }

    vertexCount = vertexCount + 4

    return vertexCount, indices
end


function BuildChunkMesh(chunk)
    local newChunkMesh
    local meshVertex = {}
    local indices = {}


    local start = lovr.timer.getTime()
    print("----------STARTING TEST------------")
    print("start " .. collectgarbage("count"))
    local vertexCount = 0
    for i = 1,1 do
        local x,y,z = __index_to_pos(i)
        local index = __pos_to_index(x,y,z)

        --print("INTERNAL: " .. i .. " | CALCULATED: " .. index)

        -- if (i ~= index) then
            -- print("FAILURE AT: " .. i .. " IS EQUAL TO " .. index .. "! MATH MISCALCULATION!")
        -- end
        -- print("x: " .. x .. " y: " .. y .. " z: " .. z)
        vertexCount, indices = __buildCube(x,y,z,nil,nil,nil,nil,meshVertex, vertexCount, indices)

        x,y,z,index = nil,nil,nil,nil
    end
    print("end " .. collectgarbage("count"))
    print("Elapsed time: " .. lovr.timer.getTime() - start)
    print("------------TEST HAS ENDED----------------")

    -- This mesh is a single triangle
    newChunkMesh = lovr.graphics.newMesh({{ 'lovrPosition', 'float', 3 }, { 'lovrNormal', 'float', 3 }}, vertexCount, "triangles", "static", false)

    newChunkMesh:setVertices(meshVertex)

    newChunkMesh:setVertexMap(indices)
    
    return newChunkMesh
end