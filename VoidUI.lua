local VoidUI = {}

-- Create a Screen GUI
function VoidUI:CreateWindow(settings)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = settings.Name or "VoidHubUI"
    ScreenGui.Parent = game.CoreGui

    -- Create the main frame for the window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.Parent = ScreenGui

    -- Add title text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = settings.Name or "Void Hub"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- Tabs container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, 0, 1, -30)
    TabsContainer.Position = UDim2.new(0, 0, 0, 30)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame

    -- Store tabs
    local Tabs = {}

    function Tabs:CreateTab(name)
        local TabFrame = Instance.new("Frame")
        TabFrame.Name = name
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = #Tabs == 0 -- Show first tab by default
        TabFrame.Parent = TabsContainer

        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Button"
        TabButton.Text = name
        TabButton.Size = UDim2.new(0, 100, 0, 30)
        TabButton.Position = UDim2.new(0, (#Tabs * 100), 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Parent = MainFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(TabsContainer:GetChildren()) do
                child.Visible = false
            end
            TabFrame.Visible = true
        end)

        return TabFrame
    end

    return Tabs
end

function VoidUI:CreateButton(parent, settings, callback)
    local Button = Instance.new("TextButton")
    Button.Name = settings.Name or "Button"
    Button.Text = settings.Text or "Click Me"
    Button.Size = UDim2.new(0, 200, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = parent

    Button.MouseButton1Click:Connect(function()
        callback()
    end)

    return Button
end

function VoidUI:CreateToggle(parent, settings, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Name = settings.Name or "Toggle"
    Toggle.Text = settings.Text or "Toggle"
    Toggle.Size = UDim2.new(0, 200, 0, 30)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Parent = parent

    local State = false

    Toggle.MouseButton1Click:Connect(function()
        State = not State
        Toggle.Text = settings.Text .. ": " .. (State and "ON" or "OFF")
        callback(State)
    end)

    return Toggle
end

return VoidUI

