local folderName = "VisualWave"
local mainScriptName = "Main.lua" -- or whatever main entrypoint you want

local rawUrlBase = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/"

-- Make sure folder exists
if not isfolder(folderName) then
    makefolder(folderName)
end

local mainFilePath = folderName .. "/" .. mainScriptName

-- Download main script if missing or update logic here
if not isfile(mainFilePath) then
    local success, content = pcall(function()
        return game:HttpGet(rawUrlBase .. mainScriptName)
    end)
    if success and content then
        writefile(mainFilePath, content)
    else
        warn("Failed to download " .. mainScriptName)
        return
    end
end

local mainScript = readfile(mainFilePath)
loadstring(mainScript)()
