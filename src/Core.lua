local Core = {}
Core.__index = Core

function Core.new(data)
    local self = setmetatable({}, Core)
    
    self.Theme = data.Theme
    self.Input = data.Input
    self.Anims = data.Anims
    self.Options = data.Options

    -- Główny kontener
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "XenoLib"
    self.Gui.Parent = game:GetService("CoreGui")
    self.Gui.Enabled = true

    -- Main Frame (Okno)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = self.Theme.Colors.MainBackground
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui

    -- Stylizacja (UICorner i UIStroke)
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

    local list = Instance.new("UIListLayout")
    list.Parent = self.Sidebar
    list.Padding = UDim.new(0, 5)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Obsługa binda i dragu
    self.Input:Initialize(self.Options.Bind, function()
        self:Toggle()
    end)

    self.Input:SetupDragging(self.MainFrame, self.MainFrame)
    self.Anims:FadeIn(self.MainFrame)

    return self
end

-- Naprawia błąd "missing method Toggle"
function Core:Toggle()
    self.Gui.Enabled = not self.Gui.Enabled
    if self.Gui.Enabled then
        -- Centrowanie przy otwarciu
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.Anims:FadeIn(self.MainFrame)
    end
end

function Core:CreateTab(options)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 35)
    TabButton.BackgroundColor3 = self.Theme.Colors.ActiveTabBackground
    TabButton.Text = options.Icon .. " " .. options.Name
    TabButton.TextColor3 = self.Theme.Colors.Text
    TabButton.Font = self.Theme.Fonts.Primary.Font
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.Sidebar

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, self.Theme.Rounding.Buttons)
    bCorner.Parent = TabButton

    return {}
end

return Core