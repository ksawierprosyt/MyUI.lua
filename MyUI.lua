-- MyUI Library for Roblox with additional features
local MyUI = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI Utility Functions
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function createUIStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color
    stroke.Parent = parent
end

-- Create a Loading Screen
function MyUI:ShowLoadingScreen(text, duration)
    local LoadingScreen = Instance.new("ScreenGui")
    local LoadingFrame = Instance.new("Frame")
    local LoadingLabel = Instance.new("TextLabel")

    LoadingScreen.Name = "LoadingScreen"
    LoadingScreen.Parent = playerGui
    LoadingScreen.ResetOnSpawn = false

    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = LoadingScreen
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    createUICorner(LoadingFrame, 10)

    LoadingLabel.Name = "LoadingLabel"
    LoadingLabel.Parent = LoadingFrame
    LoadingLabel.Text = text or "Loading..."
    LoadingLabel.Font = Enum.Font.SourceSansBold
    LoadingLabel.TextSize = 24
    LoadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)

    wait(duration or 2)
    LoadingScreen:Destroy()
end

-- Key System Function
function MyUI:KeySystem(requiredKey)
    local KeyScreen = Instance.new("ScreenGui")
    local KeyFrame = Instance.new("Frame")
    local KeyInput = Instance.new("TextBox")
    local KeyButton = Instance.new("TextButton")
    local ErrorLabel = Instance.new("TextLabel")

    KeyScreen.Name = "KeySystem"
    KeyScreen.Parent = playerGui
    KeyScreen.ResetOnSpawn = false

    KeyFrame.Name = "KeyFrame"
    KeyFrame.Parent = KeyScreen
    KeyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    KeyFrame.Size = UDim2.new(0, 300, 0, 150)
    createUICorner(KeyFrame, 10)
    createUIStroke(KeyFrame, 2, Color3.fromRGB(255, 255, 255))

    KeyInput.Name = "KeyInput"
    KeyInput.Parent = KeyFrame
    KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    KeyInput.Size = UDim2.new(0, 200, 0, 30)
    KeyInput.Position = UDim2.new(0.5, -100, 0.3, 0)
    KeyInput.Font = Enum.Font.SourceSans
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.TextSize = 18
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(KeyInput, 5)

    KeyButton.Name = "KeyButton"
    KeyButton.Parent = KeyFrame
    KeyButton.Size = UDim2.new(0, 100, 0, 30)
    KeyButton.Position = UDim2.new(0.5, -50, 0.6, 0)
    KeyButton.Text = "Submit"
    KeyButton.Font = Enum.Font.SourceSansBold
    KeyButton.TextSize = 18
    KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    createUICorner(KeyButton, 5)
    createUIStroke(KeyButton, 1, Color3.fromRGB(100, 100, 255))

    ErrorLabel.Name = "ErrorLabel"
    ErrorLabel.Parent = KeyFrame
    ErrorLabel.Text = ""
    ErrorLabel.Font = Enum.Font.SourceSansBold
    ErrorLabel.TextSize = 16
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    ErrorLabel.Position = UDim2.new(0.5, 0, 0.9, 0)
    ErrorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ErrorLabel.Visible = false

    KeyButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == requiredKey then
            KeyScreen:Destroy()
        else
            ErrorLabel.Text = "Invalid Key!"
            ErrorLabel.Visible = true
        end
    end)
end

-- Create the main UI window
function MyUI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")

    ScreenGui.Name = "MyUI"
    ScreenGui.Parent = playerGui
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    createUICorner(MainFrame, 10)
    createUIStroke(MainFrame, 2, Color3.fromRGB(100, 100, 255))

    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = MainFrame
    TitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = title or "MyUI"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 20
    createUICorner(TitleLabel, 10)

    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame

    return self
end

-- Add a new tab to the UI
function MyUI:AddTab(name)
    local TabButton = Instance.new("TextButton")

    TabButton.Name = name .. "TabButton"
    TabButton.Parent = self.MainFrame
    TabButton.Size = UDim2.new(0, 100, 0, 30)
    TabButton.Position = UDim2.new(0, (#self.MainFrame:GetChildren() - 1) * 110, 0, 50)
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 18
    TabButton.Text = name
    createUICorner(TabButton, 5)
    createUIStroke(TabButton, 1, Color3.fromRGB(150, 150, 255))

    TabButton.MouseButton1Click:Connect(function()
        print(name .. " tab selected.")
        -- Add tab switch functionality here
    end)

    return TabButton
end

-- Add a button to the specified tab
function MyUI:AddButton(tab, buttonName, callback)
    local Button = Instance.new("TextButton")

    Button.Name = buttonName .. "Button"
    Button.Parent = tab
    Button.Size = UDim2.new(0, 120, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.Text = buttonName
    createUICorner(Button, 5)
    createUIStroke(Button, 1, Color3.fromRGB(100, 100, 255))

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return Button
end

return MyUI
