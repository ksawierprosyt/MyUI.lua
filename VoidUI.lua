local VoidUI = {}

-- Function to create the main window
function VoidUI:CreateWindow(settings)
    -- Screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = settings.Name or "VoidHubUI"
    ScreenGui.Parent = game.CoreGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.Parent = ScreenGui

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = settings.Name or "Void Hub"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- Configuration Saving
    if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled then
        VoidUI.SaveConfig = function(filename, data)
            local folder = settings.ConfigurationSaving.FolderName or "VoidHubConfigs"
            local file = settings.ConfigurationSaving.FileName or "Config"

            if not isfolder(folder) then
                makefolder(folder)
            end
            writefile(folder .. "/" .. file, game:GetService("HttpService"):JSONEncode(data))
        end

        VoidUI.LoadConfig = function(filename)
            local folder = settings.ConfigurationSaving.FolderName or "VoidHubConfigs"
            local file = settings.ConfigurationSaving.FileName or "Config"

            if isfile(folder .. "/" .. file) then
                return game:GetService("HttpService"):JSONDecode(readfile(folder .. "/" .. file))
            end
            return {}
        end
    end

    -- Discord Prompt
    if settings.Discord and settings.Discord.Enabled then
        local success, error = pcall(function()
            request({
                Url = "http://discord.com/api/v9/invites/" .. settings.Discord.Invite,
                Method = "POST"
            })
        end)

        if not success then
            warn("Failed to send Discord invite: " .. error)
        end
    end

    -- Key System
    if settings.KeySystem then
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Size = UDim2.new(0, 300, 0, 150)
        KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        KeyFrame.Parent = ScreenGui

        local KeyBox = Instance.new("TextBox")
        KeyBox.PlaceholderText = "Enter Key"
        KeyBox.Size = UDim2.new(0.8, 0, 0.2, 0)
        KeyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
        KeyBox.Parent = KeyFrame

        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Text = "Submit"
        SubmitButton.Size = UDim2.new(0.8, 0, 0.2, 0)
        SubmitButton.Position = UDim2.new(0.1, 0, 0.7, 0)
        SubmitButton.Parent = KeyFrame

        SubmitButton.MouseButton1Click:Connect(function()
            if table.find(settings.KeySettings.Key, KeyBox.Text) then
                KeyFrame:Destroy()
                print("Key Accepted")
            else
                KeyBox.Text = "Invalid Key!"
            end
        end)
    end

    return {
        AddTab = function(tabName)
            -- Add tab functionality here
        end
    }
end

return VoidUI
