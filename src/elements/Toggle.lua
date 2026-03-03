return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = options.Name or "Toggle"
    ToggleFrame.Size = UDim2.new(0.5, -5, 0, 35)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleFrame
    themeManager:Register(ToggleBtn, "BackgroundColor3", "Secondary")

    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", ToggleBtn)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Text = options.Name or "Toggle"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleBtn
    themeManager:Register(Label, "TextColor3", "Text")

    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Name = "Switch"
    ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
    ToggleSwitch.Position = UDim2.new(1, -50, 0.5, 0)
    ToggleSwitch.AnchorPoint = Vector2.new(0, 0.5)
    ToggleSwitch.Parent = ToggleBtn
    themeManager:Register(ToggleSwitch, "BackgroundColor3", "Accent2")
    Instance.new("UICorner", ToggleSwitch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Name = "Circle"
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, 0)
    Circle.AnchorPoint = Vector2.new(0, 0.5)
    Circle.Parent = ToggleSwitch
    themeManager:Register(Circle, "BackgroundColor3", "Text")
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local Value = options.CurrentValue or false
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Value = menuConfig[options.Flag]
    end

    local function UpdateState()
        if Value then
            ToggleSwitch.BackgroundColor3 = Color3.fromRGB(unpack(themeManager.CurrentTheme.Success))
            Circle:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)
        else
            ToggleSwitch.BackgroundColor3 = Color3.fromRGB(unpack(themeManager.CurrentTheme.Accent2))
            Circle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)
        end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        Value = not Value
        UpdateState()
        if options.Flag then saveMenuConfig(options.Flag, Value) end
        if options.Callback then options.Callback(Value) end
    end)

    UpdateState()
    if options.Callback then options.Callback(Value) end -- Wywołaj callback przy starcie

    local API = {}
    function API:Set(newValue)
        Value = newValue
        UpdateState()
        if options.Flag then saveMenuConfig(options.Flag, Value) end
        if options.Callback then options.Callback(Value) end
    end

    return API
end