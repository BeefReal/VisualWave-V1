-- Roblox GUI Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main frame (container for all panels)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 1000, 0, 500)
mainFrame.Position = UDim2.new(0.5, -500, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Add corner rounding to main frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Categories configuration
local categories = {
    {
        name = "Visual-Wave",
        color = Color3.fromRGB(255, 100, 200),
        buttons = {"Gui", "Credits", "Community", "Settings", "Keybinds", "Profiles", "Theme", "Updates", "Discord", "Website"}
    },
    {
        name = "Combat",
        color = Color3.fromRGB(255, 100, 100),
        buttons = {"Aimbot", "Triggerbot", "Auto Fire", "Recoil Control", "Silent Aim", "Hitbox Expand", "Auto Shoot", "Weapon Mods", "Damage Boost", "Infinite Ammo"}
    },
    {
        name = "Exploit", 
        color = Color3.fromRGB(255, 200, 100),
        buttons = {"Speed Hack", "No Clip", "Fly Mode", "Teleport", "Walk Speed", "Jump Power", "Infinite Jump", "Phase", "God Mode", "Anti-Kick"}
    },
    {
        name = "World",
        color = Color3.fromRGB(100, 255, 100), 
        buttons = {"X-Ray", "Fullbright", "No Fall", "Fast Break", "Auto Mine", "Reach", "Anti-Void", "Click TP", "Spawn Items", "Time Change"}
    },
    {
        name = "Render",
        color = Color3.fromRGB(150, 100, 255),
        buttons = {"ESP", "Tracers", "Glow", "Chams", "Wireframe", "Name Tags", "Health Bar", "Distance", "Box ESP", "Skeleton"}
    }
}

-- Button states storage
local buttonStates = {}

-- Animation tweens
local showTween = TweenService:Create(mainFrame, 
    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 1000, 0, 500), BackgroundTransparency = 0.1}
)

local hideTween = TweenService:Create(mainFrame,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
)

-- Create panels and buttons
for i, category in ipairs(categories) do
    -- Create panel frame
    local panel = Instance.new("Frame")
    panel.Name = category.name .. "Panel"
    panel.Size = UDim2.new(0, 190, 0, 480)
    panel.Position = UDim2.new(0, 10 + (i-1) * 200, 0, 10)
    panel.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    panel.BorderSizePixel = 0
    panel.Parent = mainFrame
    
    -- Panel corner rounding
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = panel
    
    -- Category header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = category.color
    header.BorderSizePixel = 0
    header.Parent = panel
    
    -- Header corner rounding
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    -- Fix bottom corners of header
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 8)
    headerFix.Position = UDim2.new(0, 0, 1, -8)
    headerFix.BackgroundColor3 = category.color
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    -- Category title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = category.name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = header
    
    -- Initialize button states for this category
    buttonStates[i] = {}
    
    -- Create buttons
    for j, buttonName in ipairs(category.buttons) do
        local button = Instance.new("TextButton")
        button.Name = buttonName
        button.Size = UDim2.new(1, -20, 0, 35)
        
        -- Calculate button spacing to fill the panel
        local availableHeight = 480 - 50 - 10 -- Total height - header - bottom padding
        local buttonSpacing = availableHeight / #category.buttons
        button.Position = UDim2.new(0, 10, 0, 50 + (j-1) * buttonSpacing)
        
        button.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        button.BorderSizePixel = 0
        button.Text = buttonName
        button.TextColor3 = Color3.fromRGB(220, 220, 220)
        button.TextScaled = true
        button.Font = Enum.Font.Gotham
        button.Parent = panel
        
        -- Button corner rounding
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Initialize button state
        buttonStates[i][j] = false
        
        -- Button click handler
        button.MouseButton1Click:Connect(function()
            buttonStates[i][j] = not buttonStates[i][j]
            
            if buttonStates[i][j] then
                -- Active state
                button.BackgroundColor3 = category.color
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                print(category.name .. " - " .. buttonName .. ": ON")
            else
                -- Inactive state
                button.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
                button.TextColor3 = Color3.fromRGB(220, 220, 220)
                print(category.name .. " - " .. buttonName .. ": OFF")
            end
        end)
        
        -- Hover effects
        button.MouseEnter:Connect(function()
            if not buttonStates[i][j] then
                button.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not buttonStates[i][j] then
                button.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
            end
        end)
    end
end

-- Toggle function
local function toggleGUI()
    if mainFrame.Visible then
        hideTween:Play()
        hideTween.Completed:Wait()
        mainFrame.Visible = false
    else
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.BackgroundTransparency = 1
        showTween:Play()
    end
end

-- Input handler for Right Shift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGUI()
    end
end)

-- Optional: Add a subtle drop shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ZIndex = -1
shadow.Parent = mainFrame

print("GUI loaded! Press Right Shift to toggle.")
print("Categories: Combat, Exploit, World, Render")