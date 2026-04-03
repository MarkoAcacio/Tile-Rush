local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

local UIService = require(sd.ClientModules:WaitForChild("UIService"))

task.spawn(function()
    UIService:Init()
end)