local Dashboard = {}

-- Ładowanie ikon
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()

function Dashboard:Render(UI, order)
    local TabElements = UI:CreateTab("Dashboard", "layout-dashboard", order or 1)
    local Page = TabElements.Page

    -- 1. Sekcja "Quick Links" (Górna)
    local QuickLinksContainer = Instance.new("Frame")
    QuickLinksContainer.Name = "QuickLinks"
    QuickLinksContainer.Size = UDim2.new(1, -40, 0, 140) -- Wysokość kart
    QuickLinksContainer.BackgroundTransparency = 1
    QuickLinksContainer.Parent = Page

    local QuickLinksLayout = Instance.new("UIListLayout")
    QuickLinksLayout.FillDirection = Enum.FillDirection.Horizontal
    QuickLinksLayout.SortOrder = Enum.SortOrder.LayoutOrder
    QuickLinksLayout.Padding = UDim.new(0, 15)
    QuickLinksLayout.Parent = QuickLinksContainer

    -- Funkcja pomocnicza do tworzenia kart
    local function createCard(title, subtitle, iconName, btnText)
        local Card = Instance.new("Frame")
        Card.Name = "Card_" .. title
        -- Obliczamy szerokość: (100% - (2 * padding)) / 3 karty
        -- Używamy Scale, aby było responsywne
        Card.Size = UDim2.new(0.333, -10, 1, 0)
        Card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Card.Parent = QuickLinksContainer

        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Color = Color3.fromRGB(60, 60, 60)
        Stroke.Thickness = 1
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        -- Ikona na górze
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 32, 0, 32)
        Icon.Position = UDim2.new(0.5, 0, 0, 15)
        Icon.AnchorPoint = Vector2.new(0.5, 0)
        Icon.BackgroundTransparency = 1
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Icon.Parent = Card
        Icons:Apply(Icon, iconName)

        -- Tytuł
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 14
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.Size = UDim2.new(1, 0, 0, 20)
        TitleLabel.Position = UDim2.new(0, 0, 0, 55)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Parent = Card

        -- Podtytuł
        local SubLabel = Instance.new("TextLabel")
        SubLabel.Text = subtitle
        SubLabel.Font = Enum.Font.Gotham
        SubLabel.TextSize = 12
        SubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        SubLabel.Size = UDim2.new(1, 0, 0, 15)
        SubLabel.Position = UDim2.new(0, 0, 0, 75)
        SubLabel.BackgroundTransparency = 1
        SubLabel.Parent = Card

        -- Przycisk
        local Btn = Instance.new("TextButton")
        Btn.Text = btnText or "Open"
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 12
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Btn.Size = UDim2.new(0.8, 0, 0, 30)
        Btn.Position = UDim2.new(0.5, 0, 1, -15)
        Btn.AnchorPoint = Vector2.new(0.5, 1)
        Btn.Parent = Card
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        -- Mała ikona linku w przycisku
        local LinkIcon = Instance.new("ImageLabel")
        LinkIcon.Size = UDim2.new(0, 12, 0, 12)
        LinkIcon.Position = UDim2.new(1, -20, 0.5, 0)
        LinkIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        LinkIcon.BackgroundTransparency = 1
        LinkIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        LinkIcon.Parent = Btn
        Icons:Apply(LinkIcon, "external-link")

        return Btn
    end

    createCard("Discord", "Join our community", "users", "Join")
    createCard("Script", "Version 2.5.1", "file-text", "Copy")
    createCard("Support", "Get help now", "life-buoy", "Contact")


    -- 2. Sekcja "Latest Updates" (Dolna)
    local UpdatesContainer = Instance.new("Frame")
    UpdatesContainer.Name = "UpdatesContainer"
    UpdatesContainer.Size = UDim2.new(1, -40, 1, -160) -- Reszta miejsca
    UpdatesContainer.BackgroundTransparency = 1
    UpdatesContainer.Parent = Page

    -- Nagłówek sekcji
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundTransparency = 1
    Header.Parent = UpdatesContainer

    local HeaderIcon = Instance.new("ImageLabel")
    HeaderIcon.Size = UDim2.new(0, 20, 0, 20)
    HeaderIcon.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    HeaderIcon.BackgroundTransparency = 1
    HeaderIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    HeaderIcon.Parent = Header
    Icons:Apply(HeaderIcon, "activity")

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Text = "Latest Updates"
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.TextSize = 16
    HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderText.Size = UDim2.new(1, -30, 1, 0)
    HeaderText.Position = UDim2.new(0, 30, 0, 0)
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.BackgroundTransparency = 1
    HeaderText.Parent = Header

    -- Lista zmian
    local ChangelogList = Instance.new("ScrollingFrame")
    ChangelogList.Size = UDim2.new(1, 0, 1, -40)
    ChangelogList.Position = UDim2.new(0, 0, 0, 40)
    ChangelogList.BackgroundTransparency = 1
    ChangelogList.BorderSizePixel = 0
    ChangelogList.ScrollBarThickness = 2
    ChangelogList.Parent = UpdatesContainer

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.Parent = ChangelogList

    local function addLog(text)
        local LogItem = Instance.new("Frame")
        LogItem.Size = UDim2.new(1, 0, 0, 30)
        LogItem.BackgroundTransparency = 1
        LogItem.Parent = ChangelogList

        local Bullet = Instance.new("Frame")
        Bullet.Size = UDim2.new(0, 6, 0, 6)
        Bullet.Position = UDim2.new(0, 5, 0.5, 0)
        Bullet.AnchorPoint = Vector2.new(0, 0.5)
        Bullet.BackgroundColor3 = Color3.fromRGB(100, 255, 100) -- Zielona kropka
        Bullet.Parent = LogItem
        Instance.new("UICorner", Bullet).CornerRadius = UDim.new(1, 0)

        local LogText = Instance.new("TextLabel")
        LogText.Text = text
        LogText.Font = Enum.Font.Gotham
        LogText.TextSize = 14
        LogText.TextColor3 = Color3.fromRGB(200, 200, 200)
        LogText.Size = UDim2.new(1, -20, 1, 0)
        LogText.Position = UDim2.new(0, 20, 0, 0)
        LogText.TextXAlignment = Enum.TextXAlignment.Left
        LogText.BackgroundTransparency = 1
        LogText.Parent = LogItem

        local Separator = Instance.new("Frame")
        Separator.Size = UDim2.new(1, 0, 0, 1)
        Separator.Position = UDim2.new(0, 0, 1, 0)
        Separator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Separator.BorderSizePixel = 0
        Separator.Parent = LogItem
    end

    addLog("Added new aimbot features")
    addLog("Fixed ESP flickering issue")
    addLog("Updated UI design to modern style")
    addLog("Improved performance on low-end PCs")
end

return Dashboard