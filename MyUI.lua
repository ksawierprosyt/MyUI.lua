-- Improved Custom UI Library Framework
local MyUI = {}

-- Utility function for creating rounded corners
local function createUICorner(parent, cornerRadius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, cornerRadius)
    uiCorner.Parent = parent
end

-- Function to create a new window
function MyUI:CreateWindow(config)
    local window = {}
    window.Title = config.Name or "Untitled Window"

    -- Create the main UI window
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local shadowFrame = Instance.new("Frame") -- Shadow effect for main frame

    -- Window Styling
    screenGui.Name = window.Title
    screenGui.Parent = game.CoreGui

    -- Loading Animation
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 100, 0, 100)
    loadingFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    loadingFrame.Parent = screenGui
    createUICorner(loadingFrame, 8)

    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "Loading..."
    loadingText.Size = UDim2.new(1, 0, 1, 0)
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.Font = Enum.Font.GothamBold
    loadingText.TextScaled = true
    loadingText.Parent = loadingFrame

    -- Animate loading by fading out
    task.wait(1)
    for i = 1, 10 do
        loadingFrame.BackgroundTransparency = loadingFrame.BackgroundTransparency + 0.1
        task.wait(0.05)
    end
    loadingFrame:Destroy()

    -- Set up shadow and main frame for window
    shadowFrame.Size = UDim2.new(0.32, 0, 0.52, 0)
    shadowFrame.Position = UDim2.new(0.34, 0, 0.24, 0)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.5
    shadowFrame.BorderSizePixel = 0
    shadowFrame.Parent = screenGui

    mainFrame.Size = UDim2.new(1, -8, 1, -8)
    mainFrame.Position = UDim2.new(0, 4, 0, 4)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = shadowFrame
    createUICorner(mainFrame, 10)

    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = window.Title
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.Parent = mainFrame

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    window.Gui = screenGui
    window.MainFrame = mainFrame
    window.Tabs = {}

    -- Function to create a new tab
    function window:CreateTab(name)
        local tab = {}
        tab.Name = name or "Tab"

        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tab.Name
        tabButton.Size = UDim2.new(0.2, 0, 0.08, 0)
        tabButton.Position = UDim2.new(#window.Tabs * 0.21, 0, 0.1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.BorderSizePixel = 0
        tabButton.Parent = mainFrame
        createUICorner(tabButton, 6)

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 0.8, 0)
        tabFrame.Position = UDim2.new(0, 0, 0.18, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = mainFrame

        -- Show the tab's content on button click
        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.TabFrame.Visible = false
            end
            tabFrame.Visible = true
        end)

        tab.TabFrame = tabFrame
        table.insert(window.Tabs, tab)

        -- Function to create a new section in the tab
        function tab:CreateSection(name)
            local section = {}
            section.Name = name or "Section"
            
            -- Section Frame
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0.3, 0)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

            -- Function to create a button in the section
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
                button.BorderSizePixel = 0
                createUICorner(button, 6)

                -- Add a hover effect for the button
                button.MouseEnter:Connect(function()
                    button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
                end)
                button.MouseLeave:Connect(function()
                    button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                end)

                button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
            end

            return section
        end

        return tab
    end

    function window:Destroy()
        if screenGui then
            screenGui:Destroy()
        end
    end

    return window
end

return MyUI
