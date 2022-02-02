function lovr.conf(t)
    -- Set the project version and identity
    t.version = '0.15.0'
    t.identity = "Crafter"

    -- Set save directory precedence
    t.saveprecedence = true

    -- Enable or disable different modules
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.headset = false
    t.modules.math = true
    t.modules.physics = true
    t.modules.system = true
    t.modules.thread = true
    t.modules.timer = true
    
    -- Audio
    t.audio.spatializer = nil
    t.audio.start = true

    -- Graphics
    t.graphics.debug = true

    -- Headset settings
    -- 'openxr', 'oculus', 'vrapi', 'pico', 'openvr', 'webxr',
    t.headset.drivers = {  "desktop" }
    t.headset.supersample = false
    t.headset.offset = 0
    t.headset.msaa = 0

    -- Math settings
    t.math.globals = true

    -- additional window parameters
    t.window.fullscreentype = "desktop"	-- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.x = nil			-- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil			-- The y-coordinate of the window's position in the specified display (number)
    t.window.minwidth = 1			-- Minimum window width if the window is resizable (number)
    t.window.minheight = 1			-- Minimum window height if the window is resizable (number)
    t.window.display = 1			-- Index of the monitor to show the window in (number)
    t.window.centered = false		-- Align window on the center of the monitor (boolean)
    t.window.topmost = false		-- Show window on top (boolean)
    t.window.borderless = false		-- Remove all border visuals from the window (boolean)
    t.window.resizable = false		-- Let the window be user-resizable (boolean)
    t.window.opacity = 1			-- Window opacity value (number)

    conf = t.window
end