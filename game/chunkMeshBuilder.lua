print("reloaded!--------")
print("REMEMBER FFI ARRAYS START AT 0")

-- lua locals
local 
floor, graphics, timer, data
= 
math.floor, lovr.graphics, lovr.timer, lovr.data

local ffi = require('ffi')

local __width = 16;
local __depth = 128;
local __xCalc = __depth * __width
local __zCalc = __depth

-- Texture Atlas - Will be constructed of all mod textures in the future
local texture = graphics.newTexture("textures/dirt.png", {mipmaps = true})
texture:setFilter("nearest")
texture:setWrap("repeat", "repeat")
local material = graphics.newMaterial(texture, 1, 1, 1, 1)

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


--[[

+z = south
-z = north

+y = up
-y = down

+x = west
-x = east

]]--


-- Deconstructs 3D position to 1D table point
local function __pos_to_index(x, y, z)
    -- Returns an integer
	return floor((z * __zCalc) + (x * __xCalc) + y + 1)
end

local function __insert_data(x, y, z, w, q, array, arrayCount, xx, yy, zz)

    array[arrayCount    ] = x + xx
    array[arrayCount + 1] = y + yy
    array[arrayCount + 2] = z + zz

    array[arrayCount + 3] = w
    array[arrayCount + 4] = q

    arrayCount = arrayCount + 5

    return array, arrayCount
end

local function __face_up(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)
    -- NOTE: this was * x,  * y,  * z

    -- Tri 1
    array, arrayCount = __insert_data(0,1,0, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,1,1, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,1,1, 1,1, array, arrayCount, x, y, z)

    -- Tri 2
    array, arrayCount = __insert_data(1,1,0, 1,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,1,0, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,1,1, 1,1, array, arrayCount, x, y, z)

    return array, arrayCount
end

local function __face_down(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)
    -- NOTE: this was * x,  * y,  * z

    -- Tri 1
    array, arrayCount = __insert_data(0,0,1, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,0,0, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,0,0, 1,0, array, arrayCount, x, y, z)

    -- Tri 2
    array, arrayCount = __insert_data(1,0,1, 1,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,0,1, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,0,0, 1,0, array, arrayCount, x, y, z)


    return array, arrayCount
end


local function __face_south(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)
    -- NOTE: this was * x,  * y,  * z

    -- Tri 1
    array, arrayCount = __insert_data(0,1,1, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,0,1, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,0,1, 1,0, array, arrayCount, x, y, z)

    -- Tri 2
    array, arrayCount = __insert_data(1,1,1, 1,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,1,1, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,0,1, 1,0, array, arrayCount, x, y, z)

    return array, arrayCount
end


local function __face_north(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)
    -- NOTE: this was * x,  * y,  * z
    -- Tri 1
    array, arrayCount = __insert_data(0,0,0, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,1,0, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,1,0, 1,1, array, arrayCount, x, y, z)

    -- Tri 2
    array, arrayCount = __insert_data(1,0,0, 1,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,0,0, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,1,0, 1,1, array, arrayCount, x, y, z)

    return array, arrayCount
end


local function __face_west(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)
    -- NOTE: this was * x,  * y,  * z

    -- Tri 1
    array, arrayCount = __insert_data(1,0,1, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,0,0, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,1,0, 1,1, array, arrayCount, x, y, z)

    -- Tri 2
    array, arrayCount = __insert_data(1,1,1, 1,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,0,1, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(1,1,0, 1,1, array, arrayCount, x, y, z)

    return array, arrayCount
end

local function __face_east(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)
    -- NOTE: this was * x,  * y,  * z
    array, arrayCount = __insert_data(0,0,0, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,0,1, 0,0, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,1,1, 1,0, array, arrayCount, x, y, z)

    array, arrayCount = __insert_data(0,1,0, 1,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,0,0, 0,1, array, arrayCount, x, y, z)
    array, arrayCount = __insert_data(0,1,1, 1,0, array, arrayCount, x, y, z)

    return array, arrayCount
end



-- Builds a single block of the chunk's mesh - utilizes localized functions for this
local function __buildCube(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)

    array, arrayCount =    __face_up(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)

    array, arrayCount =  __face_down(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)

    array, arrayCount = __face_north(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)

    array, arrayCount = __face_south(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)

    array, arrayCount = __face_west(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)

    array, arrayCount = __face_east(array, arrayCount, x, y, z, width, height, texturePointX, texturePointY)

    return array, arrayCount
end


function BuildChunkMesh(chunk)

    local arrayCounter = 0

    local start = timer.getTime()
    

    local prescan = 0

    -- local blocksPointer = chunk.blocks

    --[[
    for i = 1,32768 do
        if blocksPointer[i] > 0 then
            prescan = prescan + 1
        end
    end
    ]]

    -- prescan blocks * bits * (vertex + textureMap + normals)

    local myBlob = data.newBlob(32768 * 8 * (30 * 6), "blobby")
    local array = ffi.cast("float*", myBlob:getPointer())


    print("----------STARTING TEST------------")
    print("start " .. collectgarbage("count"))
    for i = 1,32768 do
        local x,y,z = __index_to_pos(i)
        local index = __pos_to_index(x,y,z)

        --print("INTERNAL: " .. i .. " | CALCULATED: " .. index)

        -- if (i ~= index) then
            -- print("FAILURE AT: " .. i .. " IS EQUAL TO " .. index .. "! MATH MISCALCULATION!")
        -- end
        -- print("x: " .. x .. " y: " .. y .. " z: " .. z)
        array,arrayCounter = __buildCube(array, arrayCounter, x,y,z,nil,nil,nil,nil)

        x,y,z,index = nil,nil,nil,nil
    end

    -- This mesh is a single triangle
    local newChunkMesh = graphics.newMesh(
        {
            {"lovrPosition", "float", 3}, {"lovrTexCoord", "float", 2}
        },
        myBlob, "triangles", "static", false)

    --release memory
    -- array = nil
    -- myBlob:release()

    --array = nil
    --myBlob = nil

    newChunkMesh:setMaterial(material)
    
    print("end " .. collectgarbage("count"))
    print("Elapsed time: " .. timer.getTime() - start)
    print("------------TEST HAS ENDED----------------")
    return newChunkMesh
end