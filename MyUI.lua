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
    keyFrame.Size = UDim2.new(0.4, 0, 0.35, 0) -- Increased height for better proportions
    keyFrame.Position = UDim2.new(0.3, 0, 0.35, 0)
    keyFrame.BackgroundColor3 = selectedTheme.Background
    createUICorner(keyFrame, 15)
    addStrokeToFrame(keyFrame, selectedTheme.Accent, 2)
    keyFrame.Parent = screenGui

    local keyTitle = Instance.new("TextLabel")
    keyTitle.Text = "Enter Key"
    keyTitle.Size = UDim2.new(0.8, 0, 0.15, 0) -- Reduced height for cleaner layout
    keyTitle.Position = UDim2.new(0.1, 0, 0.1, 0)
    keyTitle.TextColor3 = selectedTheme.Text
    keyTitle.TextScaled = true
    keyTitle.Font = Enum.Font.SourceSansBold
    keyTitle.BackgroundTransparency = 1
    keyTitle.Parent = keyFrame

    local keyInput = Instance.new("TextBox")
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.Size = UDim2.new(0.8, 0, 0.2, 0) -- Reduced height for sleek input
    keyInput.Position = UDim2.new(0.1, 0, 0.3, 0) -- Positioned closer to the title
    keyInput.BackgroundColor3 = selectedTheme.Accent
    createUICorner(keyInput, 10)
    keyInput.TextColor3 = selectedTheme.Text
    keyInput.Font = Enum.Font.SourceSans
    keyInput.TextScaled = true
    keyInput.Parent = keyFrame

    local submitButton = Instance.new("TextButton")
    submitButton.Text = "Submit"
    submitButton.Size = UDim2.new(0.3, 0, 0.2, 0) -- Reduced width and height
    submitButton.Position = UDim2.new(0.35, 0, 0.6, 0) -- Centered within the frame
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

if config.LoadingScreen then
    -- Create Loading Frame
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.Position = UDim2.new(0, 0, 0, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    loadingFrame.ZIndex = 10
    loadingFrame.Visible = true
    loadingFrame.Parent = screenGui

    -- Title Label
    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Text = config.LoadingTitle or "Loading Interface"
    loadingTitle.Size = UDim2.new(0.6, 0, 0.1, 0)
    loadingTitle.Position = UDim2.new(0.2, 0, 0.35, 0)
    loadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingTitle.Font = Enum.Font.GothamBold
    loadingTitle.TextScaled = true
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.Parent = loadingFrame

    -- Subtitle Label
    local loadingSubtitle = Instance.new("TextLabel")
    loadingSubtitle.Text = config.LoadingSubtitle or "Please wait while we load..."
    loadingSubtitle.Size = UDim2.new(0.8, 0, 0.05, 0)
    loadingSubtitle.Position = UDim2.new(0.1, 0, 0.45, 0)
    loadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingSubtitle.Font = Enum.Font.Gotham
    loadingSubtitle.TextScaled = true
    loadingSubtitle.BackgroundTransparency = 1
    loadingSubtitle.Parent = loadingFrame

    -- Loading Bar Background
    local loadingBarBackground = Instance.new("Frame")
    loadingBarBackground.Size = UDim2.new(0.6, 0, 0.04, 0)
    loadingBarBackground.Position = UDim2.new(0.2, 0, 0.55, 0)
    loadingBarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    loadingBarBackground.BorderSizePixel = 0
    createUICorner(loadingBarBackground, 10)
    loadingBarBackground.Parent = loadingFrame

    -- Loading Bar (Animated)
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.Position = UDim2.new(0, 0, 0, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    loadingBar.BorderSizePixel = 0
    createUICorner(loadingBar, 10)
    loadingBar.Parent = loadingBarBackground

    -- Fade-In Animation
    loadingFrame.BackgroundTransparency = 1
    for i = 1, 0, -0.05 do
        loadingFrame.BackgroundTransparency = i
        task.wait(0.03)
    end

    -- Loading Bar Animation
    coroutine.wrap(function()
        for i = 0, 1, 0.01 do
            loadingBar.Size = UDim2.new(i, 0, 1, 0)
            task.wait(0.03)
        end
    end)()

    -- Fade-Out and Remove
    task.delay(3, function()
        for i = 0, 1, 0.05 do
            loadingFrame.BackgroundTransparency = i
            loadingTitle.TextTransparency = i
            loadingSubtitle.TextTransparency = i
            task.wait(0.03)
        end
        loadingFrame:Destroy()
    end)
end


    return window
end

return KsawierHub
