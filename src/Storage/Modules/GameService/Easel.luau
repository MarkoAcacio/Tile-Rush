local Easel = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local NetworkService = sd.NetworkService

local TemplateFolder = game:GetService("ServerStorage"):WaitForChild("Templates")

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

-- Checks if the painted area is == 9, if yes then check win.
function Easel:CountPaintedArea(GameTable, PaintArea : BasePart)
    if not self.LocalizedPaintedGrids[GameTable] then
        self.LocalizedPaintedGrids[GameTable] = {paintedGrids = 0}
    end

    local paintedData = self.LocalizedPaintedGrids[GameTable]

    if not paintedData then 
        return
    end

    if paintedData.paintedGrids == 9 then
        return true
    end

    paintedData.paintedGrids = paintedData.paintedGrids + 1
    print(paintedData.paintedGrids)

    return false
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

    local allGrids = {}

    for _, x in pairs(GridFolder:GetChildren()) do
        if not x then continue end
        local gridObj = SortGrids(x:GetChildren())
         InsertToGameBoardTable(GameBoardModel, gridObj)
        
        for _, z  in pairs(gridObj) do
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
        PaintArea.Color = sd.validColors[Easel.ChosenColor]
        PaintArea:SetAttribute("CurrentColor", Easel.ChosenColor)
        PaintArea:SetAttribute("Colored", true)

        local isComplete = self:CountPaintedArea(GameBoardModel, PaintArea)
        
        if isComplete then
           TemplateFolder:FindFirstChild("IsAllPainted"):Fire("Test")
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