local PaletteUI = {}

local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
local NetworkService = sd.NetworkService

PaletteUI.ChosenColor = nil

function PaletteUI:Init(Palette_ScreenGui)
    if not Palette_ScreenGui or not sd:IsLocalPlayerExists() then
        return
    end

    local ContainerFrame = Palette_ScreenGui:WaitForChild("ContainerFrame")
    local PaletteFrame = ContainerFrame:WaitForChild("PaletteFrame")
    local ColorTemplate = PaletteFrame:WaitForChild("ColorTemplate")
    local ColorFolder = PaletteFrame:WaitForChild("ColorButtons")

    self:GenerateColorFrames(ColorTemplate, ColorFolder)
    
end

function PaletteUI:GenerateColorFrames(ColorTemplate : TextButton, ColorFolder : Folder)
    
    for _,  name in pairs(sd.colorOrder) do
        local ClonedTemplate = ColorTemplate:Clone()
        ClonedTemplate.Parent = ColorFolder
        ClonedTemplate.Name = name
        ClonedTemplate.BackgroundColor3 = sd.validColors[name]

        ClonedTemplate.Visible = true

        self:CreateListener(ClonedTemplate)

    end
end

function PaletteUI:CreateListener(ColorButton : TextButton)
    ColorButton.MouseButton1Click:Connect(function()

        NetworkService.PalettePackets.ChosenColor.send({
            ColorName = ColorButton.Name
    })
    end)
end

return PaletteUI