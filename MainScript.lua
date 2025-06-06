local folderName = "VisualWave"

local function loadModule(path)
    local content = readfile(path)
    local func = loadstring(content, path)
    return func and func()
end

local Combat = loadModule(folderName .. "/modules/Combat.lua")
local Gui = loadModule(folderName .. "/guis/custom_gui.lua")

-- Initialize your GUI and Combat here:
Gui.Setup()       -- (example, your actual GUI function)
Combat.Fly()      -- or hook buttons to Combat functions

print("VisualWave fully loaded!")
