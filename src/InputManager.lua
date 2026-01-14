--[[
    InputManager
    Obsługuje globalne Bindy oraz logikę przesuwania okna (Dragging).
]]

local InputManager = {}
local UserInputService = game:GetService("UserInputService")

-- Zmienna przechowująca aktualny KeyBind i funkcję do wywołania
local currentBind = nil
local onBindPressed = nil

-- Nasłuchiwanie globalne na wciśnięcie klawisza
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Ignorujemy input, jeśli jest on używany np. do pisania na czacie

    if input.UserInputType == Enum.UserInputType.Keyboard and currentBind and input.KeyCode == currentBind then
        if onBindPressed then
            onBindPressed()
        end
    end
end)

-- Funkcja do inicjalizacji Binda, wywoływana przez Core.lua
function InputManager:Initialize(bind, callback)
    currentBind = bind
    onBindPressed = callback
end

-- Funkcja do ustawienia logiki przesuwania okna
function InputManager:SetupDragging(draggableFrame, mainFrame)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    draggableFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    draggableFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )
            end
        end
    end)
end

return InputManager
