return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = options.Name or "ColorPicker"
    ColorPickerFrame.Size = UDim2.new(0.5, -5, 0, 35)
    ColorPickerFrame.BackgroundTransparency = 1
    ColorPickerFrame.Parent = parent

    local Main = Instance.new("TextButton")
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.Text = ""
    Main.Parent = ColorPickerFrame
    themeManager:Register(Main, "BackgroundColor3", "Secondary")
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Color Picker"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Main
    themeManager:Register(Label, "TextColor3", "Text")

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

    -- TODO: Pełne okno wyboru koloru (HSV)
    -- Na razie symulacja: kliknięcie losuje kolor (placeholder)
    Main.MouseButton1Click:Connect(function()
        CurrentColor = Color3.fromHSV(math.random(), 1, 1)
        ColorPreview.BackgroundColor3 = CurrentColor
        if options.Callback then options.Callback(CurrentColor) end
        if options.Flag then
            saveMenuConfig(options.Flag, {CurrentColor.R*255, CurrentColor.G*255, CurrentColor.B*255})
        end
    end)

    local API = {}
    function API:Set(newColor)
        CurrentColor = newColor
        ColorPreview.BackgroundColor3 = CurrentColor
    end
    return API
end