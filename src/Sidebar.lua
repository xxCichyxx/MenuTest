local Sidebar = {}

function Sidebar:Create(UI, theme, config)
    local SidebarFrame = Instance.new("Frame")
    SidebarFrame.Name = "Sidebar"
    SidebarFrame.Size = UDim2.new(0, 200, 1, -32)
    SidebarFrame.Position = UDim2.new(0, 0, 0, 32)
    SidebarFrame.BackgroundTransparency = 1
    SidebarFrame.Parent = UI.MainFrame
    UI.Sidebar = SidebarFrame

    -- // GÓRNA CZĘŚĆ (Tytuł i Linia)
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = config.Name or "X HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Parent = SidebarFrame
    UI.ThemeManager:Register(Title, "TextColor3", "Text")

    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, 0, 0, 1)
    TitleLine.Position = UDim2.new(0, 0, 0, 45)
    TitleLine.BorderSizePixel = 0
    TitleLine.ZIndex = 10
    TitleLine.Parent = SidebarFrame
    UI.ThemeManager:Register(TitleLine, "BackgroundColor3", "Accent")

    -- // LISTA ZAKŁADEK (SCROLLING FRAME)
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 0.5, -46) -- Zmniejszona wysokość na profil
    TabList.Position = UDim2.new(0, 0, 0, 46)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarThickness = 0
    TabList.Parent = SidebarFrame
    UI.TabList = TabList

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 0)
    TabListLayout.Parent = TabList

    -- // DOLNA CZĘŚĆ (Profil)
    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Name = "ProfileFrame"
    ProfileFrame.Size = UDim2.new(1, 0, 0.5, 0)
    ProfileFrame.Position = UDim2.new(0, 0, 1, 0)
    ProfileFrame.AnchorPoint = Vector2.new(0, 1) -- Przypięty do dołu
    ProfileFrame.BackgroundTransparency = 1
    ProfileFrame.Parent = SidebarFrame

    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.new(0, 60, 0, 60)
    Avatar.Position = UDim2.new(0.5, 0, 0, 10)
    Avatar.AnchorPoint = Vector2.new(0.5, 0)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. game.Players.LocalPlayer.UserId .. "&w=150&h=150"
    Avatar.Parent = ProfileFrame

    -- Maska okrągła (wymaga ImageLabel z ImageRectOffset i ImageRectSize)
    -- Alternatywnie można użyć pluginu do tworzenia masek

    local DisplayName = Instance.new("TextLabel")
    DisplayName.Name = "DisplayName"
    DisplayName.Text = game.Players.LocalPlayer.DisplayName
    DisplayName.Font = Enum.Font.GothamMedium
    DisplayName.TextSize = 14
    DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
    DisplayName.Size = UDim2.new(1, 0, 0, 20)
    DisplayName.Position = UDim2.new(0, 0, 0, 75)
    DisplayName.BackgroundTransparency = 1
    DisplayName.TextXAlignment = Enum.TextXAlignment.Center
    DisplayName.Parent = ProfileFrame
    UI.ThemeManager:Register(DisplayName, "TextColor3", "Text")

    return SidebarFrame, TabList
end

return Sidebar