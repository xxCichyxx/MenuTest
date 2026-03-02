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

-- Funkcja do ładnego formatowania JSON
function prettyEncode(tbl)
    local result = "{\n"
    local entries = {}
    for k, v in pairs(tbl) do
        local keyStr = "\t\"" .. tostring(k) .. "\": "
        local valStr = "[" .. table.concat(v, ", ") .. "]"
        table.insert(entries, keyStr .. valStr)
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

    -- Definicje motywów
    local darkTheme = {
        Main = {15, 15, 15},
        Secondary = {25, 25, 25},
        Accent = {60, 60, 60},
        Accent2 = {40, 40, 40},
        Text = {255, 255, 255},
        Text_Secondary = {160, 160, 160},
        Success = {100, 255, 100},
        Close = {200, 50, 50}
    }
    local lightTheme = {
        Main = {245, 245, 245},
        Secondary = {230, 230, 230},
        Accent = {200, 200, 200},
        Accent2 = {215, 215, 215},
        Text = {30, 30, 30},
        Text_Secondary = {100, 100, 100},
        Success = {40, 180, 40},
        Close = {200, 50, 50}
    }

    if not isfile(themesFolder .. "/dark.json") then
        writefile(themesFolder .. "/dark.json", prettyEncode(darkTheme))
    end
    if not isfile(themesFolder .. "/light.json") then
        writefile(themesFolder .. "/light.json", prettyEncode(lightTheme))
    end

    local themeColors
    local success, data = pcall(function() return HttpService:JSONDecode(readfile(themesFolder .. "/dark.json")) end)
    if success and type(data) == "table" then
        themeColors = data
    else
        themeColors = darkTheme -- Fallback
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

    -- 4. OBSŁUGA ZDARZEŃ
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Keybind] then toggleMenu() end
    end)
    UI.MinBtn.MouseButton1Click:Connect(toggleMenu)
    UI.CloseBtn.MouseButton1Click:Connect(function()
        if UI.ShowExitModal then UI.ShowExitModal() else UI.ScreenGui:Destroy() end
    end)
    if UI.MobileToggle then UI.MobileToggle.MouseButton1Click:Connect(toggleMenu) end

    -- 5. ŁADOWANIE ZAKŁADEK
    local DashboardModule = loadstring(game:HttpGet(baseUrl .. "tabs/Dashboard.lua"))()
    DashboardModule:Render(UI, 1, themeColors)

    local SettingsModule = loadstring(game:HttpGet(baseUrl .. "tabs/Settings.lua"))()
    SettingsModule:Render(UI, 999, themeColors, mainFolder)

    -- 6. PUBLICZNE API
    local WindowAPI = {}
    local userTabCounter = 2
    function WindowAPI:CreateTab(name, icon)
        -- ...
    end
    return WindowAPI
end

return XHUB