return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

    -- Główny kontener modułu
    local ModuleFrame = Instance.new("Frame")
    ModuleFrame.Name = options.Name or "Module"
    ModuleFrame.Size = UDim2.new(0.5, -5, 0, 35) -- Startowa wysokość (zwinięty)
    ModuleFrame.BackgroundTransparency = 1
    ModuleFrame.ClipsDescendants = true -- Ważne dla animacji rozwijania
    ModuleFrame.Parent = parent

    -- Przycisk główny (Header)
    local HeaderBtn = Instance.new("TextButton")
    HeaderBtn.Name = "Header"
    HeaderBtn.Size = UDim2.new(1, 0, 0, 35)
    HeaderBtn.Text = ""
    HeaderBtn.Parent = ModuleFrame
    themeManager:Register(HeaderBtn, "BackgroundColor3", "Secondary")

    Instance.new("UICorner", HeaderBtn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", HeaderBtn)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    -- Ikona (opcjonalna)
    if options.Icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 10, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.Parent = HeaderBtn
        themeManager:Register(Icon, "ImageColor3", "Text")
        Icons:Apply(Icon, options.Icon)
    end

    -- Nazwa modułu
    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Module"
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Position = UDim2.new(0, options.Icon and 40 or 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = HeaderBtn
    themeManager:Register(Label, "TextColor3", "Text")

    -- Przycisk rozwijania (strzałka)
    local ExpandBtn = Instance.new("ImageButton")
    ExpandBtn.Size = UDim2.new(0, 20, 0, 20)
    ExpandBtn.Position = UDim2.new(1, -30, 0.5, 0)
    ExpandBtn.AnchorPoint = Vector2.new(0, 0.5)
    ExpandBtn.BackgroundTransparency = 1
    ExpandBtn.Parent = HeaderBtn
    themeManager:Register(ExpandBtn, "ImageColor3", "Text_Secondary")
    Icons:Apply(ExpandBtn, "chevron-down")

    -- Kontener na opcje (wewnętrzny)
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Name = "Options"
    OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 0, 0, 40) -- Pod nagłówkiem
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.Parent = ModuleFrame

    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 5)
    OptionsLayout.Parent = OptionsContainer

    local OptionsPadding = Instance.new("UIPadding")
    OptionsPadding.PaddingLeft = UDim.new(0, 10)
    OptionsPadding.PaddingRight = UDim.new(0, 10)
    OptionsPadding.PaddingBottom = UDim.new(0, 10)
    OptionsPadding.Parent = OptionsContainer

    -- Logika Toggle (Włączanie/Wyłączanie modułu)
    local Enabled = options.Default or false
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Enabled = menuConfig[options.Flag]
    end

    local function UpdateState()
        if Enabled then
            themeManager:Register(HeaderBtn, "BackgroundColor3", "Success") -- Zielony gdy włączony? Albo inny akcent
            -- Lepiej: Zmienić kolor tekstu lub dodać wskaźnik, żeby nie psuć stylu
            -- Tutaj prosta zmiana koloru tekstu na zielony
            Label.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            themeManager:Register(HeaderBtn, "BackgroundColor3", "Secondary")
            themeManager:Register(Label, "TextColor3", "Text")
        end
    end

    -- Kliknięcie w nagłówek włącza/wyłącza moduł (chyba że klikniemy w strzałkę)
    HeaderBtn.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        UpdateState()
        if options.Flag then saveMenuConfig(options.Flag, Enabled) end
        if options.Callback then options.Callback(Enabled) end
    end)

    -- Logika Rozwijania
    local Expanded = false
    ExpandBtn.MouseButton1Click:Connect(function()
        Expanded = not Expanded

        local targetHeight = 35 -- Wysokość zwinięta
        if Expanded then
            -- Oblicz wysokość opcji
            targetHeight = 35 + OptionsLayout.AbsoluteContentSize.Y + 15 -- + paddingi
            Icons:Apply(ExpandBtn, "chevron-up")
        else
            Icons:Apply(ExpandBtn, "chevron-down")
        end

        TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.5, -5, 0, targetHeight)
        }):Play()
    end)

    UpdateState()

    -- API Modułu (Dodawanie opcji)
    local ModuleAPI = {}

    -- Ładowanie sub-elementów (używamy tych samych co w CreateTab, ale z innym rodzicem)
    -- Musimy załadować je tutaj dynamicznie lub przekazać fabryki.
    -- Dla uproszczenia załaduję je tutaj ponownie, ale w produkcji lepiej przekazać referencje.
    local SliderElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Slider.lua"))()
    local ToggleElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Toggle.lua"))()
    local DropdownElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Dropdown.lua"))()

    function ModuleAPI:AddSlider(subOptions)
        local slider = SliderElement(subOptions, themeManager, OptionsContainer, menuConfig, saveMenuConfig)
        -- Dostosowanie stylu dla sub-elementu (np. mniejszy, bez tła)
        if slider.Frame then -- Zakładając, że Slider zwraca obiekt z Frame
             slider.Frame.Size = UDim2.new(1, 0, 0, 30)
             slider.Frame.BackgroundTransparency = 1
        end
        return slider
    end

    function ModuleAPI:AddToggle(subOptions)
        local toggle = ToggleElement(subOptions, themeManager, OptionsContainer, menuConfig, saveMenuConfig)
        -- Dostosowanie stylu
        return toggle
    end

    function ModuleAPI:AddDropdown(subOptions)
        local dropdown = DropdownElement(subOptions, themeManager, OptionsContainer, menuConfig, saveMenuConfig)
        return dropdown
    end

    return ModuleAPI
end