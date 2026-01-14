local Utils = {}
local TweenService = game:GetService("TweenService")

-- Funkcja do płynnego pokazywania UI
function Utils.FadeIn(object, duration)
    object.Visible = true
    object.GroupTransparency = 1 -- Wymaga CanvasGroup dla najlepszego efektu
    local info = TweenInfo.new(duration or 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(object, info, {GroupTransparency = 0}):Play()
end

-- Funkcja do płynnego chowania UI (FadeOut)
function Utils.FadeOut(object, duration, callback)
    local info = TweenInfo.new(duration or 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, {GroupTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        object.Visible = false
        if callback then callback() end
    end)
end

-- Funkcja do skalowania (płynny "pop-up")
function Utils.PopUp(object, duration, finalSize)
    object.Size = UDim2.new(0, 0, 0, 0)
    local info = TweenInfo.new(duration or 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(object, info, {Size = finalSize}):Play()
end

return Utils