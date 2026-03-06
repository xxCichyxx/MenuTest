return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local UserInputService = game:GetService("UserInputService")

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = options.Name or "Slider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 50) -- Wyższy kontener
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    -- Opis na górze
    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Slider"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = SliderFrame
    themeManager:Register(Label, "TextColor3", "Text")

    -- Tło suwaka (Grubsze)
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 20) -- Grubszy pasek (20px)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    SliderBar.Parent = SliderFrame
    themeManager:Register(SliderBar, "BackgroundColor3", "Accent2")
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 6)

    -- Wypełnienie
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.Parent = SliderBar
    themeManager:Register(Fill, "BackgroundColor3", "Accent")
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 6)

    -- Wartość pośrodku suwaka
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 12
    ValueLabel.Size = UDim2.new(1, 0, 1, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.ZIndex = 2
    ValueLabel.Parent = SliderBar
    themeManager:Register(ValueLabel, "TextColor3", "Text")

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
    function API:Set(val) Update(val) end
    return API
end