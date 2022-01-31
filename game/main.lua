require("dump")
require("map")

-- lua locals
local
lovr 
= 
lovr

function lovr.load(args)
    local test1 = NewChunk(0,0)
    local test2 = NewChunk(0,1)

    print(test1.blocks[5])
    print(test2.blocks[5])
end


function lovr.draw()
    local delta = lovr.timer.getDelta()
end