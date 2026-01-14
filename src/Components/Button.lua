--[[
    Component: Button
    Tworzy klikalny przycisk.
]]

local Button = {}
Button.__index = Button

function Button.new(parent, theme, options)
    local self = setmetatable({}, Button)

    self.Parent = parent
    self.Theme = theme
    self.Name = options.Name or "Button"
    self.Callback = options.Callback or function() end

    self:_build()
    
    return self
end

function Button:_build()
    self.Instance = Instance.new("TextButton")
    self.Instance.Name = self.Name
    self.Instance.Text = self.Name
    self.Instance.Size = UDim2.new(1, -20, 0, 30) -- -20 na padding
    self.Instance.BackgroundColor3 = self.Theme.Colors.SecondaryPanels
    self.Instance.TextColor3 = self.Theme.Colors.Text
    self.Instance.Font = self.Theme.Fonts.Primary.Font
    self.Instance.Parent = self.Parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Theme.Rounding.Buttons)
    corner.Parent = self.Instance
    
    -- Podłączenie funkcji zwrotnej (Callback)
    self.Instance.MouseButton1Click:Connect(self.Callback)
    
    -- Efekt hover
    self.Instance.MouseEnter:Connect(function()
        self.Instance.BackgroundColor3 = self.Theme.Colors.ActiveTabBackground
    end)
    
    self.Instance.MouseLeave:Connect(function()
        self.Instance.BackgroundColor3 = self.Theme.Colors.SecondaryPanels
    end)
end

return Button
