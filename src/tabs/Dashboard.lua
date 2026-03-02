local Dashboard = {}

function Dashboard:Render(UI, order)
    -- Tworzymy zakładkę z wymuszonym LayoutOrder
    local TabElements = UI:CreateTab("Dashboard", "layout-dashboard", order or 1)
    local Page = TabElements.Page

    -- Przykładowa treść Dashboardu
    local WelcomeText = Instance.new("TextLabel")
    WelcomeText.Name = "WelcomeText"
    WelcomeText.Text = "Witaj w XHUB!"
    WelcomeText.Font = Enum.Font.GothamBold
    WelcomeText.TextSize = 24
    WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeText.Size = UDim2.new(1, -40, 0, 50)
    WelcomeText.BackgroundTransparency = 1
    WelcomeText.Parent = Page

    local DescText = Instance.new("TextLabel")
    DescText.Name = "DescText"
    DescText.Text = "Wybierz zakładkę z menu po lewej stronie."
    DescText.Font = Enum.Font.Gotham
    DescText.TextSize = 14
    DescText.TextColor3 = Color3.fromRGB(150, 150, 150)
    DescText.Size = UDim2.new(1, -40, 0, 30)
    DescText.BackgroundTransparency = 1
    DescText.Parent = Page
end

return Dashboard