return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    -- Uproszczona implementacja, aby pokazać API
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = options.Name or "ColorPicker"
    ColorPickerFrame.Size = UDim2.new(0.5, -5, 0, 35)
    ColorPickerFrame.BackgroundColor = options.Color or Color3.fromRGB(255,255,255)
    ColorPickerFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Text = options.Name or "Color Picker"
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 0.5
    Label.BackgroundColor = Color3.fromRGB(0,0,0)
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.Parent = ColorPickerFrame

    local API = {}
    function API:Set(newColor)
        ColorPickerFrame.BackgroundColor3 = newColor
        if options.Flag then saveMenuConfig(options.Flag, {newColor.r*255, newColor.g*255, newColor.b*255}) end
        if options.Callback then options.Callback(newColor) end
    end

    return API
end