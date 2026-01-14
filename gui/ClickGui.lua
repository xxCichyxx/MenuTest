-- gui/ClickGui.lua
-- Moduł ClickGui zorientowany obiektowo.

local ClickGui = {}
ClickGui.__index = ClickGui

-- Zależności (wstrzykiwane, aby kod był bardziej modularny)
local TweenService = game:GetService("TweenService")
local animation
local drag

--[[
    Konstruktor obiektu ClickGui.
    @param animModule - moduł do animacji
    @param dragModule - moduł do przeciągania
    @return instancja ClickGui
]]
function ClickGui.new(animModule, dragModule)
    local self = setmetatable({}, ClickGui)
    
    -- Wstrzyknięcie zależności
    animation = animModule
    drag = dragModule
    
    self.isOpen = false
    self.gui = nil
    
    return self
end

--[[
    Przełącza widoczność GUI.
]]
function ClickGui:toggle()
    self.isOpen = not self.isOpen
    if self.isOpen then
        self:open()
    else
        self:close()
    end
end

--[[
    Otwiera GUI z animacją.
]]
function ClickGui:open()
    -- Reset pozycji i widoczności
    self.gui.ScreenGui.Enabled = true
    self.gui.MainFrame.Visible = true
    self.gui.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.gui.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Animacja
    animation.FadeIn(self.gui.MainFrame, 0.3)
end

--[[
    Zamyka GUI z animacją.
]]
function ClickGui:close()
    -- Kluczowe: animacja dzieje się na CanvasGroup, więc wszystkie dzieci znikają razem z nim.
    -- Po zakończeniu animacji, główny kontener jest wyłączany.
    animation.FadeOut(self.gui.MainFrame, 0.3, function()
        self.gui.ScreenGui.Enabled = false
    end)
end

--[[
    Prywatna metoda do tworzenia szkieletu UI.
    @return tabela z elementami UI
]]
function ClickGui:_createUI()
    local gui = {}

    gui.ScreenGui = Instance.new("ScreenGui")
    gui.ScreenGui.Name = "ClickGui"
    gui.ScreenGui.ResetOnSpawn = false
    gui.ScreenGui.Parent = game:GetService("CoreGui")
    gui.ScreenGui.Enabled = false -- Domyślnie wyłączone

    gui.MainFrame = Instance.new("CanvasGroup")
    gui.MainFrame.Name = "MainFrame"
    gui.MainFrame.Size = UDim2.new(0, 500, 0, 350)
    gui.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    gui.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    gui.MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    gui.MainFrame.Parent = gui.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = gui.MainFrame

    gui.TopBar = Instance.new("Frame")
    gui.TopBar.Name = "TopBar"
    gui.TopBar.Size = UDim2.new(1, 0, 0, 40)
    gui.TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    gui.TopBar.Parent = gui.MainFrame
    
    local topCorner = corner:Clone()
    topCorner.Parent = gui.TopBar

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "Your Menu"
    title.Font = Enum.Font.SourceSansBold
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 18
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.fromOffset(10, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = gui.TopBar
    
    gui.ContentFrame = Instance.new("Frame")
    gui.ContentFrame.Name = "Content"
    gui.ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    gui.ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    gui.ContentFrame.BackgroundTransparency = 1
    gui.ContentFrame.Parent = gui.MainFrame
    
    return gui
end

return ClickGui
