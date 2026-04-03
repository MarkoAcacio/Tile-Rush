local Easel = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local NetworkService = sd.NetworkService

Easel.ChosenColor = nil

local function SortGrids(_gridObj)
    local gridObj = _gridObj
    table.sort(gridObj, function(a, b)
         return tonumber(a.Name) < tonumber(b.Name)
    end)

    return gridObj
end

function Easel:LoadPaintArea()
    local GridFolder = sd.GameAreas.GameTable.Easel.Grids -- SETS THIS TO THE TABLE PLAYER IS SITTING AT NEXT TIME
    
    for _, x in pairs(GridFolder:GetChildren()) do
        if not x then return end
        local gridObj = SortGrids(x:GetChildren())
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

    cd.MouseClick:Connect(function()
        print(Easel.ChosenColor)
        PaintArea.Color = sd.validColors[Easel.ChosenColor]
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