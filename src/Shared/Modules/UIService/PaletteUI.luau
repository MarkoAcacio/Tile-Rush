local PaletteUI = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

function PaletteUI:Init()
    print(sd.PaletteScreenGui.ContainerFrame)
end

return PaletteUI