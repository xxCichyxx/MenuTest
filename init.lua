--[[
    Główny plik inicjalizujący bibliotekę.
    Użytkownik ładuje ten plik, a on zajmuje się resztą.
]]

local Hub = {}
local BASE_URL = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/main/" -- Zmień na swój URL

-- Funkcja pomocnicza do ładowania modułów
local function LoadModule(path)
    local success, module = pcall(function()
        local url = BASE_URL .. path .. "?v=" .. tick() -- Dodano cache-busting
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return module
    else
        warn("Nie udało się załadować modułu:", path, module)
        return nil
    end
end

-- Ładowanie modułów biblioteki
local ThemeManager = LoadModule("src/ThemeManager.lua")
local InputManager = LoadModule("src/InputManager.lua")
local Core = LoadModule("src/Core.lua")

-- Wstrzykiwanie zależności i budowanie API
if ThemeManager and InputManager and Core then
    -- Tworzymy funkcję :CreateWindow, która będzie dostępna dla użytkownika
    function Hub:CreateWindow(options)
        -- Przekazujemy załadowane moduły i BASE_URL do Core, aby mógł z nich korzystać
        return Core.new({
            ThemeManager = ThemeManager,
            InputManager = InputManager,
            Options = options,
            BASE_URL = BASE_URL -- Przekazanie URL do Core
        })
    end
else
    warn("Nie wszystkie moduły GUI zostały poprawnie załadowane. Biblioteka może nie działać.")
end

-- Zwracamy gotowy obiekt Hub, aby umożliwić składnię:
-- local Hub = loadstring(...)()
return Hub
