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

    local isTouch = UserInputService.TouchEnabled or config.TestMobile
    
    -- 1. USTALANIE LOKALIZACJI I RESET STAREGO GUI
    local ProtectedLocation = nil
    local success, _ = pcall(function() ProtectedLocation = CoreGui end)
    if not success then ProtectedLocation = Players.LocalPlayer:WaitForChild("PlayerGui") end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and child:FindFirstChild("XHUB_IDENTIFIER") then
            child:Destroy()
        end
    end

    local function generateName()
        local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local randomName = ""
        for i = 1, 15 do
            local rand = math.random(1, #chars)
            randomName = randomName .. string.sub(chars, rand, rand)
        end
        return randomName
    end

    -- 2. ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = generateName()
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ProtectedLocation
    UI.ScreenGui = ScreenGui

    local Tag = Instance.new("BoolValue")
    Tag.Name = "XHUB_IDENTIFIER"
    Tag.Parent = ScreenGui

    -- 3. Shadow (Cień) - Dodano brakującą definicję
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://10385930982" -- Blur image
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 50, 50)
    Shadow.Parent = ScreenGui
    
    -- 4. MainFrame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 400)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 1
    MainFrame.Parent = ScreenGui
    UI.MainFrame = MainFrame

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(80, 80, 80)
    MainStroke.Thickness = 1.6
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- 5. TopBar (Nagłówek)
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
        TopTitle.TextColor3 = Color3.fromRGB(180, 180, 180) 
        TopTitle.BackgroundTransparency = 1
        TopTitle.Size = UDim2.new(1, -115, 1, 0) 
        TopTitle.Position = UDim2.new(0, 10, 0, 0) 
        TopTitle.Parent = TopBar

        if config.TittlePos == "Center" then
            TopTitle.TextXAlignment = Enum.TextXAlignment.Center
            TopTitle.Position = UDim2.new(0, 0, 0, 0)
            TopTitle.Size = UDim2.new(1, 0, 1, 0)
            TopTitle.ZIndex = 4 
        else
            TopTitle.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        UI.TopTitle = TopTitle
    end

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 32)
    TopLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TopLine.BorderSizePixel = 0
    TopLine.ZIndex = 10
    TopLine.Parent = MainFrame

    -- 6. Sidebar (Menu boczne)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, -32)
    Sidebar.Position = UDim2.new(0, 0, 0, 32)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame
    UI.Sidebar = Sidebar

    local VerticalLine = Instance.new("Frame")
    VerticalLine.Size = UDim2.new(0, 1, 1, 0)
    VerticalLine.Position = UDim2.new(1, 0, 0, 0)
    VerticalLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    VerticalLine.BorderSizePixel = 0
    VerticalLine.ZIndex = 10
    VerticalLine.Parent = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = config.Name or "X HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar

    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, 0, 0, 1)
    TitleLine.Position = UDim2.new(0, 0, 0, 45)
    TitleLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TitleLine.BorderSizePixel = 0
    TitleLine.ZIndex = 10
    TitleLine.Parent = Sidebar
    
    -- 7. TabList (Kontener na zakładki)
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, -46)
    TabList.Position = UDim2.new(0, 0, 0, 46)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    TabList.ScrollBarThickness = 3
    TabList.Parent = Sidebar
    UI.TabList = TabList

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabList

    -- 8. PagesContainer (Kontener na strony)
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Size = UDim2.new(1, -200, 1, -32)
    PagesContainer.Position = UDim2.new(0, 200, 0, 32)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.ClipsDescendants = true
    PagesContainer.Parent = MainFrame
    UI.PagesContainer = PagesContainer
    
    -- 9. Controls (Przyciski kontrolne)
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
        iconImg.ImageColor3 = Color3.fromRGB(200, 200, 200)
        iconImg.Parent = btn
        
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

    -- 10. Resize Handle
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
    ResizeIcon.ImageColor3 = Color3.fromRGB(80, 80, 80)
    ResizeIcon.Parent = ResizeHandle
    Icons:Apply(ResizeIcon, "arrow-down-right")

    Interactions:MakeDraggable(TopBar, MainFrame)
    Interactions:MakeResizable(ResizeHandle, MainFrame, 600, 350)

    RunService.RenderStepped:Connect(function()
        if MainFrame.Visible then
            local offset = 35
            Shadow.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset - offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - offset)
            Shadow.Size = UDim2.new(0, MainFrame.AbsoluteSize.X + (offset * 2), 0, MainFrame.AbsoluteSize.Y + (offset * 2))
        end
        Shadow.Visible = MainFrame.Visible
    end)
    
    -- 11. Logika mobilna i przełącznik
    if isTouch then
        local MobileToggle = Instance.new("TextButton")
        MobileToggle.Name = "MobileToggle"
        MobileToggle.Size = UDim2.new(0, 55, 0, 65) 
        MobileToggle.Position = UDim2.new(0, 20, 0.5, -32)
        MobileToggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        MobileToggle.BorderSizePixel = 0
        MobileToggle.Text = ""
        MobileToggle.ZIndex = 100
        MobileToggle.Parent = ScreenGui
        UI.MobileToggle = MobileToggle

        Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(0, 10)
        local Stroke = Instance.new("UIStroke", MobileToggle)
        Stroke.Color = Color3.fromRGB(60, 60, 60)
        Stroke.Thickness = 1.5

        local MobileIcon = Instance.new("ImageLabel")
        MobileIcon.Name = "Icon"
        MobileIcon.Size = UDim2.new(0, 22, 0, 22)
        MobileIcon.Position = UDim2.new(0.5, 0, 0.4, 0)
        MobileIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        MobileIcon.BackgroundTransparency = 1
        MobileIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        MobileIcon.Parent = MobileToggle
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
        ToggleText.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleText.Parent = MobileToggle
        UI.MobileToggleText = ToggleText

        MainFrame.Visible = true -- Domyślnie otwarte

        MobileToggle.MouseButton1Click:Connect(function()
            local isVisible = MainFrame.Visible
            MainFrame.Visible = not isVisible
            Shadow.Visible = not isVisible

            if isVisible then
                ToggleText.Text = "OPEN"
                ToggleText.TextColor3 = Color3.fromRGB(100, 255, 100) -- Zielony
            else
                ToggleText.Text = "CLOSE"
                ToggleText.TextColor3 = Color3.fromRGB(255, 100, 100) -- Czerwony
            end
        end)

        Interactions:MakeDraggable(MobileToggle, MobileToggle)
    end
    
    function UI:CreateTab(name, icon)
    local Tab = {}
    
    -- 1. Przycisk zakładki (Prostokąt bez zaokrągleń, do krawędzi)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 45) -- Wysokość 45px, szerokość 100%
    TabButton.BackgroundTransparency = 1
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = #UI.Tabs + 1
    TabButton.Parent = TabList

    -- 2. BIAŁA KRESKA (Indicator) - Po lewej stronie
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 2, 1, 0) -- 1 = 100% wysokości przycisku
    Indicator.Position = UDim2.new(0, 0, 0, 0) -- Od samej góry (Y=0)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.BorderSizePixel = 0
    Indicator.BackgroundTransparency = 1 -- Ukryta domyślnie
    Indicator.ZIndex = 3
    Indicator.Parent = TabButton

    -- 3. Ikona
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Name = "Icon"
    TabIcon.Size = UDim2.new(0, 20, 0, 20)
    TabIcon.Position = UDim2.new(0, 15, 0.5, 0)
    TabIcon.AnchorPoint = Vector2.new(0, 0.5)
    TabIcon.BackgroundTransparency = 1
    TabIcon.ImageColor3 = Color3.fromRGB(160, 160, 160)
    TabIcon.Parent = TabButton
    Icons:Apply(TabIcon, icon)
    
    -- 4. Tekst (Label)
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Name = "Label"
    TabLabel.Size = UDim2.new(1, -50, 1, 0)
    TabLabel.Position = UDim2.new(0, 45, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.Text = name
    TabLabel.TextSize = 14
    TabLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    
    -- 5. Strona (Content)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.ScrollBarThickness = 0
    Page.Parent = PagesContainer

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 10)
    Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 20)
    Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 20)
    
    -- 6. Logika wyboru i animacje
    local function Select()
        if UI.SelectedTab == TabButton then return end
        
        -- Reset poprzedniej zakładki
        if UI.SelectedTab then
            local prev = UI.SelectedTab
            TweenService:Create(prev, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
            TweenService:Create(prev.Icon, TweenInfo.new(0.25), {ImageColor3 = Color3.fromRGB(160, 160, 160)}):Play()
            TweenService:Create(prev.Label, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
            TweenService:Create(prev.Indicator, TweenInfo.new(0.25), {Size = UDim2.new(0, 2, 0, 0), BackgroundTransparency = 1}):Play()
        end
        
        -- Ukryj wszystkie strony
        for _, p in pairs(UI.Pages) do p.Visible = false end
        
        -- Aktywuj nową
        Page.Visible = true
        UI.SelectedTab = TabButton
        
        -- Animacja "Xeno"
        TweenService:Create(TabButton, TweenInfo.new(0.25), {BackgroundTransparency = 0.93}):Play() -- Podświetlenie tła
        TweenService:Create(TabIcon, TweenInfo.new(0.25), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(TabLabel, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        
        -- Animacja białej kreski (Indicator)
        TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 2, 0, 22), -- Wysokość kreski
            BackgroundTransparency = 0
        }):Play()
    end

    TabButton.MouseButton1Click:Connect(Select)
    
    table.insert(UI.Tabs, TabButton)
    table.insert(UI.Pages, Page)
    
    Tab.Button = TabButton
    Tab.Page = Page
    
    if #UI.Tabs == 1 then
        task.spawn(Select)
    end
    
    return Tab
end
    
    -- Domyślna zakładka "Dashboard"
    UI:CreateTab("Dashboard", "layout-dashboard")
    UI:CreateTab("Settings", "settings")

    return UI
end

return Window