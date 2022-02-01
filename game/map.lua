-- Lua locals
local
lovr 
= 
lovr

math.randomseed(os.time())

-- Holds all chunk data
local __chunk_key       = {}
local __chunk_dimension = {}
local __chunk_blocks    = {}
local __chunk_rotations = {}
local __chunk_light     = {}
local __chunk_heightMap = {}


local function __hash_chunk(x,z)
	return (z + 2147483648) * 4294967296
		 +  x + 2147483648
end

local function __get_chunk_pos(hash)
	local x = (hash % 4294967296) - 2147483648
	hash  = math.floor(hash / 4294967296)
	local z = (hash % 4294967296) - 2147483648
	return {x=x, z=z}
end


-- Simple keygenner
local function keyGen(x,z)
    return __hash_chunk(x,z)
end

-- Simple 3D to 1D converter
local function posToIndex(x, y, z)
    return (z * 2048) + (y * 16) + x
end

-- Internal adder for chunk creation
local function __create_chunk(x, z, dimension)

    local index = #__chunk_key

    __chunk_key[keyGen(x,z)] = index

    __chunk_dimension[index] = dimension

    -- Biome generator init goes here
    __chunk_blocks[index] = {}
    __chunk_rotations[index] = {}
    __chunk_light[index] = {}

    --[[
        Blank chunk creation.
        A biome generator function will be created in the future maybe
    
        This is still 2D and needs to have more math backing a pure 1D implementation
    ]]--
    for i = 1, 32768 do
        __chunk_blocks[index][i]    = 1
        __chunk_rotations[index][i] = 1
        __chunk_light[index][i]     = 1
    end

    __chunk_heightMap[index] = {}

     -- Heightmap data
     for i = 1,256 do
        __chunk_heightMap[index][i] = 0
    end

    return(index)
end

-- External oneline creator which returns the index reference to the chunk
function NewChunk(x, z, dimension)
    return __create_chunk(x,z, dimension)
end

-- Simple testing of getting lua chunk object data from tables
-- Returns as immutable to original object or nil
function GetChunk(x, z)

    local key = keyGen(x,z)
    local chunkIndex = __chunk_key[key]

    if chunkIndex == nil then
        return nil
    end

    local chunkContainer = {
        dimension = nil,
        blocks = {},
        rotations = {},
        light = {},
        heightMap = {},
    }

    chunkContainer.dimension = __chunk_dimension[chunkIndex]

    for i = 1, 32768 do
        chunkContainer.blocks[i]    = __chunk_blocks[chunkIndex][i]
        chunkContainer.rotations[i] = __chunk_rotations[chunkIndex][i]
        chunkContainer.light[i]     = __chunk_light[chunkIndex][i]
    end

    for i = 1,256 do
        chunkContainer.heightMap[i] = __chunk_heightMap[chunkIndex][i]
    end

    return chunkContainer
end

-- Simple testing of removing chunks from container
function DeleteChunk(x, z)

    local key = keyGen(x,z)
    local chunkIndex = __chunk_key[key]

    if chunkIndex == nil then
        return false
    end

    __chunk_dimension[chunkIndex] = nil
    __chunk_blocks[chunkIndex]    = nil
    __chunk_rotations[chunkIndex] = nil
    __chunk_light[chunkIndex]     = nil
    __chunk_heightMap[chunkIndex] = nil
    __chunk_key[key] = nil
end