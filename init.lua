local Hub = {}
local BASE_URL = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/main/"

local function LoadModule(path)
    local url = BASE_URL .. path .. "?v=" .. tick()
    local success, content = pcall(function() return game:HttpGet(url) end)
    if not success then return nil end
    local func, err = loadstring(content)
    if not func then 
        warn("Błąd w module " .. path .. ": " .. tostring(err))
        return nil 
    end
    return func()
end

function Hub:CreateWindow(options)
    -- Załaduj moduły przy wywołaniu, aby mieć pewność, że są świeże
    local Theme = LoadModule("src/ThemeManager.lua")
    local Input = LoadModule("src/InputManager.lua")
    local Anim  = LoadModule("src/AnimationManager.lua")
    local Core  = LoadModule("src/Core.lua")

    if not (Theme and Input and Anim and Core) then
        error("Nie udało się załadować wszystkich komponentów biblioteki!")
    end

    return Core.new({
        Theme = Theme,
        Input = Input,
        Anims = Anim,
        Config = options
    })
end

return Hub