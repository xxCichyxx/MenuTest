-- Plik: src/Interactions.lua
local Interactions = {}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function Interactions:MakeDraggable(clickObj, moveObj)
    local dragging, dragStart, startPos
    clickObj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = moveObj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            moveObj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

function Interactions:MakeResizable(handle, mainFrame, minX, minY)
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local sSize = mainFrame.AbsoluteSize
            local sMouse = UIS:GetMouseLocation()
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then connection:Disconnect() return end
                local curM = UIS:GetMouseLocation()
                local d = curM - sMouse
                mainFrame.Size = UDim2.new(0, math.max(sSize.X + d.X, minX), 0, math.max(sSize.Y + d.Y, minY))
            end)
        end
    end)
end

return Interactions