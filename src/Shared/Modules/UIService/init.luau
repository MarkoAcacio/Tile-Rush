local init = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

local PaletteUI = require(script.PaletteUI)
local Billboards = require(script.Billboards)
local Board = require(script.Board)


local function getUIs()
    local UITable = {}
    UITable.StarterGui = sd.StarterGui
    UITable.PlayerGui = sd.LocalPlayer:WaitForChild("PlayerGui")
    UITable.Palette = UITable.PlayerGui:WaitForChild("Palette")
    UITable.Board = UITable.PlayerGui:WaitForChild("Board")

    return UITable
end

function init:Init()
    local UIs = getUIs()
    sd:forceDisableResetting(UIs.StarterGui)
    PaletteUI:Init(UIs.Palette) -- Load Once Only! During in-game, just reset the UI and set visibilty to true of screengui
    Board:Init(UIs.Board)

    Billboards.StartTweens()
end

return init