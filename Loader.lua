local url = "https://raw.githubusercontent.com/BeefReal/VisualWave-V1/refs/heads/main/gui/custom_gui.lua"

local HttpService = game:GetService("HttpService")
local HttpEnabled, err = pcall(function()
    return game:GetService("HttpService"):GetAsync(url)
end)

if HttpEnabled then
    local scriptCode = game:GetService("HttpService"):GetAsync(url)
    loadstring(scriptCode)()
else
    warn("Failed to fetch GUI script: "..err)
end
