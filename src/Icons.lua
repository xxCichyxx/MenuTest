local IconsModule = {}

-- Pobieramy bazę danych ikon (plik z listą ID)
local success, IconsData = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/icons/icons.lua'))()
end)

function IconsModule:Apply(obj, iconName)
    if not success or not IconsData then 
        warn("XHUB: Nie udało się załadować bazy danych ikon!")
        return 
    end
    
    -- Czyszczenie nazwy (małe litery, usuwanie spacji)
    local name = string.match(string.lower(iconName), "^%s*(.*)%s*$")
    
    -- Szukamy w sekcji 48px
    local data = IconsData['48px'][name]
    
    if data and obj and obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        obj.Image = "rbxassetid://" .. data[1]
        obj.ImageRectSize = Vector2.new(data[2][1], data[2][2])
        obj.ImageRectOffset = Vector2.new(data[3][1], data[3][2])
    else
        if not data then
            warn("XHUB: Ikona o nazwie '" .. tostring(iconName) .. "' nie istnieje w bazie.")
        end
    end
end

return IconsModule