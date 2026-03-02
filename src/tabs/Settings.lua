local Settings = {}

-- Serwisy
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

-- Ładowanie ikon
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()

function Settings:Render(UI, order, theme, mainFolder)
    local TabElements = UI:CreateTab("Settings", "settings", order or 999)
    local Page = TabElements.Page

    -- Funkcja pomocnicza do konwersji tabeli {r, g, b} na Color3
    local function getColor(colorTable)
        return Color3.fromRGB(unpack(colorTable))
    end

    -- Layout strony
    local PageLayout = Page:FindFirstChildOfClass("UIListLayout")
    if PageLayout then
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 20) -- Odstęp między sekcjami
    end

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 20)
    PagePadding.PaddingRight = UDim.new(0, 20)
    PagePadding.Parent = Page

    -- Sekcja: Themes
    local ThemesSection = Instance.new("Frame")
    ThemesSection.Name = "ThemesSection"
    ThemesSection.Size = UDim2.new(1, -40, 0, 0) -- Wysokość dynamiczna
    ThemesSection.AutomaticSize = Enum.AutomaticSize.Y
    ThemesSection.BackgroundTransparency = 1
    ThemesSection.LayoutOrder = 1
    ThemesSection.Parent = Page

    local ThemesHeader = Instance.new("TextLabel")
    ThemesHeader.Text = "THEMES"
    ThemesHeader.Font = Enum.Font.GothamBold
    ThemesHeader.TextSize = 12
    ThemesHeader.TextColor3 = getColor(theme.Text_Secondary)
    ThemesHeader.Size = UDim2.new(1, 0, 0, 20)
    ThemesHeader.BackgroundTransparency = 1
    ThemesHeader.TextXAlignment = Enum.TextXAlignment.Left
    ThemesHeader.Parent = ThemesSection

    local ThemesContainer = Instance.new("Frame")
    ThemesContainer.Name = "Container"
    ThemesContainer.Size = UDim2.new(1, 0, 0, 0)
    ThemesContainer.AutomaticSize = Enum.AutomaticSize.Y
    ThemesContainer.Position = UDim2.new(0, 0, 0, 25)
    ThemesContainer.BackgroundColor3 = getColor(theme.Secondary)
    ThemesContainer.Parent = ThemesSection

    Instance.new("UICorner", ThemesContainer).CornerRadius = UDim.new(0, 6)
    local ThemesStroke = Instance.new("UIStroke", ThemesContainer)
    ThemesStroke.Color = getColor(theme.Accent)
    ThemesStroke.Thickness = 1
    ThemesStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local ThemesListLayout = Instance.new("UIListLayout")
    ThemesListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ThemesListLayout.Padding = UDim.new(0, 5)
    ThemesListLayout.Parent = ThemesContainer

    local ThemesPadding = Instance.new("UIPadding")
    ThemesPadding.PaddingTop = UDim.new(0, 10)
    ThemesPadding.PaddingBottom = UDim.new(0, 10)
    ThemesPadding.PaddingLeft = UDim.new(0, 10)
    ThemesPadding.PaddingRight = UDim.new(0, 10)
    ThemesPadding.Parent = ThemesContainer

    -- Funkcja odświeżania motywów
    local function RefreshThemes()
        -- Czyścimy stare przyciski (oprócz layoutu i paddingu)
        for _, child in pairs(ThemesContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local themesFolder = mainFolder .. "/themes"
        if isfolder(themesFolder) then
            for _, file in pairs(listfiles(themesFolder)) do
                if file:sub(-5) == ".json" then
                    -- Wyciągamy samą nazwę pliku z pełnej ścieżki
                    local themeName = file:match("([^/\\]+)%.json$") or file:match("([^/\\]+)$")

                    local ThemeBtn = Instance.new("TextButton")
                    ThemeBtn.Name = themeName
                    ThemeBtn.Size = UDim2.new(1, 0, 0, 30)
                    ThemeBtn.BackgroundColor3 = getColor(theme.Main)
                    ThemeBtn.Text = "   " .. themeName
                    ThemeBtn.Font = Enum.Font.Gotham
                    ThemeBtn.TextSize = 14
                    ThemeBtn.TextColor3 = getColor(theme.Text)
                    ThemeBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ThemeBtn.Parent = ThemesContainer

                    Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 4)

                    ThemeBtn.MouseButton1Click:Connect(function()
                        print("Selected theme:", themeName)
                        -- Tutaj można dodać logikę zapisu wybranego motywu do configu
                    end)
                end
            end
        end

        -- Przycisk odświeżania zawsze na dole
        local RefreshBtn = Instance.new("TextButton")
        RefreshBtn.Text = "Refresh Themes"
        RefreshBtn.Size = UDim2.new(1, 0, 0, 30)
        RefreshBtn.BackgroundColor3 = getColor(theme.Accent)
        RefreshBtn.TextColor3 = getColor(theme.Text)
        RefreshBtn.Font = Enum.Font.GothamMedium
        RefreshBtn.TextSize = 14
        RefreshBtn.LayoutOrder = 999
        RefreshBtn.Parent = ThemesContainer
        Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 4)

        -- Musimy przekazać funkcję rekurencyjnie lub zdefiniować ją wyżej,
        -- ale w Lua lokalna funkcja nie widzi samej siebie podczas definicji.
        -- Rozwiązanie: użyjemy zmiennej forward declaration.
    end

    -- Forward declaration dla RefreshThemes
    local _RefreshThemes
    _RefreshThemes = function()
         -- Czyścimy stare przyciski (oprócz layoutu i paddingu)
        for _, child in pairs(ThemesContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local themesFolder = mainFolder .. "/themes"
        if isfolder(themesFolder) then
            for _, file in pairs(listfiles(themesFolder)) do
                if file:sub(-5) == ".json" then
                    local themeName = file:match("([^/\\]+)%.json$") or file:match("([^/\\]+)$")

                    local ThemeBtn = Instance.new("TextButton")
                    ThemeBtn.Name = themeName
                    ThemeBtn.Size = UDim2.new(1, 0, 0, 30)
                    ThemeBtn.BackgroundColor3 = getColor(theme.Main)
                    ThemeBtn.Text = "   " .. themeName
                    ThemeBtn.Font = Enum.Font.Gotham
                    ThemeBtn.TextSize = 14
                    ThemeBtn.TextColor3 = getColor(theme.Text)
                    ThemeBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ThemeBtn.Parent = ThemesContainer

                    Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 4)

                    ThemeBtn.MouseButton1Click:Connect(function()
                        print("Selected theme:", themeName)
                    end)
                end
            end
        end

        local RefreshBtn = Instance.new("TextButton")
        RefreshBtn.Text = "Refresh Themes"
        RefreshBtn.Size = UDim2.new(1, 0, 0, 30)
        RefreshBtn.BackgroundColor3 = getColor(theme.Accent)
        RefreshBtn.TextColor3 = getColor(theme.Text)
        RefreshBtn.Font = Enum.Font.GothamMedium
        RefreshBtn.TextSize = 14
        RefreshBtn.LayoutOrder = 999
        RefreshBtn.Parent = ThemesContainer
        Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 4)
        RefreshBtn.MouseButton1Click:Connect(_RefreshThemes)
    end

    _RefreshThemes() -- Pierwsze wywołanie

    -- Sekcja: Other Settings
    local SettingsSection = Instance.new("Frame")
    SettingsSection.Name = "SettingsSection"
    SettingsSection.Size = UDim2.new(1, -40, 0, 0)
    SettingsSection.AutomaticSize = Enum.AutomaticSize.Y
    SettingsSection.BackgroundTransparency = 1
    SettingsSection.LayoutOrder = 2
    SettingsSection.Parent = Page

    local SettingsHeader = Instance.new("TextLabel")
    SettingsHeader.Text = "OPTIONS"
    SettingsHeader.Font = Enum.Font.GothamBold
    SettingsHeader.TextSize = 12
    SettingsHeader.TextColor3 = getColor(theme.Text_Secondary)
    SettingsHeader.Size = UDim2.new(1, 0, 0, 20)
    SettingsHeader.BackgroundTransparency = 1
    SettingsHeader.TextXAlignment = Enum.TextXAlignment.Left
    SettingsHeader.Parent = SettingsSection

    local SettingsContainer = Instance.new("Frame")
    SettingsContainer.Name = "Container"
    SettingsContainer.Size = UDim2.new(1, 0, 0, 0)
    SettingsContainer.AutomaticSize = Enum.AutomaticSize.Y
    SettingsContainer.Position = UDim2.new(0, 0, 0, 25)
    SettingsContainer.BackgroundColor3 = getColor(theme.Secondary)
    SettingsContainer.Parent = SettingsSection

    Instance.new("UICorner", SettingsContainer).CornerRadius = UDim.new(0, 6)
    local SettingsStroke = Instance.new("UIStroke", SettingsContainer)
    SettingsStroke.Color = getColor(theme.Accent)
    SettingsStroke.Thickness = 1
    SettingsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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
    AntiAfkLabel.TextColor3 = getColor(theme.Text)
    AntiAfkLabel.Size = UDim2.new(1, -50, 1, 0)
    AntiAfkLabel.BackgroundTransparency = 1
    AntiAfkLabel.TextXAlignment = Enum.TextXAlignment.Left
    AntiAfkLabel.Parent = AntiAfkFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -40, 0.5, 0)
    ToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
    ToggleBtn.BackgroundColor3 = getColor(theme.Accent2)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = AntiAfkFrame
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.BackgroundColor3 = getColor(theme.Text)
    ToggleCircle.Parent = ToggleBtn
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    local antiAfkEnabled = false
    local antiAfkConnection

    ToggleBtn.MouseButton1Click:Connect(function()
        antiAfkEnabled = not antiAfkEnabled

        if antiAfkEnabled then
            ToggleBtn.BackgroundColor3 = getColor(theme.Success)
            ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, 0), "Out", "Quart", 0.2, true)

            -- Logika Anti-AFK
            antiAfkConnection = Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            ToggleBtn.BackgroundColor3 = getColor(theme.Accent2)
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Quart", 0.2, true)

            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end)

    -- Save Config Button
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Text = "Save Configuration"
    SaveBtn.Size = UDim2.new(1, 0, 0, 35)
    SaveBtn.BackgroundColor3 = getColor(theme.Accent)
    SaveBtn.TextColor3 = getColor(theme.Text)
    SaveBtn.Font = Enum.Font.GothamMedium
    SaveBtn.TextSize = 14
    SaveBtn.Parent = SettingsContainer
    Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 6)

    SaveBtn.MouseButton1Click:Connect(function()
        SaveBtn.Text = "Saved!"
        task.wait(1)
        SaveBtn.Text = "Save Configuration"
    end)

end

return Settings