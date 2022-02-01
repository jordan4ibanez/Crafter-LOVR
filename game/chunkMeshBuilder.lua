
function BuildChunkMesh(chunk)
    local newChunkMesh
    -- This mesh is a single triangle
    newChunkMesh = lovr.graphics.newMesh({{ 'lovrPosition', 'float', 3 }, { 'lovrNormal', 'float', 3 }}, 3, 'triangles')
    newChunkMesh:setVertices({{0,0,0, 0,0,1}, {1,0,0, 0,0,1}, {0,1,0, 0,0,1}})
    
    return newChunkMesh
end