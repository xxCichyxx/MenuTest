-- main.lua
local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Library:CreateWindow(options)
    local Window = {
        Name = options.Name or "Xeno Hub",
        Active = true,
        ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    }

    -- Root ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Xeno_UI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.DisplayOrder = 100
    ScreenGui.IgnoreGuiInset = true

    -- Main Container (CanvasGroup dla idealnego znikania)
    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.fromOffset(600, 400)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5) -- Zawsze na środku
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- UI Elementy (Stylizacja)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1
    Stroke.Parent = MainFrame

    -- Pasek Boczny (Sidebar)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    -- Tytuł (Xeno Style)
    local Title = Instance.new("TextLabel")
    Title.Text = Window.Name
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar

    -- LOGIKA TOGGLE (Naprawiona)
    local function Toggle(state)
        Window.Active = state
        if Window.Active then
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                GroupTransparency = 0,
                Position = UDim2.fromScale(0.5, 0.5) -- Wymusza środek przy otwarciu
            }):Play()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                GroupTransparency = 1
            })
            t:Play()
            t.Completed:Connect(function()
                if not Window.Active then MainFrame.Visible = false end
            end)
        end
    end

    -- Bindowanie Right Shift
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Window.ToggleKey then
            Toggle(not Window.Active)
        end
    end)

    -- Funkcja tworzenia Tabu (Szkielet)
    function Window:CreateTab(name, icon)
        print("Tworzenie tabu: " .. name)
        -- Tu dodamy logikę przycisków w Sidebarze w następnym kroku
        return {} 
    end

    return Window
end

return Library