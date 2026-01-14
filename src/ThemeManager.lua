--[[
    ThemeManager
    Zarządza wyglądem wszystkich elementów GUI zgodnie z motywem "Xeno".
]]

local Theme = {}

Theme.Colors = {
    -- Główne kolory okna
    MainBackground = Color3.fromRGB(0, 0, 0),
    SidebarBackground = Color3.fromRGB(0, 0, 0),
    SecondaryPanels = Color3.fromRGB(20, 20, 20),
    
    -- Kolory tekstu
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),

    -- Kolory akcentów i ramek
    Border = Color3.fromRGB(40, 40, 40), -- Ciemnoszary stroke
    Accent = Color3.fromRGB(255, 255, 255), -- Biały wskaźnik aktywnej zakładki
    GreenBadge = Color3.fromRGB(0, 255, 100),
    
    -- Kolory stanu
    ActiveTabBackground = Color3.fromRGB(25, 25, 25),
}

Theme.Fonts = {
    -- Roblox nie ma domyślnie czcionki Gotham. Używamy SourceSans, który jest podobny.
    -- Można dodać Gotham, jeśli jest zaimportowany do gry.
    Primary = {
        Font = Enum.Font.SourceSans,
        Weight = Enum.FontWeight.Regular,
    },
    Header = {
        Font = Enum.Font.SourceSans,
        Weight = Enum.FontWeight.Bold,
    }
}

Theme.Rounding = {
    MainWindow = 10,
    InnerPanels = 8,
    Buttons = 6,
}

Theme.Sizes = {
    SidebarWidth = 200, -- 20-25% typowej szerokości okna
    WindowPadding = 20,
    ElementPadding = 10,
}

return Theme
