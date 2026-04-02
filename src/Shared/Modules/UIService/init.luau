local init = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

local PaletteUI = require(script.PaletteUI)

function init:Init()
    print("Starting UIService")
    PaletteUI:Init()

end

return init