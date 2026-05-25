local Easel = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local NetworkService = sd.NetworkService

-- Localized is just my way of portraying a specific gametable by the players.
Easel.LocalizedGameBoards = {}
Easel.LocalizedPaintedGrids = {}

Easel.ChosenColor = nil

-- Callback invoked when a player's easel reaches the painted threshold.
-- GameService:Init sets this so it can run :CheckWinners(gameTable).
Easel.OnAllPainted = nil

local function SortGrids(_gridObj)
    local gridObj = _gridObj
    table.sort(gridObj, function(a, b)
         return tonumber(a.Name) < tonumber(b.Name)
    end)

    return gridObj
end

-----------------------------------------------------------------------------

local PAINT_THRESHOLD = 9

-- Increments the painted-cell counter for the given table and returns true once
-- the threshold is reached. Caps at the threshold so repaints don't inflate it.
function Easel:CountPaintedArea(GameTable)
    if not self.LocalizedPaintedGrids[GameTable] then
        self.LocalizedPaintedGrids[GameTable] = {paintedGrids = 0}
    end

    local paintedData = self.LocalizedPaintedGrids[GameTable]
    if paintedData.paintedGrids >= PAINT_THRESHOLD then
        return true
    end

    paintedData.paintedGrids = paintedData.paintedGrids + 1
    print(paintedData.paintedGrids)

    return paintedData.paintedGrids >= PAINT_THRESHOLD
end

function Easel:IsAllPainted(GameTable)
    local paintedData = self.LocalizedPaintedGrids[GameTable]
    return paintedData ~= nil and paintedData.paintedGrids >= PAINT_THRESHOLD
end

-----------------------------------------------------------------------------

local function InsertToGameBoardTable(GameBoardModel, SortedGrids)
    -- Initialize array for this game board if it doesn't exist
    if not Easel.LocalizedGameBoards[GameBoardModel] then
        Easel.LocalizedGameBoards[GameBoardModel] = {}
    end
    
    -- Insert each grid into this game board's array
    for _, obj in ipairs(SortedGrids) do
        table.insert(Easel.LocalizedGameBoards[GameBoardModel], obj)
    end
end

function Easel:LoadPaintArea()
    --[[
    
        Gridfolder & the gameboard model should be taken as a parameter next time.
        It must be passed by gameservice -> easel

    ]]
    local GridFolder = sd.GameAreas.GameTable.Easel.Grids -- SETS THIS TO THE TABLE PLAYER IS SITTING AT NEXT TIME


    local GameBoardModel = GridFolder.Parent.Parent

    if not GridFolder then 
        return
    end

    local gridFolders = GridFolder:GetChildren()
    table.sort(gridFolders, function(a, b)
        return a.Name < b.Name
    end)

    for _, x in ipairs(gridFolders) do
        local gridObj = SortGrids(x:GetChildren())
        InsertToGameBoardTable(GameBoardModel, gridObj)

        for _, z in ipairs(gridObj) do
            self:SetupClickDetectors(z, GameBoardModel)
        end
    end
end

function Easel:SetupClickDetectors(PaintArea : BasePart, GameBoardModel)
    local cd = PaintArea:FindFirstChild("ClickDetector")

    if not cd or not PaintArea then 
        return 
    end

    if not GameBoardModel then 
        return
    end
    
    cd.MouseClick:Connect(function()
        if not sd.validColors[Easel.ChosenColor] then
            return
        end

        local wasAlreadyPainted = PaintArea:GetAttribute("Colored") == true

        PaintArea.Color = sd.validColors[Easel.ChosenColor]
        PaintArea:SetAttribute("CurrentColor", Easel.ChosenColor)
        PaintArea:SetAttribute("Colored", true)

        if not wasAlreadyPainted then
            self:CountPaintedArea(GameBoardModel)
        end

        if self:IsAllPainted(GameBoardModel) and Easel.OnAllPainted then
            Easel.OnAllPainted(GameBoardModel)
        end
    end)

end

function Easel:LoadListeners()
    NetworkService.PalettePackets.ChosenColor.listen(function(data, player)
        Easel.ChosenColor = data.ColorName
    end)
end

function Easel:Init()
    self:LoadListeners()
    self:LoadPaintArea()
end


return Easel