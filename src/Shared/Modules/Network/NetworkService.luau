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

NetworkService.GamePackets = ByteNet.defineNamespace("GamePackets", function()
    return {
        PlayingState = ByteNet.definePacket({
            value = ByteNet.struct({
                isPlaying = ByteNet.bool
            })
        }),

        BoardColors = ByteNet.definePacket({
            value = ByteNet.struct({
                colors = ByteNet.array(ByteNet.string)
            })
        })
    }
end)

return NetworkService
