-- MyUI Framework: Modular UI system for Roblox

local MyUI = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)

-- Function to create the main window
function MyUI:CreateWindow(options)
    local window = Instance.new("Frame")
    window.Name = options.Name or "Default Window"
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.BorderSizePixel = 0
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.Parent = ScreenGui

    local title = Instance.new("TextLabel")
    title.Text = options.Name or "My UI"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.TextAlignment = Enum.TextAlignment.Center
    title.Parent = window

    -- Function to create a tab in the window
    function window:CreateTab(name)
        local tab = Instance.new("Frame")
        tab.Size = UDim2.new(1, 0, 0, 40)
        tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tab.BorderSizePixel = 0
        tab.Position = UDim2.new(0, 0, 0, 40)
        tab.Parent = window

        local tabButton = Instance.new("TextButton")
        tabButton.Text = name
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 20
        tabButton.TextAlignment = Enum.TextAlignment.Center
        tabButton.Parent = tab

        -- Handle tab click (toggle sections)
        tabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(window:GetChildren()) do
                if child:IsA("Frame") and child ~= tab then
                    child.Visible = false
                end
            end
            tab.Visible = true
        end)

        -- Create a section inside the tab
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 1, -80) -- Adjust for the title and tab button
        section.Position = UDim2.new(0, 0, 0, 80)
        section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        section.Parent = window
        section.Visible = false -- Initially hidden until tab is clicked

        -- Function to create buttons in the section
        function section:CreateButton(label, callback)
            local button = Instance.new("TextButton")
            button.Text = label
            button.Size = UDim2.new(0, 200, 0, 40)
            button.Position = UDim2.new(0.5, -100, 0, 10)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 18
            button.Parent = section

            button.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        -- Function to create sliders in the section
        function section:CreateSlider(label, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -40, 0, 60)
            sliderFrame.Position = UDim2.new(0, 20, 0, 60)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderFrame.Parent = section

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, 0, 0, 10)
            sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            sliderBar.Parent = sliderFrame

            local sliderHandle = Instance.new("Frame")
            sliderHandle.Size = UDim2.new(0, 20, 0, 20)
            sliderHandle.Position = UDim2.new(0, 0, 0, -5)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            sliderHandle.Parent = sliderBar

            -- Update slider value on drag
            local dragging = false
            sliderHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            sliderHandle.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging then
                    local pos = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                    sliderHandle.Position = UDim2.new(0, pos - sliderHandle.Size.X.Offset / 2, 0, -5)
                    local value = math.floor((pos / sliderBar.AbsoluteSize.X) * (max - min) + min)
                    callback(value)
                end
            end)

            -- Set initial slider value
            local initialPos = (default - min) / (max - min) * sliderBar.AbsoluteSize.X
            sliderHandle.Position = UDim2.new(0, initialPos - sliderHandle.Size.X.Offset / 2, 0, -5)
        end

        -- Create color picker (just a simple button for now)
        function section:CreateColorPicker(label, defaultColor, callback)
            local colorPickerButton = Instance.new("TextButton")
            colorPickerButton.Text = label
            colorPickerButton.Size = UDim2.new(0, 200, 0, 40)
            colorPickerButton.Position = UDim2.new(0.5, -100, 0, 110)
            colorPickerButton.BackgroundColor3 = defaultColor
            colorPickerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            colorPickerButton.TextSize = 18
            colorPickerButton.Parent = section

            colorPickerButton.MouseButton1Click:Connect(function()
                local newColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)) -- random color
                colorPickerButton.BackgroundColor3 = newColor
                callback(newColor)
            end)
        end

        -- Return the created section
        return section
    end

    -- Return the created window
    return window
end

-- Function to create an optional loading screen
function MyUI.CreateLoadingScreen(options)
    local loadingScreen = Instance.new("Frame")
    loadingScreen.Size = UDim2.new(1, 0, 1, 0)
    loadingScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loadingScreen.BackgroundTransparency = 0.7
    loadingScreen.Parent = ScreenGui

    local title = Instance.new("TextLabel")
    title.Text = options.Title or "Loading"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.TextAlignment = Enum.TextAlignment.Center
    title.Parent = loadingScreen

    local subtitle = Instance.new("TextLabel")
    subtitle.Text = options.Subtitle or ""
    subtitle.Size = UDim2.new(1, 0, 0, 40)
    subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitle.TextSize = 18
    subtitle.TextAlignment = Enum.TextAlignment.Center
    subtitle.Parent = loadingScreen

    -- Show the loading screen with animation
    function loadingScreen:Show()
        loadingScreen.Visible = true
    end

    -- Hide the loading screen
    function loadingScreen:Hide()
        loadingScren.Visible = false
    end

    return loadingScreen
end

return MyUI
