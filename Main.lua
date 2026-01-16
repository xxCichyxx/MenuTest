local XHUB = {}

-- // SERWISY
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- // KONFIGURACJA ŚCIEŻEK (GitHub)
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"

-- // ŁADOWANIE MODUŁÓW (Musi być w tej kolejności)
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()
local WindowModule = loadstring(game:HttpGet(baseUrl .. "Window.lua"))()
local Interactions = loadstring(game:HttpGet(baseUrl .. "Interactions.lua"))()

-- // FUNKCJE POMOCNICZE
local function generatePureRandomName()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomName = ""
    for i = 1, 15 do
        local rand = math.random(1, #chars)
        randomName = randomName .. string.sub(chars, rand, rand)
    end
    return randomName
end

function XHUB:CreateWindow(options)
    local Config = options or {}
    local Name = Config.Name or "X HUB"
    local Keybind = Config.ToggleUIKeybind or "Insert"
    local TestMobile = Config.TestMobile or false
    
    -- 1. Lokalizacja i czyszczenie starego GUI
    local ProtectedLocation = nil
    local success = pcall(function() ProtectedLocation = CoreGui end)
    if not success then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:sub(1,5) == "XHUB_") then
            child:Destroy()
        end
    end

    -- 2. Tworzenie Szkieletu (z Window.lua)
    local UI = WindowModule:Create({
        Name = Name,
        TestMobile = TestMobile
    })
    UI.ScreenGui.Name = "XHUB_" .. generatePureRandomName()
    UI.ScreenGui.Parent = ProtectedLocation

    -- 3. FUNKCJA TWORZENIA PRZYCISKÓW Z IKONAMI (Naprawa błędu ikon)
    local function createIconBtn(iconName, pos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 1, 0)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = UI.Controls

        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 17, 0, 17) 
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.BackgroundTransparency = 1
        iconImg.ImageColor3 = Color3.fromRGB(200, 200, 200)
        iconImg.Parent = btn
        
        Icons:Apply(iconImg, iconName) -- Wywołanie modułu Icons
        return btn
    end

    local MinBtn = createIconBtn("minus", UDim2.new(0, 0, 0, 0))
    local MaxBtn = createIconBtn("maximize-2", UDim2.new(0, 35, 0, 0))
    local CloseBtn = createIconBtn("x", UDim2.new(0, 70, 0, 0))

    -- Dodanie ikony do ResizeHandle
    local ResizeIcon = Instance.new("ImageLabel")
ResizeIcon.Name = "Icon" -- TERAZ FindFirstChild go znajdzie
ResizeIcon.Size = UDim2.new(0, 15, 0, 15)
ResizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
ResizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
ResizeIcon.BackgroundTransparency = 1
ResizeIcon.ImageColor3 = Color3.fromRGB(80, 80, 80)
ResizeIcon.Parent = UI.ResizeHandle
    Icons:Apply(ResizeIcon, "arrow-down-right")

    -- 4. AKTYWACJA INTERAKCJI (Naprawa błędu interakcji)
    Interactions:MakeDraggable(UI.TopBar, UI.MainFrame)
    Interactions:MakeResizable(UI.ResizeHandle, UI.MainFrame, 600, 350)

    -- 5. LOGIKA OTWIERANIA/ZAMYKANIA
    local isVisible = true
    local isTweening = false
    local CurrentMainPos = UI.MainFrame.Position
    local HiddenPos = UDim2.new(0, -850, UI.MainFrame.Position.Y.Scale, UI.MainFrame.Position.Y.Offset)

    local function toggleMenu()
        if isTweening then return end
        isTweening = true
        
        if isVisible then CurrentMainPos = UI.MainFrame.Position end
        local target = isVisible and HiddenPos or CurrentMainPos
        
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

    -- 6. OBSŁUGA BINDA I PRZYCISKÓW
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Keybind] then
            toggleMenu()
        end
    end)

    MinBtn.MouseButton1Click:Connect(toggleMenu)
    CloseBtn.MouseButton1Click:Connect(function() UI.ScreenGui:Destroy() end)
    
    if UI.MobileToggle then
        UI.MobileToggle.MouseButton1Click:Connect(toggleMenu)
        Interactions:MakeDraggable(UI.MobileToggle, UI.MobileToggle)
    end

    -- 7. API OKNA
    local WindowAPI = {}
    function WindowAPI:CreateTab(name)
        print("Tab: " .. name)
    end
    return WindowAPI
end

return XHUB