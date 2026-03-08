return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")

    local Colors = {
        Stroke = Color3.fromRGB(31, 31, 38),
        Accent = Color3.fromRGB(120, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 160)
    }

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Name = options.Name or "Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Text = ""
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Toggle"
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Colors.TextDim
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleFrame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 36, 0, 20)
    Switch.Position = UDim2.new(1, 0, 0.5, 0)
    Switch.AnchorPoint = Vector2.new(1, 0.5)
    Switch.BackgroundColor3 = Colors.Stroke
    Switch.Parent = ToggleFrame
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.BackgroundColor3 = Colors.Text
    Knob.Parent = Switch
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Value = options.CurrentValue or false
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Value = menuConfig[options.Flag]
    end

    local function Update(instant)
        -- FIX: Sprawdzamy czy obiekt jest w drzewie gry
        if not ToggleFrame.Parent then instant = true end

        if Value then
            if instant then
                Switch.BackgroundColor3 = Colors.Accent
                Knob.Position = UDim2.new(1, -18, 0.5, 0)
                Label.TextColor3 = Colors.Text
            else
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
                Knob:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)
                Label.TextColor3 = Colors.Text
            end
        else
            if instant then
                Switch.BackgroundColor3 = Colors.Stroke
                Knob.Position = UDim2.new(0, 2, 0.5, 0)
                Label.TextColor3 = Colors.TextDim
            else
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Stroke}):Play()
                Knob:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)
                Label.TextColor3 = Colors.TextDim
            end
        end
    end

    ToggleFrame.MouseButton1Click:Connect(function()
        Value = not Value
        Update(false) -- Użyj tweena przy interakcji
        if options.Callback then options.Callback(Value) end
        if options.Flag then saveMenuConfig(options.Flag, Value) end
    end)

    Update(true) -- Inicjalizacja natychmiastowa

    local API = {}
    function API:Set(val) Value = val Update(false) end
    return API
end