local GameService = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

local Easel = require(script.Easel) 
local Colors = require(script.Colors)
local Board = require(script.Board)

-- Config
local RoundTimer = 10
local RevealTimer = 5
local NumberOfRounds = 3


local function CompareColor(EaselTable, BoardTable)

    if not EaselTable or not BoardTable then
        return
    end

    for i, x in pairs(EaselTable) do
        if x:GetAttribute("CurrentColor") == BoardTable[i]:GetAttribute("CurrentColor") then
            print(x:GetAttribute("CurrentColor"), BoardTable[i]:GetAttribute("CurrentColor"))
        end
    end
end

function GameService:Init()
    local ColorTable, ColorDict = Colors.GenerateColors()
    Easel:Init()

    task.spawn(function()
        while true do
            task.wait(5)
            self:CheckWinners()
        end
    end)

end

function GameService:StartGame()
    
    -- PUT EASEL HERE! MODIFY INIT IN THE FUTURE.

end

function GameService:CheckWinners()
    local GameBoard = sd.GameAreas.GameTable -- CHANGE THIS NEXT TIME TO THE PLAYER'S TABLE / BOARD.

    local EaselGameboard = Easel.LocalizedGameBoards[GameBoard]
    local BoardGameboard = Board.LocalizedGameBoards[GameBoard]

    print("Easel: ", EaselGameboard, "  |   Board: ", BoardGameboard)
    CompareColor(EaselGameboard, BoardGameboard)
end


return GameService