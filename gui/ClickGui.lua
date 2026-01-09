local ClickGui = {}

function ClickGui.CreateMenu(parentFrame)
    -- Lewy panel (Sidebar)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = parentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = Sidebar

    -- Linia oddzielająca (ta pionowa z Twojego screena)
    local Line = Instance.new("Frame")
    Line.Name = "Separator"
    Line.Position = UDim2.new(1, 0, 0, 0)
    Line.Size = UDim2.new(0, 1, 1, 0)
    Line.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Line.BorderSizePixel = 0
    Line.Parent = Sidebar

    -- Kontener na przyciski w Sidebarze
    local ButtonList = Instance.new("UIListLayout")
    ButtonList.Parent = Sidebar
    ButtonList.Padding = UDim.new(0, 5)
    ButtonList.SortOrder = Enum.SortOrder.LayoutOrder

    print("ClickGui: Sidebar utworzony.")
end

return ClickGui