local UserInputService = game:GetService("UserInputService")

local BindManager = {}
BindManager.BindKey = Enum.KeyCode.RightShift
BindManager.IsBinding = false
BindManager.OnToggle = nil

function BindManager.Init(onToggleCallback)
    BindManager.OnToggle = onToggleCallback

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and not BindManager.IsBinding then
            if input.KeyCode == BindManager.BindKey then
                if BindManager.OnToggle then
                    BindManager.OnToggle()
                end
            end
        end
    end)
end

function BindManager.SetBind(newKey)
    if typeof(newKey) == "EnumItem" then
        BindManager.BindKey = newKey
    end
end

function BindManager.StartBinding(callback)
    BindManager.IsBinding = true
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            BindManager.BindKey = input.KeyCode
            BindManager.IsBinding = false
            if callback then callback(input.KeyCode) end
            connection:Disconnect()
        end
    end)
end

return BindManager