--[[
    Component: Toggle
    Tworzy przełącznik (on/off).
]]

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, theme, options)
    local self = setmetatable({}, Toggle)

    self.Parent = parent
    self.Theme = theme
    self.Name = options.Name or "Toggle"
    self.Callback = options.Callback or function(value) print(self.Name, "is now", value) end
    self.Value = options.Default or false

    self:_build()
    self:_updateVisuals()
    
    return self
end

function Toggle:_build()
    -- Główny kontener dla etykiety i przełącznika
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name
    self.Container.Size = UDim2.new(1, -20, 0, 30)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Parent
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = self.Container

    -- Etykieta
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label"
    self.Label.Text = self.Name
    self.Label.Size = UDim2.new(0.8, 0, 1, 0)
    self.Label.BackgroundTransparency = 1
    self.Label.TextColor3 = self.Theme.Colors.Text
    self.Label.Font = self.Theme.Fonts.Primary.Font
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Container
    
    -- Przycisk przełącznika
    self.Switch = Instance.new("TextButton")
    self.Switch.Name = "Switch"
    self.Switch.Size = UDim2.new(0.2, 0, 0.8, 0)
    self.Switch.Text = ""
    self.Switch.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.UICorner)
    corner.Parent = self.Switch

    -- Kółko wewnątrz przełącznika
    self.Knob = Instance.new("Frame")
    self.Knob.Size = UDim2.new(0.4, 0, 0.8, 0)
    self.Knob.Position = UDim2.fromScale(0.05, 0.1)
    self.Knob.BackgroundColor3 = Color3.new(1,1,1)
    self.Knob.BorderSizePixel = 0
    self.Knob.Parent = self.Switch
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0) -- Okrągły
    knobCorner.Parent = self.Knob
    
    -- Logika kliknięcia
    self.Switch.MouseButton1Click:Connect(function()
        self.Value = not self.Value
        self:_updateVisuals()
        self.Callback(self.Value)
    end)
end

function Toggle:_updateVisuals()
    local knobPosition = self.Value and UDim2.fromScale(0.55, 0.1) or UDim2.fromScale(0.05, 0.1)
    local switchColor = self.Value and self.Theme.Colors.Accent or self.Theme.Colors.Secondary

    self.Switch.BackgroundColor3 = switchColor
    self.Knob.Position = knobPosition
end

return Toggle
