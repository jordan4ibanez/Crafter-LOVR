-- lua locals
local
lovr 
= 
lovr

function lovr.load(args)
    print("plop")
end


function lovr.draw(dtime)
    local delta = lovr.timer.getDelta()


    print(delta)

end