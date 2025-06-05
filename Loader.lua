local folderName = "VisualWave"
local workspace = game:GetService("Workspace")

if workspace:FindFirstChild(folderName) then
    print(folderName .. " folder already exists in workspace.")
else
    local folder = Instance.new("Folder")
    folder.Name = folderName
    folder.Parent = workspace
    print(folderName .. " folder created in workspace.")
end
