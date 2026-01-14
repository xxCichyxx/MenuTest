local Core = {}
Core.__index = Core

function Core.new(data)
    local self = setmetatable({}, Core)
    
    -- Zapisujemy referencje do modułów, aby CreateTab mógł z nich korzystać
    self.Theme = data.Theme
    self.Anims = data.Anims
    self.Input = data.Input
    
    -- Główne GUI
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "XenoLib"
    self.Gui.Parent = game:GetService("CoreGui")

    -- Główne Okno
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 650, 0, 400)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = self.Theme.Colors.MainBackground
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui

    -- Stylistyka
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.MainWindow)
    corner.Parent = self.MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = self.Theme.Colors.Border
    stroke.Parent = self.MainFrame

    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, self.Theme.Sizes.SidebarWidth, 1, 0)
    self.Sidebar.BackgroundColor3 = self.Theme.Colors.SidebarBackground
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame

    -- Layout dla przycisków w Sidebarze
    local layout = Instance.new("UIListLayout")
    layout.Parent = self.Sidebar
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    -- Inicjalizacja Binda i Draggingu
    self.Input:Initialize(data.Config.Bind, function()
        self.Gui.Enabled = not self.Gui.Enabled
        if self.Gui.Enabled then
            self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            self.Anims:FadeIn(self.MainFrame)
        end
    end)

    self.Input:SetupDragging(self.MainFrame, self.MainFrame)
    self.Anims:FadeIn(self.MainFrame)

    return self
end

function Core:CreateTab(options)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = options.Name .. "Tab"
    TabButton.Size = UDim2.new(1, -20, 0, 35)
    TabButton.Position = UDim2.new(0, 10, 0, 0)
    TabButton.BackgroundColor3 = self.Theme.Colors.ActiveTabBackground
    TabButton.Text = options.Icon .. "  " .. options.Name
    TabButton.TextColor3 = self.Theme.Colors.Text
    TabButton.Font = self.Theme.Fonts.Primary.Font
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.Buttons)
    corner.Parent = TabButton

    -- Efekt Hover z AnimationManagera
    TabButton.MouseEnter:Connect(function()
        self.Anims:Hover(TabButton, Color3.fromRGB(40, 40, 40))
    end)
    TabButton.MouseLeave:Connect(function()
        self.Anims:Hover(TabButton, self.Theme.Colors.ActiveTabBackground)
    end)

    return {}
end

return Core