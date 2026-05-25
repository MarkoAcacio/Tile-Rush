local Billboards = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local TweenUtils = require(sd.ClientModules:WaitForChild("TweenUtils"))



function Billboards.StartTweens()
	
	local GameTables = sd.GameAreas
	
	for _, GameTable in pairs(GameTables:GetChildren()) do
		
		local GameText = GameTable:WaitForChild("GameText")
		if not GameText then 
			continue
		end
		
		TweenUtils:Levitate(GameText, 1.5, 2)
		
	end
	
end

function Billboards.CreateListeners()
	
end

function Billboards.ChangeText()
	
end


return Billboards