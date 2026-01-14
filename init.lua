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

-- Ładowanie wszystkich komponentów
local ThemeManager = LoadModule("src/ThemeManager.lua")
local InputManager = LoadModule("src/InputManager.lua")
local AnimManager  = LoadModule("src/AnimationManager.lua")
local Core         = LoadModule("src/Core.lua")

if ThemeManager and InputManager and AnimManager and Core then
    function Hub:CreateWindow(options)
        return Core.new({
            Theme = ThemeManager,
            Input = InputManager,
            Anims = AnimManager,
            Config = options
        })
    end
else
    warn("❌ Krytyczny błąd ładowania biblioteki!")
end

return Hub