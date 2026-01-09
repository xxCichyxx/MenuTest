local Core = {}
local RepoURL = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/main/"

-- Pobieranie modułów
local animContent = game:HttpGet(RepoURL .. "utils/animation.lua")
local guiContent = game:HttpGet(RepoURL .. "gui/ClickGui.lua")

local Animation = loadstring(animContent)()
local ClickGui = loadstring(guiContent)()

function Core:Boot()
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "XenoUI"
    sgui.Parent = (game:GetService("RunService"):IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or game:GetService("CoreGui")

    -- Główny klocek (MainFrame)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = sgui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- ŁĄCZENIE: Wywołujemy ClickGui, żeby zbudowało menu wewnątrz MainFrame
    ClickGui.CreateMenu(MainFrame)

    -- Animacja na koniec
    Animation.PopIn(MainFrame)
end
Core:Boot()
return Core