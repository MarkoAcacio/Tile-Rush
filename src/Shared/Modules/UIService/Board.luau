local Board = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local NetworkService = sd.NetworkService

Board.GridItems = {}

local function CollectGridFrames(Container)
    local items = {}
    if not Container then
        return items
    end

    local gridFolders = {}
    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Folder") then
            table.insert(gridFolders, child)
        end
    end

    table.sort(gridFolders, function(a, b)
        return a.Name < b.Name
    end)

    for _, gridFolder in ipairs(gridFolders) do
        local frames = gridFolder:GetChildren()
        table.sort(frames, function(a, b)
            return tonumber(a.Name) < tonumber(b.Name)
        end)
        for _, frame in ipairs(frames) do
            table.insert(items, frame)
        end
    end

    return items
end

function Board:Init(Board_ScreenGui)
    if not Board_ScreenGui or not sd:IsLocalPlayerExists() then
        return
    end

    local Container = Board_ScreenGui:WaitForChild("Container")
    self.GridItems = CollectGridFrames(Container)

    print("[DEBUG Board:Init] Container=", Container, "GridItems count=", #self.GridItems)

    self:LoadListeners()
end

function Board:LoadListeners()
    NetworkService.GamePackets.BoardColors.listen(function(data)
        print("[DEBUG Board.listen] received BoardColors, count=", #data.colors)
        self:ApplyColors(data.colors)
    end)
end

function Board:ApplyColors(colorNames)
    for i, frame in ipairs(self.GridItems) do
        local name = colorNames[i]
        if not name then
            continue
        end

        local color = sd.validColors[name]
        if not color then
            continue
        end

        frame:SetAttribute("CurrentColor", name)
        frame.BackgroundColor3 = color
    end
end

return Board
