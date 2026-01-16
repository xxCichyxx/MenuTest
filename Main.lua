local XHUB = {}

-- // SERWISY
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- // KONFIGURACJA ŚCIEŻEK
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"

-- // ŁADOWANIE MODUŁÓW
-- Zauważ, że nie musimy już ładować Icons i Interactions tutaj, 
-- bo Window.lua sam je sobie pobiera do budowy okna.
local WindowModule = loadstring(game:HttpGet(baseUrl .. "Window.lua"))()

function XHUB:CreateWindow(options)
    local Config = options or {}
    local Name = Config.Name or "X HUB"
    local Keybind = Config.ToggleUIKeybind or "Insert"
    local TestMobile = Config.TestMobile or false
    
    -- 1. Wybór lokalizacji i czyszczenie starych wersji
    local ProtectedLocation = nil
    local success = pcall(function() ProtectedLocation = CoreGui end)
    if not success then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:sub(1,5) == "XHUB_") then
            child:Destroy()
        end
    end

    -- 2. Tworzenie Okna (Window.lua teraz samo dodaje ikony i interakcje!)
    local UI = WindowModule:Create({
        Name = Name,
        TestMobile = TestMobile
    })
    UI.ScreenGui.Parent = ProtectedLocation

    -- 3. LOGIKA OTWIERANIA/ZAMYKANIA (Tweening)
    local isVisible = true
    local isTweening = false
    local MainFrame = UI.MainFrame
    
    -- Pozycja startowa i ukryta
    local CurrentMainPos = MainFrame.Position
    local HiddenPos = UDim2.new(0, -850, CurrentMainPos.Y.Scale, CurrentMainPos.Y.Offset)

    local function toggleMenu()
        if isTweening then return end
        isTweening = true
        
        if isVisible then CurrentMainPos = MainFrame.Position end
        local target = isVisible and HiddenPos or CurrentMainPos
        
        -- Aktualizacja tekstu na przycisku mobilnym (jeśli istnieje)
        if UI.MobileToggleText then
            UI.MobileToggleText.Text = isVisible and "Open" or "Close"
            UI.MobileToggleText.TextColor3 = isVisible and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end

        if not isVisible then MainFrame.Visible = true end
        
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = target})
        tween:Play()
        
        tween.Completed:Connect(function()
            isVisible = not isVisible
            if not isVisible then MainFrame.Visible = false end
            isTweening = false
        end)
    end

    -- 4. OBSŁUGA ZDARZEŃ
    -- Bind klawiszowy
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Keybind] then
            toggleMenu()
        end
    end)

    -- Obsługa przycisków nagłówka (MinBtn i CloseBtn są już w UI)
    UI.MinBtn.MouseButton1Click:Connect(toggleMenu)
    UI.CloseBtn.MouseButton1Click:Connect(function() 
        UI.ScreenGui:Destroy() 
    end)
    
    -- Obsługa przycisku mobilnego
    if UI.MobileToggle then
        UI.MobileToggle.MouseButton1Click:Connect(toggleMenu)
    end

    -- 5. PUBLICZNE API (Tabsy, Przyciski itd.)
    local WindowAPI = {}

    function WindowAPI:CreateTab(name)
        -- Tutaj w przyszłości dodasz logikę tworzenia stron
        print("Utworzono zakładkę: " .. name)
        
        local TabAPI = {}
        function TabAPI:CreateButton(text, callback)
            print("Przycisk: " .. text)
        end
        return TabAPI
    end

    return WindowAPI
end

return XHUB