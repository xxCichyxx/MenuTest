-- Pre-load sub-elements
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

    local Colors = {
        Background = Color3.fromRGB(18, 18, 22),
        Stroke = Color3.fromRGB(31, 31, 38),
        Accent = Color3.fromRGB(120, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 160)
    }

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

    -- Header (Używamy Frame + Przyciski wewnątrz dla lepszej kontroli)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Parent = ModuleFrame

    -- Przycisk do Toggle (Cały lewy obszar)
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, -100, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = Header

    -- Ikona i Label
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

    -- Kontener Content (Kluczowa poprawka)
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Position = UDim2.new(0, 0, 0, 50)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y -- Sam liczy wysokość
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.Visible = false
    Content.Parent = ModuleFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = Content

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 12)
    ContentPadding.PaddingRight = UDim.new(0, 12)
    ContentPadding.PaddingBottom = UDim.new(0, 12)
    ContentPadding.Parent = Content

    -- Stan i Logika
    local Enabled = options.Default or false
    local Expanded = false

    local function UpdateVisuals()
        local targetColor = Enabled and Colors.Accent or Colors.TextDim
        TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Enabled and Colors.Text or Colors.TextDim}):Play()
        -- Tutaj dodaj animację switcha (ToggleCircle) z Twojego poprzedniego kodu
    end

    local function Toggle()
        Enabled = not Enabled
        UpdateVisuals()
        if options.Callback then options.Callback(Enabled) end
    end

    -- Obsługa kliknięć
    ClickBtn.MouseButton1Click:Connect(Toggle)

    -- Prawy klik rozwija (MouseButton2)
    ModuleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Expanded = not Expanded
            Content.Visible = Expanded

            local targetHeight = Expanded and (50 + ContentLayout.AbsoluteContentSize.Y + 20) or 50
            TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0.5, -5, 0, targetHeight)}):Play()
        end
    end)

    -- Auto-skalowanie przy dodawaniu elementów
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then
            local targetHeight = 50 + ContentLayout.AbsoluteContentSize.Y + 20
            ModuleFrame.Size = UDim2.new(0.5, -5, 0, targetHeight)
        end
    end)

    -- API
    local API = {}
    function API:AddSlider(opts) return SliderElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    function API:AddToggle(opts) return ToggleElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    function API:AddDropdown(opts) return DropdownElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    -- ... reszta metod ...

    return API
end