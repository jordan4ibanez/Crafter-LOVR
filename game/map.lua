-- Lua locals
local
lovr 
= 
lovr

math.randomseed(os.time())

-- Holds all chunk data
local __chunk_table = {}

--Simple keygenner
local function keyGen(x,z)
    return tostring(x) .. " " .. tostring(z)
end

-- Internal adder for chunk creation
local function __create_chunk(key)

    __chunk_table[key] = {
        dimension = nil,
        blocks = {},
        rotations = {},
        light = {},
        heightMap = {},
    }

    return(__chunk_table[key])

end

-- External oneline creator which returns the pointer reference to the chunk
function NewChunk(x,z)

    local key = keyGen(x,z)

    local chunkPointer = __create_chunk(key)

    -- All chunks are in the "overworld" for now
    chunkPointer.dimension = "overworld"

    --[[
    Blank chunk creation.
    A biome generator function will be created in the future maybe
    ]]--
    for i = 1, 32768 do
        chunkPointer.blocks[i] = 1
        chunkPointer.rotations[i] = 0
        chunkPointer.light[i] = 0
    end

    -- Heightmap data
    for i = 1,256 do
        chunkPointer.heightMap = 0
    end

    return chunkPointer

end

-- Simple testing of getting lua chunk object data from table
function GetChunk(x,z)
    return __chunk_table[keyGen(x,z)]
end

-- Simple testing of removing chunks from container
function DeleteChunk(x,z)
    __chunk_table[keyGen(x,z)] = nil
end