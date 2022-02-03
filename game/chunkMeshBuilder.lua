local __width = 16;
local __depth = 128;
local __xCalc = __depth * __width
local __zCalc = __depth

print("---------------------------------------RELOAD---------------------------------------------- + " .. os.time())

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

local function __pos_to_index(x, y, z)
	return math.floor((z * __zCalc) + (x * __xCalc) + y + 1)
end

function BuildChunkMesh(chunk)
    local newChunkMesh
    -- This mesh is a single triangle
    newChunkMesh = lovr.graphics.newMesh({{"lovrPosition", "float", 3}, {"lovrNormal", "float", 3}}, 3, "fan", "static", false)

    local meshVertex = {}

    --print("start " .. collectgarbage("count"))
    for i = 1,32768 do
        local x,y,z = __index_to_pos(i)
        local index = __pos_to_index(x,y,z)

        --print("INTERNAL: " .. i .. " | CALCULATED: " .. index)

        if (i ~= index) then
            print("FAILURE AT: " .. i .. " IS EQUAL TO " .. index .. "! MATH MISCALCULATION!")
        end
        --print("x: " .. x .. " y: " .. y .. " z: " .. z)
    end
    --print("end " .. collectgarbage("count"))


    meshVertex[#meshVertex + 1] = {0,0,0, 0,0,1}
    meshVertex[#meshVertex + 1] = {1,0,0, 0,0,1}
    meshVertex[#meshVertex + 1] = {0,1,0, 0,0,1}

    newChunkMesh:setVertices(meshVertex)
    
    return newChunkMesh
end