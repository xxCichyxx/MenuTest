local InputManager = {}
local UserInputService = game:GetService("UserInputService")

local currentBind = nil
local onBindPressed = nil

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end 

    if input.UserInputType == Enum.UserInputType.Keyboard and currentBind and input.KeyCode == currentBind then
        if onBindPressed then
            onBindPressed()
        end
    end
end)

function InputManager:Initialize(bind, callback)
    currentBind = bind
    onBindPressed = callback
end

function InputManager:SetupDragging(draggableFrame, mainFrame)
    local dragging = false
    local dragInput, dragStart, startPosition

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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

return InputManager