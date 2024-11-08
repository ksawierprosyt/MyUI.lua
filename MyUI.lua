local MyUI = {}

-- Utility function for creating rounded corners
local function createUICorner(parent, cornerRadius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, cornerRadius)
    uiCorner.Parent = parent
end

-- Utility function to create button hover effect
local function createHoverEffect(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = defaultColor
    end)
end

-- Save and Load Config System
local function saveConfig(player, configData)
    local success, errorMessage = pcall(function()
        local dataStore = game:GetService("DataStoreService"):GetDataStore("MyUI_Config")
        dataStore:SetAsync(player.UserId, configData)
    end)
    
    if not success then
        warn("Failed to save config: " .. errorMessage)
    end
end

local function loadConfig(player)
    local success, result = pcall(function()
        local dataStore = game:GetService("DataStoreService"):GetDataStore("MyUI_Config")
        return dataStore:GetAsync(player.UserId)
    end)
    
    if success then
        return result
    else
        warn("Failed to load config.")
        return nil
    end
end

function MyUI:CreateWindow(config)
    local window = {}
    window.Title = config.Name or "Galaxy Window"

    -- Setup to store configuration (to load and save the state later)
    local player = game.Players.LocalPlayer
    local configData = loadConfig(player) or {}

    -- Main Frame
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 5
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    createUICorner(mainFrame, 15)
    mainFrame.Parent = screenGui

    -- Title Bar (Tabs)
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, 0, 0.1, 0)
    tabsFrame.Position = UDim2.new(0, 0, 0, 0)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    tabsFrame.Parent = mainFrame

    -- Toggle Tab Button
    local toggleTab = Instance.new("TextButton")
    toggleTab.Text = "Toggle"
    toggleTab.Size = UDim2.new(0.2, 0, 1, 0)
    toggleTab.Position = UDim2.new(0, 0, 0, 0)
    toggleTab.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    toggleTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(toggleTab, 10)
    toggleTab.Parent = tabsFrame

    -- Textbox Tab Button
    local textboxTab = Instance.new("TextButton")
    textboxTab.Text = "Textbox"
    textboxTab.Size = UDim2.new(0.2, 0, 1, 0)
    textboxTab.Position = UDim2.new(0.2, 0, 0, 0)
    textboxTab.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    textboxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(textboxTab, 10)
    textboxTab.Parent = tabsFrame

    -- Config Tab Setup
    local configFrame = Instance.new("Frame")
    configFrame.Size = UDim2.new(1, 0, 0.9, 0)
    configFrame.Position = UDim2.new(0, 0, 0.1, 0)
    configFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    createUICorner(configFrame, 15)
    configFrame.Parent = mainFrame

    -- Image URL Textbox
    local imageUrlTextbox = Instance.new("TextBox")
    imageUrlTextbox.Size = UDim2.new(0.8, 0, 0.1, 0)
    imageUrlTextbox.Position = UDim2.new(0.1, 0, 0.2, 0)
    imageUrlTextbox.Text = configData.imageUrl or "" 
    imageUrlTextbox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    imageUrlTextbox.TextColor3 = Color3.fromRGB(0, 0, 0)
    createUICorner(imageUrlTextbox, 10)
    imageUrlTextbox.Parent = configFrame

    -- Image URL saving logic
    imageUrlTextbox.FocusLost:Connect(function()
        local imageUrl = imageUrlTextbox.Text
        configData.imageUrl = imageUrl
        saveConfig(player, configData) -- Save image URL
    end)

    -- Toggle (Checkbox) for SaveConfig
    local saveConfigToggle = Instance.new("TextButton")
    saveConfigToggle.Text = configData.saveConfig and "Enabled" or "Disabled"
    saveConfigToggle.Size = UDim2.new(0.3, 0, 0.1, 0)
    saveConfigToggle.Position = UDim2.new(0.1, 0, 0.35, 0)
    saveConfigToggle.BackgroundColor3 = configData.saveConfig and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    saveConfigToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(saveConfigToggle, 10)
    saveConfigToggle.Parent = configFrame

    -- Toggle state saving and loading
    saveConfigToggle.MouseButton1Click:Connect(function()
        configData.saveConfig = not configData.saveConfig
        saveConfig(player, configData)
        saveConfigToggle.Text = configData.saveConfig and "Enabled" or "Disabled"
        saveConfigToggle.BackgroundColor3 = configData.saveConfig and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    -- Color Picker for text color change
    local colorPicker = Instance.new("TextButton")
    colorPicker.Text = "Pick Color"
    colorPicker.Size = UDim2.new(0.2, 0, 0.1, 0)
    colorPicker.Position = UDim2.new(0.6, 0, 0.2, 0)
    colorPicker.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    colorPicker.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(colorPicker, 10)
    colorPicker.Parent = configFrame
    colorPicker.MouseButton1Click:Connect(function()
        -- Simple color picker logic (in reality, this would be more complex)
        local newColor = Color3.fromHSV(math.random(), 1, 1)
        imageUrlTextbox.TextColor3 = newColor
    end)

    -- Slider Example (Custom Implementation)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.8, 0, 0.1, 0)
    sliderFrame.Position = UDim2.new(0.1, 0, 0.35, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderFrame.BorderSizePixel = 2
    sliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    createUICorner(sliderFrame, 15)
    sliderFrame.Parent = configFrame

    local sliderValueLabel = Instance.new("TextLabel")
    sliderValueLabel.Text = "Slider Value: 50"
    sliderValueLabel.Size = UDim2.new(1, 0, 0.2, 0)
    sliderValueLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderValueLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    sliderValueLabel.TextSize = 18
    sliderValueLabel.Parent = sliderFrame

    -- Custom slider implementation
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0.8, 0)
    slider.Position = UDim2.new(0, 0, 0.2, 0)
    slider.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    slider.Parent = sliderFrame

    local sliderThumb = Instance.new("Frame")
    sliderThumb.Size = UDim2.new(0, 20, 1, 0)
    sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    sliderThumb.Parent = slider

    local dragging = false
    sliderThumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderThumb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderThumb.InputChanged:Connect(function(input)
        if dragging then
            local mouseX = input.Position.X
            local newX = math.clamp(mouseX - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
            sliderThumb.Position = UDim2.new(0, newX, 0, 0)
            local value = math.floor((newX / slider.AbsoluteSize.X) * 100)
            sliderValueLabel.Text = "Slider Value: " .. value
        end
    end)

    return screenGui
end

return MyUI
