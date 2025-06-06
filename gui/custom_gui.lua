local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local keybinds = {
    Fly = nil,
    InfJump = nil
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VisualWaveGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = mainFrame

local function createExploitButton(name, posY, activateFunc)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 140, 0, 40)
    button.Position = UDim2.new(0, 20, 0, posY)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextScaled = true
    button.Parent = mainFrame

    local bindButton = Instance.new("TextButton")
    bindButton.Size = UDim2.new(0, 80, 0, 40)
    bindButton.Position = UDim2.new(0, 170, 0, posY)
    bindButton.Text = "Bind"
    bindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    bindButton.TextColor3 = Color3.new(1,1,1)
    bindButton.Font = Enum.Font.Gotham
    bindButton.TextScaled = true
    bindButton.Parent = mainFrame

    local waitingForBind = false
    bindButton.MouseButton1Click:Connect(function()
        waitingForBind = true
        bindButton.Text = "Press key"
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if waitingForBind and input.KeyCode.Name:match("^%a$") then
            keybinds[name] = input.KeyCode
            bindButton.Text = input.KeyCode.Name
            waitingForBind = false
        elseif keybinds[name] and input.KeyCode == keybinds[name] then
            activateFunc()
        end
    end)

    button.MouseButton1Click:Connect(activateFunc)
end
