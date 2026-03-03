return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    -- Uproszczona implementacja
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = options.Name or "Dropdown"
    DropdownFrame.Size = UDim2.new(0.5, -5, 0, 35)
    DropdownFrame.BackgroundColor = Color3.fromRGB(50,50,50)
    DropdownFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Text = options.Name or "Dropdown"
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 0.5
    Label.BackgroundColor = Color3.fromRGB(0,0,0)
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.Parent = DropdownFrame

    local API = {}
    function API:Refresh(newOptions)
        -- Logika aktualizacji
    end
    function API:Set(newSelection)
        -- Logika aktualizacji
    end

    return API
end