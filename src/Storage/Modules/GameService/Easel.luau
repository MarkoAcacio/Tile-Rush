local Easel = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local NetworkService = sd.NetworkService

-- Localized is just my way of portraying a specific gametable by the players.
Easel.LocalizedGameBoards = {}
Easel.LocalizedPaintedGrids = {}

Easel.ChosenColor = nil

local function SortGrids(_gridObj)
    local gridObj = _gridObj
    table.sort(gridObj, function(a, b)
         return tonumber(a.Name) < tonumber(b.Name)
    end)

    return gridObj
end

-----------------------------------------------------------------------------

local function HandlePaintedArea(GameTable)

    if not Easel.LocalizedPaintedGrids[GameTable] then
            Easel.LocalizedPaintedGrids[GameTable] = {paintedGrids = 1}
        return
     end

    local paintedData = Easel.LocalizedPaintedGrids[GameTable]

     if paintedData.paintedGrids == 9 then
        return
     end

     paintedData.paintedGrids = paintedData.paintedGrids + 1

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
    local GridFolder = sd.GameAreas.GameTable.Easel.Grids -- SETS THIS TO THE TABLE PLAYER IS SITTING AT NEXT TIME
    local GameBoardModel = GridFolder.Parent.Parent

    if not GridFolder then 
        return
    end

    local allGrids = {}

    for _, x in pairs(GridFolder:GetChildren()) do
        if not x then continue end
        local gridObj = SortGrids(x:GetChildren())
         InsertToGameBoardTable(GameBoardModel, gridObj)
        
        for _, z  in pairs(gridObj) do
            self:SetupClickDetectors(z)
        end
    end
end

function Easel:SetupClickDetectors(PaintArea : BasePart)
    local cd = PaintArea:FindFirstChild("ClickDetector")

    if not cd or not PaintArea then 
        return 
    end

    local GameTable = PaintArea.Parent.Parent.Parent.Parent

    if not GameTable then 
        return
    end
    
    cd.MouseClick:Connect(function()
        PaintArea.Color = sd.validColors[Easel.ChosenColor]
        PaintArea:SetAttribute("CurrentColor", Easel.ChosenColor)
        PaintArea:SetAttribute("Colored", true)

        HandlePaintedArea(GameTable)
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