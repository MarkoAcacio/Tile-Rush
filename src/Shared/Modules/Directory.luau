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
    ["Red"] = Color3.fromRGB(255, 30, 30),
    ["Yellow"] = Color3.fromRGB(255, 240, 30),
    ["Blue"] = Color3.fromRGB(60, 80, 190),
    ["Green"] = Color3.fromRGB(80, 190, 60),
    ["Black"] = Color3.fromRGB(15, 15, 15),
    ["White"] = Color3.fromRGB(255, 255, 255),

    ["Orange"] = Color3.fromRGB(255, 130, 20),
    ["Lime"] = Color3.fromRGB(160, 210, 60),
    ["Cyan"] = Color3.fromRGB(0, 190, 220),
    ["SkyBlue"] = Color3.fromRGB(30, 150, 250),

    ["HotPink"] = Color3.fromRGB(255, 40, 150),
    ["DeepPurple"] = Color3.fromRGB(150, 0, 180),
    ["VibrantPurple"] = Color3.fromRGB(110, 40, 210),
    ["RoyalBlue"] = Color3.fromRGB(60, 80, 190),
    ["Teal"] = Color3.fromRGB(0, 150, 140),
    ["Azure"] = Color3.fromRGB(10, 130, 230),
    ["AppleGreen"] = Color3.fromRGB(190, 230, 40),
    ["Goldenrod"] = Color3.fromRGB(255, 180, 10),
    ["Brown"] = Color3.fromRGB(120, 80, 70),
    ["SlateGray"] = Color3.fromRGB(90, 115, 130),
    ["Silver"] = Color3.fromRGB(180, 180, 180)
}

Directory.colorOrder = {
    "Red", "Yellow", "Blue", "Green", "Black", "White",  -- basic colors first
    "Orange", "Lime", "Cyan", "SkyBlue",                 -- secondary/simple colors
    "HotPink", "DeepPurple", "VibrantPurple", "RoyalBlue", 
    "Teal", "Azure", "AppleGreen", "Goldenrod", 
    "Brown", "SlateGray", "Silver"                       -- complex / nuanced colors
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