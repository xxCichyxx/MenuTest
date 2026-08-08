local MenuLib = {}

-- // SERWISY
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"

-- // SYSTEM BEZPIECZNEGO POBIERANIA (Safe HttpGet z retry)
local function safeHttpGet(url, maxRetries, retryDelay)
    maxRetries  = maxRetries  or 3
    retryDelay  = retryDelay  or 0.5
    for attempt = 1, maxRetries do
        local ok, result = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and type(result) == "string" and #result > 0 then
            return true, result
        end
        warn(string.format("[MenuLib] Próba %d/%d nie powiodła się: %s", attempt, maxRetries, tostring(url)))
        if attempt < maxRetries then task.wait(retryDelay) end
    end
    return false, nil
end

-- Pobierz, skompiluj i uruchom skrypt z URL. Zwraca wynik lub fallbackValue przy błędzie.
local function safeLoadUrl(url, fallbackValue)
    local ok, content = safeHttpGet(url)
    -- SPRAWDZENIE CZY TREŚĆ TO FAKTYCZNIE TEKST (zapobiega próbie kompilacji nil)
    if not ok or not content or type(content) ~= "string" or #content == 0 then
        warn("[MenuLib] Nie udało się pobrać lub treść jest pusta: " .. tostring(url))
        return fallbackValue
    end
    
    local chunk, compileErr = loadstring(content)
    if not chunk then
        warn("[MenuLib] Błąd kompilacji " .. tostring(url) .. ": " .. tostring(compileErr))
        return fallbackValue
    end
    
    local runOk, result = pcall(chunk)
    if not runOk then
        warn("[MenuLib] Błąd wykonania " .. tostring(url) .. ": " .. tostring(result))
        return fallbackValue
    end
    
    return result
end

-- Bezpieczna (no-op) wersja konstruktora elementu używana jako fallback
local function dummyElement()
    return {}
end
local function dummyElementLoader()
    return dummyElement
end

-- Fallback Window module (nie powinien się uruchomić, ale chroni przed crashem)
local WindowModuleFallback = {
    Create = function(self, config)
        warn("[MenuLib] KRYTYCZNY BŁĄD: Window.lua nie załadował się! Używam fallbacku.")
        local dummyGui   = Instance.new("ScreenGui")
        local dummyFrame = Instance.new("Frame")
        dummyFrame.Parent = dummyGui
        return {
            ScreenGui        = dummyGui,
            MainFrame        = dummyFrame,
            MinBtn           = Instance.new("TextButton"),
            CloseBtn         = Instance.new("TextButton"),
            Tabs             = {},
            Pages            = {},
            TabObjects       = {},
            _readyCallbacks  = {},
            ShowExitModal    = function() end,
            CreateTab        = function() return {Button = Instance.new("TextButton"), Page = Instance.new("ScrollingFrame")} end,
            SelectDashboard  = function() end,
            SelectTab        = function() end,
        }
    end
}

-- // FUNKCJE POMOCNICZE
function MenuLib:GenerateID(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length or 12 do
        result = result .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
    end
    return result
end

local function prettyEncode(tbl)
    local result = "{\n"
    local entries = {}
    local order = {"Main", "Secondary", "Accent", "Accent2", "Success", "Text", "Text_Secondary", "Close"}
    for _, k in ipairs(order) do
        if tbl[k] then
            table.insert(entries, "\t\"" .. k .. "\": [" .. table.concat(tbl[k], ", ") .. "]")
        end
    end
    for k, v in pairs(tbl) do
        local found = false
        for _, o in ipairs(order) do if o == k then found = true; break end end
        if not found then
            table.insert(entries, "\t\"" .. k .. "\": [" .. table.concat(v, ", ") .. "]")
        end
    end
    return result .. table.concat(entries, ",\n") .. "\n}"
end

-- // ============================================================
-- // GŁÓWNA FUNKCJA TWORZENIA OKNA
-- // ============================================================
function MenuLib:CreateWindow(options)
    local Config = options or {}
    local Name   = Config.Name or "Menu"

    -- CLEANUP
    local Connections = {}
    local function AddConnection(conn) table.insert(Connections, conn); return conn end
    local function Cleanup()
        for _, c in pairs(Connections) do if c then c:Disconnect() end end
        Connections = {}
    end

    -- USUWANIE STAREGO MENU
    local menuId = "MenuInstance"
    local ProtectedLocation
    pcall(function() ProtectedLocation = CoreGui end)
    if not ProtectedLocation then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and child:GetAttribute(menuId) then child:Destroy() end
    end

    -- FOLDERY I MOTYWY
    local mainFolder    = Name
    local themesFolder  = mainFolder .. "/themes"
    local configsFolder = mainFolder .. "/configs"

    if not isfolder(mainFolder)          then makefolder(mainFolder) end
    if not isfolder(configsFolder)       then makefolder(configsFolder) end
    if not isfolder(mainFolder.."/emotes") then makefolder(mainFolder.."/emotes") end
    if not isfolder(themesFolder)        then makefolder(themesFolder) end
    if not isfile(mainFolder.."/emotes/favorites.json") then
        writefile(mainFolder.."/emotes/favorites.json", "{}")
    end

    local darkTheme = {
        Main          = {15,  15,  15},
        Secondary     = {25,  25,  25},
        Accent        = {60,  60,  60},
        Accent2       = {40,  40,  40},
        Success       = {100, 255, 100},
        Text          = {255, 255, 255},
        Text_Secondary= {160, 160, 160},
        Close         = {200, 50,  50},
    }
    writefile(themesFolder .. "/dark.json", prettyEncode(darkTheme))

    local themeColors = darkTheme
    local sData, dData = pcall(function()
        return HttpService:JSONDecode(readfile(themesFolder .. "/dark.json"))
    end)
    if sData and type(dData) == "table" then themeColors = dData end

    local menuConfig     = {}
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

    -- Asset cache for remote modules (url -> content/module)
    local AssetCache = {}

    -- Cached version of safeLoadUrl: first checks AssetCache, otherwise fetches and stores.
    local function cachedLoadUrl(url, fallback)
        if AssetCache[url] ~= nil then
            return AssetCache[url]
        end
        local result = safeLoadUrl(url, fallback)
        AssetCache[url] = result
        return result
    end

    -- TWORZENIE OKNA
    local UI = cachedLoadUrl(baseUrl .. "Window.lua", WindowModuleFallback):Create({
        Name           = Name,
        Tittle         = Config.Tittle   or "",
        TittlePos      = Config.TittlePos or "Left",
        Theme          = themeColors,
        MenuId         = menuId,
        GenerateID     = function() return MenuLib:GenerateID() end,
        MenuConfig     = menuConfig,
        SaveMenuConfig = saveMenuConfig,
    })

    -- Upewnij się, że ScreenGui jest w odpowiednim miejscu (Window.lua może już to ustawić)
    if UI.ScreenGui.Parent ~= ProtectedLocation then
        UI.ScreenGui.Parent = ProtectedLocation
    end
    UI.ScreenGui.Destroying:Connect(Cleanup)

    -- LOGIKA TOGGLE MENU
    local isVisible  = true
    local isTweening = false
    local MainFrame  = UI.MainFrame
    local CenterPos  = UDim2.new(0.5, 0, 0.5, 0)
    local HiddenPos  = UDim2.new(0, -750, 1, 20)

    local function toggleMenu()
        if isTweening then return end
        isTweening = true
        local target = isVisible and HiddenPos or CenterPos
        if not isVisible then MainFrame.Visible = true end
        local tw = TweenService:Create(MainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
            {Position = target})
        tw:Play()
        tw.Completed:Connect(function()
            isVisible = not isVisible
            if not isVisible then MainFrame.Visible = false end
            isTweening = false
        end)
    end

    AddConnection(UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Config.ToggleUIKeybind or "Insert"] then
            toggleMenu()
        end
    end))

    if UI.MinBtn   then UI.MinBtn.MouseButton1Click:Connect(toggleMenu) end
    if UI.CloseBtn then
        UI.CloseBtn.MouseButton1Click:Connect(function()
            if UI.ShowExitModal then UI.ShowExitModal() else UI.ScreenGui:Destroy() end
        end)
    end
    if UI.MobileToggle then UI.MobileToggle.MouseButton1Click:Connect(toggleMenu) end

    -- // ============================================================
    -- // ŁADOWANIE ELEMENTÓW (bezpieczne, z fallbackiem)
    -- // ============================================================
    local ButtonElement       = cachedLoadUrl(baseUrl .. "elements/Button.lua",      dummyElementLoader)
    local ToggleElement       = cachedLoadUrl(baseUrl .. "elements/Toggle.lua",      dummyElementLoader)
    local ColorPickerElement  = cachedLoadUrl(baseUrl .. "elements/ColorPicker.lua", dummyElementLoader)
    local SliderElement       = cachedLoadUrl(baseUrl .. "elements/Slider.lua",      dummyElementLoader)
    local InputElement        = cachedLoadUrl(baseUrl .. "elements/Input.lua",       dummyElementLoader)
    local DropdownElement     = cachedLoadUrl(baseUrl .. "elements/Dropdown.lua",    dummyElementLoader)
    local ModuleElement       = cachedLoadUrl(baseUrl .. "elements/Module.lua",      dummyElementLoader)

    -- // ============================================================
    -- // PUBLICZNE API
    -- // ============================================================
    local WindowAPI = {}
    UI.WindowAPI    = WindowAPI

    UI._userTabCounter   = 2
    UI._systemTabsLoaded = false
    UI._isReady          = false
    UI._readyCallbacks   = {}

    function WindowAPI:CreateTab(name, icon, order)
        local tabOrder = order or UI._userTabCounter
        if not order then UI._userTabCounter = UI._userTabCounter + 1 end

        local TabElements = UI:CreateTab(name, icon or "layers", tabOrder)

        if not TabElements.Page:FindFirstChildOfClass("UIGridLayout") then
            local GridLayout = Instance.new("UIGridLayout")
            GridLayout.CellSize      = UDim2.new(0.48, 0, 0, 50)
            GridLayout.CellPadding   = UDim2.new(0.02, 0, 0, 10)
            GridLayout.SortOrder     = Enum.SortOrder.LayoutOrder
            GridLayout.FillDirection = Enum.FillDirection.Horizontal
            GridLayout.Parent        = TabElements.Page
        end

        TabElements.Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local TabAPI = {}
        TabAPI.Page  = TabElements.Page

        function TabAPI:CreateButton(opts)
            return ButtonElement(opts, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end
        function TabAPI:CreateToggle(opts)
            return ToggleElement(opts, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end
        function TabAPI:CreateColorPicker(opts)
            return ColorPickerElement(opts, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end
        function TabAPI:CreateSlider(opts)
            return SliderElement(opts, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end
        function TabAPI:CreateInput(opts)
            return InputElement(opts, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end
        function TabAPI:CreateDropdown(opts)
            return DropdownElement(opts, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end
        function TabAPI:CreateModule(opts)
            return ModuleElement(opts, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig, AddConnection)
        end

        return TabAPI
    end

    function WindowAPI:Init(callback)
        if type(callback) ~= "function" then return WindowAPI end
        WindowAPI._initCallback = callback
        if UI._systemTabsLoaded then
            task.spawn(function()
                local ok, err = pcall(callback, WindowAPI)
                if not ok then warn("[MenuLib] Błąd w Init callback: " .. tostring(err)) end
                UI:SelectDashboard()
            end)
        end
        return WindowAPI
    end

    function WindowAPI:OnReady(callback)
        if type(callback) ~= "function" then return WindowAPI end
        if UI._isReady then
            task.spawn(function() pcall(callback, WindowAPI) end)
        else
            table.insert(UI._readyCallbacks, function()
                pcall(callback, WindowAPI)
            end)
        end
        return WindowAPI
    end

    -- // ============================================================
    -- // ŁADOWANIE ZAKŁADEK SYSTEMOWYCH W TLE (Dashboard i Settings)
    -- // ============================================================
    task.spawn(function()
        -- 1. Dashboard (LayoutOrder = 1) ----------------------
        local dashOk, dashErr = pcall(function()
            local DashboardModule = safeLoadUrl(baseUrl .. "tabs/Dashboard.lua", nil)
            if DashboardModule and type(DashboardModule.Render) == "function" then
                DashboardModule:Render(UI, 1)
            else
                warn("[MenuLib] Dashboard.lua nie załadował się lub brak metody Render.")
            end
        end)
        if not dashOk then
            warn("[MenuLib] Błąd podczas renderowania Dashboard: " .. tostring(dashErr))
        end

        -- 2. Settings (LayoutOrder = 999) ----------------------
        local settOk, settErr = pcall(function()
            local SettingsModule = safeLoadUrl(baseUrl .. "tabs/Settings.lua", nil)
            if SettingsModule and type(SettingsModule.Render) == "function" then
                SettingsModule:Render(UI, 999, themeColors, mainFolder)
            else
                warn("[MenuLib] Settings.lua nie załadował się lub brak metody Render.")
            end
        end)
        if not settOk then
            warn("[MenuLib] Błąd podczas renderowania Settings: " .. tostring(settErr))
        end

        -- Zakładki systemowe załadowane
        UI._systemTabsLoaded = true

        -- 3. Uruchom Init callback użytkownika (jeśli zarejestrowany)
        if WindowAPI._initCallback then
            local ok, err = pcall(WindowAPI._initCallback, WindowAPI)
            if not ok then
                warn("[MenuLib] Błąd w Init callback: " .. tostring(err))
            end
        end

        -- 4. Oznacz bibliotekę jako gotową i uruchom OnReady callbacks
        UI._isReady = true
        for _, cb in ipairs(UI._readyCallbacks) do
            task.spawn(cb)
        end

        -- 5. Wybierz Dashboard jako domyślną zakładkę.
        --    task.wait() daje Robloxowi czas na obliczenie AbsolutePosition.
        task.wait()
        UI:SelectDashboard()
    end)

    return WindowAPI
end

return MenuLib