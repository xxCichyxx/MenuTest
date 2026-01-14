-- managers/BindManager.lua
-- Modułowy i elastyczny system do zarządzania wieloma przypisaniami klawiszy.

local UserInputService = game:GetService("UserInputService")

local BindManager = {}
BindManager.Binds = {} -- Tabela przechowująca wszystkie aktywne przypisania

--[[
    Tworzy nowe przypisanie klawisza.
    @param key Enum.KeyCode - Klawisz do przypisania.
    @param callback function - Funkcja, która zostanie wywołana po naciśnięciu klawisza.
]]
function BindManager:new(key, callback)
    if not typeof(key) == "EnumItem" or not typeof(callback) == "function" then
        warn("BindManager: Nieprawidłowe argumenty. Oczekiwano Enum.KeyCode i funkcji.")
        return
    end
    
    local bindObject = {
        Key = key,
        Callback = callback,
        Enabled = true
    }
    
    table.insert(self.Binds, bindObject)
    
    -- Zwracamy obiekt, aby można było go w przyszłości modyfikować (np. unbind)
    return bindObject
end

--[[
    Inicjalizuje główną pętlę nasłuchującą. Należy to wywołać tylko raz.
]]
function BindManager:init()
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            for _, bind in ipairs(BindManager.Binds) do
                if bind.Enabled and input.KeyCode == bind.Key then
                    -- Uruchamiamy callback w bezpiecznym wątku
                    task.spawn(bind.Callback)
                end
            end
        end
    end)
end

return BindManager
