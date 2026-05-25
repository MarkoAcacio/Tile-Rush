local GameService = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local NetworkService = sd.NetworkService

local Easel = require(script.Easel)
local Colors = require(script.Colors)

-- Config
local RoundTimer = 10
local RevealTimer = 5
local NumberOfRounds = 3

-- Per-GameTable answer key: { [GameTable] = { "Red", "Blue", ... } }
GameService.BoardAnswers = {}


local function CountCorrectColors(EaselTable, AnswerNames)

    local correct = 0

    if not EaselTable or not AnswerNames then
        return
    end

    for i, x in ipairs(EaselTable) do
        if x:GetAttribute("CurrentColor") == AnswerNames[i] then
            correct += 1
        end
    end

    return correct
end

local function ToColorNames(ColorTable)
    local names = {}
    for _, entry in ipairs(ColorTable) do
        table.insert(names, entry.Name)
    end
    return names
end

function GameService:Init()
    local GameBoard = sd.GameAreas.GameTable -- SWITCH THIS NEXT TIME TO THE PLAYER'S TABLE.

    local ColorTable, ColorDict = Colors.GenerateColors(GameBoard)

    Easel.OnAllPainted = function(gameTable)
        self:CheckWinners(gameTable)
    end
    Easel:Init()

    local colorNames = ToColorNames(ColorTable)
    GameService.BoardAnswers[GameBoard] = colorNames

    print("[DEBUG GameService:Init] GameBoard=", GameBoard, "generated", #colorNames, "colors:", table.concat(colorNames, ", "))

    local function sendColorsTo(player)
        task.wait(2)
        local playerTable = sd.GameAreas.GameTable -- SWITCH THIS NEXT TIME TO THE PLAYER'S TABLE.
        local tableColors = Colors.TableColors[playerTable]
        if not tableColors then
            print("[DEBUG sendColorsTo] no TableColors for", player.Name, "playerTable=", playerTable)
            return
        end

        print("[DEBUG sendColorsTo] sendTo", player.Name, "with", #tableColors, "colors")
        NetworkService.GamePackets.BoardColors.sendTo({ colors = ToColorNames(tableColors) }, player)
    end

    for _, player in ipairs(sd.PlayerService:GetPlayers()) do
        task.spawn(sendColorsTo, player)
    end

    sd.PlayerService.PlayerAdded:Connect(function(player)
        task.spawn(sendColorsTo, player)
    end)

end

function GameService:StartGame()

    -- PUT EASEL HERE! MODIFY INIT IN THE FUTURE.
    -- SET THE ATTRIBUTE OF THE EASEL TO THE PLAYER WHO OWNS THE EASEL. THIS IS TO DETERMINE A WINNER

end

function GameService:CheckWinners(gameTable)
    gameTable = gameTable or sd.GameAreas.GameTable -- CHANGE THIS NEXT TIME TO THE PLAYER'S TABLE / BOARD.

    if not gameTable then return end

    local EaselGameboard = Easel.LocalizedGameBoards[gameTable]
    local AnswerColors = GameService.BoardAnswers[gameTable]

    local correct = CountCorrectColors(EaselGameboard, AnswerColors)
    local total = AnswerColors and #AnswerColors or 0

    print(string.format("[GameService:CheckWinners] %s: %d / %d correct", gameTable.Name, correct or 0, total))
end


return GameService
