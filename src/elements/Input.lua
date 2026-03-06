return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = options.Name or "Input"
    InputFrame.Size = UDim2.new(1, 0, 0, 35)
    InputFrame.BackgroundTransparency = 1
    InputFrame.Parent = parent

    local Main = Instance.new("TextBox")
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.BackgroundTransparency = 1
    Main.Font = Enum.Font.Gotham
    Main.TextSize = 14
    Main.TextColor3 = Color3.fromRGB(255, 255, 255)
    Main.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    Main.TextXAlignment = Enum.TextXAlignment.Left
    Main.ClearTextOnFocus = false
    Main.Text = options.CurrentValue or ""
    Main.PlaceholderText = options.PlaceholderText or "Enter Text Here..."
    Main.Parent = InputFrame

    -- Stylizacja
    Main.BackgroundColor3 = Color3.fromRGB(31, 31, 38) -- Stroke
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Padding = Instance.new("UIPadding", Main)
    Padding.PaddingLeft = UDim.new(0, 8)
    Padding.PaddingRight = UDim.new(0, 8)

    -- Logika
    if options.Flag and menuConfig[options.Flag] ~= nil then
        Main.Text = menuConfig[options.Flag]
    end

    Main.FocusLost:Connect(function(enterPressed)
        if options.Callback then options.Callback(Main.Text) end
        if options.Flag then saveMenuConfig(options.Flag, Main.Text) end
        if options.RemoveTextAfterFocusLost then
            Main.Text = ""
        end
    end)

    local API = {}
    function API:Set(text)
        Main.Text = text
    end

    return API
end