require("dump")
require("map")

-- lua locals
local
lovr 
= 
lovr


function lovr.load(args)
    for x = -100, 100 do
        for z = -100, 100 do
            print("Generating: " .. x .. " " .. z)
            NewChunk(x,z,"overworld")
        end
    end

end


function lovr.draw()
    local delta = lovr.timer.getDelta()
end