local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Directory = {}

-- Services
Directory.ReplicatedStorage = game:GetService("ReplicatedStorage")
Directory.TweenService = game:GetService("TweenService")
Directory.PlayerService = game:GetService("Players")
Directory.StarterGui = game:GetService("StarterGui")

-- Folders
Directory.Shared = ReplicatedStorage:WaitForChild("Shared")
Directory.SharedTemplates = Directory.Shared:WaitForChild("Templates")
Directory.GameAreas = workspace:WaitForChild("GameAreas")
Directory.ClientModules = Directory.Shared:WaitForChild("Modules")

-- Packages / Modules
Directory.NetworkService = require(Directory.ClientModules:WaitForChild("Network"):WaitForChild("NetworkService"))

-- Player
Directory.LocalPlayer = Directory.PlayerService.LocalPlayer

Directory.validColors = {
    ["Red"] = Color3.fromRGB(220, 40, 40),
    ["Orange"] = Color3.fromRGB(255, 130, 20),
    ["Yellow"] = Color3.fromRGB(255, 230, 40),
    ["Green"] = Color3.fromRGB(60, 180, 70),
    ["Blue"] = Color3.fromRGB(50, 100, 220),
    ["Purple"] = Color3.fromRGB(140, 50, 200),
    ["Pink"] = Color3.fromRGB(255, 110, 180),
    ["Brown"] = Color3.fromRGB(120, 80, 50),
    ["Black"] = Color3.fromRGB(20, 20, 20),
    ["White"] = Color3.fromRGB(240, 240, 240),
}

Directory.colorOrder = {
    "Red", "Orange", "Yellow", "Green", "Blue",
    "Purple", "Pink", "Brown", "Black", "White",
}


-- Functions

function Directory:forceDisableResetting(sg)
	local success = false
	
	while success == false do
		success = pcall(function ()
			return sg:SetCore("ResetButtonCallback", false)
		end)
		if not success then wait() end
	end
end

function Directory:IsLocalPlayerExists()
    return Directory.LocalPlayer 
        and Directory.LocalPlayer:IsDescendantOf(Directory.PlayerService)
end

function Directory:IsPlayerExists(Player: Player)
    return Player and Player:IsDescendantOf(Directory.PlayerService)
end


return Directory