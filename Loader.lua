local folderName = "VisualWave"
local isfile = isfile or function(file)
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
    writefile(file, '')
end

local function downloadFile(path)
    if not isfile(path) then
        local url = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/main/" .. path
        local suc, res = pcall(function()
            return game:HttpGet(url, true)
        end)
        if not suc or res == '404: Not Found' then
            error("Failed to download file: " .. path .. "\nResponse: " .. tostring(res))
        end
        if path:find("%.lua$") then
            res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after updates.\n" .. res
        end
        writefile(path, res)
    end
    return readfile(path)
end

local function wipeFolder(path)
    if not isfolder(path) then return end
    for _, file in pairs(listfiles(path)) do
        if file:lower():find("loader") then
            continue
        end
        if isfile(file) then
            local content = readfile(file)
            if content:sub(1, 70):find("This watermark is used to delete the file") then
                delfile(file)
            end
        end
    end
end

-- Ensure folders exist
local folders = {
    folderName,
    folderName .. "/modules",
    folderName .. "/guis",
    folderName .. "/assets"
}

for _, f in pairs(folders) do
    if not isfolder(f) then
        makefolder(f)
    end
end

-- Wipe old cached files (except loader.lua)
wipeFolder(folderName)
wipeFolder(folderName .. "/modules")
wipeFolder(folderName .. "/guis")
wipeFolder(folderName .. "/assets")

-- Commit version (hardcoded or fetched)
local commit = "main"
writefile(folderName .. "/commit.txt", commit)

-- Files to download
local filesToDownload = {
    folderName .. "/MainScript.lua",
    folderName .. "/modules/Combat.lua",
    folderName .. "/guis/custom_gui.lua",
    -- Add your assets here if any, e.g.:
    -- folderName .. "/assets/image.png",
}

for _, path in pairs(filesToDownload) do
    downloadFile(path)
end

-- Load and execute MainScript.lua (the entrypoint)
local mainCode = downloadFile(folderName .. "/MainScript.lua")
local mainFunc, err = loadstring(mainCode, "MainScript.lua")
if not mainFunc then
    error("Failed to load MainScript.lua: " .. tostring(err))
end
mainFunc()
