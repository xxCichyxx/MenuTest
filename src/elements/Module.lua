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

    -- Kolory zgodne ze specyfikacją wizualną
    local Colors = {
        Background = Color3.fromRGB(18, 18, 22),
        Stroke = Color3.fromRGB(31, 31, 38),
        Accent = Color3.fromRGB(120, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 160)
    }

    -- Główny kontener modułu (0.5 szerokości dla układu Grid)
    local ModuleFrame = Instance.new("Frame")
    ModuleFrame.Name = options.Name or "Module"
    ModuleFrame.Size = UDim2.new(0.5, -5, 0, 50)
    ModuleFrame.BackgroundColor3 = Colors.Background
    ModuleFrame.ClipsDescendants = true
    ModuleFrame.Parent = parent

    local Corner = Instance.new("UICorner", ModuleFrame)
    Corner.CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke", ModuleFrame)
    MainStroke.Color = Colors.Stroke
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Nagłówek (Header) - Obsługuje kliknięcie główne i prawy przycisk
    local Header = Instance.new("TextButton")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Text = ""
    Header.AutoButtonColor = false
    Header.Parent = ModuleFrame

    -- Ikona
    if options.Icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 22, 0, 22)
        Icon.Position = UDim2.new(0, 12, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.ImageColor3 = Colors.Text
        Icon.Parent = Header
        Icons:Apply(Icon, options.Icon)
    end

    -- Nazwa modułu
    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Module"
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextColor3 = Colors.TextDim
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -110, 1, 0)
    Label.Position = UDim2.new(0, options.Icon and 42 or 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Header

    -- Przycisk Bind (3 kropki / klawisz)
    local BindBtn = Instance.new("TextButton")
    BindBtn.Name = "Bind"
    BindBtn.Size = UDim2.new(0, 30, 0, 22)
    BindBtn.Position = UDim2.new(1, -55, 0.5, 0)
    BindBtn.AnchorPoint = Vector2.new(1, 0.5)
    BindBtn.BackgroundColor3 = Colors.Stroke
    BindBtn.Text = "..."
    BindBtn.TextColor3 = Colors.TextDim
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 10
    BindBtn.Parent = Header
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    -- Toggle (Switch wizualny)
    local ToggleContainer = Instance.new("Frame")
    ToggleContainer.Name = "ToggleVisual"
    ToggleContainer.Size = UDim2.new(0, 34, 0, 18)
    ToggleContainer.Position = UDim2.new(1, -12, 0.5, 0)
    ToggleContainer.AnchorPoint = Vector2.new(1, 0.5)
    ToggleContainer.BackgroundColor3 = Colors.Stroke
    ToggleContainer.Parent = Header
    Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleContainer
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    -- Kontener na opcje (Rozwijany)
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Position = UDim2.new(0, 0, 0, 50)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y -- Kluczowe: sam liczy wysokość dzieci
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.Visible = false
    Content.Parent = ModuleFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 10) -- Odstępy między sliderami
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = Content

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.Parent = Content

    -- Zmienne stanu
    local Enabled = options.Default or false
    local Expanded = false
    local Keybind = nil
    local Binding = false

    -- Ładowanie Configu
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Enabled = menuConfig[options.Flag]
    end
    if options.Flag and menuConfig[options.Flag .. "_Bind"] then
        local bindName = menuConfig[options.Flag .. "_Bind"]
        if bindName then pcall(function() Keybind = Enum.KeyCode[bindName] end) end
        if Keybind then BindBtn.Text = Keybind.Name:upper():sub(1, 3) end
    end

    local function UpdateVisuals()
        if Enabled then
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
            ToggleCircle:TweenPosition(UDim2.new(1, -16, 0.5, 0), "Out", "Quart", 0.2, true)
            TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
        else
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Stroke}):Play()
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)
            TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Colors.TextDim}):Play()
        end
    end

    local function Toggle()
        Enabled = not Enabled
        UpdateVisuals()
        if options.Flag then saveMenuConfig(options.Flag, Enabled) end
        if options.Callback then options.Callback(Enabled) end
    end

    -- Rozwijanie wysokości
    local function UpdateHeight()
        local targetHeight = Expanded and (50 + ContentLayout.AbsoluteContentSize.Y + 20) or 50
        TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.5, -5, 0, targetHeight)
        }):Play()
    end

    -- Obsługa kliknięć Headera
    Header.MouseButton1Click:Connect(Toggle) -- Lewy klik = Toggle
    Header.MouseButton2Click:Connect(function() -- Prawy klik = Rozwijanie
        Expanded = not Expanded
        Content.Visible = Expanded
        UpdateHeight()
    end)

    -- Bind przycisk
    BindBtn.MouseButton1Click:Connect(function()
        Binding = true
        BindBtn.Text = "..."
        BindBtn.TextColor3 = Colors.Accent
    end)

    -- Input globalny (Bindy)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Backspace then
                Keybind = nil
                BindBtn.Text = "..."
            else
                Keybind = input.KeyCode
                BindBtn.Text = input.KeyCode.Name:upper():sub(1, 3)
            end
            Binding = false
            BindBtn.TextColor3 = Colors.TextDim
            if options.Flag then saveMenuConfig(options.Flag .. "_Bind", Keybind and Keybind.Name or nil) end
        elseif not gpe and Keybind and input.KeyCode == Keybind then
            Toggle()
        end
    end)

    -- Auto-resize przy zmianie zawartości (np. dodanie slidera)
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then UpdateHeight() end
    end)

    UpdateVisuals()

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