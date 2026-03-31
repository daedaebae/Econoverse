# Econoverse — Project Plan
*Last updated: 2026-03-27*

---

## Overview

**Econoverse** is a medieval merchant trading game built in Godot 4.
The player travels between points of interest, buys low and sells high, manages inventory,
and must pay a recurring tithe/tax to survive. The core tension is economic survival under time pressure.

**Engine:** Godot 4
**Platform target:** PC (Windows, Mac, Linux) — Steam
**Business model:** One-time premium purchase, no DLC or microtransactions

---

## Project Structure

```
Econoverse/
├── _project/               ← You are here. Docs, plans, design notes.
│   ├── PROJECT_PLAN.md     ← This file
│   ├── game_design_doc_v2.md
│   ├── economy_system_overview.md
│   ├── system_architecture.md
│   └── archive/            ← V1 reference docs
├── Econoverse_v2/          ← Active Godot project
├── Econoverse_v1/          ← Legacy reference (C#, not active)
├── sound design/           ← SFX and audio project files
└── README.md
```

---

## Core Loop

```
Player travels → Clicks artisan/merchant → Trade UI opens →
Player sets quantities → Trade executes → Ledger records it →
Time advances → Tithe deadline approaches → Repeat
```

---

## Current State (as of 2026-03-27)

### Done
- [x] World scene with 3 artisan NPCs (Bogus Buchannon, Bron, Butthead)
- [x] Player + artisan registration via GameController event bus
- [x] Artisan click detection (`_input` + distance check)
- [x] Trade UI opens on artisan click
- [x] `trade()` method executes inventory swap between player and NPC
- [x] `GameController.on_trade_complete()` — trade pipeline connected
- [x] `Logging` singleton — trades written to log file and in-game log window
- [x] `WorldClock` singleton — game time (day/hour/minute), heartbeat
- [x] `ui_ledger.track()` — ledger rows populate on trade
- [x] UI layering fixed — trade menu receives input correctly
- [x] Debug print statements throughout trade pipeline

### In Progress / Broken
- [ ] Ledger display — row population logic needs testing end-to-end
- [ ] Artisan click detection — recently reverted to `input_event` signal (needs re-check)
- [ ] Trade items are hardcoded (`"Coins"` / `"Sword"`) — not pulled from NPC data
- [ ] Ledger sort buttons — all are TODO stubs
- [ ] `ledger.gd` (backend) — still empty, no price history or supply/demand logic

---

## V2 Focus Features
*These are the priority items for the current version.*

| Feature | Status | Notes |
|---|---|---|
| Trade pipeline (player.trade() → signal → ledger → log) | In Progress | Core loop connected, testing ongoing |
| Trading System | In Progress | Functional but hardcoded items |
| Player Inventory GUI with Trade button | Not Started | Player needs to see their own inventory |
| Taxonomy (items, types, categories) | Not Started | `ItemResource` exists, needs expansion |
| Inventory system | Not Started | Backend exists, no UI |
| In-game Debug menu / tooling | Not Started | Print statements are current substitute |
| Beta Trade function | In Progress | Working end-to-end, needs polish |
| State Machine — Location | Not Started | Character has `Location` enum, no logic |
| Separation of duties (NPC professions → items) | Not Started | Artisans should offer items by profession |
| Graphics (sprites, tiles) | In Progress | Placeholder sprites in use |
| Dialogue-based Signal Emitters | Not Started | Requires dialogue system |

---

## V2 Stretch Features
*Nice-to-have within V2, can slip to V3.*

| Feature | Notes |
|---|---|
| Game menu / options / audio menu | Main menu, settings screen |
| Config scripting + Save file | Persist game state across sessions |
| Overworld map | Travel between POIs |
| Fog of war | Hide unexplored areas |
| Randomized Artisans ("The Whittler") | Procedural NPC generation |
| Time-based mechanics, day/night | WorldClock exists, events not wired |
| Quests | Quest system, David-style quests |
| Schedules | NPCs follow daily routines |
| Tithe / Tax (recurring cost) | Core tension mechanic — not implemented |
| Defined map with POIs | Actual explorable world |

---

## V3 and Beyond

| Feature | Notes |
|---|---|
| Isometric world map | Visual upgrade from top-down |
| Unique items (special effects) | Rare/legendary trade goods |
| Passive skill tree | Character progression |
| Characters — GoT archetypes | Distinct NPC personalities |
| Overarching story / main quest | Narrative campaign |
| Character dialogue | Dialogue system integration |
| Full crafting systems | Convert raw materials into goods |
| Profession selection (player) | Player chooses a specialization |
| Theme — The Veil / magic | World-building layer |
| Mood board / art direction | Visual identity finalized |

---

## Suggested Milestones

### Milestone 1 — Playable Trade Loop *(Current focus)*
The player can click an artisan, trade items, see the result in the ledger and log,
and the economy registers the transaction.

- [ ] Trade items driven by NPC profession (not hardcoded)
- [ ] Player inventory UI visible during trade
- [ ] Ledger fully populated and scrollable after multiple trades
- [ ] All debug prints removed or gated behind a debug flag

### Milestone 2 — Economy Backbone
The game has a functioning economy that responds to trades.

- [ ] Item prices tracked over time in `ledger.gd`
- [ ] Supply/demand affects prices between artisans
- [ ] Player wallet tracked (Coins as currency)
- [ ] Basic HUD shows Coins, time, tithe countdown

### Milestone 3 — World & Movement
The player can move between locations.

- [ ] Overworld map with at least 3 POIs
- [ ] Player travel between locations
- [ ] Location-based artisan availability
- [ ] Tithe mechanic implemented (countdown + consequence)

### Milestone 4 — Vertical Slice
A complete, sharable demo session.

- [ ] Save/load game state
- [ ] Main menu
- [ ] At least one quest
- [ ] Polished UI and basic art pass

---

## Architecture Notes

See `system_architecture.md` for the full GameController sequence diagram.

**Key singletons:**
| Singleton | Role |
|---|---|
| `GameController` | Event bus — registers nodes, routes signals |
| `Logging` | Writes timestamped entries to file + in-game window |
| `WorldClock` | Tracks game time, emits `time_changed` |
| `UITrade` | Autoload script (note: actual scene is in `playground.tscn`) |
| `UI` | Main HUD |

**Known architectural debt:**
- `UITrade` autoload and `UI-Trade` scene instance are two separate nodes — confusing, should be consolidated
- Trade items are hardcoded in `GameController._on_artisan_clicked()` — needs to come from NPC data
- `ledger.gd` is still a skeleton — all ledger logic is currently in `ui_ledger.gd`
- `game.log` and `.DS_Store` should be added to `.gitignore`

---

## Open Questions

1. **What items does each artisan sell?** Currently all sell Swords for Coins. Need a profession → item mapping.
2. **How does pricing work?** Fixed prices, or supply/demand driven? GDD suggests supply/demand.
3. **Is the tithe a hard deadline (game over) or a soft penalty?** Defines the game's tension level.
4. **Top-down or isometric?** Current art is top-down. Isometric is V3 — confirm this is still the plan.
5. **Multiplayer ever?** GDD says no — confirm.

---

## Files in `_project/`

| File | Description |
|---|---|
| `PROJECT_PLAN.md` | This file — living document, update regularly |
| `game_design_doc_v2.md` | Full GDD for V2 (The Merchant's Burden concept) |
| `economy_system_overview.md` | Draft economy flow diagram (Mermaid) |
| `system_architecture.md` | GameController architecture + sequence diagram |
| `archive/game_design_doc_v1.md` | V1 GDD (C# era, for reference only) |
| `archive/dialog_choices_v1.md` | V1 dialogue system diagram |
