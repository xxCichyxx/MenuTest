local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Ustawienia wyglądu (Odwzorowanie obrazka Xeno)
local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(10, 10, 10),
    Accent = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham
}

function Library:CreateWindow(config)
    local Window = {
        Visible = true,
        Key = config.ToggleKey or Enum.KeyCode.RightShift
    }

    -- Root
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "Xeno_Root"
    ScreenGui.ResetOnSpawn = false

    -- Main Frame (CanvasGroup zapobiega zostawaniu elementów przy zamykaniu)
    local Main = Instance.new("CanvasGroup", ScreenGui)
    Main.Name = "MainFrame"
    Main.Size = UDim2.fromOffset(600, 400)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.fromScale(0.5, 0.5) -- Centrowanie 1 do 1
    Main.BackgroundColor3 = Theme.Main
    Main.BorderSizePixel = 0
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.Position = UDim2.fromOffset(0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0

    local Layout = Instance.new("UIListLayout", TabContainer)
    Layout.Padding = UDim.new(0, 5)

    -- Logika Zamykania/Otwierania
    local function Toggle()
        Window.Visible = not Window.Visible
        if Window.Visible then
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {GroupTransparency = 0, Size = UDim2.fromOffset(600, 400)}):Play()
        else
            local T = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {GroupTransparency = 1, Size = UDim2.fromOffset(580, 380)})
            T:Play()
            T.Completed:Connect(function() if not Window.Visible then Main.Visible = false end end)
        end
    end

    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Window.Key then Toggle() end
    end)

    -- API: Tworzenie Tabów
    function Window:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -20, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Theme.Text
        TabBtn.Font = Theme.Font
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local ElementsContainer = Instance.new("ScrollingFrame", Main)
        ElementsContainer.Size = UDim2.new(1, -180, 1, -20)
        ElementsContainer.Position = UDim2.fromOffset(170, 10)
        ElementsContainer.BackgroundTransparency = 1
        ElementsContainer.Visible = false
        
        local ELayout = Instance.new("UIListLayout", ElementsContainer)
        ELayout.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Main:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            ElementsContainer.Visible = true
        end)

        -- API: Tworzenie Przycisków w Tabie
        local TabObject = {}
        function TabObject:CreateButton(btnConfig)
            local Button = Instance.new("TextButton", ElementsContainer)
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Button.Text = btnConfig.Name
            Button.TextColor3 = Color3.new(1, 1, 1)
            Button.Font = Theme.Font
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            
            Button.MouseButton1Click:Connect(btnConfig.Callback)
        end
        
        return TabObject
    end

    return Window
end

return Library