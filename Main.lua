local XHUB = {}

-- // SERWISY
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- // KONFIGURACJA ŚCIEŻEK
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"

-- // ŁADOWANIE MODUŁÓW
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

    -- 2. Tworzenie Okna
    local UI = WindowModule:Create({
        Name = Name,
        TestMobile = TestMobile,
        Tittle = Config.Tittle or "",
        TittlePos = Config.TittlePos or "Left"
    })
    UI.ScreenGui.Parent = ProtectedLocation

    -- 3. LOGIKA OTWIERANIA/ZAMYKANIA (Tweening)
    local isVisible = true
    local isTweening = false
    local MainFrame = UI.MainFrame
    
    local CenterPos = UDim2.new(0.5, 0, 0.5, 0)
    local HiddenPos = UDim2.new(0, -750, 1, 20)

    local function toggleMenu()
        if isTweening then return end
        isTweening = true
        
        local target = isVisible and HiddenPos or CenterPos
        
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
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Keybind] then
            toggleMenu()
        end
    end)

    UI.MinBtn.MouseButton1Click:Connect(toggleMenu)

    -- ZMIANA: Używamy ShowExitModal zamiast bezpośredniego Destroy
    UI.CloseBtn.MouseButton1Click:Connect(function()
        if UI.ShowExitModal then
            UI.ShowExitModal()
        else
            UI.ScreenGui:Destroy()
        end
    end)
    
    if UI.MobileToggle then
        UI.MobileToggle.MouseButton1Click:Connect(toggleMenu)
    end

    -- 5. ŁADOWANIE ZAKŁADEK SYSTEMOWYCH

    -- Dashboard (LayoutOrder = 1)
    local DashboardModule = loadstring(game:HttpGet(baseUrl .. "tabs/Dashboard.lua"))()
    DashboardModule:Render(UI, 1)

    -- 6. PUBLICZNE API (Tabsy, Przyciski itd.)
    local WindowAPI = {}
    local userTabCounter = 2 -- Zaczynamy od 2, bo 1 to Dashboard

    function WindowAPI:CreateTab(name, icon)
        local TabElements = UI:CreateTab(name, icon or "layers", userTabCounter)
        userTabCounter = userTabCounter + 1

        local TabAPI = {}
        function TabAPI:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Text = text
            Button.Size = UDim2.new(1, -40, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = TabElements.Page

            local Stroke = Instance.new("UIStroke", Button)
            Stroke.Color = Color3.fromRGB(60, 60, 60)
            Stroke.Thickness = 1
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

            if callback then
                Button.MouseButton1Click:Connect(callback)
            end
            return Button
        end
        return TabAPI
    end

    -- Settings (LayoutOrder = 999) - Ładujemy na końcu, ale z wysokim LayoutOrder
    local SettingsModule = loadstring(game:HttpGet(baseUrl .. "tabs/Settings.lua"))()
    SettingsModule:Render(UI, 999)

    return WindowAPI
end

return XHUB