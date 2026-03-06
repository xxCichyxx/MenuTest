return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local Button = Instance.new("TextButton")
    Button.Name = options.Name or "Button"
    Button.Text = options.Name or "Button"
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(31, 31, 38) -- Stroke color as bg
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.Parent = parent

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    if options.Callback then
        Button.MouseButton1Click:Connect(options.Callback)
    end

    local API = {}
    function API:Set(text)
        Button.Text = text
    end
    return API
end