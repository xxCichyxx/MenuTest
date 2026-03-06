return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local UserInputService = game:GetService("UserInputService")

    -- Kolory (Lokalne dla spójności z Module)
    local Colors = {
        Background = Color3.fromRGB(18, 18, 22),
        Stroke = Color3.fromRGB(31, 31, 38),
        Accent = Color3.fromRGB(120, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 160)
    }

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = options.Name or "Slider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 40)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    -- Nazwa i Wartość
    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Slider"
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Colors.TextDim
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -50, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 12
    ValueLabel.TextColor3 = Colors.Text
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Size = UDim2.new(1, 0, 0, 15)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Parent = SliderFrame

    -- Szyna (Track)
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0, 25)
    Track.BackgroundColor3 = Colors.Stroke
    Track.Parent = SliderFrame
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    -- Wypełnienie (Fill)
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    -- Gałka (Knob)
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 10, 0, 10)
    Knob.Position = UDim2.new(1, 0, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Fill
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    -- Cień gałki (opcjonalny)
    local KnobShadow = Instance.new("UIStroke", Knob)
    KnobShadow.Color = Color3.fromRGB(0,0,0)
    KnobShadow.Transparency = 0.5
    KnobShadow.Thickness = 1

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
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
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
            local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            local newVal = math.floor(Min + ((Max - Min) * pos))
            Update(newVal)
        end
    end)

    Update(Value)

    local API = {}
    function API:Set(val) Update(val) end
    return API
end