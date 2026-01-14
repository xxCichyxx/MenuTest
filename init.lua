local Hub = {}
local BASE_URL = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/main/"

local function LoadModule(path)
    local url = BASE_URL .. path .. "?v=" .. tick()
    local success, content = pcall(function() return game:HttpGet(url) end)
    if not success then return nil end
    local func, err = loadstring(content)
    if not func then return nil end
    return func()
end

local Theme = LoadModule("src/ThemeManager.lua")
local Input = LoadModule("src/InputManager.lua")
local Anim  = LoadModule("src/AnimationManager.lua")
local Core  = LoadModule("src/Core.lua")

function Hub:CreateWindow(options)
    -- Kluczowe: Przekazujemy wszystkie moduły do Core.new
    return Core.new({
        Theme = Theme,
        Input = Input,
        Anims = Anim,
        Config = options
    })
end

return Hub