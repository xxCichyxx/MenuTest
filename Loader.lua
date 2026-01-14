-- Loader.lua
-- Wersja przywrócona do ładowania z GitHub, ale wykorzystująca nową, modułową strukturę kodu.

local Core = {}
-- Upewnij się, że ta ścieżka jest poprawna i prowadzi do Twojego repozytorium.
local RepoURL = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/main/"

-- Funkcja do pobierania i ładowania modułów z GitHub.
local function GetModule(path)
    print("Pobieranie modułu: " .. path)
    local success, content = pcall(function() return game:HttpGet(RepoURL .. path, true) end)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            -- Wywołujemy załadowany kod, aby zwrócił tabelę modułu
            return func()
        else
            warn("Błąd loadstring dla " .. path .. ": " .. tostring(err))
            return nil
        end
    else
        warn("Nie udało się pobrać modułu: " .. path)
        return nil
    end
end

-- Główna funkcja rozruchowa
function Core:Boot()
    -- Przywrócona logika dla auto-execute po teleportacji
    if typeof(queue_on_teleport) == "function" then
        queue_on_teleport('loadstring(game:HttpGet("' .. RepoURL .. 'Loader.lua", true))()')
        print("Dodano do kolejki ponownego wykonania po teleportacji.")
    end

    print("Ładowanie menu...")

    -- Pobieranie wszystkich komponentów (nowych wersji)
    local animation = GetModule("utils/animation.lua")
    local drag = GetModule("utils/drag.lua")
    local BindManager = GetModule("managers/BindManager.lua")
    local ClickGui = GetModule("gui/ClickGui.lua")

    -- Sprawdzanie, czy wszystkie moduły zostały poprawnie załadowane
    if not (animation and drag and BindManager and ClickGui) then
        warn("Jeden lub więcej modułów nie został załadowany. Przerywanie.")
        return
    end
    
    print("Wszystkie moduły pobrane pomyślnie.")

    -- --- NOWA LOGIKA ŁĄCZENIA MODUŁÓW ---

    -- 1. Inicjalizacja menedżera przypisań klawiszy
    BindManager:init()
    print("BindManager zainicjalizowany.")

    -- 2. Stworzenie instancji GUI z wstrzyknięciem zależności
    local myGui = ClickGui.new(animation, drag)
    print("Instancja ClickGui utworzona.")

    -- 3. Stworzenie nowego przypisania dla przełączania GUI
    -- Używamy anonimowej funkcji, aby zapewnić, że `myGui:toggle()` jest wywoływane z poprawnym `self`.
    BindManager:new(Enum.KeyCode.RightShift, function()
        myGui:toggle()
    end)
    print("Przypisano klawisz Prawy Shift do przełączania GUI.")
    
    -- --- KONIEC NOWEJ LOGIKI ---

    print("Menu załadowane pomyślnie! Naciśnij Prawy Shift, aby otworzyć/zamknąć.")
end

-- Uruchomienie
Core:Boot()

return Core