return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

    -- Główny kontener modułu (Karta)
    local ModuleFrame = Instance.new("Frame")
    ModuleFrame.Name = options.Name or "Module"
    ModuleFrame.Size = UDim2.new(0.5, -5, 0, 50) -- Wyższy nagłówek (50px)
    ModuleFrame.BackgroundTransparency = 1
    ModuleFrame.ClipsDescendants = true
    ModuleFrame.Parent = parent

    -- Tło Karty (Header + Content)
    local CardBackground = Instance.new("Frame")
    CardBackground.Name = "CardBackground"
    CardBackground.Size = UDim2.new(1, 0, 1, 0)
    CardBackground.Parent = ModuleFrame
    themeManager:Register(CardBackground, "BackgroundColor3", "Secondary")

    Instance.new("UICorner", CardBackground).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", CardBackground)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    -- Przycisk rozwijania (cały nagłówek jest przyciskiem)
    local ExpandBtn = Instance.new("TextButton")
    ExpandBtn.Name = "ExpandBtn"
    ExpandBtn.Size = UDim2.new(1, 0, 0, 50)
    ExpandBtn.BackgroundTransparency = 1
    ExpandBtn.Text = ""
    ExpandBtn.Parent = CardBackground

    -- Ikona (Lewy Górny)
    if options.Icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 24, 0, 24)
        Icon.Position = UDim2.new(0, 12, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.Parent = ExpandBtn
        themeManager:Register(Icon, "ImageColor3", "Text")
        Icons:Apply(Icon, options.Icon)
    end

    -- Nazwa (Obok ikony)
    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Module"
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, options.Icon and 45 or 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = ExpandBtn
    themeManager:Register(Label, "TextColor3", "Text")

    -- Toggle (Prawy Górny) - Mały switch
    local ToggleContainer = Instance.new("TextButton") -- Kliknięcie tutaj tylko przełącza, nie rozwija
    ToggleContainer.Name = "Toggle"
    ToggleContainer.Size = UDim2.new(0, 40, 0, 20)
    ToggleContainer.Position = UDim2.new(1, -15, 0.5, 0)
    ToggleContainer.AnchorPoint = Vector2.new(1, 0.5)
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Accent2
    ToggleContainer.Text = ""
    ToggleContainer.Parent = ExpandBtn
    themeManager:Register(ToggleContainer, "BackgroundColor3", "Accent2")
    Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.Parent = ToggleContainer
    themeManager:Register(ToggleCircle, "BackgroundColor3", "Text")
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    -- Kontener na opcje (Wewnętrzny)
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Name = "Options"
    OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 0, 0, 50) -- Pod nagłówkiem
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.Parent = CardBackground

    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 10)
    OptionsLayout.Parent = OptionsContainer

    local OptionsPadding = Instance.new("UIPadding")
    OptionsPadding.PaddingLeft = UDim.new(0, 10)
    OptionsPadding.PaddingRight = UDim.new(0, 10)
    OptionsPadding.PaddingBottom = UDim.new(0, 15)
    OptionsPadding.Parent = OptionsContainer

    -- Logika Toggle
    local Enabled = options.Default or false
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Enabled = menuConfig[options.Flag]
    end

    local function UpdateState()
        if Enabled then
            local successColor = Color3.fromRGB(unpack(themeManager.CurrentTheme.Success))
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = successColor}):Play()
            ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)
            Label.TextColor3 = successColor -- Opcjonalnie: zmiana koloru tekstu
        else
            local accent2Color = Color3.fromRGB(unpack(themeManager.CurrentTheme.Accent2))
            local textColor = Color3.fromRGB(unpack(themeManager.CurrentTheme.Text))
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = accent2Color}):Play()
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)
            Label.TextColor3 = textColor
        end
    end

    ToggleContainer.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        UpdateState()
        if options.Flag then saveMenuConfig(options.Flag, Enabled) end
        if options.Callback then options.Callback(Enabled) end
    end)

    -- Logika Rozwijania
    local Expanded = false
    ExpandBtn.MouseButton1Click:Connect(function()
        Expanded = not Expanded

        local targetHeight = 50 -- Wysokość zwinięta
        if Expanded then
            targetHeight = 50 + OptionsLayout.AbsoluteContentSize.Y + 15 -- + paddingi
        end

        TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.5, -5, 0, targetHeight)
        }):Play()
    end)

    -- Auto-resize przy dodawaniu elementów
    OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then
            local targetHeight = 50 + OptionsLayout.AbsoluteContentSize.Y + 15
            TweenService:Create(ModuleFrame, TweenInfo.new(0.1), {
                Size = UDim2.new(0.5, -5, 0, targetHeight)
            }):Play()
        end
    end)

    UpdateState()

    -- API Modułu
    local ModuleAPI = {}

    -- Ładowanie sub-elementów
    local SliderElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Slider.lua"))()
    local ToggleElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Toggle.lua"))()
    local DropdownElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Dropdown.lua"))()

    function ModuleAPI:AddSlider(subOptions)
        -- Modyfikujemy styl slidera dla modułu
        local slider = SliderElement(subOptions, themeManager, OptionsContainer, menuConfig, saveMenuConfig)
        -- Tutaj można by wymusić specyficzny styl (np. mniejszy)
        return slider
    end

    function ModuleAPI:AddToggle(subOptions)
        return ToggleElement(subOptions, themeManager, OptionsContainer, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddDropdown(subOptions)
        return DropdownElement(subOptions, themeManager, OptionsContainer, menuConfig, saveMenuConfig)
    end

    return ModuleAPI
end