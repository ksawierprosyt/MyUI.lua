-- MyUI Framework: A modular UI library with Rayfield-inspired layout

local MyUI = {}

-- Function to create the main window
function MyUI:CreateWindow(options)
    local window = {
        Name = options.Name or "Default Window",
        Theme = options.Theme or "Dark",
        HoverEffect = options.HoverEffect or false,
        Tabs = {}
    }

    -- Function to create a tab within the window
    function window:CreateTab(name)
        local tab = {
            Name = name,
            Sections = {}
        }

        -- Function to create a section within a tab
        function tab:CreateSection(name)
            local section = {
                Name = name,
                Buttons = {},
                Sliders = {},
                ColorPickers = {},
                Toggles = {},
                Dropdowns = {}
            }

            -- Function to create a button within a section
            function section:CreateButton(label, callback, options)
                local button = {
                    Label = label,
                    Callback = callback,
                    HoverEffect = options and options.HoverEffect or false
                }
                table.insert(self.Buttons, button)
            end

            -- Function to create a slider within a section
            function section:CreateSlider(label, min, max, default, callback, options)
                local slider = {
                    Label = label,
                    Min = min,
                    Max = max,
                    Value = default,
                    Callback = callback,
                    HoverEffect = options and options.HoverEffect or false
                }
                table.insert(self.Sliders, slider)
            end

            -- Function to create a color picker within a section
            function section:CreateColorPicker(label, default, callback, options)
                local colorPicker = {
                    Label = label,
                    Color = default,
                    Callback = callback,
                    HoverEffect = options and options.HoverEffect or false
                }
                table.insert(self.ColorPickers, colorPicker)
            end

            -- Function to create a toggle within a section
            function section:CreateToggle(label, default, callback, options)
                local toggle = {
                    Label = label,
                    State = default,
                    Callback = callback,
                    HoverEffect = options and options.HoverEffect or false
                }
                table.insert(self.Toggles, toggle)
            end

            -- Function to create a dropdown within a section
            function section:CreateDropdown(label, items, callback, options)
                local dropdown = {
                    Label = label,
                    Items = items,
                    Callback = callback,
                    HoverEffect = options and options.HoverEffect or false
                }
                table.insert(self.Dropdowns, dropdown)
            end

            -- Store the section in the tab
            table.insert(tab.Sections, section)
            return section
        end

        -- Store the tab in the window
        table.insert(window.Tabs, tab)
        return tab
    end

    -- Function to close the window
    function window:Close()
        print("Closing window:", self.Name)
    end

    return window
end

-- Function to create an optional loading screen
function MyUI:CreateLoadingScreen(options)
    local loadingScreen = {
        Title = options.Title or "Loading",
        Subtitle = options.Subtitle or "",
        AnimationColor = options.AnimationColor or Color3.fromRGB(255, 255, 255)
    }

    -- Show the loading screen with animation
    function loadingScreen:Show()
        print("Showing loading screen:", self.Title)
        -- Implement loading animation here (e.g., spinner or fade-in effect)
    end

    -- Hide the loading screen
    function loadingScreen:Hide()
        print("Hiding loading screen:", self.Title)
        -- Implement hide animation here (e.g., fade-out)
    end

    return loadingScreen
end

return MyUI
