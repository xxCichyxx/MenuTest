local Core = {}
Core.__index = Core

function Core.new(data)
    local self = setmetatable({}, Core)
    
    -- Przypisanie modułów do obiektu, aby były dostępne w innych funkcjach
    self.Theme = data.Theme
    self.Input = data.Input
    self.Anims = data.Anims
    self.Tabs = {} -- Tabela na kontenery zakładek

    -- Tworzenie ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "XenoLib"
    self.Gui.Parent = game:GetService("CoreGui")
    self.Gui.Enabled = true

    -- Główne Okno (MainFrame)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Kluczowe do centrowania
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = self.Theme.Colors.MainBackground
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui

    -- Stylizacja (Rogi i Obramowanie)
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

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = self.Sidebar
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Kontener na treść (Container)
    self.Container = Instance.new("Frame")
    self.Container.Name = "ContentContainer"
    self.Container.Size = UDim2.new(1, -self.Theme.Sizes.SidebarWidth, 1, 0)
    self.Container.Position = UDim2.new(0, self.Theme.Sizes.SidebarWidth, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.MainFrame

    -- LOGIKA BINDA: Centrowanie przy każdym otwarciu
    self.Input:Initialize(data.Config.Bind, function()
        self.Gui.Enabled = not self.Gui.Enabled
        if self.Gui.Enabled then
            self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Reset na środek
            self.Anims:FadeIn(self.MainFrame)
        end
    end)

    self.Input:SetupDragging(self.MainFrame, self.MainFrame)
    self.Anims:FadeIn(self.MainFrame)

    return self
end

function Core:CreateTab(options)
    -- Przycisk w Sidebaru
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 35)
    TabButton.BackgroundColor3 = self.Theme.Colors.ActiveTabBackground
    TabButton.Text = options.Icon .. " " .. options.Name
    TabButton.TextColor3 = self.Theme.Colors.Text
    TabButton.Font = self.Theme.Fonts.Primary.Font
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.Buttons)
    corner.Parent = TabButton

    -- Kontener na elementy tej zakładki
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, -20, 1, -20)
    TabPage.Position = UDim2.new(0, 10, 0, 10)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.Parent = self.Container

    -- Proste przełączanie (na razie pierwsza zakładka staje się widoczna)
    if #self.Sidebar:GetChildren() == 2 then -- 2 bo UIListLayout to też dziecko
        TabPage.Visible = true
    end

    return {
        -- Tutaj dodamy funkcje typu AddButton
    }
end

return Core