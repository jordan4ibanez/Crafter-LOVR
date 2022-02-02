local window = require("lovr-libraries.lovr-window")

local title

function InitializeWindow()
    title = "Crafter " .. GetVersionName()

    -- sets window opacity, resolution and title
    local width, height = window.getDisplayDimensions(1)

    window.setMode(width / 2, height / 2, {opacity = 1, fullscreentype = "desktop", resizable = true})

    window.setTitle(title)

    local width, height, mode = window.getMode()

    print(width .. " " .. height .. " " .. dump(mode))

end

function lovr.resize()
    lovr.graphics.reset()
end