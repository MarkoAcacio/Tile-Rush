# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

TileRush is a Roblox minigame for 2-4 players racing to color tiles first. Code is in Luau, built with [Rojo](https://rojo.space) (see `default.project.json`) and uses [Wally](https://wally.run) for dependencies (`wally.toml`).

## Tooling

- **Sync to Studio:** `rojo serve` (uses `default.project.json`).
- **Install dependencies:** `wally install` (also populates `src/Shared/Packages` and `src/Storage/ServerPackages` based on `realm` in `wally.toml`).
- **Lint:** `selene src` (Roblox std, configured in `selene.toml`).
- There is no test runner configured.

## Rojo source layout

The Rojo project (`default.project.json`) maps source folders into the Roblox DataModel — keep this mapping in mind when adding modules, because the folder you put a file in determines where it ends up at runtime:

| Source folder            | Roblox location                                    |
| ------------------------ | -------------------------------------------------- |
| `src/Shared`             | `ReplicatedStorage.Shared` (client + server visible) |
| `src/Server`             | `ServerScriptService.Server` (currently empty)     |
| `src/Storage`            | `ServerStorage.Storage` (server-only modules)      |
| `src/Client`             | `StarterPlayer.StarterPlayerScripts.Client`        |

`src/Server` is intentionally empty right now — server bootstrap is done from `src/Storage/Modules/GameService` (which is reached via `ServerStorage`). When adding the server-side entry script, it belongs in `src/Server`.

## Architectural conventions

**`Directory` is the central service locator.** `src/Shared/Modules/Directory.luau` exposes Roblox services, folder references (`Shared`, `GameAreas`, `SharedTemplates`, `ClientModules`), shared data (`validColors`, `colorOrder`), and the singleton `NetworkService`. Almost every module starts with:

```lua
local sd = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Directory"))
```

When you need a new global reference (a folder, a service, shared config), add it to `Directory.luau` rather than re-resolving paths in each module.

**Networking via ByteNet namespaces.** `NetworkService.luau` defines namespaces (`PalettePackets`, `GamePackets`) using `ByteNet.defineNamespace`. The same module is loaded by both client (via `Directory`) and server (via `ServerStorage` modules), so packet definitions live in one place. To add a packet, extend an existing namespace or add a new `defineNamespace` block.

**Module-level state keyed by GameTable.** Multi-table support is partially built: modules like `Easel` and `Board` keep `LocalizedGameBoards` / `LocalizedPaintedGrids` dictionaries keyed by the game-table model. Several call sites still hard-code `sd.GameAreas.GameTable` (single table) — comments marked `NEXT TIME` or `SWITCH THIS` indicate where the per-player/per-table parameterization is pending. Prefer threading the GameTable model through new code rather than referencing `GameAreas.GameTable` directly.

**Workspace folder contract.** Runtime expects a `workspace.GameAreas` folder containing per-table models with children: `Easel.Grids.<gridFolder>.<part>`, `BlackBoard.Grids.<gridFolder>.<part>`, `Chair.Seat`, and `GameText`. Parts inside grids must be numerically named so `tonumber(name)` sorts them in paint order.

**`ServerStorage.Templates.IsAllPainted` is a `BindableEvent`** used as the cross-module signal that a player's easel is complete (`Easel:CountPaintedArea` fires it, `GameService:Init` listens). Treat `ServerStorage.Templates` as the shared bindable/template repository.

**Client entry point** is `src/Client/ClientHandler.client.lua`, which only initializes `UIService`. UI sub-modules (`PaletteUI`, `Billboards`) are required by `UIService/init.luau` and should be wired in there, not from the client handler.
