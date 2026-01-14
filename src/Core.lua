--[[
    Core.lua
    Główna logika biblioteki. Tworzy okno, zarządza jego stanem,
    animacjami i zakładkami.
]]

local Core = {}
Core.__index = Core

local TweenService = game:GetService("TweenService")

-- Funkcja 'konstruktora' do tworzenia nowego okna "Xeno"
function Core.new(dependencies)
    local self = setmetatable({}, Core)

    -- Rozpakowanie zależności
    self.Theme = dependencies.ThemeManager
    self.InputManager = dependencies.InputManager
    self.Options = dependencies.Options
    self.Components = {} 
    self.BASE_URL = dependencies.BASE_URL

    -- Stan okna
    self.Visible = false
    self.Tabs = {}
    self.ActiveTab = nil

    -- Inicjalizacja UI
    self:_build()

    -- Ustawienie Binda
    self.InputManager:Initialize(self.Options.Bind or Enum.KeyCode.RightShift, function()
        self:Toggle()
    end)
    
    -- Aktywuj pierwszą zakładkę po zbudowaniu
    if self.Tabs[self.Options.DefaultTab] then
         self.Tabs[self.Options.DefaultTab].Button:MouseButton1Click()
    end

    return self
end

-- Prywatna metoda do budowania interfejsu "Xeno"
function Core:_build()
    -- 1. ScreenGui i efekt rozmycia
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 0
    self.Blur.Parent = game.Lighting

    -- 2. Główny kontener
    self.MainFrame = Instance.new("CanvasGroup")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.fromScale(0.45, 0.55) -- Nowy rozmiar
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.MainFrame.GroupTransparency = 1
    self.MainFrame.Visible = false
    self.MainFrame.BackgroundColor3 = self.Theme.Colors.MainBackground
    self.MainFrame.Parent = self.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.MainWindow)
    corner.Parent = self.MainFrame
    
    local border = Instance.new("UIStroke")
    border.Color = self.Theme.Colors.Border
    border.Thickness = 1
    border.Parent = self.MainFrame

    local mainLayout = Instance.new("UIListLayout")
    mainLayout.FillDirection = Enum.FillDirection.Horizontal
    mainLayout.Parent = self.MainFrame

    -- 3. Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, self.Theme.Sizes.SidebarWidth, 1, 0)
    self.Sidebar.BackgroundColor3 = self.Theme.Colors.SidebarBackground
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 15)
    sidebarPadding.Parent = self.Sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = self.Sidebar

    -- Nagłówek w Sidebarze
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, -20, 0, 50)
    header.BackgroundTransparency = 1
    header.Parent = self.Sidebar
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    headerLayout.Parent = header
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Text = " " -- Zastąpione przez ImageLabel
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "Xeno"
    title.Font = self.Theme.Fonts.Header.Font
    title.TextSize = 24
    title.TextColor3 = self.Theme.Colors.Text
    title.Size = UDim2.new(1, -60, 1, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Kontener na zakładki
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 1, -50)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.ClipsDescendants = true
    self.TabContainer.Parent = self.Sidebar
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = self.TabContainer

    -- 4. Main Content
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -self.Theme.Sizes.SidebarWidth, 1, 0)
    self.ContentFrame.BackgroundColor3 = self.Theme.Colors.MainBackground
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame
    
    -- 5. Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(0, 80, 0, 20)
    topBar.Position = UDim2.new(1, -95, 0, 15)
    topBar.BackgroundTransparency = 1
    topBar.Parent = self.MainFrame
    local topBarLayout = Instance.new("UIListLayout")
    topBarLayout.FillDirection = Enum.FillDirection.Horizontal
    topBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    topBarLayout.Parent = topBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 20, 1, 0)
    closeBtn.Event.MouseButton1Click:Connect(function() self:Toggle() end)
    closeBtn.Parent = topBar
    
    self.InputManager:SetupDragging(self.MainFrame, self.MainFrame)

    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Metoda do tworzenia nowej zakładki w stylu "Xeno"
function Core:CreateTab(options)
    local name = options.Name
    local iconSymbol = options.Icon or " "

    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Text = "" 
    tabButton.Size = UDim2.new(1, -30, 0, 40)
    tabButton.AutoButtonColor = false
    tabButton.BackgroundColor3 = self.Theme.Colors.SidebarBackground
    tabButton.Parent = self.TabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 12)
    tabLayout.Parent = tabButton
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 15)
    tabPadding.Parent = tabButton
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, self.Theme.Rounding.Buttons)
    tabCorner.Parent = tabButton

    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.BackgroundColor3 = self.Theme.Colors.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 2
    indicator.Parent = tabButton
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Text = iconSymbol
    iconLabel.Size = UDim2.new(0, 20, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.TextColor3 = self.Theme.Colors.TextSecondary
    iconLabel.Font = self.Theme.Fonts.Primary.Font
    iconLabel.TextSize = 20
    iconLabel.Parent = tabButton
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Text = name
    textLabel.Size = UDim2.new(1, -50, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextColor3 = self.Theme.Colors.TextSecondary
    textLabel.Font = self.Theme.Fonts.Header.Font
    textLabel.TextSize = 16
    textLabel.Parent = tabButton
    
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "Content_" .. name
    contentContainer.Size = UDim2.fromScale(1, 1)
    contentContainer.Visible = false
    contentContainer.BackgroundColor3 = self.Theme.Colors.MainBackground
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = self.ContentFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, self.Theme.Sizes.ElementPadding)
    contentLayout.Parent = contentContainer
    
    local Tab = {}
    
    tabButton.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.Tabs) do
            otherTab.Container.Visible = false
            otherTab.Button.BackgroundColor3 = self.Theme.Colors.SidebarBackground
            otherTab.Indicator.Visible = false
            otherTab.Icon.TextColor3 = self.Theme.Colors.TextSecondary
            otherTab.Label.TextColor3 = self.Theme.Colors.TextSecondary
        end
        contentContainer.Visible = true
        tabButton.BackgroundColor3 = self.Theme.Colors.ActiveTabBackground
        indicator.Visible = true
        iconLabel.TextColor3 = self.Theme.Colors.Text
        textLabel.TextColor3 = self.Theme.Colors.Text
        self.ActiveTab = Tab
    end)
    
    self.Tabs[name] = { 
        Button = tabButton, 
        Container = contentContainer, 
        Indicator = indicator,
        Icon = iconLabel,
        Label = textLabel
    }
    
    if not self.ActiveTab or options.Default then
        tabButton:MouseButton1Click()
    end
    
    local function getComponent(componentName)
        if not self.Components[componentName] then
            local path = "src/Components/" .. componentName .. ".lua"
            local success, module = pcall(function()
                return loadstring(game:HttpGet(self.BASE_URL .. path))()
            end)
            if success and type(module) == "table" then
                self.Components[componentName] = module
            else
                warn("Nie udało się załadować komponentu:", componentName, module)
            end
        end
        return self.Components[componentName]
    end

    function Tab:CreateButton(options)
        local ButtonModule = getComponent("Button")
        if ButtonModule then return ButtonModule.new(contentContainer, self.Theme, options) end
    end

    function Tab:CreateToggle(options)
        local ToggleModule = getComponent("Toggle")
        if ToggleModule then return ToggleModule.new(contentContainer, self.Theme, options) end
    end

    function Tab:CreateSlider(options)
        local SliderModule = getComponent("Slider")
        if SliderModule then return SliderModule.new(contentContainer, self.Theme, options) end
    end

    return Tab
end

return Core
