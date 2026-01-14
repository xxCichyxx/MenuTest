local Core = {}
Core.__index = Core

-- Definiujemy Toggle przed konstruktorem, aby zawsze był dostępny
function Core:Toggle()
    if not self.Gui or not self.MainFrame then return end
    self.Gui.Enabled = not self.Gui.Enabled
    if self.Gui.Enabled then
        -- Centrowanie przy otwarciu na środek ekranu
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        if self.Anims then self.Anims:FadeIn(self.MainFrame) end
    end
end

function Core.new(data)
    local self = setmetatable({}, Core)
    
    -- Sprawdzanie czy moduły dotarły
    self.Theme = data.Theme or error("Brak ThemeManager w Core!")
    self.Input = data.Input or error("Brak InputManager w Core!")
    self.Anims = data.Anims or error("Brak AnimationManager w Core!")
    
    -- Tworzenie ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "XenoLib"
    self.Gui.ResetOnSpawn = false
    self.Gui.Parent = game:GetService("CoreGui")

    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = self.Theme.Colors.MainBackground
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui

    -- UIStyle
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

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = self.Sidebar
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ContentContainer"
    self.Container.Size = UDim2.new(1, -self.Theme.Sizes.SidebarWidth, 1, 0)
    self.Container.Position = UDim2.new(0, self.Theme.Sizes.SidebarWidth, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.MainFrame

    -- Inicjalizacja sterowania (używamy Config.Bind z init.lua)
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
    TabButton.Text = (options.Icon or "") .. " " .. (options.Name or "Tab")
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