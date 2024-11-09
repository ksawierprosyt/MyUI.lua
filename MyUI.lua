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

-- Utility function to add a stroke to a frame
local function addStrokeToFrame(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
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
    addStrokeToFrame(mainFrame, Color3.fromRGB(0, 0, 0), 2)  -- Adding stroke
    mainFrame.Parent = screenGui

    -- Title Bar (Tabs)
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, 0, 0.1, 0)
    tabsFrame.Position = UDim2.new(0, 0, 0, 0)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    tabsFrame.Parent = mainFrame
    addStrokeToFrame(tabsFrame, Color3.fromRGB(0, 0, 0), 2)  -- Adding stroke to tab bar

    -- Toggle Tab Button
    local toggleTab = Instance.new("TextButton")
    toggleTab.Text = "Toggle"
    toggleTab.Size = UDim2.new(0.2, 0, 1, 0)
    toggleTab.Position = UDim2.new(0, 0, 0, 0)
    toggleTab.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    toggleTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(toggleTab, 10)
    createHoverEffect(toggleTab, Color3.fromRGB(200, 150, 50), Color3.fromRGB(180, 120, 40))  -- Hover effect
    toggleTab.Parent = tabsFrame

    -- Textbox Tab Button
    local textboxTab = Instance.new("TextButton")
    textboxTab.Text = "Textbox"
    textboxTab.Size = UDim2.new(0.2, 0, 1, 0)
    textboxTab.Position = UDim2.new(0.2, 0, 0, 0)
    textboxTab.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    textboxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(textboxTab, 10)
    createHoverEffect(textboxTab, Color3.fromRGB(200, 150, 50), Color3.fromRGB(180, 120, 40))  -- Hover effect
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

    -- Close Button (X)
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(closeButton, 10)
    createHoverEffect(closeButton, Color3.fromRGB(255, 0, 0), Color3.fromRGB(200, 0, 0))  -- Hover effect
    closeButton.Parent = mainFrame
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()  -- Closes the UI window when clicked
    end)

    -- Return the window object for further configuration
    return window
end

return MyUI
