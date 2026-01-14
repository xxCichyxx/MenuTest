--[[
    Component: Slider
    Tworzy suwak do wyboru wartości z danego przedziału.
]]

local Slider = {}
Slider.__index = Slider

function Slider.new(parent, theme, options)
    local self = setmetatable({}, Slider)

    self.Parent = parent
    self.Theme = theme
    self.Name = options.Name or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Callback = options.Callback or function(value) print(self.Name, "value:", value) end
    self.Value = self.Default

    self:_build()
    self:_updateVisuals((self.Value - self.Min) / (self.Max - self.Min))
    
    return self
end

function Slider:_build()
    -- Główny kontener
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name
    self.Container.Size = UDim2.new(1, -20, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Parent
    
    -- Etykieta i wartość
    self.LabelFrame = Instance.new("Frame")
    self.LabelFrame.Size = UDim2.new(1, 0, 0.5, 0)
    self.LabelFrame.BackgroundTransparency = 1
    self.LabelFrame.Parent = self.Container
    
    local labelLayout = Instance.new("UIListLayout")
    labelLayout.FillDirection = Enum.FillDirection.Horizontal
    labelLayout.Parent = self.LabelFrame
    
    self.Label = Instance.new("TextLabel")
    self.Label.Text = self.Name
    self.Label.Size = UDim2.new(0.5, 0, 1, 0)
    self.Label.BackgroundTransparency = 1
    self.Label.TextColor3 = self.Theme.Colors.Text
    self.Label.Font = self.Theme.Fonts.Primary.Font
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.LabelFrame

    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.Size = UDim2.new(0.5, 0, 1, 0)
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.TextColor3 = self.Theme.Colors.TextSecondary
    self.ValueLabel.Font = self.Theme.Fonts.Primary.Font
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.Parent = self.LabelFrame

    -- Pasek suwaka
    self.Track = Instance.new("Frame")
    self.Track.Name = "Track"
    self.Track.Size = UDim2.new(1, 0, 0.2, 0)
    self.Track.Position = UDim2.new(0, 0, 0.6, 0)
    self.Track.BackgroundColor3 = self.Theme.Colors.SecondaryPanels
    self.Track.Parent = self.Container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = self.Track
    
    self.Fill = Instance.new("Frame")
    self.Fill.Name = "Fill"
    self.Fill.Size = UDim2.fromScale(0.5, 1)
    self.Fill.BackgroundColor3 = self.Theme.Colors.GreenBadge
    self.Fill.Parent = self.Track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = self.Fill

    -- Logika przesuwania
    local function onDrag(input)
        local relativeX = math.clamp(input.Position.X - self.Track.AbsolutePosition.X, 0, self.Track.AbsoluteSize.X)
        local percentage = relativeX / self.Track.AbsoluteSize.X
        self:_updateVisuals(percentage)
    end
    
    self.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            onDrag(input) -- Aktualizuj od razu po kliknięciu
            
            local moveConn, releaseConn
            moveConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.Change then
                    onDrag(input)
                end
            end)
            releaseConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    moveConn:Disconnect()
                    releaseConn:Disconnect()
                end
            end)
        end
    end)
end

function Slider:_updateVisuals(percentage)
    self.Fill.Size = UDim2.fromScale(percentage, 1)
    
    local newValue = self.Min + (self.Max - self.Min) * percentage
    self.Value = math.floor(newValue + 0.5) -- Zaokrąglij do najbliższej liczby całkowitej
    
    self.ValueLabel.Text = tostring(self.Value)
    self.Callback(self.Value)
end

return Slider
