local Board = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

Board.LocalizedGameBoards = {}

local function GetGridObjects(GridTable)
    
    local items = {}

    if not GridTable then 
        return
    end

    for i, GridModel in pairs(GridTable) do 
        local gridObjects = GridModel:GetChildren()
        if gridObjects then

            table.sort(gridObjects, function(a, b)
                 return tonumber(a.Name) < tonumber(b.Name)
            end)

            for i, obj in pairs(gridObjects) do
                table.insert(items, obj)
            end
        end
    end

    return items

end

local function ApplyColorToItems(colorTable, GridItems)
    for i = 1, #GridItems do
        local part = GridItems[i]
        part:SetAttribute("CurrentColor", colorTable[i].Name)
        part.Color = colorTable[i].Value
    end
end


function Board.ApplyColors(colorTable)
    local board = sd.GameAreas.GameTable.BlackBoard -- SWITCH THIS TO THE PARENT OF THE CHAIR NEXT TIME.
    local GameTable = sd.GameAreas.GameTable

    if not board or not colorTable then
        return
    end

    local gridTable = board:WaitForChild("Grids"):GetChildren()
    local GridItems = GetGridObjects(gridTable)

    Board.LocalizedGameBoards[GameTable] = GridItems

    ApplyColorToItems(colorTable, GridItems)
end


function Board:GetColorTable() -- ADD A PARAMETER HERE NEXT TIME DEPENDING WHERE THE PLAYER IS PLAYING AT.
    print(Board.LocalizedGameBoards)
end

return Board