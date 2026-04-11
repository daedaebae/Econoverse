Authored by: Claude in collaboration with Kaelin

# Quest System Design

## Overview

Econoverse is a run-based merchant game where the player trades, builds relationships, and navigates economic challenges. The quest system provides structure, narrative, and emotional stakes to this loop. Quests break up freeform trading with purposeful goals — from tutorials that teach mechanics organically, to the central Tithe quest that serves as the run's win/lose condition.

### Design Pillars

- **Depth of emotion** inspired by The Elder Scrolls: Oblivion — quests feel personal, NPCs have personality, consequences are felt
- **Strategic planning** inspired by Age of Empires 2 — but channeled through a merchant's mindset, not warfare
- **Relationship-driven discovery** — quests deepen character connections and reveal the world
- **Universal trade verb** — the trade UI is the primary interaction for all NPCs, including quest-relevant ones; NPC personality comes through in *how they respond* within that interface

---

## Core Architecture

### Resources

All quest data is defined as Godot `.tres` Resource files, matching the existing `ItemResource` workflow. Adding a quest means creating a `.tres` file in the Inspector — core code is never touched.

#### QuestResource

| Field              | Type               | Description |
|--------------------|---------------------|-------------|
| `id`               | String              | Unique identifier (e.g., `"quest_tithe"`) |
| `title`            | String              | Display name shown in quest log |
| `description`      | String (multiline)  | Journal-style prose, written in first-person for immersion (Oblivion-inspired) |
| `_type`            | String/Enum         | Private, design-facing classification — not gameplay data. Used to reason about quest behavior and UI treatment |
| `days_to_complete` | int                 | Days from quest start. -1 or 0 = no deadline |
| `objectives`       | Array[QuestObjective] | Flat list, all active in parallel |
| `completion_event` | EventResource       | Optional. Fires when all objectives are met |
| `failure_event`    | EventResource       | Optional. Fires when deadline expires or failure condition is met |

**`_type` values and their intent:**

| Type          | Purpose |
|---------------|---------|
| `tutorial`    | Teaches a mechanic through a character's diegetic need. Gentle, no harsh failure. |
| `main_story`  | Core narrative quests. The Tithe lives here. High stakes. |
| `surprise`    | Unexpected events that emerge from world state. Breaks routine. |
| `typical`     | Standard side quests — deliveries, favors, economic opportunities. |

These types help the team evaluate how different quests should *feel* and how the UI should treat them (e.g., does it toast? does it auto-pin as an exception?).

#### QuestObjective

| Field              | Type   | Description |
|--------------------|--------|-------------|
| `id`               | String | Unique identifier |
| `description`      | String | What the player needs to do |
| `target_id`        | String | ID of the relevant NPC, item, or location |
| `required_quantity` | int   | Amount needed (e.g., 10000 Coin for the Tithe) |

**Inspector tooling:** The objective resource uses a `@tool` script to resolve `target_id` into a human-readable name displayed as a read-only field in the Inspector. If the ID doesn't match any known resource, it shows `"(unknown)"` as a visual warning. This prevents authoring errors before runtime.

**Progress tracking:** Objectives support cumulative/partial progress. The Tithe can be paid in installments — 5,000 today, 5,000 tomorrow. Progress is tracked at runtime in QuestManager, not stored on the resource.

#### EventResource

| Field | Type   | Description |
|-------|--------|-------------|
| `id`  | String | Unique identifier (e.g., `"event_tithe_paid"`, `"event_tithe_failed"`) |

- Fires a **signal** when triggered, broadcasting to the entire game
- Any object (NPC, world, UI) can listen and respond
- Holds logic/data for what should happen (e.g., win screen, game over, NPC behavior change)
- Responses can be **delayed** — an NPC might react the next day, not instantly, making the world feel alive

**Design decision:** Events are decoupled from quests intentionally. A quest doesn't know what winning or losing *means* — it just fires the event. This keeps the quest schema generic and pushes all game-specific consequence into the event layer. Adding a new type of reward or failure never requires changing the quest resource.

---

### Singletons

#### QuestManager

Registered as an autoload singleton, following the same pattern as `GameController` and `Logging`.

**Responsibilities:**

1. **Active quest management** — Only loads and holds quests that are currently active. Undiscovered quests have no presence in memory. Completed and failed quests are written to a historical record and unloaded. The QuestManager is an active quest evaluator, not a quest encyclopedia.
2. **Activation** — When something triggers a quest (NPC interaction, game event, timed popup), the QuestManager loads the `.tres` definition from `res://quests/` and adds it to the active set. This is an explicit action, not automatic discovery.
3. **Listening** — Connects to trade/interaction signals emitted by Characters. NPCs are oblivious to quests — they broadcast "a trade happened with me" and QuestManager decides if it matters
4. **Evaluation** — When a signal arrives, checks all active quests for objectives with a matching `target_id`, then updates progress
5. **Deadline tracking** — Connects to `WorldClock.time_changed` signal. Each tick, checks if any active quest with `days_to_complete` has expired
6. **Completion teardown** — When a quest completes or fails: fire the appropriate event, write the quest record to history, unload the quest from the active set
7. **Event dispatch** — Fires `completion_event` or `failure_event` when conditions are met

**Signals emitted:**

| Signal | When |
|--------|------|
| `quest_started(quest_id)` | A new quest becomes active |
| `quest_progress(quest_id, objective_id)` | An objective's progress changes |
| `quest_completed(quest_id)` | All objectives met, completion event fired |
| `quest_failed(quest_id)` | Deadline expired or failure triggered |

**Runtime state:**

```
active_quests: Dictionary  # quest_id -> { start_day, objectives_progress }
completed_quests: Array[String]
failed_quests: Array[String]
```

Only runtime progress is stored — quest definitions are never modified. This makes save/load trivial when implemented later (`get_save_data()` / `load_save_data()`).

---

### Character Integration

#### Class_Character Changes

| Addition | Description |
|----------|-------------|
| `id` field | Unique identifier, distinct from `char_name`. Quest objectives reference this, not the display name. Renaming an NPC never breaks quest logic. |
| Trade signal | Emits a signal containing trade information and the Character's `id` when a trade completes. QuestManager listens for this. |
| `events_to_handle` | Dictionary of event IDs the NPC cares about. Empty = default behavior. When a matching event fires, the NPC runs the associated response logic. |
| `speech` dictionary | Keyed strings for contextual dialogue (e.g., `speech.decline`). Default: `"I don't want that."` Taxman: `"Just the coin. Now."` |

**Stretch goal:** `speech` values become arrays, with a method that returns a random selection for a more alive feel.

**Design decision:** NPCs never hold references to QuestManager or know about quests. All communication flows through signals. This keeps NPC scenes clean and quest logic centralized.

---

### Signal Flow

```
Trade completes
  -> Character emits trade signal (with Character id + trade data)
    -> QuestManager evaluates against active quest objectives
      -> Objective progress updated
        -> QuestManager emits quest_progress signal
          -> Quest Log UI updates

All objectives met:
  -> QuestManager fires completion_event
    -> EventResource emits signal
      -> NPCs with matching events_to_handle respond
      -> World/UI responds (win screen, new quest unlocks, etc.)

Deadline expires (WorldClock tick):
  -> QuestManager fires failure_event
    -> EventResource emits signal
      -> Game over screen, NPC reactions, etc.
```

---

## Quest Log UI

Three layers, giving the player full control over focus:

### 1. Full Quest Journal (Back Menu)

- Browse all active and completed quests
- Read full descriptions (first-person prose, Oblivion-style)
- Select a quest to pin/track on the HUD
- Accessed via a menu key/button

### 2. Pinned Tracker (Upper Right HUD)

- Shows the player's chosen quest — name and objective progress at a glance
- Example: `"Tithe: 3,200 / 10,000 Coin"`
- Player manually pins from the journal. **Quests are never auto-pinned.**

### 3. Notification Toasts

- Ephemeral popups on quest start and progress milestones
- Fires when a new quest is added — makes the player *feel* it has begun
- Does not linger or clutter the screen

**Design decision:** The player is always in control of what they're focused on. The game communicates when something happens but never nags or auto-pins.

---

## The Tithe Quest — First Implementation

The Tithe is the run's win/lose condition. Every trade, relationship, and side quest exists in service of reaching the gold target before the deadline.

### Narrative

The taxman — a visually distinct, pompous character with puffy clothes, oversized feather, and a beard — informs the player they owe an entry tithe of 10,000 Coin. The tone is snyde and uncomfortable, a deliberate contrast to the otherwise wholesome world. This is the sinking stomach moment.

### First Iteration (v1)

- **Quest trigger:** A simple popup at a set in-game time. Two buttons: "Pay 10,000 Coin" (impossible at start) and "I don't have it." The response dialogue sets the deadline.
- **Taxman NPC:** Present on the map with a unique sprite. Uses the standard trade UI. Only accepts Coin, offers nothing, rejects everything else with personality-driven dialogue.
- **Payment:** Cumulative. Player can pay in installments across multiple interactions.
- **Win condition:** `completion_event` fires a win routine — UI changes to display endgame statistics, options to quit or review the world.
- **Lose condition:** `failure_event` fires game over. Deadline expired, you can't pay.

### Future Iteration

- The taxman walks the player down and initiates the encounter himself (NPC movement/routine system)
- NPCs react to the Tithe being paid via `events_to_handle` — the carpenter congratulates you the next day, the baker offers a discount

---

## File Structure

```
Econoverse_v2/
  quests/                           # .tres quest definition files
    quest_tithe.tres
  scripts/
    quests/
      Resource_QuestResource.gd     # Quest definition resource class
      Resource_QuestObjective.gd    # Objective resource class
      Resource_EventResource.gd     # Event resource class
  singleton/
    quest_manager.gd                # Autoload singleton
```

---

## Unique IDs

Every resource type carries a unique `id: String` field. This is the universal key for cross-referencing across the quest system.

| Resource         | Example ID |
|------------------|------------|
| QuestResource    | `"quest_tithe"` |
| QuestObjective   | `"obj_tithe_payment"` |
| EventResource    | `"event_tithe_paid"` |
| Class_Character  | `"npc_taxman"` |
| ItemResource     | `"item_coin"` |

Objectives reference targets by `id`, never by display name. Renaming is always safe.

---

## Development Tooling

### Inspector Enhancements

- `@tool` scripts on quest resources resolve `target_id` into a read-only display name in the Inspector
- Unknown IDs show `"(unknown)"` as a visual warning

### Validation Script

- A `@tool` editor script traverses all `.tres` quest files
- Checks for: orphaned objectives, missing `target_id` references, nonexistent item IDs, circular prerequisites
- Runs as a pre-export step or on-demand in the editor
- One-afternoon build, high ROI

### Debug Overlay

- CanvasLayer toggled by a key during development
- Displays active quest state: current objectives, progress values, deadline countdowns
- Helps both team members verify quest behavior without reading logs

---

## Design Principles

1. **Quests don't know what they mean.** A quest defines structure (objectives, deadlines). Events define consequence. This separation keeps the system generic.
2. **NPCs don't know about quests.** Characters broadcast signals. QuestManager interprets meaning. NPCs stay clean.
3. **The trade UI is the universal verb.** Even the Tithe is paid through the same interface as buying corn. NPC personality differentiates the experience.
4. **Player controls focus.** No auto-pinning. The journal is there when they want it, the tracker shows what they chose, notifications are ephemeral.
5. **Events are world-level broadcasts.** Any object can listen and respond, with optional delays. This makes the world feel reactive without tight coupling.
6. **Author in the Inspector, not in code.** Adding a quest is creating a `.tres` file. The system auto-discovers it. Core code is never touched.
7. **Build for now, design for later.** Parallel objectives, no branching. Save/load deferred until game loop is solid. NPC routines deferred until the static version works.

---

## Open Questions for Future Design Sessions

- **Event resource internals:** What data shape does an EventResource hold? How does it encode "show win screen" vs. "change NPC prices"? This is the next layer to design.
- **Quest prerequisites:** When multiple quests exist, can one quest require another to be completed first? Simple array of quest IDs, or something richer?
- **NPC `events_to_handle` response format:** What does the response logic look like? Another resource? A callable? A simple dictionary of property changes?
- **Character `speech` structure:** Dictionary of strings vs. dictionary of string arrays with random selection. When to formalize this?
- **Quest categories in the journal:** When there are 10+ quests, how are they organized? By `_type`? By region? By NPC?
