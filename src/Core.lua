local Core = {}
Core.__index = Core

-- Definicja Toggle przed konstruktorem, aby uniknąć błędu 'missing method'
function Core:Toggle()
    if not self.Gui then return end
    self.Gui.Enabled = not self.Gui.Enabled
    
    if self.Gui.Enabled then
        -- Reset pozycji na środek ekranu (wymóg: zawsze na środku)
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.Anims:FadeIn(self.MainFrame)
    end
end

function Core.new(data)
    local self = setmetatable({}, Core)
    
    -- Przypisanie modułów do obiektu self
    self.Theme = data.Theme
    self.Input = data.Input
    self.Anims = data.Anims
    
    -- Tworzenie ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "XenoLib"
    self.Gui.Parent = game:GetService("CoreGui")
    self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Główne Okno (MainFrame)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    -- AnchorPoint 0.5 zapewnia idealne centrowanie
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) 
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = self.Theme.Colors.MainBackground
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui

    -- Stylizacja Xeno
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.MainWindow)
    corner.Parent = self.MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = self.Theme.Colors.Border
    stroke.Parent = self.MainFrame

    -- Sidebar (Pasek boczny)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, self.Theme.Sizes.SidebarWidth, 1, 0)
    self.Sidebar.BackgroundColor3 = self.Theme.Colors.SidebarBackground
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame

    -- Inicjalizacja Input (Bind i Dragging)
    self.Input:Initialize(data.Config.Bind, function()
        self:Toggle()
    end)

    self.Input:SetupDragging(self.MainFrame, self.MainFrame)
    self.Anims:FadeIn(self.MainFrame)

    return self
end

function Core:CreateTab(options)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 35)
    TabButton.BackgroundColor3 = self.Theme.Colors.ActiveTabBackground
    TabButton.Text = (options.Icon or "") .. " " .. options.Name
    TabButton.TextColor3 = self.Theme.Colors.Text
    TabButton.Font = self.Theme.Fonts.Primary.Font
    TabButton.TextSize = 14
    TabButton.Parent = self.Sidebar
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, self.Theme.Rounding.Buttons)
    bCorner.Parent = TabButton

    return {}
end

return Core