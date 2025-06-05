local uis = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
_G.infiniteJump = true

uis.JumpRequest:Connect(function()
    if _G.infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
