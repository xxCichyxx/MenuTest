return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

    -- Kolory ze specyfikacji
    local Colors = {
        Background = Color3.fromRGB(18, 18, 22), -- #121216
        Stroke = Color3.fromRGB(31, 31, 38),     -- #1F1F26
        Accent = Color3.fromRGB(120, 100, 255),  -- #7864FF
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 160)
    }

    -- Główny kontener modułu
    local ModuleFrame = Instance.new("Frame")
    ModuleFrame.Name = options.Name or "Module"
    ModuleFrame.Size = UDim2.new(0.5, -5, 0, 45) -- Startowa wysokość (tylko nagłówek)
    ModuleFrame.BackgroundColor3 = Colors.Background
    ModuleFrame.ClipsDescendants = true
    ModuleFrame.Parent = parent

    Instance.new("UICorner", ModuleFrame).CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke", ModuleFrame)
    MainStroke.Color = Colors.Stroke
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Nagłówek (Header) - Klikalny (Prawy/Lewy)
    local Header = Instance.new("TextButton")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1
    Header.Text = ""
    Header.Parent = ModuleFrame

    -- Ikona
    if options.Icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 12, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.ImageColor3 = Colors.Text
        Icon.Parent = Header
        Icons:Apply(Icon, options.Icon)
    end

    -- Nazwa
    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Module"
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextColor3 = Colors.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, options.Icon and 40 or 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Header

    -- Przycisk Bind (3 kropki)
    local BindBtn = Instance.new("TextButton")
    BindBtn.Name = "Bind"
    BindBtn.Size = UDim2.new(0, 24, 0, 24)
    BindBtn.Position = UDim2.new(1, -50, 0.5, 0)
    BindBtn.AnchorPoint = Vector2.new(1, 0.5)
    BindBtn.BackgroundColor3 = Colors.Stroke -- Tło przycisku bind
    BindBtn.Text = "..."
    BindBtn.TextColor3 = Colors.TextDim
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 12
    BindBtn.Parent = Header
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    -- Główny Toggle (Switch)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Size = UDim2.new(0, 36, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -10, 0.5, 0)
    ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    ToggleBtn.BackgroundColor3 = Colors.Stroke -- Nieaktywny
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Header
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0) -- Pill shape

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleBtn
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    -- Kontener Content (Ukryty)
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 45)
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.Parent = ModuleFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = Content

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.Parent = Content

    -- ZMIENNE STANU
    local Enabled = options.Default or false
    local Keybind = nil
    local Binding = false

    -- Wczytywanie Configu
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Enabled = menuConfig[options.Flag]
    end
    if options.Flag and menuConfig[options.Flag .. "_Bind"] then
        local bindName = menuConfig[options.Flag .. "_Bind"]
        if bindName then
            pcall(function() Keybind = Enum.KeyCode[bindName] end)
            if Keybind then BindBtn.Text = Keybind.Name:sub(1, 3) end
        end
    end

    -- FUNKCJA AKTUALIZACJI STANU
    local function UpdateState()
        if Enabled then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
            ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)
            Label.TextColor3 = Colors.Text
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Stroke}):Play()
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)
            Label.TextColor3 = Colors.TextDim
        end
    end

    local function ToggleModule(forceState)
        if forceState ~= nil then
            Enabled = forceState
        else
            Enabled = not Enabled
        end

        UpdateState()

        if options.Flag then saveMenuConfig(options.Flag, Enabled) end
        if options.Callback then options.Callback(Enabled) end
    end

    -- OBSŁUGA KLIKNIĘĆ
    ToggleBtn.MouseButton1Click:Connect(function() ToggleModule() end)
    Header.MouseButton1Click:Connect(function() ToggleModule() end)

    -- OBSŁUGA BINDOWANIA
    BindBtn.MouseButton1Click:Connect(function()
        Binding = true
        BindBtn.Text = "?"
        BindBtn.TextColor3 = Colors.Accent
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if Binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Backspace then
                    Keybind = nil
                    BindBtn.Text = "..."
                else
                    Keybind = input.KeyCode
                    BindBtn.Text = input.KeyCode.Name:sub(1, 3)
                end

                Binding = false
                BindBtn.TextColor3 = Colors.TextDim

                if options.Flag then
                    saveMenuConfig(options.Flag .. "_Bind", Keybind and Keybind.Name or nil)
                end
            end
        elseif not gpe and Keybind and input.KeyCode == Keybind then
            ToggleModule()
        end
    end)

    -- LOGIKA ROZWIJANIA (Prawy Klik)
    local Expanded = false
    Header.MouseButton2Click:Connect(function()
        Expanded = not Expanded

        local targetHeight = 45
        if Expanded then
            targetHeight = 45 + ContentLayout.AbsoluteContentSize.Y + 20
        end

        TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.5, -5, 0, targetHeight)
        }):Play()
    end)

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then
            local targetHeight = 45 + ContentLayout.AbsoluteContentSize.Y + 20
            TweenService:Create(ModuleFrame, TweenInfo.new(0.1), {
                Size = UDim2.new(0.5, -5, 0, targetHeight)
            }):Play()
        end
    end)

    UpdateState() -- Inicjalizacja stanu wizualnego

    -- API MODUŁU
    local ModuleAPI = {}

    function ModuleAPI:AddSlider(subOptions)
        local func = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Slider.lua"))()
        return func(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddToggle(subOptions)
        local func = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Toggle.lua"))()
        return func(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddDropdown(subOptions)
        local func = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Dropdown.lua"))()
        return func(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddInput(subOptions)
        local func = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Input.lua"))()
        return func(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddColorPicker(subOptions)
        local func = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/ColorPicker.lua"))()
        return func(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddButton(subOptions)
        local func = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Button.lua"))()
        return func(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    return ModuleAPI
end