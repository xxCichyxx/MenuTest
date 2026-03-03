local MenuLib = {}

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

    local menuId = "MenuInstance"
    local ProtectedLocation = nil
    pcall(function() ProtectedLocation = CoreGui end)
    if not ProtectedLocation then ProtectedLocation = PlayerGui end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and child:GetAttribute(menuId) then
            child:Destroy()
        end
    end

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
    local success, data = pcall(function() return HttpService:JSONDecode(readfile(themesFolder .. "/dark.json")) end)
    if success and type(data) == "table" then themeColors = data end

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

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[Config.ToggleUIKeybind or "Insert"] then toggleMenu() end
    end)
    UI.MinBtn.MouseButton1Click:Connect(toggleMenu)
    UI.CloseBtn.MouseButton1Click:Connect(function()
        if UI.ShowExitModal then UI.ShowExitModal() else UI.ScreenGui:Destroy() end
    end)
    if UI.MobileToggle then UI.MobileToggle.MouseButton1Click:Connect(toggleMenu) end

    -- // 5. PUBLICZNE API
    local WindowAPI = {}
    local userTabCounter = 2

    -- Ładowanie modułów elementów
    local ButtonElement = loadstring(game:HttpGet(baseUrl .. "elements/Button.lua"))()
    local ToggleElement = loadstring(game:HttpGet(baseUrl .. "elements/Toggle.lua"))()
    local ColorPickerElement = loadstring(game:HttpGet(baseUrl .. "elements/ColorPicker.lua"))()
    local SliderElement = loadstring(game:HttpGet(baseUrl .. "elements/Slider.lua"))()
    local InputElement = loadstring(game:HttpGet(baseUrl .. "elements/Input.lua"))()
    local DropdownElement = loadstring(game:HttpGet(baseUrl .. "elements/Dropdown.lua"))()

    function WindowAPI:CreateTab(name, icon, order)
        local TabElements = UI:CreateTab(name, icon or "layers", order or userTabCounter)
        if not order then userTabCounter = userTabCounter + 1 end

        local GridLayout = Instance.new("UIGridLayout")
        GridLayout.CellSize = UDim2.new(0.5, -5, 0, 35)
        GridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
        GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        GridLayout.Parent = TabElements.Page

        local TabAPI = {}
        TabAPI.Page = TabElements.Page -- NAPRAWA: Udostępniamy Page w API

        function TabAPI:CreateButton(options)
            return ButtonElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig)
        end

        function TabAPI:CreateToggle(options)
            return ToggleElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig)
        end

        function TabAPI:CreateColorPicker(options)
            return ColorPickerElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig)
        end

        function TabAPI:CreateSlider(options)
            return SliderElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig)
        end

        function TabAPI:CreateInput(options)
            return InputElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig)
        end

        function TabAPI:CreateDropdown(options)
            return DropdownElement(options, UI.ThemeManager, TabElements.Page, UI.MenuConfig, UI.SaveMenuConfig)
        end

        return TabAPI
    end

    UI.WindowAPI = WindowAPI

    -- // 6. ŁADOWANIE ZAKŁADEK SYSTEMOWYCH
    local DashboardModule = loadstring(game:HttpGet(baseUrl .. "tabs/Dashboard.lua"))()
    DashboardModule:Render(UI, 1)

    local SettingsModule = loadstring(game:HttpGet(baseUrl .. "tabs/Settings.lua"))()
    SettingsModule:Render(UI, 999, themeColors, mainFolder)

    return WindowAPI
end

return MenuLib