local MenuLib = {}

-- // SERWISY
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"

-- // SYSTEM BEZPIECZNEGO POBIERANIA (Safe Loading with Retries & Fallback)
local function safeHttpGet(url, maxRetries, delayTime)
    maxRetries = maxRetries or 3
    delayTime = delayTime or 0.5
    for attempt = 1, maxRetries do
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and type(result) == "string" and #result > 0 then
            return true, result
        end
        if attempt < maxRetries then
            task.wait(delayTime)
        end
    end
    return false, nil
end

local function safeLoadUrl(url, fallbackValue)
    local ok, content = safeHttpGet(url, 3, 0.5)
    if ok and content then
        local loadedFunc, err = loadstring(content)
        if loadedFunc then
            local runOk, result = pcall(loadedFunc)
            if runOk then
                return result
            else
                warn("[MenuLib] Błąd wykonania skryptu z URL (" .. tostring(url) .. "): " .. tostring(result))
            end
        else
            warn("[MenuLib] Błąd kompilacji skryptu z URL (" .. tostring(url) .. "): " .. tostring(err))
        end
    else
        warn("[MenuLib] Nie udało się pobrać pliku z URL: " .. tostring(url))
    end
    return fallbackValue
end

local WindowModuleFallback = {
    Create = function(config)
        warn("[MenuLib] Wywołano awaryjny WindowModule")
        local dummyScreen = Instance.new("ScreenGui")
        local dummyFrame = Instance.new("Frame")
        dummyFrame.Parent = dummyScreen
        return {
            ScreenGui = dummyScreen,
            MainFrame = dummyFrame,
            MinBtn = Instance.new("TextButton"),
            CloseBtn = Instance.new("TextButton"),
            CreateTab = function() return { Button = Instance.new("TextButton"), Page = Instance.new("ScrollingFrame") } end,
            SelectDashboard = function() end,
            Tabs = {},
            Pages = {},
            _readyCallbacks = {}
        }
    end
}

local WindowModule = safeLoadUrl(baseUrl .. "Window.lua", WindowModuleFallback)

-- // FUNKCJE POMOCNICZE
function MenuLib:GenerateID(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length or 12 do
        result = result .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
    end
    return result
end

function prettyEncode(tbl)
    local result = "{\n"
    local entries = {}
    local order = {"Main", "Secondary", "Accent", "Accent2", "Success", "Text", "Text_Secondary", "Close"}
    for _, k in ipairs(order) do
        if tbl[k] then
            local v = tbl[k]
            local keyStr = "\t\"" .. tostring(k) .. "\": "
            local valStr = "[" .. table.concat(v, ", ") .. "]"
            table.insert(entries, keyStr .. valStr)
        end
    end
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

function MenuLib:CreateWindow(options)
    local Config = options or {}
    local Name = Config.Name or "Menu"

    -- // SYSTEM CLEANUP (Zarządzanie połączeniami)
    local Connections = {}

    local function AddConnection(conn)
        table.insert(Connections, conn)
        return conn
    end

    local function Cleanup()
        for _, conn in pairs(Connections) do
            if conn then conn:Disconnect() end
        end
        Connections = {}
    end

    -- // 1. SYSTEM IDENTYFIKACJI I USUWANIA STAREGO MENU
    local menuId = "MenuInstance"
    local ProtectedLocation = nil
    pcall(function() ProtectedLocation = CoreGui end)
    if not ProtectedLocation then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and child:GetAttribute(menuId) then
            child:Destroy()
        end
    end

    -- // 2. SYSTEM PLIKÓW I MOTYWÓW
    local mainFolder = Name
    local themesFolder = mainFolder .. "/themes"
    local configsFolder = mainFolder .. "/configs"

    if not isfolder(mainFolder) then makefolder(mainFolder) end
    if not isfolder(configsFolder) then makefolder(configsFolder) end
    if not isfolder(mainFolder .. "/emotes") then makefolder(mainFolder .. "/emotes") end
    if not isfolder(themesFolder) then makefolder(themesFolder) end

    if not isfile(mainFolder .. "/emotes/favorites.json") then
        writefile(mainFolder .. "/emotes/favorites.json", "{}")
    end

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
    writefile(themesFolder .. "/dark.json", prettyEncode(darkTheme))

    local themeColors = darkTheme
    local sData, dData = pcall(function() return HttpService:JSONDecode(readfile(themesFolder .. "/dark.json")) end)
    if sData and type(dData) == "table" then themeColors = dData end

    local menuConfig = {}
    local configFilePath = configsFolder .. "/settings.json"

    local function loadMenuConfig()
        if isfile(configFilePath) then
            local s, d = pcall(function() return HttpService:JSONDecode(readfile(configFilePath)) end)
            if s and type(d) == "table" then menuConfig = d end
        end
    end
    loadMenuConfig()

    local function saveMenuConfig(flag, value)
        menuConfig[flag] = value
        writefile(configFilePath, HttpService:JSONEncode(menuConfig))
    end

    -- 3. TWORZENIE OKNA
    local UI = WindowModule:Create({
        Name = Name,
        Tittle = Config.Tittle or "",
        TittlePos = Config.TittlePos or "Left",
        Theme = themeColors,
        MenuId = menuId,
        GenerateID = MenuLib.GenerateID,
        MenuConfig = menuConfig,
        SaveMenuConfig = saveMenuConfig
    })
    UI.ScreenGui.Parent = ProtectedLocation

    UI.ScreenGui.Destroying:Connect(Cleanup)

    -- 4. LOGIKA UI
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

    AddConnection(UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Config.ToggleUIKeybind or "Insert"] then toggleMenu() end
    end))

    if UI.MinBtn then UI.MinBtn.MouseButton1Click:Connect(toggleMenu) end
    if UI.CloseBtn then
        UI.CloseBtn.MouseButton1Click:Connect(function()
            if UI.ShowExitModal then
                UI.ShowExitModal()
            else
                UI.ScreenGui:Destroy()
            end
        end)
    end
    if UI.MobileToggle then UI.MobileToggle.MouseButton1Click:Connect(toggleMenu) end

    -- // 5. PUBLICZNE API
    local WindowAPI = {}
    UI._userTabCounter = 2
    UI._systemTabsLoaded = false
    UI._isSystemLoading = false
    UI._isReady = false
    UI._readyCallbacks = UI._readyCallbacks or {}

    local dummyElementConstructor = function() return function() return {} end end

    local ButtonElement = safeLoadUrl(baseUrl .. "elements/Button.lua", dummyElementConstructor)
    local ToggleElement = safeLoadUrl(baseUrl .. "elements/Toggle.lua", dummyElementConstructor)
    local ColorPickerElement = safeLoadUrl(baseUrl .. "elements/ColorPicker.lua", dummyElementConstructor)
    local SliderElement = safeLoadUrl(baseUrl .. "elements/Slider.lua", dummyElementConstructor)
    local InputElement = safeLoadUrl(baseUrl .. "elements/Input.lua", dummyElementConstructor)
    local DropdownElement = safeLoadUrl(baseUrl .. "elements/Dropdown.lua", dummyElementConstructor)
    local ModuleElement = safeLoadUrl(baseUrl .. "elements/Module.lua", dummyElementConstructor)

    function WindowAPI:CreateTab(name, icon, order)
        -- Odczekaj na zakładki systemowe tylko jeśli wywołanie pochodzi z kodu użytkownika (poza procesem ładowania systemowego)
        if not UI._systemTabsLoaded and not UI._isSystemLoading then
            while not UI._systemTabsLoaded do
                task.wait()
            end
        end

        local tabOrder = order or UI._userTabCounter
        if not order then UI._userTabCounter = UI._userTabCounter + 1 end

        local TabElements = UI:CreateTab(name, icon or "layers", tabOrder)

        local GridLayout = Instance.new("UIGridLayout")
        GridLayout.CellSize = UDim2.new(0.48, 0, 0, 50)
        GridLayout.CellPadding = UDim2.new(0.02, 0, 0, 10)
        GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        GridLayout.FillDirection = Enum.FillDirection.Horizontal
        GridLayout.Parent = TabElements.Page

        TabElements.Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local TabAPI = {}
        TabAPI.Page = TabElements.Page

        function TabAPI:CreateButton(options)
            return ButtonElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        function TabAPI:CreateToggle(options)
            return ToggleElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        function TabAPI:CreateColorPicker(options)
            return ColorPickerElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        function TabAPI:CreateSlider(options)
            return SliderElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        function TabAPI:CreateInput(options)
            return InputElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        function TabAPI:CreateDropdown(options)
            return DropdownElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        function TabAPI:CreateModule(options)
            return ModuleElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        return TabAPI
    end

    -- Funkcja inicjalizująca / callbackowa do rejestracji zakładek użytkownika po ładowaniu zakładek systemowych
    function WindowAPI:Init(callback)
        if type(callback) == "function" then
            WindowAPI._initCallback = callback
            if UI._systemTabsLoaded then
                task.spawn(function()
                    local ok, err = pcall(callback, WindowAPI)
                    if not ok then warn("[MenuLib] Błąd w callbacku Init: " .. tostring(err)) end
                    UI:SelectDashboard()
                end)
            end
        end
        return WindowAPI
    end

    function WindowAPI:OnReady(callback)
        if UI._isReady then
            task.spawn(function() pcall(callback, WindowAPI) end)
        else
            table.insert(UI._readyCallbacks, function()
                pcall(callback, WindowAPI)
            end)
        end
        return WindowAPI
    end

    UI.WindowAPI = WindowAPI

    -- // SEKWENCYJNE I SYNCHRONICZNE ŁADOWANIE ZAKŁADEK SYSTEMOWYCH W TLE
    task.spawn(function()
        UI._isSystemLoading = true

        -- 1. Najpierw Dashboard.lua (LayoutOrder = 1)
        local DashboardModule = safeLoadUrl(baseUrl .. "tabs/Dashboard.lua", nil)
        if DashboardModule and type(DashboardModule.Render) == "function" then
            pcall(function()
                DashboardModule:Render(UI, 1)
            end)
        else
            warn("[MenuLib] Nie udało się załadować Dashboard.lua (pomijanie/fallback)")
        end

        -- 2. Następnie Settings.lua (LayoutOrder = 999)
        local SettingsModule = safeLoadUrl(baseUrl .. "tabs/Settings.lua", nil)
        if SettingsModule and type(SettingsModule.Render) == "function" then
            pcall(function()
                SettingsModule:Render(UI, 999, themeColors, mainFolder)
            end)
        else
            warn("[MenuLib] Nie udało się załadować Settings.lua (pomijanie/fallback)")
        end

        -- Zakładki systemowe w pełni zainicjalizowane
        UI._systemTabsLoaded = true
        UI._isSystemLoading = false

        -- 3. Jeśli użytkownik zarejestrował metodę Init, wykonujemy ją teraz
        if WindowAPI._initCallback then
            local ok, err = pcall(WindowAPI._initCallback, WindowAPI)
            if not ok then
                warn("[MenuLib] Błąd w callbacku Init: " .. tostring(err))
            end
        end

        UI._isReady = true
        if UI._readyCallbacks then
            for _, cb in ipairs(UI._readyCallbacks) do
                task.spawn(cb)
            end
        end

        -- 4. DOMYŚLNY WYBÓR DASHBOARD:
        -- Po zakończeniu ładowania wszystkich zakładek (systemowych i użytkownika)
        -- automatycznie aktywujemy i wybieramy pierwszą zakładkę od góry (Dashboard).
        task.defer(function()
            UI:SelectDashboard()
        end)
    end)

    return WindowAPI
end

return MenuLib