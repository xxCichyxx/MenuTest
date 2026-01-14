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
    -- Auto Execute (Queue on Teleport) - system jak w Infinite Yield
    if typeof(queue_on_teleport) == "function" then
        queue_on_teleport('loadstring(game:HttpGet("' .. RepoURL .. 'Loader.lua"))()')
    end

    print("Ładowanie xxx..")
    
    -- Pobieranie wszystkich komponentów
    local Animation = GetModule("utils/animation.lua")
    local Drag = GetModule("utils/drag.lua")
    local BindManager = GetModule("managers/BindManager.lua")
    local ClickGui = GetModule("gui/ClickGui.lua")

    if Animation and Drag and ClickGui and BindManager then
        -- Łączenie modułów
        BindManager.Init(function()
            ClickGui.Toggle()
        end)

        ClickGui.Init(Drag, Animation, BindManager)
        ClickGui.CreateMenu()
        print("xxx załadowane pomyślnie!")
    end
end

Core:Boot()
return Core