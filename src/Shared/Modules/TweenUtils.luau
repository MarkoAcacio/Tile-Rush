local TweenUtils = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))


function TweenUtils:Levitate(Object : BasePart?, Height : number, Speed : number)
	if not Object then
		return
	end

	sd.TweenService:Create(
		Object,
		TweenInfo.new(Speed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{ CFrame = Object.CFrame * CFrame.new(0, Height, 0) }
	):Play()
	
end



return TweenUtils