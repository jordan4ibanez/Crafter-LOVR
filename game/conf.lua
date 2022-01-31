function lovr.conf(t)
    -- Set the project version and identity
    t.version = '0.15.0'
    t.identity = "blah blah blah"

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
    t.headset.drivers = {  'desktop' }
    t.headset.supersample = false
    t.headset.offset = 0
    t.headset.msaa = 0

    -- Math settings
    t.math.globals = true

    -- Configure the desktop window
    t.window.width = 1080
    t.window.height = 600
    t.window.fullscreen = false
    t.window.msaa = 0
    t.window.vsync = 1
    t.window.title = "The Potato game"
    t.window.icon = nil
end