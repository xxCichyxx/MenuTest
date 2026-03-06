return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = options.Name or "ColorPicker"
    ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)
    ColorPickerFrame.BackgroundTransparency = 1
    ColorPickerFrame.Parent = parent

    local Main = Instance.new("TextButton")
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.BackgroundColor3 = Color3.fromRGB(31, 31, 38)
    Main.Text = ""
    Main.Parent = ColorPickerFrame
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Color Picker"
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(150, 150, 160)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Main

    local ColorPreview = Instance.new("Frame")
    ColorPreview.Size = UDim2.new(0, 40, 0, 20)
    ColorPreview.Position = UDim2.new(1, -50, 0.5, 0)
    ColorPreview.AnchorPoint = Vector2.new(0, 0.5)
    ColorPreview.Parent = Main
    Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0, 4)

    local CurrentColor = options.Color or Color3.fromRGB(255, 255, 255)
    if options.Flag and menuConfig[options.Flag] ~= nil then
        local c = menuConfig[options.Flag]
        CurrentColor = Color3.fromRGB(c[1], c[2], c[3])
    end
    ColorPreview.BackgroundColor3 = CurrentColor

    Main.MouseButton1Click:Connect(function()
        -- Placeholder: Losowy kolor
        CurrentColor = Color3.fromHSV(math.random(), 1, 1)
        ColorPreview.BackgroundColor3 = CurrentColor
        if options.Callback then options.Callback(CurrentColor) end
        if options.Flag then
            saveMenuConfig(options.Flag, {CurrentColor.R*255, CurrentColor.G*255, CurrentColor.B*255})
        end
    end)

    return {}
end