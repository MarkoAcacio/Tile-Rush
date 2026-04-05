local GameService = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local TemplateFolder = game:GetService("ServerStorage"):WaitForChild("Templates")

local Easel = require(script.Easel) 
local Colors = require(script.Colors)
local Board = require(script.Board)

-- Config
local RoundTimer = 10
local RevealTimer = 5
local NumberOfRounds = 3


local function CountCorrectColors(EaselTable, BoardTable)

    local correct = 0

    if not EaselTable or not BoardTable then
        return
    end

    for i, x in pairs(EaselTable) do
        if x:GetAttribute("CurrentColor") == BoardTable[i]:GetAttribute("CurrentColor") then
            correct +=1
        end
    end

    return correct
end

function GameService:Init()
    local ColorTable, ColorDict = Colors.GenerateColors()
    Easel:Init()

    TemplateFolder:FindFirstChild("IsAllPainted").Event:Connect(function()
        self:CheckWinners()
    end)

end

function GameService:StartGame()
    
    -- PUT EASEL HERE! MODIFY INIT IN THE FUTURE.
    -- SET THE ATTRIBUTE OF THE EASEL TO THE PLAYER WHO OWNS THE EASEL. THIS IS TO DETERMINE A WINNER

end

function GameService:CheckWinners()
    local GameBoard = sd.GameAreas.GameTable -- CHANGE THIS NEXT TIME TO THE PLAYER'S TABLE / BOARD.

    if not GameBoard then return end

    local EaselGameboard = Easel.LocalizedGameBoards[GameBoard]
    local BoardGameboard = Board.LocalizedGameBoards[GameBoard]

    local Winner = CountCorrectColors(EaselGameboard, BoardGameboard)

end


return GameService