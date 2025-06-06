local folderName = "VisualWave"

local isfile = isfile or function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
    writefile(file, '')
end

local function downloadFile(path, func)
    if not isfile(path) then
        local rawCommit = 'main' -- fallback commit
        if isfile(folderName..'/profiles/commit.txt') then
            rawCommit = readfile(folderName..'/profiles/commit.txt')
        end

        local url = 'https://raw.githubusercontent.com/BeefReal/VisualWave-V1/'..rawCommit..'/'..path
        local suc, res = pcall(function()
            return game:HttpGet(url, true)
        end)
        if not suc or res == '404: Not Found' then
            error("Failed to download "..path..": "..tostring(res))
        end

        -- Add watermark only to Lua scripts (optional)
        if path:find('%.lua$') then
            res = '--VisualWave cache watermark - remove to keep file after update\n' .. res
        end

        -- Make sure folder exists before writing file
        local folderPath = path:match("(.+)/[^/]+$")
        if folderPath and not isfolder(folderPath) then
            makefolder(folderPath)
        end

        writefile(path, res)
    end
    return (func or readfile)(path)
end

local function wipeFolder(path)
    if not isfolder(path) then return end
    for _, file in ipairs(listfiles(path)) do
        -- skip loader itself (case-insensitive)
        if not file:lower():find('loader') then
            if isfile(file) then
                local content = readfile(file)
                if content:find('--VisualWave cache watermark') then
                    delfile(file)
                end
            end
        end
    end
end

-- Ensure folders exist
local folders = {
    folderName,
    folderName .. '/assets',
    folderName .. '/guis',
    folderName .. '/modules',
    folderName .. '/profiles',
    folderName .. '/libraries',
}

for _, f in ipairs(folders) do
    if not isfolder(f) then
        makefolder(f)
    end
end

if not shared.VisualWaveDeveloper then
    local suc, webContent = pcall(function()
        return game:HttpGet('https://github.com/BeefReal/VisualWave-V1', true)
    end)

    -- Try to extract commit hash from GitHub page source (simple heuristic)
    local commit = webContent and webContent:match('currentOid":"([a-f0-9]+)"') or nil
    commit = (commit and #commit == 40 and commit) or 'main'

    local cachedCommit = isfile(folderName..'/profiles/commit.txt') and readfile(folderName..'/profiles/commit.txt') or ''

    if commit == 'main' or cachedCommit ~= commit then
        wipeFolder(folderName)
        wipeFolder(folderName .. '/assets')
        wipeFolder(folderName .. '/guis')
        wipeFolder(folderName .. '/modules')
        wipeFolder(folderName .. '/libraries')
    end

    writefile(folderName..'/profiles/commit.txt', commit)
end

-- Load the main script
return loadstring(downloadFile(folderName..'/main.lua'), 'main.lua')()
