-- Loader.lua
-- Główny plik inicjalizujący menu i jego komponenty w środowisku lokalnym/plikowym.
-- Zakłada, że skrypty modułowe znajdują się w odpowiednich podfolderach (gui, managers, utils).

print("Ładowanie menu...")

-- W środowisku Roblox, ścieżki do require wyglądałyby np. tak:
-- local BindManager = require(game.ReplicatedStorage.Menu.managers.BindManager)
-- Tutaj symulujemy to, zakładając, że struktura plików jest zachowana.
-- W standardowym Lua, `require` używa `package.path`. W Luau (Roblox) jest to oparte na hierarchii obiektów.
-- Poniższy kod jest przykładem, jakby to wyglądało w Robloxie, dostosowanym do logiki.

-- Ścieżki do modułów
-- Dla celów demonstracyjnych, zakładamy, że moduły są w tym samym folderze, 
-- ale normalnie byłyby w ReplicatedStorage lub podobnym miejscu.
-- W tym przypadku musimy dostosować ścieżkę dla lokalnego require.
-- W Lua, `.` jest używany jako separator katalogów w `require`.
local BindManager = require(script.Parent.managers.BindManager)
local ClickGui = require(script.Parent.gui.ClickGui)
local animation = require(script.Parent.utils.animation)
local drag = require(script.Parent.utils.drag)

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
print("Przypisano klawisz RightShift do przełączania GUI.")

print("Menu załadowane pomyślnie. Naciśnij Prawy Shift, aby otworzyć/zamknąć.")
