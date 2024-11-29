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

function KsawierHub:CreateWindow(config)
    local window = {}
    local player = game.Players.LocalPlayer

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "KsawierHubWindow"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
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

    -- Icon (if provided)
    if config.Icon and config.Icon ~= 0 then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0.1, 0, 1, 0)
        icon.Position = UDim2.new(0.05, 0, 0, 0)
        icon.BackgroundTransparency = 1
        if type(config.Icon) == "string" then
            icon.Image = config.Icon -- Assume a Lucide Icon
        elseif type(config.Icon) == "number" then
            icon.Image = "rbxassetid://" .. config.Icon -- Roblox Image ID
        end
        icon.Parent = titleBar
    end

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

    -- Configuration Saving
    if config.ConfigurationSaving and config.ConfigurationSaving.Enabled then
        local saveFolder = config.ConfigurationSaving.FolderName or "KsawierHub"
        local saveFile = config.ConfigurationSaving.FileName or "Config"

        -- Load Configuration (if exists)
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(
                game:GetService("DataStoreService")
                    :GetDataStore(saveFolder)
                    :GetAsync(saveFile)
            )
        end)

        if success and data then
            print("Loaded Configuration:", data)
        else
            print("No previous configuration found or failed to load.")
        end
    end

    -- Discord Prompt (if enabled)
    if config.Discord and config.Discord.Enabled then
        print("Prompting Discord Join for Invite:", config.Discord.Invite)
    end

    -- Key System
    if config.KeySystem then
        local keyFrame = Instance.new("Frame")
        keyFrame.Size = UDim2.new(0.5, 0, 0.3, 0)
        keyFrame.Position = UDim2.new(0.25, 0, 0.35, 0)
        keyFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        createUICorner(keyFrame, 10)
        keyFrame.Parent = screenGui

        local keyInput = Instance.new("TextBox")
        keyInput.PlaceholderText = "Enter Key"
        keyInput.Size = UDim2.new(0.8, 0, 0.5, 0)
        keyInput.Position = UDim2.new(0.1, 0, 0.25, 0)
        keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        createUICorner(keyInput, 10)
        keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyInput.Parent = keyFrame

        local submitButton = Instance.new("TextButton")
        submitButton.Text = "Submit"
        submitButton.Size = UDim2.new(0.4, 0, 0.5, 0)
        submitButton.Position = UDim2.new(0.3, 0, 0.8, -25)
        submitButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        createUICorner(submitButton, 10)
        createHoverEffect(submitButton, Color3.fromRGB(70, 70, 70), Color3.fromRGB(90, 90, 90))
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

