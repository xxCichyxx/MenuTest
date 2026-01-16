local IconsModule = {}

-- Pobieramy bazę danych ikon
local IconsData = loadstring(game:HttpGet('https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/icons/icons.lua'))()

function IconsModule:getIcon(name)
    if not IconsData then return nil end
    name = string.match(string.lower(name), "^%s*(.*)%s*$")
    local sizedicons = IconsData['48px']
    local r = sizedicons[name]
    if not r then return nil end
    return {
        id = r[1], 
        imageRectSize = Vector2.new(r[2][1], r[2][2]), 
        imageRectOffset = Vector2.new(r[3][1], r[3][2])
    }
end

function IconsModule:Apply(obj, iconName)
    if not obj then return end
    local data = self:getIcon(iconName)
    if data and (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) then
        obj.Image = "rbxassetid://" .. data.id
        obj.ImageRectSize = data.imageRectSize
        obj.ImageRectOffset = data.imageRectOffset
    end
end

return IconsModule