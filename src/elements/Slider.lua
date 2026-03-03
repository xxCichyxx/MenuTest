return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local UserInputService = game:GetService("UserInputService")

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = options.Name or "Slider"
    SliderFrame.Size = UDim2.new(0.5, -5, 0, 45)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.Parent = SliderFrame
    themeManager:Register(Main, "BackgroundColor3", "Secondary")
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Slider"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Parent = Main
    themeManager:Register(Label, "TextColor3", "Text")

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Size = UDim2.new(1, -10, 0, 20)
    ValueLabel.Position = UDim2.new(0, 0, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Parent = Main
    themeManager:Register(ValueLabel, "TextColor3", "Text")

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.Parent = Main
    themeManager:Register(SliderBar, "BackgroundColor3", "Accent2")
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.Parent = SliderBar
    themeManager:Register(Fill, "BackgroundColor3", "Success") -- Lub Accent
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new(0, 0, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Parent = Fill -- Dziecko Fill, żeby podążało za końcem
    -- Ale lepiej: Dziecko SliderBar, pozycja ustawiana skryptem
    Knob.Parent = SliderBar
    themeManager:Register(Knob, "BackgroundColor3", "Text")
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    -- Logika
    local Min = options.Range[1]
    local Max = options.Range[2]
    local Value = options.CurrentValue or Min
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Value = menuConfig[options.Flag]
    end

    local function Update(val)
        Value = math.clamp(val, Min, Max)
        local percent = (Value - Min) / (Max - Min)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Knob.Position = UDim2.new(percent, 0, 0.5, 0)
        ValueLabel.Text = tostring(Value) .. (options.Suffix or "")

        if options.Callback then options.Callback(Value) end
        if options.Flag then saveMenuConfig(options.Flag, Value) end
    end

    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local newVal = math.floor(Min + ((Max - Min) * pos))
            Update(newVal)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local newVal = math.floor(Min + ((Max - Min) * pos))
            Update(newVal)
        end
    end)

    Update(Value)

    local API = {}
    function API:Set(val)
        Update(val)
    end
    return API
end