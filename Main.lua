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

-- Funkcja do ładnego formatowania JSON (Pretty Print)
function prettyEncode(tbl)
    local result = "{\n"
    local entries = {}

    -- Kolejność kluczy dla estetyki (opcjonalne, ale ładne)
    local order = {"Main", "Secondary", "Accent", "Accent2", "Success", "Text", "Text_Secondary", "Close"}

    for _, k in ipairs(order) do
        if tbl[k] then
            local v = tbl[k]
            local keyStr = "\t\"" .. tostring(k) .. "\": "
            local valStr = "[" .. table.concat(v, ", ") .. "]"
            table.insert(entries, keyStr .. valStr)
        end
    end

    -- Dodaj pozostałe klucze, jeśli są
    for k, v in pairs(tbl) do
        local found = false
        for _, o in ipairs(order) do if o == k then found = true break end end
        if not found then
            local keyStr = "\t\"" .. tostring(k) .. "\": "
            local valStr = "[" .. table.concat(v, ", ") .. "]"
            table.insert(entries, keyStr .. valStr)
        end
    end

    result = result .. table.concat(entries, ",\n") .. "\n}"
    return result
end

function XHUB:CreateWindow(options)
    local Config = options or {}
    local Name = Config.Name or "X HUB"
    local Keybind = Config.ToggleUIKeybind or "Insert"
    local TestMobile = Config.TestMobile or false

    -- // 1. SYSTEM PLIKÓW I MOTYWÓW
    local mainFolder = Name
    local themesFolder = mainFolder .. "/themes"

    if not isfolder(mainFolder) then makefolder(mainFolder) end
    if not isfolder(mainFolder .. "/configs") then makefolder(mainFolder .. "/configs") end
    if not isfolder(mainFolder .. "/emotes") then makefolder(mainFolder .. "/emotes") end
    if not isfolder(themesFolder) then makefolder(themesFolder) end

    if not isfile(mainFolder .. "/emotes/favorites.json") then
        writefile(mainFolder .. "/emotes/favorites.json", "{}")
    end

    -- Definicja motywu DARK (Zgodnie z Twoim wzorem)
    local darkTheme = {
        Main = {15, 15, 15},
        Secondary = {25, 25, 25},
        Accent = {60, 60, 60},
        Accent2 = {40, 40, 40},
        Success = {100, 255, 100},
        Text = {255, 255, 255},
        Text_Secondary = {160, 160, 160},
        Close = {200, 50, 50}
    }

    -- ZAWSZE nadpisujemy dark.json przy starcie, aby naprawić ewentualne błędy struktury
    -- (W produkcji można to zmienić na sprawdzanie czy istnieje, ale teraz naprawiamy błędy)
    writefile(themesFolder .. "/dark.json", prettyEncode(darkTheme))

    local themeColors = darkTheme
    -- Próba odczytu (na wypadek gdyby użytkownik zmienił coś ręcznie poprawnie)
    local success, data = pcall(function() return HttpService:JSONDecode(readfile(themesFolder .. "/dark.json")) end)
    if success and type(data) == "table" then
        themeColors = data
    end

    -- 2. Tworzenie Okna
    local ProtectedLocation = nil
    pcall(function() ProtectedLocation = CoreGui end)
    if not ProtectedLocation then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:sub(1,5) == "XHUB_") then child:Destroy() end
    end

    local UI = WindowModule:Create({
        Name = Name,
        TestMobile = TestMobile,
        Tittle = Config.Tittle or "",
        TittlePos = Config.TittlePos or "Left",
        Theme = themeColors
    })
    UI.ScreenGui.Parent = ProtectedLocation

    -- 3. LOGIKA OTWIERANIA/ZAMYKANIA
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

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Keybind] then toggleMenu() end
    end)
    UI.MinBtn.MouseButton1Click:Connect(toggleMenu)
    UI.CloseBtn.MouseButton1Click:Connect(function()
        if UI.ShowExitModal then UI.ShowExitModal() else UI.ScreenGui:Destroy() end
    end)
    if UI.MobileToggle then UI.MobileToggle.MouseButton1Click:Connect(toggleMenu) end

    -- 4. ŁADOWANIE ZAKŁADEK SYSTEMOWYCH
    local DashboardModule = loadstring(game:HttpGet(baseUrl .. "tabs/Dashboard.lua"))()
    DashboardModule:Render(UI, 1)

    local SettingsModule = loadstring(game:HttpGet(baseUrl .. "tabs/Settings.lua"))()
    SettingsModule:Render(UI, 999, themeColors, mainFolder)

    -- 5. PUBLICZNE API (Naprawione)
    local WindowAPI = {}
    local userTabCounter = 2

    function WindowAPI:CreateTab(name, icon)
        -- Wywołujemy funkcję z Window.lua, która zwraca {Button, Page}
        local TabElements = UI:CreateTab(name, icon or "layers", userTabCounter)
        userTabCounter = userTabCounter + 1

        local TabAPI = {}

        function TabAPI:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Text = text
            Button.Size = UDim2.new(1, -40, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Domyślny, ThemeManager nadpisze
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = TabElements.Page -- Dodajemy do strony!

            -- Rejestracja w ThemeManager
            UI.ThemeManager:Register(Button, "BackgroundColor3", "Secondary")
            UI.ThemeManager:Register(Button, "TextColor3", "Text")

            local Stroke = Instance.new("UIStroke", Button)
            Stroke.Color = Color3.fromRGB(60, 60, 60)
            Stroke.Thickness = 1
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UI.ThemeManager:Register(Stroke, "Color", "Accent")

            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

            if callback then
                Button.MouseButton1Click:Connect(callback)
            end
            return Button
        end

        return TabAPI
    end

    return WindowAPI
end

return XHUB