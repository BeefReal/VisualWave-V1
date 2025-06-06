local folderName = "VisualWave"

-- File list with destination paths and raw URLs
local files = {
    ["MainScript.lua"] = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/MainScript.lua",
    ["Loader.lua"] = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/Loader.lua",
    ["modules/Combat.lua"] = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/modules/Combat.lua",
    ["gui/custom_gui.lua"] = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/gui/custom_gui.lua",
    ["assets/Logo.png"] = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/assets/Logo.png",
}

-- Helper to check if folder exists, else create it
local function ensureFolder(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

-- Ensure all necessary folders exist
ensureFolder(folderName)
ensureFolder(folderName .. "/modules")
ensureFolder(folderName .. "/gui")
ensureFolder(folderName .. "/assets")

-- Download files if missing or outdated
for relativePath, url in pairs(files) do
    local fullPath = folderName .. "/" .. relativePath

    -- Create folder structure for file if needed
    local folderPath = fullPath:match("(.*/)")
    if folderPath then
        ensureFolder(folderPath:sub(1, -2)) -- remove trailing slash
    end

    local needsDownload = false
    if not isfile(fullPath) then
        needsDownload = true
    else
        -- Optional: Add logic here to check for updates (e.g. hash comparison)
        -- For simplicity, just keep the file if it exists
    end

    if needsDownload then
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content then
            writefile(fullPath, content)
        else
            warn("Failed to download: " .. url)
        end
    end
end

-- Run the main script
local mainScriptPath = folderName .. "/MainScript.lua"
if isfile(mainScriptPath) then
    local mainScript = readfile(mainScriptPath)
    local func, err = loadstring(mainScript)
    if func then
        func()
    else
        warn("Failed to load MainScript.lua: " .. tostring(err))
    end
else
    warn("MainScript.lua not found!")
end
