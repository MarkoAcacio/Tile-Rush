local init = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

local PaletteUI = require(script.PaletteUI)


local function getUIs()
    local UITable = {}

    UITable.StarterGui = sd.StarterGui
    UITable.PlayerGui = sd.LocalPlayer:WaitForChild("PlayerGui")
    UITable.Palette = UITable.PlayerGui:WaitForChild("Palette")

    return UITable
end

function init:Init()
    local UIs = getUIs()
    sd:forceDisableResetting(UIs.StarterGui)
    PaletteUI:Init(UIs.Palette) -- Load Once Only! During in-game, just reset the UI and set visibilty to true of screengui

end

return init