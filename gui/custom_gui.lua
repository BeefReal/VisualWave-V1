local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local categoryColor = Color3.fromRGB(255, 200, 100)
local panel = Instance.new("Frame")
panel.Name = "ExploitPanel"
panel.Size = UDim2.new(1, -20, 1, -20)
panel.Position = UDim2.new(0, 10, 0, 10)
panel.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
panel.BorderSizePixel = 0
panel.Parent = mainFrame

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 8)
panelCorner.Parent = panel

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = categoryColor
header.BorderSizePixel = 0
header.Parent = panel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Exploit"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = header

-- Helper to create buttons with keybinds
local function createToggleWithBind(parent, text, positionY, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 120, 0, 35)
    toggleBtn.Position = UDim2.new(0, 10, 0, positionY)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = text .. ": OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleBtn

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0, 50, 0, 35)
    bindBtn.Position = UDim2.new(0, 140, 0, positionY)
    bindBtn.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
    bindBtn.BorderSizePixel = 0
    bindBtn.Text = "Bind"
    bindBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    bindBtn.TextScaled = true
    bindBtn.Font = Enum.Font.Gotham
    bindBtn.Parent = parent

    local bindCorner = Instance.new("UICorner")
    bindCorner.CornerRadius = UDim.new(0, 6)
    bindCorner.Parent = bindBtn

    local enabled = false
    local bindKey = nil
    local awaitingBind = false

    local function updateToggleText()
        toggleBtn.Text = text .. (enabled and ": ON" or ": OFF")
        toggleBtn.BackgroundColor3 = enabled and categoryColor or Color3.fromRGB(65, 65, 75)
        toggleBtn.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 220)
    end

    local function onToggle()
        enabled = not enabled
        updateToggleText()
        callback(enabled)
    end

    toggleBtn.MouseButton1Click:Connect(onToggle)

    -- Bind button functionality
    bindBtn.MouseButton1Click:Connect(function()
        if awaitingBind then
            return
        end
        bindBtn.Text = "Press Key"
        awaitingBind = true

        local keyConn
        keyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                bindKey = input.KeyCode
                bindBtn.Text = "Bind: " .. bindKey.Name
                awaitingBind = false
                keyConn:Disconnect()
            end
        end)
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if enabled and bindKey and input.KeyCode == bindKey then
            onToggle()
        end
    end)

    updateToggleText()
end

-- Import Combat module
local Combat = require(script.Parent:WaitForChild("Combat"))

-- Setup toggles with callbacks
createToggleWithBind(panel, "Fly", 50, function(enabled)
    if enabled then
        Combat.Fly()
    else
        -- If you want to stop flying, consider implementing a stop function in Combat.Fly and call it here
        -- For now, it will just keep flying because Combat.Fly returns a stop function in the revised Combat.lua
    end
end)

createToggleWithBind(panel, "Inf Jump", 100, function(enabled)
    if enabled then
        Combat.InfiniteJump()
    else
        -- Similarly for InfiniteJump, add disconnect logic if needed
    end
end)

-- Show GUI when player presses RightControl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
