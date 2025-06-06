local folderName = "VisualWave"

-- Base URL of your raw GitHub repo (adjust branch if needed)
local baseRawUrl = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/main/"

-- List all files you want to download, with relative paths
local filesToDownload = {
    "assets/Logo.png",
    "gui/custom_gui.lua",
    "modules/combat.lua",
    "mainScript.lua",  -- main entrypoint script (adjust name as needed)
}

-- Helper function to create nested folders if they don't exist
local function ensureFolders(path)
    local parts = {}
    for part in string.gmatch(path, "[^/]+") do
        table.insert(parts, part)
        local subPath = table.concat(parts, "/")
        if not isfolder(folderName .. "/" .. subPath) then
            makefolder(folderName .. "/" .. subPath)
        end
    end
end

-- Download each file
for _, relativePath in ipairs(filesToDownload) do
    local fullPath = folderName .. "/" .. relativePath
    
    -- Create folders if needed (only for paths with folders)
    local folderPath = relativePath:match("(.+)/[^/]+$")
    if folderPath then
        ensureFolders(folderPath)
    end
    
    -- Download the file if missing or optionally always update
    local shouldDownload = not isfile(fullPath)
    
    if shouldDownload then
        local url = baseRawUrl .. relativePath
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and content then
            writefile(fullPath, content)
            print("Downloaded " .. relativePath)
        else
            warn("Failed to download " .. relativePath)
        end
    end
end

-- Finally load and run your main script
local mainScriptPath = folderName .. "/main.lua"  -- adjust if needed
if isfile(mainScriptPath) then
    local mainScript = readfile(mainScriptPath)
    loadstring(mainScript)()
else
    warn("Main script not found: " .. mainScriptPath)
end
