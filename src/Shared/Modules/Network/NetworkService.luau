-- Packages

local NetworkService = {}

local ByteNet = require(game:GetService("ReplicatedStorage")
:WaitForChild("Shared")
:WaitForChild("Packages")
:WaitForChild("bytenet"))

NetworkService.PalettePackets = ByteNet.defineNamespace("Palette", function()
    return {
        ResetColor = ByteNet.definePacket({
            value = ByteNet.struct({
                action = ByteNet.bool
            })
        }),

        ChosenColor = ByteNet.definePacket({
            value = ByteNet.struct({
                ColorName = ByteNet.string,
            })
        })
    }
end)

return NetworkService