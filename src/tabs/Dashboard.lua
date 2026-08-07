local Dashboard = {}

-- Serwisy
local HttpService = game:GetService("HttpService")

-- Ładowanie ikon
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()

function Dashboard:Render(UI, order)
    local TabElements = UI:CreateTab("Dashboard", "layout-dashboard", order or 1)
    local Page = TabElements.Page
    local ThemeManager = UI.ThemeManager

    local PageLayout = Page:FindFirstChildOfClass("UIListLayout")
    if PageLayout then PageLayout.SortOrder = Enum.SortOrder.LayoutOrder end

    local QuickLinksContainer = Instance.new("Frame")
    QuickLinksContainer.Name = "QuickLinks"
    QuickLinksContainer.Size = UDim2.new(1, -5, 0, 140)
    QuickLinksContainer.BackgroundTransparency = 1
    QuickLinksContainer.LayoutOrder = 2
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
        Card.Parent = QuickLinksContainer
        ThemeManager:Register(Card, "BackgroundColor3", "Secondary")

        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Thickness = 1
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ThemeManager:Register(Stroke, "Color", "Accent")

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 32, 0, 32)
        Icon.Position = UDim2.new(0.5, 0, 0, 15)
        Icon.AnchorPoint = Vector2.new(0.5, 0)
        Icon.BackgroundTransparency = 1
        Icon.Parent = Card
        ThemeManager:Register(Icon, "ImageColor3", "Text")
        Icons:Apply(Icon, iconName)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 14
        TitleLabel.Size = UDim2.new(1, 0, 0, 20)
        TitleLabel.Position = UDim2.new(0, 0, 0, 55)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Parent = Card
        ThemeManager:Register(TitleLabel, "TextColor3", "Text")

        local SubLabel = Instance.new("TextLabel")
        SubLabel.Text = subtitle
        SubLabel.Font = Enum.Font.Gotham
        SubLabel.TextSize = 12
        SubLabel.Size = UDim2.new(1, 0, 0, 15)
        SubLabel.Position = UDim2.new(0, 0, 0, 75)
        SubLabel.BackgroundTransparency = 1
        SubLabel.Parent = Card
        ThemeManager:Register(SubLabel, "TextColor3", "Text_Secondary")

        if title == "Version" then versionLabel = SubLabel end

        local Btn = Instance.new("TextButton")
        Btn.Text = btnText or "Open"
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 12
        Btn.Size = UDim2.new(0.8, 0, 0, 30)
        Btn.Position = UDim2.new(0.5, 0, 1, -15)
        Btn.AnchorPoint = Vector2.new(0.5, 1)
        Btn.Parent = Card
        ThemeManager:Register(Btn, "TextColor3", "Text")
        ThemeManager:Register(Btn, "BackgroundColor3", "Accent2")
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        local LinkIcon = Instance.new("ImageLabel")
        LinkIcon.Size = UDim2.new(0, 12, 0, 12)
        LinkIcon.Position = UDim2.new(1, -20, 0.5, 0)
        LinkIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        LinkIcon.BackgroundTransparency = 1
        LinkIcon.Parent = Btn
        ThemeManager:Register(LinkIcon, "ImageColor3", "Text_Secondary")
        Icons:Apply(LinkIcon, "external-link")

        if link and typeof(setclipboard) == "function" then
            Btn.MouseButton1Click:Connect(function() setclipboard(link) end)
        end
        return Btn
    end

    createCard("Discord", "Join community", "users", "Copy", "https://dsc.gg/xeno-scripts-pl")
    createCard("Version", "Ładowanie...", "package", "Copy")
    createCard("GitHub", "View source", "github", "Copy", "https://github.com/xxCichyxx/MenuTest")

    local UpdatesContainer = Instance.new("Frame")
    UpdatesContainer.Name = "UpdatesContainer"
    UpdatesContainer.Size = UDim2.new(1, -5, 0, 185)
    UpdatesContainer.LayoutOrder = 3
    UpdatesContainer.Parent = Page
    ThemeManager:Register(UpdatesContainer, "BackgroundColor3", "Secondary")

    Instance.new("UICorner", UpdatesContainer).CornerRadius = UDim.new(0, 8)
    local UpdatesStroke = Instance.new("UIStroke", UpdatesContainer)
    UpdatesStroke.Thickness = 1
    UpdatesStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ThemeManager:Register(UpdatesStroke, "Color", "Accent")

    -- POPRAWKA: Zwiększony padding, aby ikona nie wystawała
    local UpdatesPadding = Instance.new("UIPadding")
    UpdatesPadding.PaddingTop = UDim.new(0, 15)
    UpdatesPadding.PaddingBottom = UDim.new(0, 15)
    UpdatesPadding.PaddingLeft = UDim.new(0, 20) -- Zwiększono z 15 na 20
    UpdatesPadding.PaddingRight = UDim.new(0, 20)
    UpdatesPadding.Parent = UpdatesContainer

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundTransparency = 1
    Header.Parent = UpdatesContainer

    local HeaderIcon = Instance.new("ImageLabel")
    HeaderIcon.Size = UDim2.new(0, 20, 0, 20)
    HeaderIcon.Position = UDim2.new(0, 0, 0.5, 0) -- Ikona zaczyna się od krawędzi paddingu
    HeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    HeaderIcon.BackgroundTransparency = 1
    HeaderIcon.Parent = Header
    ThemeManager:Register(HeaderIcon, "ImageColor3", "Text")
    Icons:Apply(HeaderIcon, "activity")

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Text = "Latest Updates"
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.TextSize = 16
    HeaderText.Size = UDim2.new(1, -30, 1, 0)
    HeaderText.Position = UDim2.new(0, 30, 0, 0)
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.BackgroundTransparency = 1
    HeaderText.Parent = Header
    ThemeManager:Register(HeaderText, "TextColor3", "Text")

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
    ListLayout.Parent = ChangelogList

    local function addLog(message, commitId)
        local LogItem = Instance.new("Frame")
        LogItem.Size = UDim2.new(1, 0, 0, 35)
        LogItem.BackgroundTransparency = 1
        LogItem.Parent = ChangelogList

        local Bullet = Instance.new("ImageLabel")
        Bullet.Size = UDim2.new(0, 14, 0, 14)
        Bullet.Position = UDim2.new(0, 0, 0.5, 0) -- Wyrównanie do lewej krawędzi listy
        Bullet.AnchorPoint = Vector2.new(0, 0.5)
        Bullet.BackgroundTransparency = 1
        Bullet.Parent = LogItem
        ThemeManager:Register(Bullet, "ImageColor3", "Success")
        Icons:Apply(Bullet, "arrow-right")

        local LogText = Instance.new("TextLabel")
        LogText.Text = message
        LogText.Font = Enum.Font.Gotham
        LogText.TextSize = 14
        LogText.Position = UDim2.new(0, 25, 0, 0)
        LogText.TextYAlignment = Enum.TextYAlignment.Center
        LogText.Size = UDim2.new(1, -100, 1, 0)
        LogText.TextXAlignment = Enum.TextXAlignment.Left
        LogText.BackgroundTransparency = 1
        LogText.TextTruncate = Enum.TextTruncate.AtEnd
        LogText.Parent = LogItem
        ThemeManager:Register(LogText, "TextColor3", "Text_Secondary")

        local CommitLabel = Instance.new("TextLabel")
        CommitLabel.Text = commitId
        CommitLabel.Font = Enum.Font.Gotham
        CommitLabel.TextSize = 12
        CommitLabel.Size = UDim2.new(0, 70, 1, 0)
        CommitLabel.Position = UDim2.new(1, -70, 0, 0)
        CommitLabel.TextXAlignment = Enum.TextXAlignment.Center
        CommitLabel.TextYAlignment = Enum.TextYAlignment.Center
        CommitLabel.BackgroundTransparency = 1
        CommitLabel.Parent = LogItem
        ThemeManager:Register(CommitLabel, "TextColor3", "Text_Secondary")

        local Separator = Instance.new("Frame")
        Separator.Size = UDim2.new(1, 0, 0, 1)
        Separator.Position = UDim2.new(0, 0, 1, -1)
        Separator.BorderSizePixel = 0
        Separator.Parent = LogItem
        ThemeManager:Register(Separator, "BackgroundColor3", "Accent2")
    end
    local function safeHttpGet(url)
    -- Sprawdzamy czy executor obsługuje funkcję request (często pomija restrykcje gry)
    if request then
        local response = request({
            Url = url,
            Method = "GET"
        })
        if response and response.StatusCode == 200 then
            return true, response.Body
        end
        return false, nil
    elseif syn and syn.request then
        local response = syn.request({
            Url = url,
            Method = "GET"
        })
        if response and response.StatusCode == 200 then
            return true, response.Body
        end
        return false, nil
    else
        -- Awaryjnie zwykły HttpGet w pcall
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        return success, result
    end
    end

    task.spawn(function()
    local success, version = safeHttpGet("https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/version.txt")
    if versionLabel then
        versionLabel.Text = (success and version) and "v" .. version:gsub("^%s*(.-)%s*$", "%1") or "Unknown"
    end

    local successResp, response = safeHttpGet("https://api.github.com/repos/xxCichyxx/MenuTest/commits")

    if successResp and response then
        local successJson, commits = pcall(function() return HttpService:JSONDecode(response) end)
        if successJson and type(commits) == "table" then
            for _, child in pairs(ChangelogList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
            for i = 1, math.min(5, #commits) do
                local commitData = commits[i]
                if commitData and commitData.commit then
                    addLog(commitData.commit.message, commitData.sha:sub(1, 7))
                end
            end
        end
    end
    end)
end

return Dashboard