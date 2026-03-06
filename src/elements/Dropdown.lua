return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

    local Colors = {
        Background = Color3.fromRGB(18, 18, 22),
        Stroke = Color3.fromRGB(31, 31, 38),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 160),
        Accent = Color3.fromRGB(120, 100, 255)
    }

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = options.Name or "Dropdown"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.ZIndex = 2
    DropdownFrame.Parent = parent

    local Main = Instance.new("TextButton")
    Main.Size = UDim2.new(1, 0, 0, 35)
    Main.BackgroundColor3 = Colors.Background
    Main.Text = ""
    Main.Parent = DropdownFrame

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Colors.Stroke
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Label = Instance.new("TextLabel")
    Label.Text = options.Name
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Colors.TextDim
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Main

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Position = UDim2.new(1, -26, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.ImageColor3 = Colors.TextDim
    Icon.Parent = Main
    Icons:Apply(Icon, "chevron-down")

    -- Lista
    local List = Instance.new("Frame")
    List.Size = UDim2.new(1, 0, 0, 0)
    List.Position = UDim2.new(0, 0, 1, 5)
    List.BackgroundColor3 = Colors.Background
    List.Visible = false
    List.ZIndex = 5
    List.Parent = DropdownFrame

    Instance.new("UICorner", List).CornerRadius = UDim.new(0, 6)
    local ListStroke = Instance.new("UIStroke", List)
    ListStroke.Color = Colors.Stroke

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = List

    local Options = options.Options or {}
    local CurrentOption = options.CurrentOption or {Options[1]}
    if options.Flag and menuConfig[options.Flag] ~= nil then
        CurrentOption = menuConfig[options.Flag]
    end

    local function UpdateLabel()
        Label.Text = options.Name .. ": " .. table.concat(CurrentOption, ", ")
    end
    UpdateLabel()

    local isOpen = false
    Main.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        List.Visible = isOpen
        if isOpen then
            Icons:Apply(Icon, "chevron-up")
            local height = #Options * 30
            List.Size = UDim2.new(1, 0, 0, height)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35 + height + 5)
        else
            Icons:Apply(Icon, "chevron-down")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
        end
    end)

    for _, opt in ipairs(Options) do
        local Item = Instance.new("TextButton")
        Item.Size = UDim2.new(1, 0, 0, 30)
        Item.BackgroundTransparency = 1
        Item.Text = "   " .. opt
        Item.Font = Enum.Font.Gotham
        Item.TextSize = 12
        Item.TextColor3 = Colors.TextDim
        Item.TextXAlignment = Enum.TextXAlignment.Left
        Item.Parent = List

        Item.MouseButton1Click:Connect(function()
            CurrentOption = {opt}
            UpdateLabel()
            isOpen = false
            List.Visible = false
            Icons:Apply(Icon, "chevron-down")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            if options.Callback then options.Callback(CurrentOption) end
            if options.Flag then saveMenuConfig(options.Flag, CurrentOption) end
        end)
    end

    return {}
end