local Core = {}
Core.__index = Core

function Core.new(data)
    local self = setmetatable({}, Core)
    local Theme = data.Theme
    local Input = data.Input
    local Anims = data.Anims

    -- 1. ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "XenoLib"
    self.Gui.Parent = game:GetService("CoreGui")
    self.Gui.Enabled = true

    -- 2. Główne Okno
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 650, 0, 400)
    -- Ustawiamy punkt kotwiczenia na środek (AnchorPoint)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    -- Pozycja na środku ekranu
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = Theme.Colors.MainBackground
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui

    -- Stylistyka (Corner i Stroke)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Rounding.MainWindow)
    corner.Parent = self.MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Theme.Colors.Border
    stroke.Parent = self.MainFrame

    -- Sidebar i Separator
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, 0)
    self.Sidebar.BackgroundColor3 = Theme.Colors.SidebarBackground
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(0, 1, 1, 0)
    sep.Position = UDim2.new(1, 0, 0, 0)
    sep.BackgroundColor3 = Theme.Colors.Border
    sep.Parent = self.Sidebar

    -- 3. Logika Binda i Centrowania
    Input:Initialize(data.Config.Bind, function()
        self.Gui.Enabled = not self.Gui.Enabled
        
        -- Jeśli menu się właśnie otworzyło, wyśrodkuj je i odpal animację
        if self.Gui.Enabled then
            self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Powrót na środek
            Anims:FadeIn(self.MainFrame)
        end
    end)

    -- Przeciąganie działa na MainFrame
    Input:SetupDragging(self.MainFrame, self.MainFrame)

    -- Pierwsze otwarcie
    Anims:FadeIn(self.MainFrame)

    return self
end

function Core:CreateTab(options)
    -- Logika tworzenia przycisku w Sidebar
    local Theme = self.Theme -- Zakładając, że przypisałeś Theme do self w .new
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = options.Name .. "Tab"
    TabButton.Parent = self.Sidebar
    -- Tutaj dodasz resztę wyglądu przycisku (tekst, ikona, itp.)
    
    return {}
end

return Core