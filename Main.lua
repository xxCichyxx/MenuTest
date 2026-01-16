local XHUB = {}

-- // SERWISY
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"

local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()
local WindowModule = loadstring(game:HttpGet(baseUrl .. "Window.lua"))()
local Interactions = loadstring(game:HttpGet(baseUrl .. "Interactions.lua"))()

function XHUB:CreateWindow(options)
    -- 1. Parametry wejściowe
    local Config = options or {}
    local Name = Config.Name or "X HUB"
    local Keybind = Config.ToggleUIKeybind or "Insert"
    local TestMobile = Config.TestMobile or false
    
    -- 2. Lokalizacja i czyszczenie starego GUI
    local ProtectedLocation = nil
    local success = pcall(function() ProtectedLocation = CoreGui end)
    if not success then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:sub(1,5) == "XHUB_") then
            child:Destroy()
        end
    end

    -- 3. Inicjalizacja Szkieletu (z Window.lua)
    local UI = WindowModule:Create({
        Name = Name,
        TestMobile = TestMobile
    })
    UI.ScreenGui.Parent = ProtectedLocation

    -- 4. Podpinanie Ikon do przycisków kontrolnych
    -- (createIconBtn z poprzedniego kodu można teraz zintegrować tutaj lub w Window.lua)
    -- Dla przykładu podpinamy Resize Icon:
    Icons:Apply(UI.ResizeHandle:FindFirstChild("Icon"), "arrow-down-right")

    -- 5. Logika Toggle (Otwieranie/Zamykanie)
    local isVisible = true
    local isTweening = false
    local CurrentMainPos = UI.MainFrame.Position
    local HiddenPos = UDim2.new(0, -750, UI.MainFrame.Position.Y.Scale, UI.MainFrame.Position.Y.Offset)

    local function toggleMenu()
        if isTweening then return end
        isTweening = true
        
        if isVisible then CurrentMainPos = UI.MainFrame.Position end
        local target = isVisible and HiddenPos or CurrentMainPos
        
        -- Aktualizacja napisu na przycisku mobilnym
        if UI.MobileToggleText then
            UI.MobileToggleText.Text = isVisible and "Open" or "Close"
            UI.MobileToggleText.TextColor3 = isVisible and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end

        if not isVisible then UI.MainFrame.Visible = true end
        
        local tween = TweenService:Create(UI.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = target})
        tween:Play()
        tween.Completed:Connect(function()
            isVisible = not isVisible
            if not isVisible then UI.MainFrame.Visible = false end
            isTweening = false
        end)
    end

    -- 6. Reakcja na klawisz i przyciski
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Keybind] then
            toggleMenu()
        end
    end)

    if UI.MobileToggle then
        UI.MobileToggle.MouseButton1Click:Connect(toggleMenu)
        Interactions:MakeDraggable(UI.MobileToggle, UI.MobileToggle) -- Przycisk mobilny też można przesuwać
    end

    -- 7. Interakcje (Drag & Resize)
    Interactions:MakeDraggable(UI.TopBar, UI.MainFrame)
    Interactions:MakeResizable(UI.ResizeHandle, UI.MainFrame, 600, 350)

    -- 8. API Zwracane użytkownikowi
    local WindowAPI = {}
    
    function WindowAPI:CreateTab(tabName)
        -- Tu będziesz wywoływał Elements.lua do tworzenia zakładek
        print("Tab created: " .. tabName)
    end

    return WindowAPI
end

return XHUB