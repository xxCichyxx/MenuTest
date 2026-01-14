-- loader.lua
local function Fetch(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then return result end
    warn("Błąd podczas pobierania: " .. url)
    return nil
end

-- Linki do Twojego GitHuba (Zmień na swoje!)
local baseUrl = "https://raw.githubusercontent.com/TWOJ_NICK/REPO/main/"
local MainLib = loadstring(Fetch(baseUrl .. "main.lua"))()

-- Zwracamy bibliotekę do skryptu użytkownika
return MainLib