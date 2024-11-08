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
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Parent = screenGui

    -- Title Bar (Tabs)
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, 0, 0.1, 0)
    tabsFrame.Position = UDim2.new(0, 0, 0, 0)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabsFrame.Parent = mainFrame

    local toggleTab = Instance.new("TextButton")
    toggleTab.Text = "Toggle"
    toggleTab.Size = UDim2.new(0.2, 0, 1, 0)
    toggleTab.Position = UDim2.new(0, 0, 0, 0)
    toggleTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleTab.Parent = tabsFrame

    local textboxTab = Instance.new("TextButton")
    textboxTab.Text = "Textbox"
    textboxTab.Size = UDim2.new(0.2, 0, 1, 0)
    textboxTab.Position = UDim2.new(0.2, 0, 0, 0)
    textboxTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textboxTab.Parent = tabsFrame

    -- Config Tab Setup
    local configFrame = Instance.new("Frame")
    configFrame.Size = UDim2.new(1, 0, 0.9, 0)
    configFrame.Position = UDim2.new(0, 0, 0.1, 0)
    configFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    configFrame.Parent = mainFrame

    -- Image URL Textbox
    local imageUrlTextbox = Instance.new("TextBox")
    imageUrlTextbox.Size = UDim2.new(0.8, 0, 0.1, 0)
    imageUrlTextbox.Position = UDim2.new(0.1, 0, 0.2, 0)
    imageUrlTextbox.Text = configData.imageUrl or "" -- If saved, load it, otherwise empty
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
    colorPicker.Parent = configFrame
    colorPicker.MouseButton1Click:Connect(function()
        -- Simple color picker logic (in reality, this would be more complex)
        local newColor = Color3.fromHSV(math.random(), 1, 1)
        imageUrlTextbox.TextColor3 = newColor
    end)

    -- Slider Example
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.8, 0, 0.1, 0)
    sliderFrame.Position = UDim2.new(0.1, 0, 0.35, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderFrame.Parent = configFrame

    local sliderValueLabel = Instance.new("TextLabel")
    sliderValueLabel.Text = "Slider Value: 50"
    sliderValueLabel.Size = UDim2.new(1, 0, 0.2, 0)
    sliderValueLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderValueLabel.Parent = sliderFrame

    local slider = Instance.new("Slider")
    slider.Size = UDim2.new(1, 0, 0.8, 0)
    slider.Position = UDim2.new(0, 0, 0.2, 0)
    slider.Max = 100
    slider.Min = 0
    slider.Value = 50
    slider.Parent = sliderFrame
    slider.Changed:Connect(function()
        sliderValueLabel.Text = "Slider Value: " .. math.floor(slider.Value)
    end)

    -- Dropdown Menu
    local dropdown = Instance.new("TextButton")
    dropdown.Text = "Select Option"
    dropdown.Size = UDim2.new(0.2, 0, 0.1, 0)
    dropdown.Position = UDim2.new(0.6, 0, 0.5, 0)
    dropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    dropdown.Parent = configFrame
    dropdown.MouseButton1Click:Connect(function()
        -- Example of a simple dropdown menu
        local options = {"Option 1", "Option 2", "Option 3"}
        local menu = Instance.new("Frame")
        menu.Size = UDim2.new(0, 100, 0, #options * 30)
        menu.Position = UDim2.new(0, 0, 0, 40)
        menu.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        menu.Parent = dropdown

        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Text = option
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
            optionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            optionButton.Parent = menu
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Text = option
                menu:Destroy()
            end)
        end
    end)

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "Close"
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Parent = mainFrame
    closeButton.MouseButton1Click:Connect(function()
        saveConfig(player, configData) -- Save when the window is closed
        screenGui:Destroy() -- Close the window
    end)

    return window
end


    -- Draggable functionality
    local dragging = false
    local dragStart
    local startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleLabel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateDrag(input)
        end
    end)

    window.Gui = screenGui
    window.MainFrame = mainFrame
    window.Tabs = {}

    function window:CreateTab(name)
        local tab = {}
        tab.Name = name or "Tab"

        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tab.Name
        tabButton.Size = UDim2.new(0.2, 0, 0.08, 0)
        tabButton.Position = UDim2.new((#window.Tabs - 1) * 0.21, 0, 0.1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.BorderSizePixel = 0
        tabButton.Parent = mainFrame
        createUICorner(tabButton, 6)
        createHoverEffect(tabButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 0.8, 0)
        tabFrame.Position = UDim2.new(0, 0, 0.18, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = mainFrame

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.TabFrame.Visible = false
                t.TabButton.BorderColor3 = Color3.fromRGB(50, 50, 50)
            end
            tabFrame.Visible = true
            tabButton.BorderColor3 = Color3.fromRGB(138, 43, 226)
        end)

        tab.TabFrame = tabFrame
        tab.TabButton = tabButton
        table.insert(window.Tabs, tab)

        if #window.Tabs == 1 then
            tabFrame.Visible = true
            tabButton.BorderColor3 = Color3.fromRGB(138, 43, 226)
        end

        function tab:CreateSection(name)
            local section = {}
            section.Name = name or "Section"
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0.3, 0)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = tabFrame
            createUICorner(sectionFrame, 8)

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Text = section.Name
            sectionLabel.Size = UDim2.new(1, 0, 0.2, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionLabel.Font = Enum.Font.Gotham
            sectionLabel.TextScaled = true
            sectionLabel.Parent = sectionFrame

            section.Frame = sectionFrame

            function section:CreateButton(text, callback)
                local button = Instance.new("TextButton")
                button.Text = text or "Button"
                button.Size = UDim2.new(0.9, 0, 0.3, 0)
                button.Position = UDim2.new(0.05, 0, 0.4, 0)
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Font = Enum.Font.Gotham
                button.TextSize = 16
                button.Parent = sectionFrame
                createUICorner(button, 5)
                createHoverEffect(button, Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 130, 200))

                button.MouseButton1Click:Connect(callback)
            end

            return section
        end

        return tab
    end

    return window
end

-- Return the UI library
return MyUI
