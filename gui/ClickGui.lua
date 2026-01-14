local ClickGui = {}
local HttpService = game:GetService("HttpService")

-- Zmienne na moduły, które załadujemy później
local DragSystem, Animation, BindManager

local MainFrame -- Przechowujemy referencję do okna globalnie w module
local ScreenGui -- Przechowujemy referencję do ScreenGui

function ClickGui.Init(dragMod, animMod, bindMod)
    DragSystem = dragMod
    Animation = animMod
    BindManager = bindMod
end

ClickGui.Visible = true

-- Funkcja przełączająca menu z animacją i resetem pozycji
function ClickGui.Toggle()
    ClickGui.Visible = not ClickGui.Visible
    
    if ClickGui.Visible then
        ScreenGui.Enabled = true
        -- Reset pozycji na środek ekranu (500x350 to rozmiar okna)
        MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
        Animation.FadeIn(MainFrame, 0.5)
    else
        Animation.FadeOut(MainFrame, 0.5, function()
            ScreenGui.Enabled = false
        end)
    end
end

function ClickGui.CreateMenu()
    -- Singleton: Sprawdzamy czy instancja już istnieje w globalnym środowisku i usuwamy ją
    local env = (getgenv and getgenv()) or _G
    if env.ActiveMenuInstance and env.ActiveMenuInstance.Parent then
        env.ActiveMenuInstance:Destroy()
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = HttpService:GenerateGUID(false) -- Losowa nazwa (np. A1B2-C3D4...)
    ScreenGui.ResetOnSpawn = false
    env.ActiveMenuInstance = ScreenGui -- Zapisujemy nową instancję, aby móc ją potem usunąć
    ScreenGui.Parent = game:GetService("CoreGui")

    MainFrame = Instance.new("CanvasGroup") -- Przypisujemy do zmiennej modułowej
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Ustawiamy punkt zakotwiczenia na środek
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Pozycja na środku ekranu
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Parent = ScreenGui

    -- Inicjalizacja systemów
    DragSystem.Enable(MainFrame)
    Animation.FadeIn(MainFrame, 0.5)
    Animation.PopUp(MainFrame, 0.5, UDim2.new(0, 500, 0, 350))

    ClickGui.CreateSidebar(MainFrame)
end

function ClickGui.CreateSidebar(parent)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Sidebar.Parent = parent
    
    local Title = Instance.new("TextLabel")
    Title.Text = "MENU"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar
end

return ClickGui