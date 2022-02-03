
function BuildChunkMesh(chunk)
    local newChunkMesh
    -- This mesh is a single triangle
    newChunkMesh = lovr.graphics.newMesh(
        {
            { 'lovrPosition', 'float', 3 },
            { 'lovrNormal', 'float', 3 }
        },
        3,
        'triangles'
    )
    local test = ""

    for i = 1,10000 do
        test = test .. math.floor(math.random() * 10)
    end

    local blob = lovr.data.newBlob(test, "test")

    test = nil

    print(blob:getString())

    newChunkMesh:setVertices(
        {
            {0,0,0, 0,0,1},
            {1,0,0, 0,0,1},
            {0,1,0, 0,0,1},
        }
    )
    
    return newChunkMesh
end