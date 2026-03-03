return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    -- Uproszczona implementacja
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = options.Name or "Slider"
    SliderFrame.Size = UDim2.new(0.5, -5, 0, 35)
    SliderFrame.BackgroundColor = Color3.fromRGB(50,50,50)
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Text = options.Name or "Slider"
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 0.5
    Label.BackgroundColor = Color3.fromRGB(0,0,0)
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.Parent = SliderFrame

    local API = {}
    function API:Set(newValue)
        -- Logika aktualizacji
    end

    return API
end