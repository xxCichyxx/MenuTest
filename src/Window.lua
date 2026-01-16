local Window = {}

-- Serwisy
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Ładowanie modułów
local baseUrl = "https://raw.githubusercontent.com/xxCichyxx/MenuTest/refs/heads/main/src/"
local Icons = loadstring(game:HttpGet(baseUrl .. "Icons.lua"))()
local Interactions = loadstring(game:HttpGet(baseUrl .. "Interactions.lua"))()

function Window:Create(config)
    local UI = {}
    local isTouch = UserInputService.TouchEnabled or config.TestMobile
    
    -- 1. USTALANIE LOKALIZACJI I RESET STAREGO GUI
    local ProtectedLocation = nil
    local success, _ = pcall(function() ProtectedLocation = CoreGui end)
    if not success then ProtectedLocation = Players.LocalPlayer:WaitForChild("PlayerGui") end

    for _, child in pairs(ProtectedLocation:GetChildren()) do
        if child:IsA("ScreenGui") and child:FindFirstChild("XHUB_IDENTIFIER") then
            child:Destroy()
        end
    end

    local function generateName()
        local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local randomName = ""
        for i = 1, 15 do
            local rand = math.random(1, #chars)
            randomName = randomName .. string.sub(chars, rand, rand)
        end
        return randomName
    end

    -- 2. ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = generateName()
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ProtectedLocation
    UI.ScreenGui = ScreenGui

    local Tag = Instance.new("BoolValue")
    Tag.Name = "XHUB_IDENTIFIER"
    Tag.Parent = ScreenGui

    -- 3. Shadow (Cień)
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

    -- 4. MainFrame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Size = UDim2.new(0, 700, 0, 400)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 1
    MainFrame.Parent = ScreenGui
    UI.MainFrame = MainFrame

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(80, 80, 80)
    MainStroke.Thickness = 1.6
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- 5. TopBar (Nagłówek)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 5
    TopBar.Parent = MainFrame
    UI.TopBar = TopBar

    -- PRZEDZIAŁKA POZIOMA (TopLine)
    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 32)
    TopLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TopLine.BorderSizePixel = 0
    TopLine.ZIndex = 10
    TopLine.Parent = MainFrame

    -- 6. Sidebar (Menu boczne)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, -32)
    Sidebar.Position = UDim2.new(0, 0, 0, 32)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame
    UI.Sidebar = Sidebar

    -- PRZEDZIAŁKA PIONOWA (VerticalLine)
    local VerticalLine = Instance.new("Frame")
    VerticalLine.Size = UDim2.new(0, 1, 1, 0)
    VerticalLine.Position = UDim2.new(1, 0, 0, 0)
    VerticalLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    VerticalLine.BorderSizePixel = 0
    VerticalLine.ZIndex = 10
    VerticalLine.Parent = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = config.Name or "X HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar

    -- PRZEDZIAŁKA POD TYTUŁEM (TitleLine)
    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, 0, 0, 1)
    TitleLine.Position = UDim2.new(0, 0, 0, 45)
    TitleLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TitleLine.BorderSizePixel = 0
    TitleLine.ZIndex = 10
    TitleLine.Parent = Sidebar

    -- 7. Controls (Przyciski kontrolne)
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 105, 1, 0)
    Controls.Position = UDim2.new(1, -105, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.ZIndex = 6
    Controls.Parent = TopBar
    UI.Controls = Controls

    local function createIconBtn(iconName, pos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 1, 0)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = Controls
        
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 17, 0, 17) 
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.BackgroundTransparency = 1
        iconImg.ImageColor3 = Color3.fromRGB(200, 200, 200)
        iconImg.Parent = btn
        
        Icons:Apply(iconImg, iconName)
        return btn
    end

    UI.MinBtn = createIconBtn("minus", UDim2.new(0, 0, 0, 0))
    UI.MaxBtn = createIconBtn("maximize-2", UDim2.new(0, 35, 0, 0))
    UI.CloseBtn = createIconBtn("x", UDim2.new(0, 70, 0, 0))

    -- --- LOGIKA MAKSYMALIZACJI ---
    local maximized = false
    local lastSize, lastPos
    UI.MaxBtn.MouseButton1Click:Connect(function()
        if not maximized then
            lastSize = MainFrame.Size
            lastPos = MainFrame.Position
            MainFrame:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
            maximized = true
            Icons:Apply(UI.MaxBtn:FindFirstChild("Icon"), "square")
            UI.ResizeHandle.Visible = false
        else
            MainFrame:TweenSizeAndPosition(lastSize, lastPos, "Out", "Quart", 0.3, true)
            maximized = false
            Icons:Apply(UI.MaxBtn:FindFirstChild("Icon"), "maximize-2")
            UI.ResizeHandle.Visible = true
        end
    end)

    -- 8. Resize Handle
    local ResizeHandle = Instance.new("TextButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 25, 0, 25)
    ResizeHandle.Position = UDim2.new(1, -25, 1, -25)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Text = ""
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = MainFrame
    UI.ResizeHandle = ResizeHandle

    local ResizeIcon = Instance.new("ImageLabel")
    ResizeIcon.Name = "Icon"
    ResizeIcon.Size = UDim2.new(0, 15, 0, 15)
    ResizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    ResizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    ResizeIcon.BackgroundTransparency = 1
    ResizeIcon.ImageColor3 = Color3.fromRGB(80, 80, 80)
    ResizeIcon.Parent = ResizeHandle
    Icons:Apply(ResizeIcon, "arrow-down-right")

    -- --- AKTYWACJA INTERAKCJI ---
    Interactions:MakeDraggable(TopBar, MainFrame)
    Interactions:MakeResizable(ResizeHandle, MainFrame, 600, 350)

    -- Synchronizacja Cienia
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