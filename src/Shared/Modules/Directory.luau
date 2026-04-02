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

-- Events

-- Player
Directory.LocalPlayer = Directory.PlayerService.LocalPlayer
Directory.PlayerGui = Directory.LocalPlayer:WaitForChild("PlayerGui")

-- GUI
Directory.PaletteScreenGui = Directory.PlayerGui:WaitForChild("Palette")

return Directory