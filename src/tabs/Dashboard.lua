local Dashboard = {}

-- Serwisy
local HttpService = game:GetService("HttpService")

-- Ładowanie ikon
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()

function Dashboard:Render(UI, order)
    local TabElements = UI:CreateTab("Dashboard", "layout-dashboard", order or 1)
    local Page = TabElements.Page

    -- Poprawka: Ustawiamy sortowanie w layoucie strony, aby mieć kontrolę nad kolejnością
    local PageLayout = Page:FindFirstChildOfClass("UIListLayout")
    if PageLayout then
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    -- 0. Spacer (Odstęp od góry)
    local Spacer = Instance.new("Frame")
    Spacer.Name = "Spacer"
    Spacer.Size = UDim2.new(1, -40, 0, 1)
    Spacer.BackgroundTransparency = 1
    Spacer.LayoutOrder = 1 -- Ustawiamy kolejność
    Spacer.Parent = Page

    -- 1. Sekcja "Quick Links" (Górna)
    local QuickLinksContainer = Instance.new("Frame")
    QuickLinksContainer.Name = "QuickLinks"
    QuickLinksContainer.Size = UDim2.new(1, -40, 0, 140)
    QuickLinksContainer.BackgroundTransparency = 1
    QuickLinksContainer.LayoutOrder = 2 -- Ustawiamy kolejność
    QuickLinksContainer.Parent = Page

    local QuickLinksLayout = Instance.new("UIListLayout")
    QuickLinksLayout.FillDirection = Enum.FillDirection.Horizontal
    QuickLinksLayout.SortOrder = Enum.SortOrder.LayoutOrder
    QuickLinksLayout.Padding = UDim.new(0, 15)
    QuickLinksLayout.Parent = QuickLinksContainer

    local versionLabel

    local function createCard(title, subtitle, iconName, btnText, link)
        local Card = Instance.new("Frame")
        Card.Name = "Card_" .. title
        Card.Size = UDim2.new(0.333, -10, 1, 0)
        Card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Card.Parent = QuickLinksContainer

        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Color = Color3.fromRGB(60, 60, 60)
        Stroke.Thickness = 1
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 32, 0, 32)
        Icon.Position = UDim2.new(0.5, 0, 0, 15)
        Icon.AnchorPoint = Vector2.new(0.5, 0)
        Icon.BackgroundTransparency = 1
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Icon.Parent = Card
        Icons:Apply(Icon, iconName)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 14
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.Size = UDim2.new(1, 0, 0, 20)
        TitleLabel.Position = UDim2.new(0, 0, 0, 55)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Parent = Card

        local SubLabel = Instance.new("TextLabel")
        SubLabel.Text = subtitle
        SubLabel.Font = Enum.Font.Gotham
        SubLabel.TextSize = 12
        SubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        SubLabel.Size = UDim2.new(1, 0, 0, 15)
        SubLabel.Position = UDim2.new(0, 0, 0, 75)
        SubLabel.BackgroundTransparency = 1
        SubLabel.Parent = Card

        if title == "Version" then
            versionLabel = SubLabel
        end

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

        local LinkIcon = Instance.new("ImageLabel")
        LinkIcon.Size = UDim2.new(0, 12, 0, 12)
        LinkIcon.Position = UDim2.new(1, -20, 0.5, 0)
        LinkIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        LinkIcon.BackgroundTransparency = 1
        LinkIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        LinkIcon.Parent = Btn
        Icons:Apply(LinkIcon, "external-link")

        if link and typeof(setclipboard) == "function" then
            Btn.MouseButton1Click:Connect(function()
                setclipboard(link)
            end)
        end

        return Btn
    end

    createCard("Discord", "Join community", "users", "Copy", "https://dsc.gg/xeno-scripts-pl")
    createCard("Version", "Ładowanie...", "package", "Copy", "0.0.1")
    createCard("GitHub", "View source", "github", "Copy", "https://github.com/xxCichyxx/MenuTest")

    -- 2. Sekcja "Latest Updates" (Dolna)
    local UpdatesContainer = Instance.new("Frame")
    UpdatesContainer.Name = "UpdatesContainer"
    UpdatesContainer.Size = UDim2.new(1, -40, 0, 185)
    UpdatesContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    UpdatesContainer.LayoutOrder = 3 -- Ustawiamy kolejność
    UpdatesContainer.Parent = Page

    Instance.new("UICorner", UpdatesContainer).CornerRadius = UDim.new(0, 8)

    local UpdatesStroke = Instance.new("UIStroke", UpdatesContainer)
    UpdatesStroke.Color = Color3.fromRGB(60, 60, 60)
    UpdatesStroke.Thickness = 1
    UpdatesStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local UpdatesPadding = Instance.new("UIPadding")
    UpdatesPadding.PaddingTop = UDim.new(0, 15)
    UpdatesPadding.PaddingBottom = UDim.new(0, 15)
    UpdatesPadding.PaddingLeft = UDim.new(0, 15)
    UpdatesPadding.PaddingRight = UDim.new(0, 15)
    UpdatesPadding.Parent = UpdatesContainer

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

    local ChangelogList = Instance.new("ScrollingFrame")
    ChangelogList.Name = "ChangelogList"
    ChangelogList.Size = UDim2.new(1, 0, 1, -40)
    ChangelogList.Position = UDim2.new(0, 0, 0, 40)
    ChangelogList.BackgroundTransparency = 1
    ChangelogList.BorderSizePixel = 0
    ChangelogList.ScrollBarThickness = 2
    ChangelogList.Parent = UpdatesContainer

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 0)
    ListLayout.Parent = ChangelogList

    local function addLog(message, commitId)
        local LogItem = Instance.new("Frame")
        LogItem.Size = UDim2.new(1, 0, 0, 35)
        LogItem.BackgroundTransparency = 1
        LogItem.Parent = ChangelogList

        local Bullet = Instance.new("ImageLabel")
        Bullet.Size = UDim2.new(0, 14, 0, 14)
        Bullet.Position = UDim2.new(0, 5, 0.5, 0)
        Bullet.AnchorPoint = Vector2.new(0, 0.5)
        Bullet.BackgroundTransparency = 1
        Bullet.ImageColor3 = Color3.fromRGB(100, 255, 100)
        Bullet.Parent = LogItem
        Icons:Apply(Bullet, "arrow-right")

        local LogText = Instance.new("TextLabel")
        LogText.Text = message
        LogText.Font = Enum.Font.Gotham
        LogText.TextSize = 14
        LogText.TextColor3 = Color3.fromRGB(200, 200, 200)
        LogText.Position = UDim2.new(0, 25, 0, 0)
        LogText.TextYAlignment = Enum.TextYAlignment.Center
        LogText.Size = UDim2.new(1, -100, 1, 0)
        LogText.TextXAlignment = Enum.TextXAlignment.Left
        LogText.BackgroundTransparency = 1
        LogText.TextTruncate = Enum.TextTruncate.AtEnd
        LogText.Parent = LogItem

        local CommitLabel = Instance.new("TextLabel")
        CommitLabel.Text = commitId
        CommitLabel.Font = Enum.Font.Gotham
        CommitLabel.TextSize = 12
        CommitLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        CommitLabel.Size = UDim2.new(0, 70, 1, 0)
        CommitLabel.Position = UDim2.new(1, -70, 0, 0)
        CommitLabel.TextXAlignment = Enum.TextXAlignment.Center
        CommitLabel.TextYAlignment = Enum.TextYAlignment.Center
        CommitLabel.BackgroundTransparency = 1
        CommitLabel.Parent = LogItem

        local Separator = Instance.new("Frame")
        Separator.Size = UDim2.new(1, 0, 0, 1)
        Separator.Position = UDim2.new(0, 0, 1, -1)
        Separator.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Separator.BorderSizePixel = 0
        Separator.Parent = LogItem
    end

    -- 3. Asynchroniczne pobieranie danych
    task.spawn(function()
        local httpEnabled = pcall(function() HttpService:GetAsync("https://google.com") end)

        local success, version = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/version.txt")
        end)

        if versionLabel then
            if success and version then
                versionLabel.Text = "v" .. version:gsub("^%s*(.-)%s*$", "%1")
            else
                versionLabel.Text = "Unknown"
            end
        end

        local success, response = pcall(function()
            return game:HttpGet("https://api.github.com/repos/xxCichyxx/MenuTest/commits")
        end)

        if success and response then
            local successJson, commits = pcall(function()
                return HttpService:JSONDecode(response)
            end)

            if successJson and type(commits) == "table" then
                for _, child in pairs(ChangelogList:GetChildren()) do
                    if child:IsA("Frame") then child:Destroy() end
                end

                for i = 1, math.min(5, #commits) do
                    local commitData = commits[i]
                    if commitData and commitData.commit then
                        local message = commitData.commit.message
                        local sha = commitData.sha:sub(1, 7)
                        addLog(message, sha)
                    end
                end
            else
                addLog("Failed to parse GitHub data", "Error")
            end
        else
            addLog("Could not fetch updates", "Network Error")
        end
    end)
end

return Dashboard