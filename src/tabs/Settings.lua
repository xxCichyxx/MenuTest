local Settings = {}

function Settings:Render(UI, order)
    -- Tworzymy zakładkę z wymuszonym LayoutOrder (np. 999)
    local TabElements = UI:CreateTab("Settings", "settings", order or 999)
    local Page = TabElements.Page

    -- Przykładowa treść Ustawień
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "Ustawienia Menu"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Parent = Page

    -- Tutaj w przyszłości dodasz przyciski do zmiany Keybindu, motywu itp.
    local Info = Instance.new("TextLabel")
    Info.Text = "Wersja: 1.0.0 BETA"
    Info.Font = Enum.Font.Gotham
    Info.TextSize = 12
    Info.TextColor3 = Color3.fromRGB(100, 100, 100)
    Info.Size = UDim2.new(1, -40, 0, 20)
    Info.BackgroundTransparency = 1
    Info.Parent = Page
end

return Settings