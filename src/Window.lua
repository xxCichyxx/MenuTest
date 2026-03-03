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
local SidebarModule = loadstring(game:HttpGet(baseUrl .. "Sidebar.lua"))()

function Window:Create(config)
    local UI = {}
    UI.Tabs = {}
    UI.Pages = {}
    UI.SelectedTab = nil
    UI.MenuConfig = config.MenuConfig
    UI.SaveMenuConfig = config.SaveMenuConfig

    -- // THEME MANAGER
    local ThemeManager = { Elements = {}, CurrentTheme = config.Theme }

    local function getColor(colorTable)
        if not colorTable then return Color3.fromRGB(255, 0, 255) end
        return Color3.fromRGB(unpack(colorTable))
    end

    function ThemeManager:Register(element, property, colorName)
        table.insert(self.Elements, { Element = element, Property = property, ColorName = colorName })
        if self.CurrentTheme[colorName] then
            element[property] = getColor(self.CurrentTheme[colorName])
        end
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

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.GenerateID()
    ScreenGui:SetAttribute(config.MenuId, true)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ProtectedLocation
    UI.ScreenGui = ScreenGui

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

    if config.Tittle and config.Tittle ~= "" then
        local TopTitle = Instance.new("TextLabel")
        TopTitle.Name = "TopTitle"
        TopTitle.Text = config.Tittle
        TopTitle.Font = Enum.Font.GothamMedium
        TopTitle.TextSize = 14
        TopTitle.BackgroundTransparency = 1
        TopTitle.Size = UDim2.new(1, -115, 1, 0)
        TopTitle.Position = UDim2.new(0, 10, 0, 0)
        TopTitle.Parent = TopBar
        ThemeManager:Register(TopTitle, "TextColor3", "Text_Secondary")

        if config.TittlePos == "Center" then
            TopTitle.TextXAlignment = Enum.TextXAlignment.Center
            TopTitle.Position = UDim2.new(0, 0, 0, 0)
            TopTitle.Size = UDim2.new(1, 0, 1, 0)
            TopTitle.ZIndex = 4
        else
            TopTitle.TextXAlignment = Enum.TextXAlignment.Left
        end
    end

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 32)
    TopLine.BorderSizePixel = 0
    TopLine.ZIndex = 10
    TopLine.Parent = MainFrame
    ThemeManager:Register(TopLine, "BackgroundColor3", "Accent")

    local SidebarFrame, TabList = SidebarModule:Create(UI, config.Theme, config)
    SidebarFrame.Parent = MainFrame
    UI.TabList = TabList

    local GlobalIndicator = Instance.new("Frame")
    GlobalIndicator.Name = "GlobalIndicator"
    GlobalIndicator.Size = UDim2.new(0, 2, 0, 45)
    GlobalIndicator.Position = UDim2.new(0, 0, 0, 46)
    GlobalIndicator.BorderSizePixel = 0
    GlobalIndicator.ZIndex = 20
    GlobalIndicator.Visible = false
    GlobalIndicator.Parent = SidebarFrame
    UI.GlobalIndicator = GlobalIndicator
    ThemeManager:Register(GlobalIndicator, "BackgroundColor3", "Text")

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

    local maximized = false
    local lastSize, lastPos

    UI.MaxBtn.MouseButton1Click:Connect(function()
        if not maximized then
            lastSize = MainFrame.Size
            lastPos = MainFrame.Position
            MainFrame:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Quart", 0.3, true)
            maximized = true
            Icons:Apply(UI.MaxBtn:FindFirstChild("Icon"), "square")
            UI.ResizeHandle.Visible = false
        else
            MainFrame:TweenSizeAndPosition(lastSize, lastPos, "Out", "Quart", 0.3, true)
            maximized = false
            Icons:Apply(UI.MaxBtn:FindFirstChild("Icon"), "maximize-2")
            UI.ResizeHandle.Visible = true
        end
    end)

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

    Shadow.AnchorPoint = MainFrame.AnchorPoint
    local SHADOW_OFFSET = 35

    RunService.RenderStepped:Connect(function()
        if MainFrame.Visible then
            Shadow.Position = UDim2.new(0, MainFrame.AbsolutePosition.X + (MainFrame.AbsoluteSize.X / 2), 0, MainFrame.AbsolutePosition.Y + (MainFrame.AbsoluteSize.Y / 2))
            Shadow.Size = UDim2.new(0, MainFrame.AbsoluteSize.X + (SHADOW_OFFSET * 2), 0, MainFrame.AbsoluteSize.Y + (SHADOW_OFFSET * 2))
        end
        Shadow.Visible = MainFrame.Visible
    end)

    if isTouch then
        local MobileToggle = Instance.new("TextButton")
        MobileToggle.Name = "MobileToggle"
        MobileToggle.Size = UDim2.new(0, 55, 0, 65)
        MobileToggle.Position = UDim2.new(0, 20, 0.5, -32)
        MobileToggle.BorderSizePixel = 0
        MobileToggle.Text = ""
        MobileToggle.ZIndex = 100
        MobileToggle.Parent = ScreenGui
        UI.MobileToggle = MobileToggle
        ThemeManager:Register(MobileToggle, "BackgroundColor3", "Main")

        Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(0, 10)
        local Stroke = Instance.new("UIStroke", MobileToggle)
        Stroke.Thickness = 1.5
        ThemeManager:Register(Stroke, "Color", "Accent")

        local MobileIcon = Instance.new("ImageLabel")
        MobileIcon.Name = "Icon"
        MobileIcon.Size = UDim2.new(0, 22, 0, 22)
        MobileIcon.Position = UDim2.new(0.5, 0, 0.4, 0)
        MobileIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        MobileIcon.BackgroundTransparency = 1
        MobileIcon.Parent = MobileToggle
        ThemeManager:Register(MobileIcon, "ImageColor3", "Text")
        Icons:Apply(MobileIcon, "menu")

        local ToggleText = Instance.new("TextLabel")
        ToggleText.Name = "MobileToggleText"
        ToggleText.Size = UDim2.new(1, 0, 0, 20)
        ToggleText.Position = UDim2.new(0.5, 0, 0.75, 0)
        ToggleText.AnchorPoint = Vector2.new(0.5, 0.5)
        ToggleText.BackgroundTransparency = 1
        ToggleText.Text = "CLOSE"
        ToggleText.Font = Enum.Font.GothamBold
        ToggleText.TextSize = 9
        ToggleText.Parent = MobileToggle
        UI.MobileToggleText = ToggleText

        MainFrame.Visible = true

        MobileToggle.MouseButton1Click:Connect(function()
            local isVisible = MainFrame.Visible
            MainFrame.Visible = not isVisible
            Shadow.Visible = not isVisible

            if isVisible then
                ToggleText.Text = "OPEN"
                ToggleText.TextColor3 = getColor(ThemeManager.CurrentTheme.Success)
            else
                ToggleText.Text = "CLOSE"
                ToggleText.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)

        Interactions:MakeDraggable(MobileToggle, MobileToggle)
    end

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
        Stroke.Thickness = 1.5
        ThemeManager:Register(Stroke, "Color", "Accent")

        local Question = Instance.new("TextLabel")
        Question.Text = "Are you sure you want to exit?"
        Question.Font = Enum.Font.GothamBold
        Question.TextSize = 16
        Question.Size = UDim2.new(1, 0, 0, 80)
        Question.BackgroundTransparency = 1
        Question.Parent = Modal
        ThemeManager:Register(Question, "TextColor3", "Text")

        local function createBtn(text, colorKey, pos)
            local btn = Instance.new("TextButton")
            btn.Text = text
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 14
            btn.Size = UDim2.new(0, 100, 0, 35)
            btn.Position = pos
            btn.Parent = Modal
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            ThemeManager:Register(btn, "TextColor3", "Text")
            ThemeManager:Register(btn, "BackgroundColor3", colorKey)
            return btn
        end

        local YesBtn = createBtn("Yes", "Close", UDim2.new(0.5, -110, 0.7, 0))
        local NoBtn = createBtn("No", "Accent", UDim2.new(0.5, 10, 0.7, 0))

        YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
        NoBtn.MouseButton1Click:Connect(function() Overlay:Destroy() end)
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
        ThemeManager:Register(TabIcon, "ImageColor3", "Text_Secondary")

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
        ThemeManager:Register(TabLabel, "TextColor3", "Text_Secondary")

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarThickness = 0
        Page.Parent = UI.PagesContainer

        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local PagePadding = Instance.new("UIPadding", Page)
        PagePadding.PaddingLeft = UDim.new(0, 20)
        PagePadding.PaddingTop = UDim.new(0, 20)
        PagePadding.PaddingRight = UDim.new(0, 20)

        local function Select()
            if UI.SelectedTab == TabButton then return end
            
            UI.GlobalIndicator.Visible = true

            if UI.SelectedTab then
                local prevIcon = UI.SelectedTab:FindFirstChild("Icon")
                local prevLabel = UI.SelectedTab:FindFirstChild("Label")
                if prevIcon then TweenService:Create(prevIcon, TweenInfo.new(0.2), {ImageColor3 = getColor(ThemeManager.CurrentTheme.Text_Secondary)}):Play() end
                if prevLabel then TweenService:Create(prevLabel, TweenInfo.new(0.2), {TextColor3 = getColor(ThemeManager.CurrentTheme.Text_Secondary)}):Play() end
            end

            for _, p in pairs(UI.Pages) do p.Visible = false end
            Page.Visible = true
            UI.SelectedTab = TabButton

            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = getColor(ThemeManager.CurrentTheme.Text)}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = getColor(ThemeManager.CurrentTheme.Text)}):Play()
            
            local sortedTabs = {}
            for _, t in pairs(TabList:GetChildren()) do
                if t:IsA("TextButton") then table.insert(sortedTabs, t) end
            end
            table.sort(sortedTabs, function(a, b) return a.LayoutOrder < b.LayoutOrder end)

            local index = 1
            for i, t in ipairs(sortedTabs) do
                if t == TabButton then index = i break end
            end

            local targetY = 46 + ((index - 1) * 45)
            TweenService:Create(UI.GlobalIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, targetY)
            }):Play()
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