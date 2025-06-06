local folderName = "VisualWave"
local fileName = "Loader.lua"
local rawUrl = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/Loader.lua"

if not isfolder(folderName) then
    makefolder(folderName)
end

local filePath = folderName .. "/" .. fileName

if not isfile(filePath) then
    local success, content = pcall(function()
        return game:HttpGet(rawUrl)
    end)

    if success and content then
        writefile(filePath, content)
    else
        warn("Failed to download Loader.lua")
        return
    end
end

local loaderScript = readfile(filePath)

local success, err = pcall(function()
    loadstring(loaderScript)()
end)

if not success then
    warn("Error executing Loader.lua: " .. tostring(err))
end
