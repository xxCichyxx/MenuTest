return function(options, themeManager, parent, menuConfig, saveMenuConfig)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = options.Name or "ColorPicker"
    ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)
    ColorPickerFrame.BackgroundTransparency = 1
    ColorPickerFrame.Parent = parent

    local Main = Instance.new("TextButton")
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.BackgroundColor3 = Color3.fromRGB(31, 31, 38)
    Main.Text = ""
    Main.Parent = ColorPickerFrame
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Text = options.Name or "Color Picker"
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(150, 150, 160)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Parent = Main

    local ColorPreview = Instance.new("Frame")
    ColorPreview.Size = UDim2.new(0, 40, 0, 20)
    ColorPreview.Position = UDim2.new(1, -50, 0.5, 0)
    ColorPreview.AnchorPoint = Vector2.new(0, 0.5)
    ColorPreview.Parent = Main
    Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0, 4)

    local CurrentColor = options.Color or Color3.fromRGB(255, 255, 255)
    if options.Flag and menuConfig[options.Flag] ~= nil then
        local c = menuConfig[options.Flag]
        CurrentColor = Color3.fromRGB(c[1], c[2], c[3])
    end
    ColorPreview.BackgroundColor3 = CurrentColor

    -- MODAL (Okno wyboru koloru)
    local ScreenGui = parent:FindFirstAncestorOfClass("ScreenGui")
    local Modal = Instance.new("Frame")
    Modal.Size = UDim2.new(0, 200, 0, 230)
    Modal.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Modal.Visible = false
    Modal.ZIndex = 100
    Modal.Parent = ScreenGui
    Instance.new("UICorner", Modal).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Modal).Color = Color3.fromRGB(60, 60, 60)

    -- Paleta SV (Sat/Val)
    local SVImage = Instance.new("ImageButton")
    SVImage.Size = UDim2.new(1, -20, 0, 150)
    SVImage.Position = UDim2.new(0, 10, 0, 10)
    SVImage.Image = "rbxassetid://4155801252" -- Color Wheel/Square
    SVImage.Parent = Modal

    local Picker = Instance.new("Frame")
    Picker.Size = UDim2.new(0, 10, 0, 10)
    Picker.AnchorPoint = Vector2.new(0.5, 0.5)
    Picker.BackgroundColor3 = Color3.new(1,1,1)
    Picker.Parent = SVImage
    Instance.new("UICorner", Picker).CornerRadius = UDim.new(1, 0)

    -- Suwak Hue
    local HueBar = Instance.new("ImageButton")
    HueBar.Size = UDim2.new(1, -20, 0, 20)
    HueBar.Position = UDim2.new(0, 10, 0, 170)
    HueBar.Image = "rbxassetid://3641079629" -- Hue Spectrum
    HueBar.Parent = Modal
    Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)

    local HueSlider = Instance.new("Frame")
    HueSlider.Size = UDim2.new(0, 2, 1, 0)
    HueSlider.BackgroundColor3 = Color3.new(1,1,1)
    HueSlider.Parent = HueBar

    -- Hex Input
    local HexInput = Instance.new("TextBox")
    HexInput.Size = UDim2.new(1, -20, 0, 25)
    HexInput.Position = UDim2.new(0, 10, 0, 200)
    HexInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    HexInput.TextColor3 = Color3.new(1,1,1)
    HexInput.Text = "#FFFFFF"
    HexInput.Parent = Modal
    Instance.new("UICorner", HexInput).CornerRadius = UDim.new(0, 4)

    -- Logika Kolorów
    local h, s, v = Color3.toHSV(CurrentColor)

    local function UpdateColor()
        CurrentColor = Color3.fromHSV(h, s, v)
        ColorPreview.BackgroundColor3 = CurrentColor
        SVImage.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        HexInput.Text = "#" .. CurrentColor:ToHex()

        if options.Callback then options.Callback(CurrentColor) end
        if options.Flag then
            saveMenuConfig(options.Flag, {CurrentColor.R*255, CurrentColor.G*255, CurrentColor.B*255})
        end
    end

    local draggingSV, draggingHue = false, false

    SVImage.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end
    end)
    HueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV, draggingHue = false, false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not Modal.Visible then return end
        local mouse = UserInputService:GetMouseLocation()

        if draggingSV then
            local rX = math.clamp((mouse.X - SVImage.AbsolutePosition.X) / SVImage.AbsoluteSize.X, 0, 1)
            local rY = math.clamp((mouse.Y - SVImage.AbsolutePosition.Y) / SVImage.AbsoluteSize.Y, 0, 1)
            s = rX
            v = 1 - rY
            Picker.Position = UDim2.new(s, 0, 1-v, 0)
            UpdateColor()
        end

        if draggingHue then
            local rX = math.clamp((mouse.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
            h = 1 - rX
            HueSlider.Position = UDim2.new(1-h, 0, 0, 0)
            UpdateColor()
        end
    end)

    -- Otwieranie/Zamykanie
    Main.MouseButton1Click:Connect(function()
        Modal.Visible = not Modal.Visible
        if Modal.Visible then
            local absPos = Main.AbsolutePosition
            Modal.Position = UDim2.new(0, absPos.X + 50, 0, absPos.Y)
        end
    end)

    -- Zamknij przyciskiem X (dodajmy go)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -20, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Parent = Modal
    CloseBtn.MouseButton1Click:Connect(function() Modal.Visible = false end)

    return {}
end