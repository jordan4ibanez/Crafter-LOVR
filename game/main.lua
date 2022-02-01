require("dump")
require("chunkMeshBuilder")
require("map")
local fragmentShader = require("shader")

-- lua locals
local
lovr 
= 
lovr

local function makeShader(prefix)
    return lovr.graphics.newShader(prefix .. [[
  out vec3 lightDirection;
  out vec3 normalDirection;
  out vec3 vertexPosition;
  
  vec3 lightPosition = vec3(10., 10., 3.);
  
  vec4 position(mat4 projection, mat4 transform, vec4 _vertex) {
    vec4 vertex = preTransform(_vertex);
  
    vec4 vVertex = transform * vertex;
    vec4 vLight = lovrView * vec4(lightPosition, 1.);
  
    lightDirection = normalize(vec3(vLight - vVertex));
    normalDirection = normalize(lovrNormalMatrix * lovrNormal);
    vertexPosition = vVertex.xyz;
  
    return projection * transform * vertex;
  }
  ]], fragmentShader)
  end

local mesh1Program = makeShader("vec4 preTransform(vec4 v) { return v; }")

local chunkMesh


function lovr.load(args)
    NewChunk(0, 0, "overworld")

    local chunkObject = GetChunk(0, 0)


    chunkMesh = BuildChunkMesh(chunkObject)

end


function lovr.draw()

    lovr.graphics.setShader(mesh1Program)

    lovr.graphics.push() -- White triangle
    lovr.graphics.setColor(1,1,1)
    lovr.graphics.translate(0, 0, -2)
    chunkMesh:draw(0,0,0)
    lovr.graphics.pop()

end