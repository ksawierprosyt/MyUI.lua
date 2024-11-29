local KsawierHub = {}

local function createUICorner(parent, cornerRadius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, cornerRadius)
    uiCorner.Parent = parent
end

local function createHoverEffect(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = defaultColor
    end)
end

local function addStrokeToFrame(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
end

-- Define themes
local themes = {
    Default = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(70, 70, 70),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(50, 50, 50)
    },
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

function KsawierHub:CreateWindow(config)
    local window = {}
    local player = game.Players.LocalPlayer

    -- Select Theme
    local selectedTheme = themes[config.Theme] or themes.Default

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "KsawierHubWindow"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = selectedTheme.Background
    mainFrame.BorderSizePixel = 0
    createUICorner(mainFrame, 10)
    addStrokeToFrame(mainFrame, selectedTheme.Accent, 2)
    mainFrame.Parent = screenGui

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0.1, 0)
    titleBar.BackgroundColor3 = selectedTheme.Accent
    createUICorner(titleBar, 10)
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.Name or "KsawierHub"
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
    titleLabel.TextColor3 = selectedTheme.Text
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

    -- Key System UI
    if config.KeySystem then
        local keyFrame = Instance.new("Frame")
        keyFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
        keyFrame.Position = UDim2.new(0.3, 0, 0.35, 0)
        keyFrame.BackgroundColor3 = selectedTheme.Background
        createUICorner(keyFrame, 15)
        addStrokeToFrame(keyFrame, selectedTheme.Accent, 2)
        keyFrame.Parent = screenGui

        local keyTitle = Instance.new("TextLabel")
        keyTitle.Text = "Enter Key"
        keyTitle.Size = UDim2.new(0.8, 0, 0.2, 0)
        keyTitle.Position = UDim2.new(0.1, 0, 0.1, 0)
        keyTitle.TextColor3 = selectedTheme.Text
        keyTitle.TextScaled = true
        keyTitle.Font = Enum.Font.SourceSansBold
        keyTitle.BackgroundTransparency = 1
        keyTitle.Parent = keyFrame

        local keyInput = Instance.new("TextBox")
        keyInput.PlaceholderText = "Key"
        keyInput.Size = UDim2.new(0.8, 0, 0.25, 0)
        keyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
        keyInput.BackgroundColor3 = selectedTheme.Accent
        createUICorner(keyInput, 10)
        keyInput.TextColor3 = selectedTheme.Text
        keyInput.Font = Enum.Font.SourceSans
        keyInput.TextScaled = true
        keyInput.Parent = keyFrame

        local submitButton = Instance.new("TextButton")
        submitButton.Text = "Submit"
        submitButton.Size = UDim2.new(0.4, 0, 0.25, 0)
        submitButton.Position = UDim2.new(0.3, 0, 0.7, 0)
        submitButton.BackgroundColor3 = selectedTheme.Accent
        createUICorner(submitButton, 10)
        createHoverEffect(submitButton, selectedTheme.Accent, Color3.fromRGB(100, 100, 100))
        submitButton.TextColor3 = selectedTheme.Text
        submitButton.Font = Enum.Font.SourceSansBold
        submitButton.TextScaled = true
        submitButton.Parent = keyFrame

        submitButton.MouseButton1Click:Connect(function()
            local enteredKey = keyInput.Text
            if table.find(config.KeySettings.Key, enteredKey) then
                keyFrame:Destroy()
                print("Key Accepted!")
            else
                print("Invalid Key!")
            end
        end)
    end

    return window
end

return KsawierHub
