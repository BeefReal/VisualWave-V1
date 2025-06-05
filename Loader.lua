local Workspace = game:GetService("Workspace")

-- Create main VisualWave folder
local visualWaveFolder = Instance.new("Folder")
visualWaveFolder.Name = "VisualWave"
visualWaveFolder.Parent = Workspace

-- Create gui folder inside VisualWave
local guiFolder = Instance.new("Folder")
guiFolder.Name = "gui"
guiFolder.Parent = visualWaveFolder

-- Create modules folder inside VisualWave
local modulesFolder = Instance.new("Folder")
modulesFolder.Name = "modules"
modulesFolder.Parent = visualWaveFolder

-- Function to fetch source and create script instance
local function createScript(url, name, parent, scriptType)
    local success, source = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then
        warn("Failed to get source from URL:", url)
        return
    end
    
    local scriptInstance = Instance.new(scriptType)
    scriptInstance.Name = name
    scriptInstance.Source = source
    scriptInstance.Parent = parent
end

-- URLs
local urls = {
    gui = {
        custom_gui = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/gui/custom_gui.lua"
    },
    modules = {
        Fly = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/modules/Fly.lua",
        InfiniteJump = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/modules/InfiniteJump.lua"
    },
    main = {
        MainScript = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/MainScript.lua"
    }
}

-- Create gui scripts
for name, url in pairs(urls.gui) do
    createScript(url, name, guiFolder, "LocalScript")
end

-- Create modules scripts
for name, url in pairs(urls.modules) do
    createScript(url, name, modulesFolder, "ModuleScript")
end

-- Create main script directly under VisualWave folder
for name, url in pairs(urls.main) do
    createScript(url, name, visualWaveFolder, "LocalScript")
end

print("VisualWave scripts loaded into Workspace.")
