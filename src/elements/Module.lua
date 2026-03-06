-- Pre-load sub-elements
local SliderElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Slider.lua"))()
local ToggleElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Toggle.lua"))()
local DropdownElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Dropdown.lua"))()
local InputElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Input.lua"))()
local ColorPickerElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/ColorPicker.lua"))()
local ButtonElement = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/elements/Button.lua"))()
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

return function(options, themeManager, parent, menuConfig, saveMenuConfig, addConnection)
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
    ModuleFrame.Size = UDim2.new(0, 220, 0, 50) -- Stała szerokość dla Gridu
    ModuleFrame.BackgroundColor3 = Colors.Background
    ModuleFrame.ClipsDescendants = true
    ModuleFrame.Parent = parent

    local Corner = Instance.new("UICorner", ModuleFrame)
    Corner.CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke", ModuleFrame)
    MainStroke.Color = Colors.Stroke
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Parent = ModuleFrame

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Name = "ClickBtn"
    ClickBtn.Size = UDim2.new(1, -100, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = Header
    ClickBtn.ZIndex = 10

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
    BindBtn.ZIndex = 11
    BindBtn.Parent = Header
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    local ToggleContainer = Instance.new("TextButton")
    ToggleContainer.Name = "Toggle"
    ToggleContainer.Size = UDim2.new(0, 40, 0, 20)
    ToggleContainer.Position = UDim2.new(1, -15, 0.5, 0)
    ToggleContainer.AnchorPoint = Vector2.new(1, 0.5)
    ToggleContainer.BackgroundColor3 = Colors.Stroke
    ToggleContainer.Text = ""
    ToggleContainer.ZIndex = 11
    ToggleContainer.Parent = Header
    Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleContainer
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Position = UDim2.new(0, 0, 0, 50)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
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

    local Enabled = options.Default or false
    local Expanded = false
    local Keybind = nil
    local Binding = false

    if options.Flag and menuConfig[options.Flag] ~= nil then
        Enabled = menuConfig[options.Flag]
    end
    if options.Flag and menuConfig[options.Flag .. "_Bind"] then
        local bindName = menuConfig[options.Flag .. "_Bind"]
        if bindName then pcall(function() Keybind = Enum.KeyCode[bindName] end) end
        if Keybind then BindBtn.Text = Keybind.Name:sub(1, 3) end
    end

    local function UpdateVisuals(instant)
        if not ModuleFrame.Parent then instant = true end

        if Enabled then
            if instant then
                ToggleContainer.BackgroundColor3 = Colors.Accent
                ToggleCircle.Position = UDim2.new(1, -18, 0.5, 0)
                Label.TextColor3 = Colors.Text
            else
                TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)
                Label.TextColor3 = Colors.Text
            end
        else
            if instant then
                ToggleContainer.BackgroundColor3 = Colors.Stroke
                ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
                Label.TextColor3 = Colors.TextDim
            else
                TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Stroke}):Play()
                ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)
                Label.TextColor3 = Colors.TextDim
            end
        end
    end

    local function ToggleModule(forceState)
        if forceState ~= nil then Enabled = forceState else Enabled = not Enabled end
        UpdateVisuals(false)
        if options.Flag then saveMenuConfig(options.Flag, Enabled) end
        if options.Callback then options.Callback(Enabled) end
    end

    ClickBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ToggleModule()
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            Expanded = not Expanded
            Content.Visible = Expanded

            local targetHeight = Expanded and (50 + ContentLayout.AbsoluteContentSize.Y + 20) or 50
            TweenService:Create(ModuleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 220, 0, targetHeight)
            }):Play()
        end
    end)

    ToggleContainer.MouseButton1Click:Connect(function() ToggleModule() end)

    BindBtn.MouseButton1Click:Connect(function()
        Binding = true
        BindBtn.Text = "?"
        BindBtn.TextColor3 = Colors.Accent
    end)

    -- Używamy addConnection, aby zarejestrować bind
    if addConnection then
        addConnection(UserInputService.InputBegan:Connect(function(input, gpe)
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
        end))
    end

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then
            local targetHeight = 50 + ContentLayout.AbsoluteContentSize.Y + 20
            ModuleFrame.Size = UDim2.new(0, 220, 0, targetHeight)
        end
    end)

    UpdateVisuals(true)

    local API = {}
    function API:AddSlider(opts) return SliderElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    function API:AddToggle(opts) return ToggleElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    function API:AddDropdown(opts) return DropdownElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    function API:AddInput(opts) return InputElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    function API:AddColorPicker(opts) return ColorPickerElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end
    function API:AddButton(opts) return ButtonElement(opts, themeManager, Content, menuConfig, saveMenuConfig) end

    return API
end