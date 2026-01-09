local ClickGui = {}
local UserInputService = game:GetService("UserInputService")

-- Zmienne na moduły, które załadujemy później
local DragSystem, Animation

function ClickGui.Init(dragMod, animMod)
    DragSystem = dragMod
    Animation = animMod
end

ClickGui.CurrentBind = Enum.KeyCode.RightShift
ClickGui.Visible = true

function ClickGui.CreateMenu()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XenoMenu_Gui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("CanvasGroup") -- Używamy CanvasGroup dla FadeIn
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Parent = ScreenGui

    -- Inicjalizacja systemów
    DragSystem.Enable(MainFrame)
    Animation.FadeIn(MainFrame, 0.8)

    ClickGui.CreateSidebar(MainFrame)

    -- Toggle Menu
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ClickGui.CurrentBind then
            ClickGui.Visible = not ClickGui.Visible
            MainFrame.Visible = ClickGui.Visible
        end
    end)
end

function ClickGui.CreateSidebar(parent)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Sidebar.Parent = parent
    
    local Title = Instance.new("TextLabel")
    Title.Text = "XENO MENU"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar
end

return ClickGui