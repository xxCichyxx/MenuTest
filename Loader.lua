local Core = {}
local RepoURL = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/main/"

local function GetModule(path)
    local success, content = pcall(function() return game:HttpGet(RepoURL .. path) end)
    if success then
        return loadstring(content)()
    else
        warn("Nie udało się pobrać: " .. path)
        return nil
    end
end

function Core:Boot()
    print("Ładowanie xxx..")
    
    -- Pobieranie wszystkich komponentów
    local Animation = GetModule("utils/animation.lua")
    local Drag = GetModule("utils/drag.lua")
    local ClickGui = GetModule("gui/ClickGui.lua")

    if Animation and Drag and ClickGui then
        -- Łączenie modułów
        ClickGui.Init(Drag, Animation)
        ClickGui.CreateMenu()
        print("xxx załadowane pomyślnie!")
    end
end

Core:Boot()
return Core