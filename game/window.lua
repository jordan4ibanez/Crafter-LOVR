local window = require("lovr-libraries.lovr-window")

local title

function InitializeWindow()

    title = "Crafter " .. GetVersionName()

    window.setIcon("textures/icon.png")

    -- sets window opacity, resolution and title
    local width, height = window.getDisplayDimensions(1)

    window.setMode(width / 2, height / 2, {opacity = 1, fullscreentype = "desktop", resizable = true})

    window.setTitle(title)

end

function lovr.resize()

    lovr.graphics.reset()

end

function FullScreenWindow()

    window.setFullscreen(true, "desktop", 1)

end

function UnFullScreenWindow()

    window.setFullscreen(false, "desktop", 1)

end

function UpdateWindowWithFPS()

    window.setTitle(title .. lovr.timer.getFPS())

end