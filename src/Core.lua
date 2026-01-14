--[[
    Core.lua
    Główna logika biblioteki. Tworzy okno, zarządza jego stanem,
    animacjami i zakładkami.
]]

local Core = {}
Core.__index = Core

local TweenService = game:GetService("TweenService")

-- Funkcja 'konstruktora' do tworzenia nowego okna
function Core.new(dependencies)
    local self = setmetatable({}, Core)

    -- Rozpakowanie zależności
    self.Theme = dependencies.ThemeManager
    self.InputManager = dependencies.InputManager
    self.Options = dependencies.Options
    self.Components = {} -- Załadujemy je później

    -- Stan okna
    self.Visible = false
    self.Tabs = {}
    self.ActiveTab = nil

    -- Inicjalizacja UI
    self:_build()

    -- Ustawienie Binda do otwierania/zamykania
    self.InputManager:Initialize(self.Options.Bind or Enum.KeyCode.RightShift, function()
        self:Toggle()
    end)
    
    return self
end

-- Prywatna metoda do budowania interfejsu
function Core:_build()
    -- 1. ScreenGui i główny kontener
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Efekt rozmycia tła (opcjonalny)
    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 0
    self.Blur.Parent = game.Lighting

    -- 2. CanvasGroup jako root - kluczowe dla animacji zanikania
    self.MainFrame = Instance.new("CanvasGroup")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.fromScale(0.4, 0.5)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.MainFrame.GroupTransparency = 1 -- Zaczynamy jako niewidoczne
    self.MainFrame.Visible = false -- Zaczynamy jako niewidoczne
    self.MainFrame.BackgroundColor3 = self.Theme.Colors.Background
    self.MainFrame.Parent = self.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.UICorner)
    corner.Parent = self.MainFrame
    
    -- Layout dla Sidebar + Content
    local mainLayout = Instance.new("UIListLayout")
    mainLayout.FillDirection = Enum.FillDirection.Horizontal
    mainLayout.Parent = self.MainFrame

    -- 3. Sidebar (pasek boczny na taby)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, self.Theme.Sizes.SidebarWidth, 1, 0)
    self.Sidebar.BackgroundColor3 = self.Theme.Colors.Primary
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, self.Theme.Sizes.ElementPadding)
    sidebarLayout.FillDirection = Enum.FillDirection.Vertical
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = self.Sidebar

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.Parent = self.Sidebar

    -- 4. Content (kontener na zawartość tabów)
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -self.Theme.Sizes.SidebarWidth, 1, 0)
    self.ContentFrame.BackgroundColor3 = self.Theme.Colors.Background
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame

    -- Ustawienie przesuwania okna
    self.InputManager:SetupDragging(self.Sidebar, self.MainFrame)

    -- Finalizacja - umieszczenie GUI w PlayerGui
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Metoda do przełączania widoczności okna
function Core:Toggle()
    self.Visible = not self.Visible
    
    local transparencyGoal = self.Visible and 0 or 1
    local blurGoal = self.Visible and 16 or 0
    
    if self.Visible then
        self.MainFrame.Visible = true
    end

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
    
    local transparencyTween = TweenService:Create(self.MainFrame, tweenInfo, { GroupTransparency = transparencyGoal })
    local blurTween = TweenService:Create(self.Blur, tweenInfo, { Size = blurGoal })
    
    transparencyTween:Play()
    blurTween:Play()
    
    transparencyTween.Completed:Connect(function()
        if not self.Visible then
            self.MainFrame.Visible = false
        end
    end)
end

-- Metoda do tworzenia nowej zakładki
function Core:CreateTab(name)
    -- Logika tworzenia przycisku w sidebarze
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Text = name
    tabButton.Size = UDim2.new(1, -20, 0, 40)
    tabButton.BackgroundColor3 = self.Theme.Colors.Secondary
    tabButton.TextColor3 = self.Theme.Colors.Text
    tabButton.Font = self.Theme.Fonts.Primary.Font
    tabButton.Parent = self.Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.UICorner)
    corner.Parent = tabButton

    -- Logika tworzenia kontenera na zawartość
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "Content_" .. name
    contentContainer.Size = UDim2.fromScale(1, 1)
    contentContainer.Visible = false -- Domyślnie ukryty
    contentContainer.BackgroundColor3 = self.Theme.Colors.Background
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = self.ContentFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, self.Theme.Sizes.ElementPadding)
    contentLayout.Parent = contentContainer

    -- Obiekt Tab, który zwrócimy
    local Tab = {}
    
    -- Przełączanie widoczności
    tabButton.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.Tabs) do
            otherTab.Container.Visible = false
            otherTab.Button.BackgroundColor3 = self.Theme.Colors.Secondary
        end
        contentContainer.Visible = true
        tabButton.BackgroundColor3 = self.Theme.Colors.Accent
        self.ActiveTab = Tab
    end)

    -- Przechowujemy referencje
    self.Tabs[name] = { Button = tabButton, Container = contentContainer }

    -- Jeśli to pierwsza zakładka, aktywuj ją
    if not self.ActiveTab then
        tabButton:MouseButton1Click()
    end
    
    -- API dla Tab
    local function loadComponent(componentName)
        if not self.Components[componentName] then
            local path = "src/Components/" .. componentName .. ".lua"
            self.Components[componentName] = loadstring(game:HttpGet(BASE_URL .. path))()
        end
        return self.Components[componentName]
    end

    function Tab:CreateButton(options)
        local ButtonModule = loadComponent("Button")
        return ButtonModule.new(contentContainer, self.Theme, options)
    end

    function Tab:CreateToggle(options)
        local ToggleModule = loadComponent("Toggle")
        return ToggleModule.new(contentContainer, self.Theme, options)
    end

    function Tab:CreateSlider(options)
        local SliderModule = loadComponent("Slider")
        return SliderModule.new(contentContainer, self.Theme, options)
    end

    return Tab
end

return Core
