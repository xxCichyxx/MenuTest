local Window = {}

-- Serwisy
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Ładowanie modułów
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()
local Interactions = loadstring(game:HttpGet(baseUrl .. "Interactions.lua"))()

function Window:Create(config)
    local UI = {}
    UI.Tabs = {}
    UI.Pages = {}
    UI.SelectedTab = nil

    -- // THEME MANAGER
    local ThemeManager = { Elements = {}, CurrentTheme = config.Theme }
    local function getColor(colorTable) return Color3.fromRGB(unpack(colorTable)) end
    function ThemeManager:Register(element, property, colorName)
        table.insert(self.Elements, { Element = element, Property = property, ColorName = colorName })
        if self.CurrentTheme[colorName] then element[property] = getColor(self.CurrentTheme[colorName]) end
    end
    function ThemeManager:Apply(newTheme)
        self.CurrentTheme = newTheme
        for _, item in pairs(self.Elements) do
            if self.CurrentTheme[item.ColorName] then
                TweenService:Create(item.Element, TweenInfo.new(0.2), { [item.Property] = getColor(self.CurrentTheme[item.ColorName]) }):Play()
            end
        end
    end
    UI.ThemeManager = ThemeManager
    -- // END THEME MANAGER

    local isTouch = UserInputService.TouchEnabled or config.TestMobile
    
    local ProtectedLocation = nil
    pcall(function() ProtectedLocation = CoreGui end)
    if not ProtectedLocation then ProtectedLocation = Players.LocalPlayer:WaitForChild("PlayerGui") end
    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and child:FindFirstChild("XHUB_IDENTIFIER") then child:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XHUB_" .. math.random(1, 9999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ProtectedLocation
    UI.ScreenGui = ScreenGui

    local Tag = Instance.new("BoolValue")
    Tag.Name = "XHUB_IDENTIFIER"
    Tag.Parent = ScreenGui

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://10385930982"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 50, 50)
    Shadow.Parent = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 400)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 1
    MainFrame.Parent = ScreenGui
    UI.MainFrame = MainFrame
    ThemeManager:Register(MainFrame, "BackgroundColor3", "Main")

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Thickness = 1.6
    ThemeManager:Register(MainStroke, "Color", "Accent")

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 5
    TopBar.Parent = MainFrame
    UI.TopBar = TopBar

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 32)
    TopLine.BorderSizePixel = 0
    TopLine.ZIndex = 10
    TopLine.Parent = MainFrame
    ThemeManager:Register(TopLine, "BackgroundColor3", "Accent")

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, -32)
    Sidebar.Position = UDim2.new(0, 0, 0, 32)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame
    UI.Sidebar = Sidebar

    local GlobalIndicator = Instance.new("Frame")
    GlobalIndicator.Name = "GlobalIndicator"
    GlobalIndicator.Size = UDim2.new(0, 2, 0, 45)
    GlobalIndicator.Position = UDim2.new(0, 0, 0, 46)
    GlobalIndicator.BorderSizePixel = 0
    GlobalIndicator.ZIndex = 20
    GlobalIndicator.Visible = false
    GlobalIndicator.Parent = Sidebar
    UI.GlobalIndicator = GlobalIndicator
    ThemeManager:Register(GlobalIndicator, "BackgroundColor3", "Text")

    local VerticalLine = Instance.new("Frame")
    VerticalLine.Size = UDim2.new(0, 1, 1, 0)
    VerticalLine.Position = UDim2.new(1, 0, 0, 0)
    VerticalLine.BorderSizePixel = 0
    VerticalLine.ZIndex = 10
    VerticalLine.Parent = Sidebar
    ThemeManager:Register(VerticalLine, "BackgroundColor3", "Accent")

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = config.Name or "X HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar
    ThemeManager:Register(Title, "TextColor3", "Text")

    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, 0, 0, 1)
    TitleLine.Position = UDim2.new(0, 0, 0, 45)
    TitleLine.BorderSizePixel = 0
    TitleLine.ZIndex = 10
    TitleLine.Parent = Sidebar
    ThemeManager:Register(TitleLine, "BackgroundColor3", "Accent")

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, -46)
    TabList.Position = UDim2.new(0, 0, 0, 46)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarThickness = 0
    TabList.Parent = Sidebar
    UI.TabList = TabList

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabList

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Size = UDim2.new(1, -200, 1, -32)
    PagesContainer.Position = UDim2.new(0, 200, 0, 32)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.ClipsDescendants = true
    PagesContainer.Parent = MainFrame
    UI.PagesContainer = PagesContainer

    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 105, 1, 0)
    Controls.Position = UDim2.new(1, -105, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.ZIndex = 6
    Controls.Parent = TopBar
    UI.Controls = Controls

    local function createIconBtn(iconName, pos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 1, 0)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = Controls

        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 17, 0, 17)
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.BackgroundTransparency = 1
        iconImg.Parent = btn
        ThemeManager:Register(iconImg, "ImageColor3", "Text_Secondary")

        Icons:Apply(iconImg, iconName)
        return btn
    end

    UI.MinBtn = createIconBtn("minus", UDim2.new(0, 0, 0, 0))
    UI.MaxBtn = createIconBtn("maximize-2", UDim2.new(0, 35, 0, 0))
    UI.CloseBtn = createIconBtn("x", UDim2.new(0, 70, 0, 0))

    -- ... (logika MaxBtn)

    local ResizeHandle = Instance.new("TextButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 25, 0, 25)
    ResizeHandle.Position = UDim2.new(1, -25, 1, -25)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Text = ""
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = MainFrame
    UI.ResizeHandle = ResizeHandle

    local ResizeIcon = Instance.new("ImageLabel")
    ResizeIcon.Name = "Icon"
    ResizeIcon.Size = UDim2.new(0, 15, 0, 15)
    ResizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    ResizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    ResizeIcon.BackgroundTransparency = 1
    ResizeIcon.Parent = ResizeHandle
    ThemeManager:Register(ResizeIcon, "ImageColor3", "Accent")
    Icons:Apply(ResizeIcon, "arrow-down-right")

    Interactions:MakeDraggable(TopBar, MainFrame)
    Interactions:MakeResizable(ResizeHandle, MainFrame, 700, 400)

    -- ... (logika Shadow)

    local function ShowExitModal()
        local Overlay = Instance.new("Frame")
        Overlay.Name = "ExitOverlay"
        Overlay.Size = UDim2.new(1, 0, 1, 0)
        Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Overlay.BackgroundTransparency = 0.5
        Overlay.ZIndex = 100
        Overlay.Parent = MainFrame

        local Modal = Instance.new("Frame")
        Modal.Name = "ExitModal"
        Modal.Size = UDim2.new(0, 300, 0, 150)
        Modal.Position = UDim2.new(0.5, 0, 0.5, 0)
        Modal.AnchorPoint = Vector2.new(0.5, 0.5)
        Modal.BorderSizePixel = 0
        Modal.Parent = Overlay
        ThemeManager:Register(Modal, "BackgroundColor3", "Secondary")

        Instance.new("UICorner", Modal).CornerRadius = UDim.new(0, 8)
        local Stroke = Instance.new("UIStroke", Modal)
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ThemeManager:Register(Stroke, "Color", "Accent")

        local Question = Instance.new("TextLabel")
        Question.Text = "Are you sure you want to exit?"
        Question.Font = Enum.Font.GothamBold
        Question.TextSize = 16
        Question.Size = UDim2.new(1, 0, 0, 80)
        Question.BackgroundTransparency = 1
        Question.Parent = Modal
        ThemeManager:Register(Question, "TextColor3", "Text")

        local YesBtn = Instance.new("TextButton")
        -- ...
        ThemeManager:Register(YesBtn, "BackgroundColor3", "Close")

        local NoBtn = Instance.new("TextButton")
        -- ...
        ThemeManager:Register(NoBtn, "BackgroundColor3", "Accent")

        -- ...
    end
    UI.ShowExitModal = ShowExitModal

    function UI:CreateTab(name, icon, order)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.BorderSizePixel = 0
        TabButton.LayoutOrder = order or (#UI.Tabs + 1)
        TabButton.Parent = TabList

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 15, 0.5, 0)
        TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Parent = TabButton
        Icons:Apply(TabIcon, icon)

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, -50, 1, 0)
        TabLabel.Position = UDim2.new(0, 45, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.Text = name
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        local Page = Instance.new("ScrollingFrame")
        -- ...
        
        local function Select()
            if UI.SelectedTab == TabButton then return end
            
            if UI.SelectedTab then
                TweenService:Create(UI.SelectedTab:FindFirstChild("Icon"), TweenInfo.new(0.2), {ImageColor3 = getColor(ThemeManager.CurrentTheme.Text_Secondary)}):Play()
                TweenService:Create(UI.SelectedTab:FindFirstChild("Label"), TweenInfo.new(0.2), {TextColor3 = getColor(ThemeManager.CurrentTheme.Text_Secondary)}):Play()
            end

            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = getColor(ThemeManager.CurrentTheme.Text)}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = getColor(ThemeManager.CurrentTheme.Text)}):Play()
            
            -- ... reszta logiki Select
        end

        TabButton.MouseButton1Click:Connect(Select)
        table.insert(UI.Tabs, TabButton)
        table.insert(UI.Pages, Page)

        if #UI.Tabs == 1 then task.spawn(Select) end
        return {Button = TabButton, Page = Page}
    end

    return UI
end

return Window