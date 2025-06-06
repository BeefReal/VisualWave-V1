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
        -- Add Vape-style watermark to .lua files to allow wiping
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
            -- Do not delete loader.lua itself
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

-- Make sure folders exist
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

-- Write commit.txt (if you want versioning, set manually here or fetch from github)
local commit = "main" -- or you can automate fetching commit sha if you want
writefile(folderName .. "/commit.txt", commit)

-- Explicitly download all needed files
local filesToDownload = {
    folderName .. "/MainScript.lua",
    folderName .. "/modules/Combat.lua",
    folderName .. "/guis/custom_gui.lua",
    -- Add other asset files if you have them, e.g.:
    -- folderName .. "/assets/some_image.png",
}

for _, path in pairs(filesToDownload) do
    downloadFile(path)
end

-- Finally, load and run main.lua
local mainCode = downloadFile(folderName .. "/main.lua")
local mainFunc, err = loadstring(mainCode, "main.lua")
if not mainFunc then
    error("Failed to load main.lua: " .. tostring(err))
end
mainFunc()
