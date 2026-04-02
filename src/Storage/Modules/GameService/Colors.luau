local Colors = {}

local validColors = {
    ["Red"] = Color3.fromRGB(255, 30, 30),
    ["HotPink"] = Color3.fromRGB(255, 40, 150),
    ["DeepPurple"] = Color3.fromRGB(150, 0, 180),
    ["VibrantPurple"] = Color3.fromRGB(110, 40, 210),
    ["RoyalBlue"] = Color3.fromRGB(60, 80, 190),

    ["GrassGreen"] = Color3.fromRGB(80, 190, 60),
    ["Teal"] = Color3.fromRGB(0, 150, 140),
    ["Cyan"] = Color3.fromRGB(0, 190, 220),
    ["SkyBlue"] = Color3.fromRGB(30, 150, 250),
    ["Azure"] = Color3.fromRGB(10, 130, 230),

    ["Lime"] = Color3.fromRGB(160, 210, 60),
    ["AppleGreen"] = Color3.fromRGB(190, 230, 40),
    ["Yellow"] = Color3.fromRGB(255, 240, 30),
    ["Goldenrod"] = Color3.fromRGB(255, 180, 10),
    ["Orange"] = Color3.fromRGB(255, 130, 20),

    ["Black"] = Color3.fromRGB(15, 15, 15),
    ["SlateGray"] = Color3.fromRGB(90, 115, 130),
    ["Silver"] = Color3.fromRGB(180, 180, 180),
    ["Brown"] = Color3.fromRGB(120, 80, 70),
    ["White"] = Color3.fromRGB(255, 255, 255)
}

-- Configs
local NumberOfGrids = 9  -- Amount of colors to be spawned

function Colors.GenerateColors()
    local keys = {}
    local colorTable = {}
    local colorDict = {}

    for name, _ in pairs(validColors) do
        table.insert(keys, name)
    end

    for i = 1, math.min(15, #keys) do
        local randomIndex = math.random(1, #keys)
        
        local colorName = keys[randomIndex]
        local colorValue = validColors[colorName]
        
        table.insert(colorTable, {Name = colorName, Value = colorValue})
        colorDict[colorName] = colorValue
        
        keys[randomIndex] = keys[#keys]
        table.remove(keys)
    end

    return colorTable, colorDict
end

function Colors.CheckColors()
    
end

return Colors