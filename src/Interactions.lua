local Interactions = {}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Funkcja pomocnicza do pobierania pozycji myszy/dotyku
local function getInputPos(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

function Interactions:MakeDraggable(clickObj, moveObj)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    clickObj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveObj.Position
            
            -- Rozłączenie przeciągania, gdy puścimy przycisk
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            moveObj.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Interactions:MakeResizable(handle, mainFrame, minX, minY)
    local resizing = false
    local maxX, maxY = 1200, 800 -- Opcjonalne wartości maksymalne

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            
            -- Zapamiętujemy parametry w momencie kliknięcia
            local startSize = mainFrame.AbsoluteSize
            local startPos = mainFrame.Position
            local startInputPos = input.Position
            
            local moveCon
            local endCon

            moveCon = UIS.InputChanged:Connect(function(moveInput)
                if resizing and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
                    local delta = moveInput.Position - startInputPos
                    
                    -- 1. Obliczamy nowy rozmiar z uwzględnieniem Min i Max
                    local newX = math.clamp(startSize.X + delta.X, minX, maxX)
                    local newY = math.clamp(startSize.Y + delta.Y, minY, maxY)
                    
                    -- 2. Obliczamy różnicę między nowym a starym rozmiarem
                    local diffX = newX - startSize.X
                    local diffY = newY - startSize.Y
                    
                    -- 3. KLUCZ DO SUKCESU:
                    -- Ponieważ AnchorPoint to (0.5, 0.5), zmiana rozmiaru o 'diff' 
                    -- rozszerza ramkę w obie strony. Przesuwając pozycję o połowę 'diff', 
                    -- sprawiamy, że lewy-górny róg zostaje "zablokowany".
                    
                    mainFrame.Size = UDim2.new(0, newX, 0, newY)
                    mainFrame.Position = UDim2.new(
                        startPos.X.Scale, 
                        startPos.X.Offset + (diffX / 2), 
                        startPos.Y.Scale, 
                        startPos.Y.Offset + (diffY / 2)
                    )
                end
            end)

            endCon = UIS.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    resizing = false
                    moveCon:Disconnect()
                    endCon:Disconnect()
                end
            end)
        end
    end)
end

return Interactions