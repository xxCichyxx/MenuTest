return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = options.Name or "Input"
    InputFrame.Size = UDim2.new(0.5, -5, 0, 35)
    InputFrame.BackgroundTransparency = 1
    InputFrame.Parent = parent

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.Parent = InputFrame
    themeManager:Register(Main, "BackgroundColor3", "Secondary")
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -20, 1, 0)
    TextBox.Position = UDim2.new(0, 10, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 14
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.Text = options.CurrentValue or ""
    TextBox.PlaceholderText = options.PlaceholderText or "Input..."
    TextBox.Parent = Main
    themeManager:Register(TextBox, "TextColor3", "Text")
    themeManager:Register(TextBox, "PlaceholderColor3", "Text_Secondary")

    if options.Flag and menuConfig[options.Flag] ~= nil then
        TextBox.Text = menuConfig[options.Flag]
    end

    TextBox.FocusLost:Connect(function(enterPressed)
        if options.Callback then options.Callback(TextBox.Text) end
        if options.Flag then saveMenuConfig(options.Flag, TextBox.Text) end
        if options.RemoveTextAfterFocusLost then
            TextBox.Text = ""
        end
    end)

    local API = {}
    function API:Set(text)
        TextBox.Text = text
        if options.Callback then options.Callback(text) end
    end
    return API
end