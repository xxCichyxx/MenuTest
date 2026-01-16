local Window = {}

-- Serwisy potrzebne do budowy UI
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function Window:Create(config)
    local UI = {}
    local isTouch = UserInputService.TouchEnabled or config.TestMobile

    -- 1. ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XHUB_" .. math.random(100, 999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.ScreenGui = ScreenGui

    -- 2. Shadow (Cień)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014264795"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = 0
    Shadow.Parent = ScreenGui
    UI.Shadow = Shadow

    -- 3. MainFrame (Główne okno)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    UI.MainFrame = MainFrame

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(80, 80, 80)
    MainStroke.Thickness = 1.6

    -- 4. TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 5
    TopBar.Parent = MainFrame
    UI.TopBar = TopBar

    -- 5. Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, -32)
    Sidebar.Position = UDim2.new(0, 0, 0, 32)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame
    UI.Sidebar = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = config.Name or "X HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar
    UI.Title = Title

    -- Dekoracja Sidebar
    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, 0, 0, 1)
    TitleLine.Position = UDim2.new(0, 0, 0, 45)
    TitleLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TitleLine.BorderSizePixel = 0
    TitleLine.Parent = Sidebar

    local VerticalLine = Instance.new("Frame")
    VerticalLine.Size = UDim2.new(0, 1, 1, 0)
    VerticalLine.Position = UDim2.new(1, 0, 0, 0)
    VerticalLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    VerticalLine.BorderSizePixel = 0
    VerticalLine.Parent = Sidebar

    -- 6. Przyciski Kontrolne (Min/Max/Close)
    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 105, 1, 0)
    Controls.Position = UDim2.new(1, -105, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TopBar
    UI.Controls = Controls

    -- 7. Resize Handle
    local ResizeHandle = Instance.new("TextButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 25, 0, 25)
    ResizeHandle.Position = UDim2.new(1, -25, 1, -25)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Text = ""
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = MainFrame
    UI.ResizeHandle = ResizeHandle

    -- 8. Mobile Toggle (Tylko jeśli Mobile)
    if isTouch then
        local MobileBtn = Instance.new("ImageButton")
        MobileBtn.Name = "MobileToggle"
        MobileBtn.Size = UDim2.new(0, 55, 0, 55)
        MobileBtn.Position = UDim2.new(0, 20, 0.5, -27)
        MobileBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        MobileBtn.ZIndex = 200
        MobileBtn.Parent = ScreenGui
        UI.MobileToggle = MobileBtn

        Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", MobileBtn).Color = Color3.fromRGB(100, 100, 100)

        local MText = Instance.new("TextLabel")
        MText.Size = UDim2.new(1, 0, 1, 0)
        MText.BackgroundTransparency = 1
        MText.Text = "Close"
        MText.TextColor3 = Color3.fromRGB(255, 100, 100)
        MText.Font = Enum.Font.GothamBold
        MText.TextSize = 13
        MText.ZIndex = 201
        MText.Parent = MobileBtn
        UI.MobileToggleText = MText
    end

    -- Funkcja synchronizacji cienia
    RunService.RenderStepped:Connect(function()
        if MainFrame.Visible then
            local offset = 35
            Shadow.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset - offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - offset)
            Shadow.Size = UDim2.new(0, MainFrame.AbsoluteSize.X + (offset * 2), 0, MainFrame.AbsoluteSize.Y + (offset * 2))
        end
        Shadow.Visible = MainFrame.Visible
    end)

    return UI
end

return Window