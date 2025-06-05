local folderName = "VisualWave"
local workspace = game:GetService("Workspace")

-- Check if folder already exists
local folder = workspace:FindFirstChild(folderName)
if folder then
    print(folderName .. " already exists in workspace. Loading GUI...")
    if folder:FindFirstChild("CustomGUI") then
        loadstring(folder.CustomGUI.Source)()
    else
        print("GUI script not found inside " .. folderName)
    end
    return
end

-- Create folder in workspace
folder = Instance.new("Folder")
folder.Name = folderName
folder.Parent = workspace

-- Helper function to download and create ModuleScript or LocalScript
local function downloadScript(path, name, className)
    local rawUrl = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/" .. path
    print("Downloading " .. name .. " from " .. rawUrl)
    local success, result = pcall(function()
        return game:HttpGet(rawUrl)
    end)
    if success and result then
        local scriptInstance = Instance.new(className or "ModuleScript")
        scriptInstance.Name = name
        scriptInstance.Source = result
        scriptInstance.Parent = folder
        print(name .. " downloaded and created.")
        return scriptInstance
    else
        warn("Failed to download " .. name)
        return nil
    end
end

-- Download your main scripts and modules
downloadScript("gui/custom_gui.lua", "CustomGUI", "LocalScript")
downloadScript("Loader.lua", "Loader", "LocalScript")
downloadScript("MainScript.lua", "MainScript", "LocalScript")

-- Download modules folder scripts
local modules = {"Fly.lua", "InfiniteJump.lua"}
local modulesFolder = Instance.new("Folder")
modulesFolder.Name = "modules"
modulesFolder.Parent = folder

for _, moduleName in ipairs(modules) do
    local rawUrl = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/modules/" .. moduleName
    print("Downloading module " .. moduleName)
    local success, result = pcall(function()
        return game:HttpGet(rawUrl)
    end)
    if success and result then
        local moduleScript = Instance.new("ModuleScript")
        moduleScript.Name = moduleName:gsub("%.lua$", "")
        moduleScript.Source = result
        moduleScript.Parent = modulesFolder
        print(moduleName .. " module downloaded and created.")
    else
        warn("Failed to download module " .. moduleName)
    end
end

print("All files downloaded. Running GUI script...")
-- Load and run the GUI script
local guiScript = folder:FindFirstChild("CustomGUI")
if guiScript then
    loadstring(guiScript.Source)()
else
    warn("GUI script not found after downloading.")
end
