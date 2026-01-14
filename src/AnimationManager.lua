--[[
    AnimationManager
    Obsługuje płynne przejścia (Tweens) dla elementów GUI.
]]

local AnimationManager = {}
local TweenService = game:GetService("TweenService")

-- Standardowe ustawienia płynności dla Xeno
local DEFAULT_INFO = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Funkcja pojawiania się okna (Fade In + Scale)
function AnimationManager:FadeIn(frame)
    -- Ustawienia początkowe (niewidoczne i lekko mniejsze)
    frame.GroupTransparency = 1
    local originalSize = frame.Size
    frame.Size = originalSize - UDim2.new(0, 20, 0, 20)
    
    -- Jeśli ramka nie ma CanvasGroup, a chcemy płynny Fade, 
    -- warto dodać CanvasGroup lub animować tło. 
    -- Dla prostoty tutaj animujemy przezroczystość tła i elementów:
    
    local tween = TweenService:Create(frame, DEFAULT_INFO, {
        Size = originalSize,
        BackgroundTransparency = 0 -- Zakładając, że tło ma być pełne
    })
    
    -- Animowanie obramowania i cienia (jeśli istnieją)
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Transparency = 1
            TweenService:Create(child, DEFAULT_INFO, {Transparency = 0}):Play()
        end
    end

    tween:Play()
end

-- Funkcja dla przycisków (Hover effect)
function AnimationManager:Hover(element, targetColor)
    local tween = TweenService:Create(element, TweenInfo.new(0.2), {
        BackgroundColor3 = targetColor
    })
    tween:Play()
end

-- Funkcja przełączania zakładek (biały pasek akcentu)
function AnimationManager:AnimateTab(accentBar, targetPosition)
    local tween = TweenService:Create(accentBar, DEFAULT_INFO, {
        Position = targetPosition
    })
    tween:Play()
end

return AnimationManager