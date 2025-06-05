-- VisualWave Executor Loader

local folderName = "VisualWave"
local fileName = folderName .. "/custom_gui.lua"
local rawUrl = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/gui/custom_gui.lua"

-- Check and create folder
if not isfolder(folderName) then
    makefolder(folderName)
end

-- Check if GUI file exists locally; if not, download and save
if not isfile(fileName) then
    print("Downloading GUI script...")
    local success, response = pcall(function()
        return game:HttpGet(rawUrl)
    end)

    if success and response and #response > 0 then
        writefile(fileName, response)
        print("Downloaded and saved GUI script locally.")
    else
        error("Failed to download GUI script from GitHub.")
    end
else
    print("GUI script found locally.")
end

-- Load and run the GUI script
local guiScript = readfile(fileName)
local func, loadErr = loadstring(guiScript)

if func then
    func()
else
    error("Failed to load GUI script: " .. (loadErr or "unknown error"))
end
