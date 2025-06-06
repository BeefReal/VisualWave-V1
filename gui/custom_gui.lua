-- Roblox GUI Script with Fly and Infinite Jump + Keybinds

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Load Combat module (make sure Combat.lua returns a table with Fly() and InfiniteJump() functions)
local Combat = loadstring(readfile("VisualWave/modules/Combat.lua"))()

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VisualWaveGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(1, 0, 1, 0)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "Exploit"
headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
headerLabel.TextScaled = true
headerLabel.Font = Enum.Font.GothamBold
headerLabel.Parent = header

-- Button parameters
local buttonWidth = 160
local buttonHeight = 40
local bindButtonWidth = 100
local buttonSpacing = 15
local startY = 60

-- Table to store binds: key = function name, value = keycode Enum.KeyCode
local binds = {
    Fly = nil,
    InfiniteJump = nil,
}

-- Table to store toggle states
local toggled = {
    Fly = false,
    InfiniteJump = false,
}

-- Helper to create main toggle buttons
local function createToggleButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

-- Helper to create bind buttons
local function createBindButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "BindButton"
    btn.Size = UDim2.new(0, bindButtonWidth, 0, buttonHeight)
    btn.Position = UDim2.new(0, buttonWidth + 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    btn.BorderSizePixel = 0
    btn.Text = "Bind: None"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

-- Create buttons and binds
local flyBtn = createToggleButton("Fly", startY)
local flyBindBtn = createBindButton("Fly", startY)

local infJumpBtn = createToggleButton("Inf Jump", startY + buttonHeight + buttonSpacing)
local infJumpBindBtn = createBindButton("InfiniteJump", startY + buttonHeight + buttonSpacing)

-- Update button colors based on toggle state
local function updateToggleButton(btn, toggled)
    if toggled then
        btn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    end
end

-- Toggle functionality
local function toggleFeature(featureName)
    toggled[featureName] = not toggled[featureName]

    -- Call the appropriate function from Combat module
    if featureName == "Fly" then
        Combat.Fly(toggled.Fly)
    elseif featureName == "InfiniteJump" then
        Combat.InfiniteJump(toggled.InfiniteJump)
    end

    -- Update button color
    if featureName == "Fly" then
        updateToggleButton(flyBtn, toggled.Fly)
    elseif featureName == "InfiniteJump" then
        updateToggleButton(infJumpBtn, toggled.InfiniteJump)
    end
end

-- Connect toggle buttons
flyBtn.MouseButton1Click:Connect(function()
    toggleFeature("Fly")
end)

infJumpBtn.MouseButton1Click:Connect(function()
    toggleFeature("InfiniteJump")
end)

-- Keybind setup
local bindingKeyFor = nil -- nil or feature name when waiting for input

local function isLetterKey(keyCode)
    return keyCode >= Enum.KeyCode.A and keyCode <= Enum.KeyCode.Z
end

-- When clicking the bind button, start listening for key press
local function setupBindButton(bindBtn, featureName)
    bindBtn.MouseButton1Click:Connect(function()
        bindBtn.Text = "Press a key..."
        bindingKeyFor = featureName
    end)
end

setupBindButton(flyBindBtn, "Fly")
setupBindButton(infJumpBindBtn, "InfiniteJump")

-- Listen for key input to assign binds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if bindingKeyFor then
        if input.UserInputType == Enum.UserInputType.Keyboard and isLetterKey(input.KeyCode) then
            binds[bindingKeyFor] = input.KeyCode
            if bindingKeyFor == "Fly" then
                flyBindBtn.Text = "Bind: " .. input.KeyCode.Name
            elseif bindingKeyFor == "InfiniteJump" then
                infJumpBindBtn.Text = "Bind: " .. input.KeyCode.Name
            end
            bindingKeyFor = nil
        else
            -- Not a valid key, reset bind button text
            if bindingKeyFor == "Fly" then
                flyBindBtn.Text = "Bind: None"
            elseif bindingKeyFor == "InfiniteJump" then
                infJumpBindBtn.Text = "Bind: None"
            end
            bindingKeyFor = nil
        end
    else
        -- Check if pressed key matches any bind and toggle that feature
        for featureName, keyCode in pairs(binds) do
            if keyCode == input.KeyCode then
                toggleFeature(featureName)
            end
        end
    end
end)

-- GUI toggle with RightShift
local showTween = TweenService:Create(mainFrame, 
    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 300, 0, 200), BackgroundTransparency = 0.1}
)
local hideTween = TweenService:Create(mainFrame,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
)

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

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGUI()
    end
end)

print("GUI loaded! Press Right Shift to toggle.")
