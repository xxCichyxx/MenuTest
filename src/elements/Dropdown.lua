return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = options.Name or "Dropdown"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35) -- Pełna szerokość
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.ZIndex = 5
    DropdownFrame.Parent = parent

    local Main = Instance.new("TextButton")
    Main.Name = "Main"
    Main.Size = UDim2.new(1, 0, 0, 35)
    Main.Text = ""
    Main.Parent = DropdownFrame
    themeManager:Register(Main, "BackgroundColor3", "Secondary")
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(Stroke, "Color", "Accent")

    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Dropdown"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Main
    themeManager:Register(Label, "TextColor3", "Text")

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(1, -30, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.Parent = Main
    themeManager:Register(Icon, "ImageColor3", "Text_Secondary")
    Icons:Apply(Icon, "chevron-down")

    -- Lista (Wewnątrz DropdownFrame, ale z wysokim ZIndex)
    -- Uwaga: Wewnątrz modułu (który ma ClipsDescendants=true) lista może być ucięta.
    -- Aby to naprawić idealnie, lista musiałaby być w ScreenGui.
    -- Na razie zostawiamy wewnątrz, ale moduł musi się rozszerzyć, jeśli lista jest długa.
    -- W obecnej implementacji modułu, wysokość jest liczona dynamicznie, więc lista rozepchnie moduł.

    local List = Instance.new("Frame") -- Zmieniono na Frame (kontener)
    List.Size = UDim2.new(1, 0, 0, 0)
    List.Position = UDim2.new(0, 0, 1, 5)
    List.BackgroundTransparency = 1
    List.Visible = false
    List.ZIndex = 10
    List.Parent = DropdownFrame

    local ListBg = Instance.new("Frame")
    ListBg.Size = UDim2.new(1, 0, 1, 0)
    ListBg.Parent = List
    themeManager:Register(ListBg, "BackgroundColor3", "Secondary")
    Instance.new("UICorner", ListBg).CornerRadius = UDim.new(0, 6)
    local ListStroke = Instance.new("UIStroke", ListBg)
    ListStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(ListStroke, "Color", "Accent")

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = List

    local Options = options.Options or {}
    local CurrentOption = options.CurrentOption or {Options[1]}
    if options.Flag and menuConfig[options.Flag] ~= nil then
        CurrentOption = menuConfig[options.Flag]
    end

    local function UpdateLabel()
        if #CurrentOption == 1 then
            Label.Text = options.Name .. ": " .. CurrentOption[1]
        else
            Label.Text = options.Name .. ": " .. #CurrentOption .. " selected"
        end
    end
    UpdateLabel()

    local isOpen = false

    local function Toggle()
        isOpen = not isOpen
        List.Visible = isOpen

        if isOpen then
            Icons:Apply(Icon, "chevron-up")
            local count = #Options
            local height = count * 30
            List.Size = UDim2.new(1, 0, 0, height)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35 + height + 5) -- Rozszerz ramkę dropdowna
        else
            Icons:Apply(Icon, "chevron-down")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35) -- Zwiń ramkę
        end
    end

    Main.MouseButton1Click:Connect(Toggle)

    local function RefreshList()
        for _, child in pairs(List:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, opt in ipairs(Options) do
            local Item = Instance.new("TextButton")
            Item.Size = UDim2.new(1, 0, 0, 30)
            Item.BackgroundTransparency = 1
            Item.Text = "   " .. opt
            Item.Font = Enum.Font.Gotham
            Item.TextSize = 14
            Item.TextXAlignment = Enum.TextXAlignment.Left
            Item.Parent = List
            themeManager:Register(Item, "TextColor3", "Text")

            local isSelected = false
            for _, s in ipairs(CurrentOption) do if s == opt then isSelected = true break end end
            if isSelected then
                Item.TextColor3 = Color3.fromRGB(100, 255, 100)
            end

            Item.MouseButton1Click:Connect(function()
                if not options.MultipleOptions then
                    CurrentOption = {opt}
                    UpdateLabel()
                    Toggle()
                    if options.Callback then options.Callback(CurrentOption) end
                    if options.Flag then saveMenuConfig(options.Flag, CurrentOption) end
                end
                RefreshList()
            end)
        end
    end
    RefreshList()

    local API = {}
    function API:Refresh(newOptions)
        Options = newOptions
        RefreshList()
    end
    function API:Set(newOption)
        CurrentOption = newOption
        UpdateLabel()
        RefreshList()
    end
    return API
end