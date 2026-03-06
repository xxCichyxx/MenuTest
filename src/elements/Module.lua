-- Pre-load sub-elements to avoid HTTP lag/errors during runtime
local SliderElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Slider.lua"))()
local ToggleElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Toggle.lua"))()
local DropdownElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Dropdown.lua"))()
local InputElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Input.lua"))()
local ColorPickerElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/ColorPicker.lua"))()
local ButtonElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Button.lua"))()
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

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
    ModuleFrame.Size = UDim2.new(0.5, -5, 0, 50) -- Startowa wysokość
    ModuleFrame.BackgroundTransparency = 1
    ModuleFrame.ClipsDescendants = true
    ModuleFrame.Parent = parent

    -- Tło Karty
    local CardBackground = Instance.new("Frame")
    CardBackground.Name = "CardBackground"
    CardBackground.Size = UDim2.new(1, 0, 1, 0)
    CardBackground.BackgroundColor3 = Colors.Background
    CardBackground.Parent = ModuleFrame

    Instance.new("UICorner", CardBackground).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", CardBackground)
    MainStroke.Color = Colors.Stroke
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Nagłówek (Header)
    local Header = Instance.new("TextButton")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Text = ""
    Header.Parent = CardBackground

    -- Ikona
    if options.Icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 24, 0, 24)
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
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.TextColor3 = Colors.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, options.Icon and 45 or 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Header

    -- Przycisk Bind
    local BindBtn = Instance.new("TextButton")
    BindBtn.Name = "Bind"
    BindBtn.Size = UDim2.new(0, 24, 0, 24)
    BindBtn.Position = UDim2.new(1, -60, 0.5, 0)
    BindBtn.AnchorPoint = Vector2.new(1, 0.5)
    BindBtn.BackgroundColor3 = Colors.Stroke
    BindBtn.Text = "..."
    BindBtn.TextColor3 = Colors.TextDim
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 12
    BindBtn.Parent = Header
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    -- Toggle (Switch)
    local ToggleContainer = Instance.new("TextButton")
    ToggleContainer.Name = "Toggle"
    ToggleContainer.Size = UDim2.new(0, 40, 0, 20)
    ToggleContainer.Position = UDim2.new(1, -15, 0.5, 0)
    ToggleContainer.AnchorPoint = Vector2.new(1, 0.5)
    ToggleContainer.BackgroundColor3 = Colors.Stroke
    ToggleContainer.Text = ""
    ToggleContainer.Parent = Header
    Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleContainer
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    -- Kontener Content (Opcje)
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 50)
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.Parent = CardBackground

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5)
    ContentLayout.Parent = Content

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 5)
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
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
            ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)
            Label.TextColor3 = Colors.Text
        else
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Stroke}):Play()
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

    ToggleContainer.MouseButton1Click:Connect(function() ToggleModule() end)

    -- Bindowanie
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

    -- Logika Rozwijania
    local Expanded = false

    local function UpdateHeight()
        if Expanded then
            local contentHeight = ContentLayout.AbsoluteContentSize.Y
            local padding = ContentPadding.PaddingTop.Offset + ContentPadding.PaddingBottom.Offset
            local totalHeight = 50 + contentHeight + padding

            TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.5, -5, 0, totalHeight)
            }):Play()
        else
            TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0.5, -5, 0, 50)
            }):Play()
        end
    end

    Header.MouseButton1Click:Connect(function() -- Lewy klik rozwija
        Expanded = not Expanded
        UpdateHeight()
    end)

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then UpdateHeight() end
    end)

    UpdateState()

    -- API MODUŁU
    local ModuleAPI = {}

    function ModuleAPI:AddSlider(subOptions)
        return SliderElement(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddToggle(subOptions)
        return ToggleElement(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddDropdown(subOptions)
        return DropdownElement(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddInput(subOptions)
        return InputElement(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddColorPicker(subOptions)
        return ColorPickerElement(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    function ModuleAPI:AddButton(subOptions)
        return ButtonElement(subOptions, themeManager, Content, menuConfig, saveMenuConfig)
    end

    return ModuleAPI
end