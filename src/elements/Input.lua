return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    -- Uproszczona implementacja
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = options.Name or "Input"
    InputFrame.Size = UDim2.new(0.5, -5, 0, 35)
    InputFrame.BackgroundColor = Color3.fromRGB(50,50,50)
    InputFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Text = options.Name or "Input"
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 0.5
    Label.BackgroundColor = Color3.fromRGB(0,0,0)
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.Parent = InputFrame

    local API = {}
    function API:Set(newText)
        -- Logika aktualizacji
    end

    return API
end