-- Combat.lua

local Combat = {}

--// Fly Module
Combat.Fly = function()
    local UIS = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local flying = true
    local speed = 5
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")

    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = root

    local directions = {w = false, a = false, s = false, d = false}

    local function getVelocity()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new(0, 0, 0)
        if directions.w then moveVec += cam.CFrame.LookVector end
        if directions.s then moveVec -= cam.CFrame.LookVector end
        if directions.a then moveVec -= cam.CFrame.RightVector end
        if directions.d then moveVec += cam.CFrame.RightVector end
        if moveVec.Magnitude > 0 then
            return moveVec.Unit * speed
        else
            return Vector3.new(0, 0, 0)
        end
    end

    local inputConn = UIS.InputBegan:Connect(function(input)
        if directions[input.KeyCode.Name:lower()] ~= nil then
            directions[input.KeyCode.Name:lower()] = true
        end
    end)

    local endConn = UIS.InputEnded:Connect(function(input)
        if directions[input.KeyCode.Name:lower()] ~= nil then
            directions[input.KeyCode.Name:lower()] = false
        end
    end)

    task.spawn(function()
        while flying do
            bodyVelocity.Velocity = getVelocity()
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            task.wait()
        end
        inputConn:Disconnect()
        endConn:Disconnect()
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
    end)
end

--// Infinite Jump Module
Combat.InfiniteJump = function()
    local UIS = game:GetService("UserInputService")
    local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

    UIS.JumpRequest:Connect(function()
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end

return Combat
