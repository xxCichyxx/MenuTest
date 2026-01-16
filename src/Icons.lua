local IconsModule = {}

-- Pobieramy bazę danych ikon (plik z listą ID)
local success, IconsData = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/icons/icons.lua'))()
end)

function IconsModule:Apply(obj, iconName)
    -- SPRAWDZENIE: Jeśli obj to nil, przerwij funkcję zamiast wywalać błąd
    if not obj then 
        return 
    end

    if not success or not IconsData then return end
    
    local name = string.match(string.lower(iconName), "^%s*(.*)%s*$")
    local data = IconsData['48px'][name]
    
    if data and (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) then
        obj.Image = "rbxassetid://" .. data[1]
        obj.ImageRectSize = Vector2.new(data[2][1], data[2][2])
        obj.ImageRectOffset = Vector2.new(data[3][1], data[3][2])
    end
end

return IconsModule