local Colors = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

-- Configs
local NumberOfGrids = 9  -- Amount of colors to be spawned

function Colors.GenerateColors()
    local keys = {}
    local colorTable = {}
    local colorDict = {}

    for name, _ in pairs(sd.validColors) do
        table.insert(keys, name)
    end

    for i = 1, math.min(15, #keys) do
        local randomIndex = math.random(1, #keys)
        
        local colorName = keys[randomIndex]
        local colorValue = sd.validColors[colorName]
        
        table.insert(colorTable, {Name = colorName, Value = colorValue})
        colorDict[colorName] = colorValue
        
        keys[randomIndex] = keys[#keys]
        table.remove(keys)
    end

    return colorTable, colorDict
end

return Colors