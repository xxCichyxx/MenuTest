--[[
    ThemeManager
    Zarządza wyglądem wszystkich elementów GUI.
    Dzięki temu zmiana motywu jest możliwa w jednym miejscu.
]]

local Theme = {}

Theme.Colors = {
    -- Główne kolory okna
    Background = Color3.fromRGB(30, 30, 30),      -- Ciemne tło
    Primary = Color3.fromRGB(45, 45, 45),        -- Kolor sidebar, kontenerów
    Secondary = Color3.fromRGB(60, 60, 60),      -- Kolor elementów (np. przycisków)
    
    -- Kolory akcentów i tekstu
    Accent = Color3.fromRGB(120, 120, 255),       -- Kolor podświetlenia, suwaków
    Text = Color3.fromRGB(255, 255, 255),        -- Główny kolor tekstu
    TextSecondary = Color3.fromRGB(180, 180, 180), -- Ciemniejszy tekst

    -- Kolory ramek
    Border = Color3.fromRGB(80, 80, 80),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Theme.Fonts = {
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
    UICorner = 8 -- Wartość w pikselach dla zaokrąglenia rogów
}

Theme.Sizes = {
    SidebarWidth = 150,
    WindowPadding = 10,
    ElementPadding = 5,
}

return Theme
