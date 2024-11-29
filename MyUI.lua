local KsawierHub = {}

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

-- Function to create a window
function KsawierHub:CreateWindow(config)
    local window = {}
    local player = game.Players.LocalPlayer

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "KsawierHubWindow"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0) -- Adjust as needed
    mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    createUICorner(mainFrame, 10)
    addStrokeToFrame(mainFrame, Color3.fromRGB(0, 0, 0), 2)
    mainFrame.Parent = screenGui

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0.1, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    createUICorner(titleBar, 10)
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.Name or "KsawierHub"
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = titleBar

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.1, 0, 1, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(closeButton, 10)
    createHoverEffect(closeButton, Color3.fromRGB(200, 50, 50), Color3.fromRGB(170, 0, 0))
    closeButton.Parent = titleBar
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0.9, 0)
    contentFrame.Position = UDim2.new(0, 0, 0.1, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    createUICorner(contentFrame, 10)
    contentFrame.Parent = mainFrame

    -- Add tabs/buttons based on the config
    if config.Tabs then
        for index, tabName in ipairs(config.Tabs) do
            local tabButton = Instance.new("TextButton")
            tabButton.Text = tabName
            tabButton.Size = UDim2.new(0.2, 0, 0.1, 0)
            tabButton.Position = UDim2.new(0.2 * (index - 1), 0, 0, 0)
            tabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            createUICorner(tabButton, 10)
            createHoverEffect(tabButton, Color3.fromRGB(100, 100, 100), Color3.fromRGB(80, 80, 80))
            tabButton.Parent = contentFrame

            -- Tab switching logic (Add frames for each tab here)
            tabButton.MouseButton1Click:Connect(function()
                print("Tab clicked: " .. tabName)
                -- You can implement logic to show/hide frames based on the tab clicked
            end)
        end
    end

    -- Return the window object for further customization
    return window
end

return KsawierHub
