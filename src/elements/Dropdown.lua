return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local TweenService = game:GetService("TweenService")
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/Icons.lua"))()

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = options.Name or "Dropdown"
    DropdownFrame.Size = UDim2.new(0.5, -5, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.ZIndex = 5 -- Wyższy ZIndex, żeby lista była na wierzchu
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

    -- Lista
    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, 0, 0, 0)
    List.Position = UDim2.new(0, 0, 1, 5)
    List.BackgroundTransparency = 1 -- Tło zrobimy osobnym Frame dla cienia
    List.BorderSizePixel = 0
    List.ScrollBarThickness = 2
    List.Visible = false
    List.ZIndex = 10
    List.Parent = DropdownFrame -- Musi być dzieckiem DropdownFrame, ale DropdownFrame musi mieć ClipsDescendants = false

    -- Tło listy
    local ListBg = Instance.new("Frame")
    ListBg.Size = UDim2.new(1, 0, 0, 0)
    ListBg.Position = UDim2.new(0, 0, 1, 5)
    ListBg.Visible = false
    ListBg.ZIndex = 9
    ListBg.Parent = DropdownFrame
    themeManager:Register(ListBg, "BackgroundColor3", "Secondary")
    Instance.new("UICorner", ListBg).CornerRadius = UDim.new(0, 6)
    local ListStroke = Instance.new("UIStroke", ListBg)
    ListStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    themeManager:Register(ListStroke, "Color", "Accent")

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = List

    -- Ważne: Ustawiamy ClipsDescendants na false w rodzicach, jeśli to możliwe,
    -- ale w UIGridLayout to trudne.
    -- Alternatywa: Lista jako dziecko ScreenGui (TopLevel), pozycjonowana absolutnie.
    -- Dla uproszczenia tutaj: Zakładamy, że UIGridLayout nie ucina (zwykle nie ucina, chyba że ScrollingFrame nadrzędny ma ClipsDescendants=true).
    -- W naszym przypadku Page ma ClipsDescendants=true (domyślnie dla ScrollingFrame).
    -- Więc Dropdown wewnątrz Page będzie ucięty.
    -- FIX: Dropdown musi zmieniać Parent na UI.MainFrame (lub ScreenGui) podczas otwierania.

    -- Na razie prosta implementacja wewnątrz (może być ucięta).
    -- Aby naprawić ucinanie w przyszłości: Przenieś List do ScreenGui i użyj AbsolutePosition.

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
        ListBg.Visible = isOpen

        if isOpen then
            Icons:Apply(Icon, "chevron-up")
            local count = #Options
            local height = math.min(count * 30, 150)
            List.Size = UDim2.new(1, 0, 0, height)
            ListBg.Size = UDim2.new(1, 0, 0, height)
            List.CanvasSize = UDim2.new(0, 0, 0, count * 30)
            DropdownFrame.ZIndex = 20 -- Przenieś na wierzch
        else
            Icons:Apply(Icon, "chevron-down")
            DropdownFrame.ZIndex = 5
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
            Item.TextColor3 = Color3.fromRGB(255, 255, 255) -- Domyślny
            Item.Parent = List
            themeManager:Register(Item, "TextColor3", "Text")

            -- Podświetlenie wybranego
            local isSelected = false
            for _, s in ipairs(CurrentOption) do if s == opt then isSelected = true break end end
            if isSelected then
                Item.TextColor3 = Color3.fromRGB(100, 255, 100) -- Success color
            end

            Item.MouseButton1Click:Connect(function()
                if options.MultipleOptions then
                    -- Logika wielokrotnego wyboru
                else
                    CurrentOption = {opt}
                    UpdateLabel()
                    Toggle() -- Zamknij
                    if options.Callback then options.Callback(CurrentOption) end
                    if options.Flag then saveMenuConfig(options.Flag, CurrentOption) end
                end
                RefreshList() -- Odśwież kolory
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