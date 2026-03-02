local Settings = {}

-- Serwisy
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Ładowanie ikon
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()

function Settings:Render(UI, order, theme, mainFolder)
    local TabElements = UI:CreateTab("Settings", "settings", order or 999)
    local Page = TabElements.Page
    local ThemeManager = UI.ThemeManager

    local PageLayout = Page:FindFirstChildOfClass("UIListLayout")
    if PageLayout then
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 20)
    end

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 20)
    PagePadding.PaddingRight = UDim.new(0, 20)
    PagePadding.Parent = Page

    -- Sekcja: Themes
    local ThemesSection = Instance.new("Frame")
    ThemesSection.Name = "ThemesSection"
    ThemesSection.Size = UDim2.new(1, -40, 0, 0)
    ThemesSection.AutomaticSize = Enum.AutomaticSize.Y
    ThemesSection.BackgroundTransparency = 1
    ThemesSection.LayoutOrder = 1
    ThemesSection.Parent = Page

    local ThemesHeader = Instance.new("TextLabel")
    ThemesHeader.Text = "THEMES"
    ThemesHeader.Font = Enum.Font.GothamBold
    ThemesHeader.TextSize = 12
    ThemesHeader.Size = UDim2.new(1, 0, 0, 20)
    ThemesHeader.BackgroundTransparency = 1
    ThemesHeader.TextXAlignment = Enum.TextXAlignment.Left
    ThemesHeader.Parent = ThemesSection
    ThemeManager:Register(ThemesHeader, "TextColor3", "Text_Secondary")

    local ThemesContainer = Instance.new("Frame")
    ThemesContainer.Name = "Container"
    ThemesContainer.Size = UDim2.new(1, 0, 0, 50) -- Wysokość dla dropdowna
    ThemesContainer.Position = UDim2.new(0, 0, 0, 25)
    ThemesContainer.Parent = ThemesSection
    ThemeManager:Register(ThemesContainer, "BackgroundColor3", "Secondary")

    Instance.new("UICorner", ThemesContainer).CornerRadius = UDim.new(0, 6)
    local ThemesStroke = Instance.new("UIStroke", ThemesContainer)
    ThemesStroke.Thickness = 1
    ThemesStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ThemeManager:Register(ThemesStroke, "Color", "Accent")

    -- Refresh Button (Po lewej)
    local RefreshBtn = Instance.new("TextButton")
    RefreshBtn.Size = UDim2.new(0, 40, 0, 30)
    RefreshBtn.Position = UDim2.new(0, 10, 0.5, 0)
    RefreshBtn.AnchorPoint = Vector2.new(0, 0.5)
    RefreshBtn.Text = ""
    RefreshBtn.Parent = ThemesContainer
    ThemeManager:Register(RefreshBtn, "BackgroundColor3", "Accent")
    Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)

    local RefreshIcon = Instance.new("ImageLabel")
    RefreshIcon.Size = UDim2.new(0, 18, 0, 18)
    RefreshIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    RefreshIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    RefreshIcon.BackgroundTransparency = 1
    RefreshIcon.Parent = RefreshBtn
    ThemeManager:Register(RefreshIcon, "ImageColor3", "Text")
    Icons:Apply(RefreshIcon, "refresh-cw")

    -- Dropdown (Po prawej)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(1, -70, 0, 30)
    Dropdown.Position = UDim2.new(0, 60, 0.5, 0)
    Dropdown.AnchorPoint = Vector2.new(0, 0.5)
    Dropdown.ZIndex = 10
    Dropdown.Parent = ThemesContainer
    ThemeManager:Register(Dropdown, "BackgroundColor3", "Main")
    Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
    DropdownBtn.BackgroundTransparency = 1
    DropdownBtn.Text = "   Select Theme..."
    DropdownBtn.Font = Enum.Font.Gotham
    DropdownBtn.TextSize = 14
    DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
    DropdownBtn.ZIndex = 11
    DropdownBtn.Parent = Dropdown
    ThemeManager:Register(DropdownBtn, "TextColor3", "Text")

    local DropdownIcon = Instance.new("ImageLabel")
    DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
    DropdownIcon.Position = UDim2.new(1, -10, 0.5, 0)
    DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.ZIndex = 11
    DropdownIcon.Parent = Dropdown
    ThemeManager:Register(DropdownIcon, "ImageColor3", "Text_Secondary")
    Icons:Apply(DropdownIcon, "chevron-down")

    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 1, 5)
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    DropdownList.ScrollBarThickness = 2
    DropdownList.BackgroundTransparency = 1
    DropdownList.Visible = false
    DropdownList.ZIndex = 20
    DropdownList.Parent = Dropdown

    -- Tło listy dropdowna (osobna ramka dla cienia/obramowania)
    local ListBg = Instance.new("Frame")
    ListBg.Size = UDim2.new(1, 0, 0, 0) -- Dynamiczne
    ListBg.Position = UDim2.new(0, 0, 1, 5)
    ListBg.Visible = false
    ListBg.ZIndex = 19
    ListBg.Parent = Dropdown
    ThemeManager:Register(ListBg, "BackgroundColor3", "Main")
    Instance.new("UICorner", ListBg).CornerRadius = UDim.new(0, 6)
    local ListStroke = Instance.new("UIStroke", ListBg)
    ListStroke.Thickness = 1
    ListStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ThemeManager:Register(ListStroke, "Color", "Accent")

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = DropdownList

    local isDropdownOpen = false

    local function ToggleDropdown()
        isDropdownOpen = not isDropdownOpen
        DropdownList.Visible = isDropdownOpen
        ListBg.Visible = isDropdownOpen

        if isDropdownOpen then
            local count = #DropdownList:GetChildren() - 1
            local height = math.min(count * 30, 150)
            DropdownList.Size = UDim2.new(1, 0, 0, height)
            ListBg.Size = UDim2.new(1, 0, 0, height)
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, count * 30)
            Icons:Apply(DropdownIcon, "chevron-up")
        else
            Icons:Apply(DropdownIcon, "chevron-down")
        end
    end

    DropdownBtn.MouseButton1Click:Connect(ToggleDropdown)

    local function LoadThemes()
        for _, child in pairs(DropdownList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local themesFolder = mainFolder .. "/themes"
        if isfolder(themesFolder) then
            for _, file in pairs(listfiles(themesFolder)) do
                if file:sub(-5) == ".json" then
                    local themeName = file:match("([^/\\]+)%.json$") or file:match("([^/\\]+)$")

                    local Item = Instance.new("TextButton")
                    Item.Size = UDim2.new(1, 0, 0, 30)
                    Item.BackgroundTransparency = 1
                    Item.Text = "   " .. themeName
                    Item.Font = Enum.Font.Gotham
                    Item.TextSize = 14
                    Item.TextXAlignment = Enum.TextXAlignment.Left
                    Item.ZIndex = 21
                    Item.Parent = DropdownList
                    ThemeManager:Register(Item, "TextColor3", "Text")

                    Item.MouseButton1Click:Connect(function()
                        DropdownBtn.Text = "   " .. themeName
                        ToggleDropdown()

                        -- Ładowanie i aplikowanie motywu
                        local success, data = pcall(function()
                            return HttpService:JSONDecode(readfile(file))
                        end)

                        if success and type(data) == "table" then
                            ThemeManager:Apply(data)
                        end
                    end)
                end
            end
        end
    end

    RefreshBtn.MouseButton1Click:Connect(function()
        LoadThemes()
        -- Animacja obrotu
        local tween = TweenService:Create(RefreshIcon, TweenInfo.new(0.5), {Rotation = 360})
        tween:Play()
        tween.Completed:Connect(function() RefreshIcon.Rotation = 0 end)
    end)

    LoadThemes() -- Inicjalne ładowanie

    -- Sekcja: Other Settings
    local SettingsSection = Instance.new("Frame")
    SettingsSection.Name = "SettingsSection"
    SettingsSection.Size = UDim2.new(1, -40, 0, 0)
    SettingsSection.AutomaticSize = Enum.AutomaticSize.Y
    SettingsSection.BackgroundTransparency = 1
    SettingsSection.LayoutOrder = 2
    SettingsSection.Position = UDim2.new(0, 0, 0, 20)
    SettingsSection.Parent = Page

    local SettingsHeader = Instance.new("TextLabel")
    SettingsHeader.Text = "OPTIONS"
    SettingsHeader.Font = Enum.Font.GothamBold
    SettingsHeader.TextSize = 12
    SettingsHeader.Size = UDim2.new(1, 0, 0, 20)
    SettingsHeader.BackgroundTransparency = 1
    SettingsHeader.TextXAlignment = Enum.TextXAlignment.Left
    SettingsHeader.Parent = SettingsSection
    ThemeManager:Register(SettingsHeader, "TextColor3", "Text_Secondary")

    local SettingsContainer = Instance.new("Frame")
    SettingsContainer.Name = "Container"
    SettingsContainer.Size = UDim2.new(1, 0, 0, 0)
    SettingsContainer.AutomaticSize = Enum.AutomaticSize.Y
    SettingsContainer.Position = UDim2.new(0, 0, 0, 25)
    SettingsContainer.Parent = SettingsSection
    ThemeManager:Register(SettingsContainer, "BackgroundColor3", "Secondary")

    Instance.new("UICorner", SettingsContainer).CornerRadius = UDim.new(0, 6)
    local SettingsStroke = Instance.new("UIStroke", SettingsContainer)
    SettingsStroke.Thickness = 1
    SettingsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ThemeManager:Register(SettingsStroke, "Color", "Accent")

    local SettingsListLayout = Instance.new("UIListLayout")
    SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsListLayout.Padding = UDim.new(0, 5)
    SettingsListLayout.Parent = SettingsContainer

    local SettingsPadding = Instance.new("UIPadding")
    SettingsPadding.PaddingTop = UDim.new(0, 10)
    SettingsPadding.PaddingBottom = UDim.new(0, 10)
    SettingsPadding.PaddingLeft = UDim.new(0, 10)
    SettingsPadding.PaddingRight = UDim.new(0, 10)
    SettingsPadding.Parent = SettingsContainer

    -- Anti-AFK Toggle
    local AntiAfkFrame = Instance.new("Frame")
    AntiAfkFrame.Size = UDim2.new(1, 0, 0, 30)
    AntiAfkFrame.BackgroundTransparency = 1
    AntiAfkFrame.Parent = SettingsContainer

    local AntiAfkLabel = Instance.new("TextLabel")
    AntiAfkLabel.Text = "Anti-AFK"
    AntiAfkLabel.Font = Enum.Font.Gotham
    AntiAfkLabel.TextSize = 14
    AntiAfkLabel.Size = UDim2.new(1, -50, 1, 0)
    AntiAfkLabel.BackgroundTransparency = 1
    AntiAfkLabel.TextXAlignment = Enum.TextXAlignment.Left
    AntiAfkLabel.Parent = AntiAfkFrame
    ThemeManager:Register(AntiAfkLabel, "TextColor3", "Text")

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -40, 0.5, 0)
    ToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = AntiAfkFrame
    ThemeManager:Register(ToggleBtn, "BackgroundColor3", "Accent2")
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.Parent = ToggleBtn
    ThemeManager:Register(ToggleCircle, "BackgroundColor3", "Text")
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    local antiAfkEnabled = false
    local antiAfkConnection

    ToggleBtn.MouseButton1Click:Connect(function()
        antiAfkEnabled = not antiAfkEnabled

        if antiAfkEnabled then
            -- Ręczna zmiana koloru na Success (ThemeManager nie obsługuje stanów logicznych bezpośrednio, więc robimy to ręcznie, ale używając kolorów z motywu)
            local successColor = Color3.fromRGB(unpack(ThemeManager.CurrentTheme.Success))
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = successColor}):Play()
            ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)

            antiAfkConnection = Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            local accent2Color = Color3.fromRGB(unpack(ThemeManager.CurrentTheme.Accent2))
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = accent2Color}):Play()
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)

            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end)
end

return Settings