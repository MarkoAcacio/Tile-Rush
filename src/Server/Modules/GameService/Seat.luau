local Seat = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))

function Seat.CreateListeners()
	local GameArea = sd.GameAreas

	for _, GameTable in pairs(GameArea:GetChildren()) do

		local Chair = GameTable:WaitForChild("Chair")
		if not Chair then 
			continue
		end

		local _Seat = Chair:WaitForChild("Seat")
		if not Seat then
			continue
		end

		_Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
		
		
		
			

			if not _Seat.Occupant then 
				return
			end

		end)
	end

end


return Seat