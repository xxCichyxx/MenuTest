local XHUB = {}

-- // SERWISY
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
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

    -- // 1. SYSTEM PLIKÓW I MOTYWÓW
    local mainFolder = Name
    local themesFolder = mainFolder .. "/themes"
    local themePath = themesFolder .. "/dark.json"

    if not isfolder(mainFolder) then makefolder(mainFolder) end
    if not isfolder(mainFolder .. "/configs") then makefolder(mainFolder .. "/configs") end
    if not isfolder(mainFolder .. "/emotes") then makefolder(mainFolder .. "/emotes") end
    if not isfolder(themesFolder) then makefolder(themesFolder) end

    if not isfile(mainFolder .. "/emotes/favorites.json") then
        writefile(mainFolder .. "/emotes/favorites.json", "{}")
    end

    local themeColors
    if not isfile(themePath) then
        local defaultTheme = {
            Main = {15, 15, 15},
            Secondary = {25, 25, 25},
            Accent = {60, 60, 60},
            Accent2 = {40, 40, 40},
            Text = {255, 255, 255},
            Text_Secondary = {160, 160, 160},
            Success = {100, 255, 100}
        }
        writefile(themePath, HttpService:JSONEncode(defaultTheme))
        themeColors = defaultTheme
    else
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(themePath)) end)
        if success and type(data) == "table" then
            themeColors = data
        else
            -- Fallback w razie uszkodzonego pliku JSON
            themeColors = { Main = {15, 15, 15}, Secondary = {25, 25, 25}, Accent = {60, 60, 60}, Accent2 = {40, 40, 40}, Text = {255, 255, 255}, Text_Secondary = {160, 160, 160}, Success = {100, 255, 100} }
        end
    end

    -- 2. Wybór lokalizacji i czyszczenie starych wersji
    local ProtectedLocation = nil
    local success = pcall(function() ProtectedLocation = CoreGui end)
    if not success then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:sub(1,5) == "XHUB_") then
            child:Destroy()
        end
    end

    -- 3. Tworzenie Okna (przekazujemy motyw)
    local UI = WindowModule:Create({
        Name = Name,
        TestMobile = TestMobile,
        Tittle = Config.Tittle or "",
        TittlePos = Config.TittlePos or "Left",
        Theme = themeColors -- Przekazanie tabeli kolorów
    })
    UI.ScreenGui.Parent = ProtectedLocation

    -- 4. LOGIKA OTWIERANIA/ZAMYKANIA
    local isVisible = true
    local isTweening = false
    local MainFrame = UI.MainFrame
    
    local CenterPos = UDim2.new(0.5, 0, 0.5, 0)
    local HiddenPos = UDim2.new(0, -750, 1, 20)

    local function toggleMenu()
        if isTweening then return end
        isTweening = true
        local target = isVisible and HiddenPos or CenterPos
        if not isVisible then MainFrame.Visible = true end
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = target})
        tween:Play()
        tween.Completed:Connect(function()
            isVisible = not isVisible
            if not isVisible then MainFrame.Visible = false end
            isTweening = false
        end)
    end

    -- 5. OBSŁUGA ZDARZEŃ
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Keybind] then
            toggleMenu()
        end
    end)

    UI.MinBtn.MouseButton1Click:Connect(toggleMenu)
    UI.CloseBtn.MouseButton1Click:Connect(function()
        if UI.ShowExitModal then UI.ShowExitModal() else UI.ScreenGui:Destroy() end
    end)
    
    if UI.MobileToggle then UI.MobileToggle.MouseButton1Click:Connect(toggleMenu) end

    -- 6. ŁADOWANIE ZAKŁADEK SYSTEMOWYCH
    local DashboardModule = loadstring(game:HttpGet(baseUrl .. "tabs/Dashboard.lua"))()
    DashboardModule:Render(UI, 1, themeColors) -- Przekazujemy motyw

    -- 7. PUBLICZNE API
    local WindowAPI = {}
    local userTabCounter = 2

    function WindowAPI:CreateTab(name, icon)
        local TabElements = UI:CreateTab(name, icon or "layers", userTabCounter)
        userTabCounter = userTabCounter + 1

        local TabAPI = {}
        function TabAPI:CreateButton(text, callback)
            -- ... implementacja przycisku (też powinna używać motywu)
        end
        return TabAPI
    end

    -- Ładowanie Settings
    local SettingsModule = loadstring(game:HttpGet(baseUrl .. "tabs/Settings.lua"))()
    SettingsModule:Render(UI, 999, themeColors, mainFolder) -- Przekazujemy motyw i główny folder

    return WindowAPI
end

return XHUB