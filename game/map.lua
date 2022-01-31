-- lua locals
local
lovr 
= 
lovr

math.randomseed(os.time())

local __chunk_table = {}

local function __create_chunk(key)

    __chunk_table[key] = {
        blocks = {},
        rotations = {},
        light = {},
        heightMap = {},
    }

    return(__chunk_table[key])

end

function NewChunk(x,z)

    local key = tostring(x) .. " " .. tostring(z)

    local chunkPointer = __create_chunk(key)

    for i = 1, 32768 do
        chunkPointer.blocks[i] = math.random()
        chunkPointer.rotations[i] = 0
        chunkPointer.light[i] = 0
    end

    for i = 1,256 do
        chunkPointer.heightMap = 0
    end

    return chunkPointer

end