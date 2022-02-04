print("reloaded!--------")

-- lua locals
local 
floor
= 
math.floor
local ffi = require('ffi')

local __width = 16;
local __depth = 128;
local __xCalc = __depth * __width
local __zCalc = __depth

-- Texture Atlas - Will be constructed of all mod textures in the future
local texture = lovr.graphics.newTexture("textures/dirt.png", {mipmaps = true})
texture:setFilter("nearest")
texture:setWrap("repeat", "repeat")
local material = lovr.graphics.newMaterial(texture, 1, 1, 1, 1)

-- Reconstructs 1D table point to 3D position
local function __index_to_pos(index)
    index = index - 1

    local x = floor(index / __xCalc)
    index = index % __xCalc

    local z = floor(index / __zCalc)
    index = index % __zCalc

    local y = floor(index)

    -- Returns a Tuple
    return x, y, z;
end

-- Deconstructs 3D position to 1D table point
local function __pos_to_index(x, y, z)
    -- Returns an integer
	return floor((z * __zCalc) + (x * __xCalc) + y + 1)
end

-- Automates the indices injection
local function __build_indices(indices, indicesCount, vertexCount)
    -- Tri 1
    indices[indicesCount + 1] = vertexCount + 1
    indices[indicesCount + 2] = vertexCount + 2
    indices[indicesCount + 3] = vertexCount + 4
    -- Tri 2
    indices[indicesCount + 4] = vertexCount + 4
    indices[indicesCount + 5] = vertexCount + 2
    indices[indicesCount + 6] = vertexCount + 3

    -- Tick up counter
    indicesCount = indicesCount + 6

    return indices, indicesCount
end

--[[

+z = south
-z = north

+y = up
-y = down

+x = west
-x = east

]]--


local function __face_up(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)
    -- NOTE: this was * x,  * y,  * z
    vertices[vertexCount + 1] = {0,1,0, 0,1,0, 0,0}
    vertices[vertexCount + 2] = {0,1,1, 0,1,0, 0,1}
    vertices[vertexCount + 3] = {1,1,1, 0,1,0, 1,1}
    vertices[vertexCount + 4] = {1,1,0, 0,1,0, 1,0}

    indices, indicesCount = __build_indices(indices, indicesCount, vertexCount)

    vertexCount = vertexCount + 4

    return indices, indicesCount, vertexCount
end

local function __face_down(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)
    -- NOTE: this was * x,  * y,  * z
    vertices[vertexCount + 1] = {0,0,1, 0,1,0, 0,1}
    vertices[vertexCount + 2] = {0,0,0, 0,1,0, 0,0}
    vertices[vertexCount + 3] = {1,0,0, 0,1,0, 1,0}
    vertices[vertexCount + 4] = {1,0,1, 0,1,0, 1,1}

    indices, indicesCount = __build_indices(indices, indicesCount, vertexCount)

    vertexCount = vertexCount + 4

    return indices, indicesCount, vertexCount
end

local function __face_south(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)
    -- NOTE: this was * x,  * y,  * z
    vertices[vertexCount + 1] = {0,1,1, 0,0,1, 0,1}
    vertices[vertexCount + 2] = {0,0,1, 0,0,1, 0,0}
    vertices[vertexCount + 3] = {1,0,1, 0,0,1, 1,0}
    vertices[vertexCount + 4] = {1,1,1, 0,0,1, 1,1}

    indices, indicesCount = __build_indices(indices, indicesCount, vertexCount)

    vertexCount = vertexCount + 4

    return indices, indicesCount, vertexCount
end

local function __face_north(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)
    -- NOTE: this was * x,  * y,  * z
    vertices[vertexCount + 1] = {0,0,0, 0,0,1, 0,0}
    vertices[vertexCount + 2] = {0,1,0, 0,0,1, 0,1}
    vertices[vertexCount + 3] = {1,1,0, 0,0,1, 1,1}
    vertices[vertexCount + 4] = {1,0,0, 0,0,1, 1,0}
    

    indices, indicesCount = __build_indices(indices, indicesCount, vertexCount)

    vertexCount = vertexCount + 4

    return indices, indicesCount, vertexCount
end

local function __face_west(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)
    -- NOTE: this was * x,  * y,  * z
    vertices[vertexCount + 1] = {1,0,1, 1,0,0, 0,0}
    vertices[vertexCount + 2] = {1,0,0, 1,0,0, 0,1}
    vertices[vertexCount + 3] = {1,1,0, 1,0,0, 1,1}
    vertices[vertexCount + 4] = {1,1,1, 1,0,0, 1,0}

    indices, indicesCount = __build_indices(indices, indicesCount, vertexCount)

    vertexCount = vertexCount + 4

    return indices, indicesCount, vertexCount
end

local function __face_east(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)
    -- NOTE: this was * x,  * y,  * z
    vertices[vertexCount + 1] = {0,0,0, 1,0,0, 0,1}
    vertices[vertexCount + 2] = {0,0,1, 1,0,0, 0,0}
    vertices[vertexCount + 3] = {0,1,1, 1,0,0, 1,0}
    vertices[vertexCount + 4] = {0,1,0, 1,0,0, 1,1}

    indices, indicesCount = __build_indices(indices, indicesCount, vertexCount)

    vertexCount = vertexCount + 4

    return indices, indicesCount, vertexCount
end

-- Builds a single block of the chunk's mesh - utilizes localized functions for this
local function __buildCube(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)

    indices, indicesCount, vertexCount = __face_up(array,x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)

    indices, indicesCount, vertexCount = __face_down(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)

    indices, indicesCount, vertexCount = __face_north(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)

    indices, indicesCount, vertexCount = __face_south(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)

    indices, indicesCount, vertexCount = __face_west(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)

    indices, indicesCount, vertexCount = __face_east(array, x, y, z, width, height, texturePointX, texturePointY, vertices, vertexCount, indices, indicesCount)

    return vertexCount, indices, indicesCount
end


function BuildChunkMesh(chunk)
    local newChunkMesh

    local vertices = {}
    local vertexCount = 0

    local indices = {}
    local indicesCount = 0

    local start = lovr.timer.getTime()


    local prescan = 0

    local blocksPointer = chunk.blocks

    for i = 1,32768 do
        if blocksPointer[i] > 0 then
            prescan = prescan + 1
        end
    end

    -- prescan * bits * indexes per face * faces
    local myBlob = lovr.data.newBlob(15 * 8, "blobby")
    local array = ffi.cast("float*", myBlob:getPointer())


    array[0] = 0.0
    array[1] = 0.0
    array[2] = 0.0

    array[3] = 0
    array[4] = 0

    array[5] = 1.0
    array[6] = 0.0
    array[7] = 0.0

    array[8] = 1
    array[9] = 0
    
    array[10] = 0.0
    array[11] = 1.0
    array[12] = 0.0

    array[13] = 0
    array[14] = 1

    -- print("----------STARTING TEST------------")
    -- print("start " .. collectgarbage("count"))
    --[[
    for i = 1,32768 do
        local x,y,z = __index_to_pos(i)
        local index = __pos_to_index(x,y,z)

        --print("INTERNAL: " .. i .. " | CALCULATED: " .. index)

        -- if (i ~= index) then
            -- print("FAILURE AT: " .. i .. " IS EQUAL TO " .. index .. "! MATH MISCALCULATION!")
        -- end
        -- print("x: " .. x .. " y: " .. y .. " z: " .. z)
        -- vertexCount, indices, indicesCount = __buildCube(array, x,y,z,nil,nil,nil,nil,vertices, vertexCount, indices, indicesCount)

        x,y,z,index = nil,nil,nil,nil
    end
    ]]

    -- This mesh is a single triangle
    newChunkMesh = lovr.graphics.newMesh({{"lovrPosition", "float", 3}, {"lovrTexCoord", "float", 2}}, myBlob, "triangles", "static", false)

    -- myBlob:release()
    -- newChunkMesh:setVertices(vertices)

    -- newChunkMesh:setVertexMap(indices)

    newChunkMesh:setMaterial(material)
    
    -- print("end " .. collectgarbage("count"))
    -- print("Elapsed time: " .. lovr.timer.getTime() - start)
    -- print("------------TEST HAS ENDED----------------")
    return newChunkMesh
end