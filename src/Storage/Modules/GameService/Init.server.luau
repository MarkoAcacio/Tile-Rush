local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

local Colors = require(script.Parent.Colors)

sd.PlayerService.PlayerAdded:Connect(function(player)
    print(player .. "Has Joined")
    Colors.GenerateColors()
end)