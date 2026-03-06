return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

    -- Kolory
    local Colors = {
        Background = Color3.fromRGB(18, 18, 22),
        Stroke = Color3.fromRGB(31, 31, 38),
        Accent = Color3.fromRGB(120, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 160)
    }

    -- Główny kontener modułu
    local ModuleFrame = Instance.new("Frame")
    ModuleFrame.Name = options.Name or "Module"
    ModuleFrame.Size = UDim2.new(0.5, -5, 0, 45) -- Startowa wysokość
    ModuleFrame.BackgroundColor3 = Colors.Background
    ModuleFrame.ClipsDescendants = true
    ModuleFrame.Parent = parent

    Instance.new("UICorner", ModuleFrame).CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke", ModuleFrame)
    MainStroke.Color = Colors.Stroke
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Nagłówek (Header)
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

    -- Przycisk Bind
    local BindBtn = Instance.new("TextButton")
    BindBtn.Name = "Bind"
    BindBtn.Size = UDim2.new(0, 24, 0, 24)
    BindBtn.Position = UDim2.new(1, -50, 0.5, 0)
    BindBtn.AnchorPoint = Vector2.new(1, 0.5)
    BindBtn.BackgroundColor3 = Colors.Stroke
    BindBtn.Text = "..."
    BindBtn.TextColor3 = Colors.TextDim
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 12
    BindBtn.Parent = Header
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    -- Toggle
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Size = UDim2.new(0, 36, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -10, 0.5, 0)
    ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    ToggleBtn.BackgroundColor3 = Colors.Stroke
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Header
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleBtn
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    -- Kontener Content (Opcje)
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 45)
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.Parent = ModuleFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5) -- Mniejszy padding między opcjami
    ContentLayout.Parent = Content

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.Parent = Content

    -- Zmienne stanu
    local Enabled = options.Default or false
    local Keybind = nil
    local Binding = false

    -- Config
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Enabled = menuConfig[options.Flag]
    end
    if options.Flag and menuConfig[options.Flag .. "_Bind"] then
        local bindName = menuConfig[options.Flag .. "_Bind"]
        if bindName then pcall(function() Keybind = Enum.KeyCode[bindName] end) end
        if Keybind then BindBtn.Text = Keybind.Name:sub(1, 3) end
    end

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
        if forceState ~= nil then Enabled = forceState else Enabled = not Enabled end
        UpdateState()
        if options.Flag then saveMenuConfig(options.Flag, Enabled) end
        if options.Callback then options.Callback(Enabled) end
    end

    ToggleBtn.MouseButton1Click:Connect(function() ToggleModule() end)
    Header.MouseButton1Click:Connect(function() ToggleModule() end)

    BindBtn.MouseButton1Click:Connect(function()
        Binding = true
        BindBtn.Text = "?"
        BindBtn.TextColor3 = Colors.Accent
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Backspace then
                Keybind = nil
                BindBtn.Text = "..."
            else
                Keybind = input.KeyCode
                BindBtn.Text = input.KeyCode.Name:sub(1, 3)
            end
            Binding = false
            BindBtn.TextColor3 = Colors.TextDim
            if options.Flag then saveMenuConfig(options.Flag .. "_Bind", Keybind and Keybind.Name or nil) end
        elseif not gpe and Keybind and input.KeyCode == Keybind then
            ToggleModule()
        end
    end)

    -- Logika Rozwijania (Prawy Klik)
    local Expanded = false

    local function UpdateHeight()
        if Expanded then
            -- Obliczamy wysokość na podstawie zawartości
            local contentHeight = ContentLayout.AbsoluteContentSize.Y
            local padding = ContentPadding.PaddingTop.Offset + ContentPadding.PaddingBottom.Offset
            local totalHeight = 45 + contentHeight + padding

            TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.5, -5, 0, totalHeight)
            }):Play()
        else
            TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.5, -5, 0, 45)
            }):Play()
        end
    end

    Header.MouseButton2Click:Connect(function()
        Expanded = not Expanded
        UpdateHeight()
    end)

    -- Nasłuchiwanie zmian w zawartości (gdy dodajemy elementy)
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then UpdateHeight() end
    end)

    UpdateState()

    -- API MODUŁU
    local ModuleAPI = {}

    -- Funkcja pomocnicza do ładowania elementów
    local function LoadElement(name)
        local url = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/" .. name .. ".lua"
        local success, result = pcall(function() return game:HttpGet(url) end)
        if not success then warn("Failed to fetch element: " .. name) return nil end

        local func = loadstring(result)
        if not func then warn("Failed to loadstring element: " .. name) return nil end

        return func() -- Wywołanie loadstring zwraca funkcję konstruktora
    end

    function ModuleAPI:AddSlider(subOptions)
        local constructor = LoadElement("Slider")
        if constructor then
            return constructor(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
        end
    end

    function ModuleAPI:AddToggle(subOptions)
        local constructor = LoadElement("Toggle")
        if constructor then
            return constructor(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
        end
    end

    function ModuleAPI:AddDropdown(subOptions)
        local constructor = LoadElement("Dropdown")
        if constructor then
            return constructor(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
        end
    end

    function ModuleAPI:AddInput(subOptions)
        local constructor = LoadElement("Input")
        if constructor then
            return constructor(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
        end
    end

    function ModuleAPI:AddColorPicker(subOptions)
        local constructor = LoadElement("ColorPicker")
        if constructor then
            return constructor(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
        end
    end

    function ModuleAPI:AddButton(subOptions)
        local constructor = LoadElement("Button")
        if constructor then
            return constructor(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
        end
    end

    return ModuleAPI
end