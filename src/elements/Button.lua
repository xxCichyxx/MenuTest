return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local Button = Instance.new("TextButton")
    Button.Name = options.Name or "Button"
    Button.Text = options.Name or "Button"
    Button.Size = UDim2.new(0.5, -5, 0, 35)
    Button.Parent = parent

    themeManager:Register(Button, "BackgroundColor3", "Secondary")
    themeManager:Register(Button, "TextColor3", "Text")

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Button)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    if options.Callback then
        Button.MouseButton1Click:Connect(options.Callback)
    end

    local API = {}
    function API:Set(name)
        Button.Text = name
    end

    return API
end