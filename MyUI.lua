-- Custom UI Library Framework
local MyUI = {}

-- Function to create a new window
function MyUI:CreateWindow(config)
    local window = {}
    window.Title = config.Name or "Untitled Window"
    window.LoadingTitle = config.LoadingTitle or "Loading"
    window.LoadingSubtitle = config.LoadingSubtitle or ""
    
    -- Create the main UI window using Roblox UI elements
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    
    screenGui.Name = window.Title
    screenGui.Parent = game.CoreGui
    mainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    mainFrame.Parent = screenGui

    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = window.Title
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Parent = mainFrame

    window.Gui = screenGui
    window.MainFrame = mainFrame
    window.Tabs = {}

    function window:CreateTab(name)
        local tab = {}
        tab.Name = name or "Tab"
        
        -- Add tab to the list of tabs in the window
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 0.8, 0)
        tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = mainFrame
        
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tab.Name
        tabButton.Size = UDim2.new(0.3, 0, 0.1, 0)
        tabButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Parent = mainFrame
        
        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.TabFrame.Visible = false
            end
            tabFrame.Visible = true
        end)

        tab.TabFrame = tabFrame
        table.insert(window.Tabs, tab)
        
        function tab:CreateSection(name)
            local section = {}
            section.Name = name or "Section"
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0.2, 0)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Parent = tabFrame

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Text = section.Name
            sectionLabel.Size = UDim2.new(1, 0, 0.2, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.TextColor3 = Color3.new(1, 1, 1)
            sectionLabel.Parent = sectionFrame

            section.Frame = sectionFrame

            function section:CreateButton(text, callback)
                local button = Instance.new("TextButton")
                button.Text = text or "Button"
                button.Size = UDim2.new(0.9, 0, 0.2, 0)
                button.BackgroundColor3 = Color3.new(0.2, 0.5, 0.8)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Parent = sectionFrame

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
