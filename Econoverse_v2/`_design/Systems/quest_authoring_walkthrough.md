# Quest Authoring Walkthrough

> **Purpose:** Step-by-step guide for adding a new quest. No code required — quests are authored entirely through Godot's Inspector by creating and wiring `.tres` resources. Follow this top-to-bottom the first time; skip around on subsequent quests.
>
> **Prerequisite reading:** `quest_system_design.md` (concepts), `Tithe_MVP_Tracker.md` (working example).

---

## Mental model

A quest is a **folder of resources** that QuestManager discovers automatically at startup. You never register a quest in code. You never wire signals in code. You build resources in the Inspector; QuestManager scans, loads, and connects them.

Four resource types make up a complete quest:

| Resource | What it is | Typical count per quest |
|---|---|---|
| `Quest` | The quest itself — title, description, deadline, links to objectives + events | 1 |
| `QuestObjective` | A single requirement (give X, meet Y, wait N days) | 1–N |
| `EventResource` | A named event that can fire and be listened for (start trigger, fail trigger, on-completion, on-failure) | 1–4 |
| Character's `on_first_talk_event` (optional) | Assigned on an NPC, not in the quest folder — lets that NPC's first Talk fire a quest's start trigger | 0–1 |

---

## Step 1 — Create the quest folder

- Navigate to `res://scripts/quests/quest bundles/`
- Right-click → New Folder
- Naming convention: `NNN - short_name` (e.g. `004 - smuggler_run`). The numeric prefix keeps quests ordered visibly in the FileSystem panel.

That's it — QuestManager recursively scans this root at startup, so anything you drop in will be picked up on the next run.

---

## Step 2 — Create the Quest resource

This is the anchor. Build it first; everything else refers back to it.

1. Right-click inside your new folder → **New Resource...**
2. Type `Quest` → Create
3. Save as `quest_<short_name>.tres`
4. Select the file; the Inspector now shows the Quest fields.

### Quest fields

| Field | What to enter | Notes |
|---|---|---|
| `id` | Unique string, e.g. `"004 - smuggler_run"` | Must be unique across all quests. Never change after shipping — save files will reference it. |
| `title` | Display name | Appears in toast, tracker, journals. |
| `description` | Multi-line prose, first-person | Will appear in the future journal UI. Keep to 1–3 sentences for MVP. |
| `_type` | Enum: TUTORIAL / MAIN_STORY / SURPRISE / TYPICAL | Tags the quest's feel; UI may treat differently later. |
| `objectives` | Array of QuestObjective refs | Leave empty for now — you'll fill this after Step 3. |
| `days_to_complete` | Int | `0` = no deadline. Any positive number = fails that many days after start. |
| `auto_start` | Bool | `true` = activates at game start. Use sparingly; most quests want a trigger instead. |
| `trigger_start_event` | EventResource | Activates the quest when this event fires. Leave null if `auto_start` is true. |
| `trigger_fail_event` | EventResource | Optional. Forces failure when this event fires. |
| `on_completion_event` | EventResource | Fires when all objectives are met. Other systems listen here. |
| `on_failure_event` | EventResource | Fires when the quest fails (deadline or trigger). |
| `dialogue_by_npc` | Dictionary | Keyed by `Character.id`. Value is the line shown on first Talk with that NPC while the quest is active. Consumed once per (quest, npc). |

Don't panic that most fields are empty — you'll fill them as you build the other resources.

---

## Step 3 — Create the objectives

Each requirement is its own resource.

1. In the same folder, **New Resource...** → `QuestObjective`
2. Save as `obj_01_<short>.tres`, `obj_02_<short>.tres`, etc.
3. Fill the Inspector:

| Field | Purpose |
|---|---|
| `id` | Unique within this quest (e.g. `"pay_coin"`). Used by QuestManager for progress tracking. |
| `objective_type` | Enum: GIVE / GET / MEET / ELAPSE. Determines which event the objective listens for. |
| `target_id` | The `Character.id` or `item_id` to match. Also accepts `"any_character"` / `"any_item"` as wildcards. |
| `item_id` | Required for GIVE/GET — constrains which item counts (e.g. `"Coin"`). Prevents junk items from incrementing progress. |
| `required_quantity` | Int target |
| `description` | Human-readable blurb for tracker/journal |

Once saved, go back to `quest_<short>.tres` and drag each objective into the `objectives` array.

---

## Step 4 — Create the EventResources

Events are the *nervous system* of the quest framework. A quest never says "when X happens, do Y" directly — it says "when this event fires, activate me" and "when I finish, fire this event." Something else decides what the event means.

You'll typically need 2–4 event files per quest. Create them in the same folder:

1. **New Resource...** → `EventResource`
2. Save with descriptive names:
   - `event_<short>_start.tres` (or reuse an existing one if another quest chains into yours)
   - `event_<short>_fail.tres` (optional)
   - `<short>_COMPLETE.tres` (fired when the quest succeeds — listeners decide what happens)
   - `<short>_FAIL.tres` (fired when the quest fails)

3. Each EventResource just needs a unique `id` string.

Then return to `quest_<short>.tres` and drag the event files into the appropriate event slots.

### Event naming conventions

- **`event_*`** — plumbing-level events fired by code (NPC met, trade completed, day rollover)
- **`*_COMPLETE` / `*_FAIL`** — semantically meaningful outcomes that UI/game-state systems listen to (e.g. `GAME_WIN`, `GAME_LOSE`)

The distinction is purely for readability; Godot treats them the same.

---

## Step 5 — Wire the start trigger

Most quests activate when something in the world happens. The most common pattern is "when the player first talks to NPC X, start this quest."

### First-meeting trigger

1. Open your NPC's `.tscn` (e.g. a Taxman scene)
2. In the Inspector, find `on_first_talk_event`
3. Drag your `event_<short>_start.tres` into that slot

Now when the player Talks to this NPC for the first time, the event fires; QuestManager sees it matches the quest's `trigger_start_event`, and activates the quest.

### Other trigger sources

- **Auto-start:** set `auto_start = true` on the Quest; no trigger needed.
- **Chained quests:** set another quest's `on_completion_event` as your quest's `trigger_start_event` (this is how `003 - tithe` chains off `002 - threes_company`).
- **Custom events:** any system can call `event_resource.fire({...})` to trigger from code — trades, combat, time-of-day, etc.

---

## Step 6 — Wire dialogue (optional)

If you want the NPC to say something *specific to this quest* the first time the player talks to them while it's active:

1. Open `quest_<short>.tres`
2. Expand `dialogue_by_npc`
3. Add entry: key = NPC's `Character.id` (e.g. `"npc_taxman"`), value = the line (e.g. `"Just the coin. Now."`)

The line is delivered once through the InteractionPopup, then falls back to the NPC's default greeting on subsequent talks. If multiple active quests have lines for the same NPC, they're all walked in sequence.

---

## Step 7 — Wire the completion/failure handlers

Your quest's `on_completion_event` and `on_failure_event` fire when the quest resolves — but those events do nothing on their own. Something has to listen.

Common listeners:
- `endgame_screen.tscn` — assign win/lose events to its Inspector slots to show an endgame screen
- Another quest's `trigger_start_event` — chain quests together
- Custom Node scripts — connect to the event's `triggered` signal in `_ready()`

For MVP, a quest without listeners simply logs to console and moves on — not a bug, just a quiet resolution.

---

## Step 8 — Test

1. Run the game
2. Check the console at startup: `QuestManager: discovered N quest(s).` — your quest count should go up by one
3. Trigger the start condition
4. Watch for: quest-start toast, tracker cluster appears, progress updates as objectives increment
5. Complete or fail the quest, confirm the right event fires downstream

### Debug aids

- **F10** — force-fails the first active quest (useful for testing failure paths without waiting on deadlines)
- `Logging.log_info` calls inside QuestManager trace activation, progress, completion, failure
- `QuestManager.validate_quest_state()` — call from a debug overlay or command prompt to check for orphans / missed triggers

---

## Worked example — smallest possible new quest

Goal: a quest that starts when the player meets any NPC and completes when they meet a second NPC.

1. Create folder `005 - wanderer`
2. Create `obj_01_wanderer.tres`:
   - `id = "meet_second"`
   - `objective_type = MEET`
   - `target_id = "any_character"`
   - `required_quantity = 1`
3. Create `event_wanderer_complete.tres` with `id = "event_wanderer_complete"`
4. Create `quest_wanderer.tres`:
   - `id = "005 - wanderer"`, `title = "The Wanderer"`, `description = "I've started meeting people. Should probably meet another."`
   - `auto_start = true` (no trigger needed for this demo)
   - `objectives = [obj_01_wanderer.tres]`
   - `on_completion_event = event_wanderer_complete.tres`
5. Run the game. Meet any NPC → quest completes → event fires.

Total: five clicks in the FileSystem, 12 field entries, zero lines of code.

---

## Gotchas

- **Renaming fields in `quest.gd`** breaks existing `.tres` files — Godot serializes by property name. If you must rename, hand-edit each `.tres` to match.
- **`item_id` on GIVE/GET is required** if you want only specific items to count. Leaving it blank lets *any* item increment progress.
- **`accepts_only` on Character** is separate from the quest — it whitelists items an NPC will accept in trade. Useful for "Taxman takes only Coin."
- **EventResources are shared globally** — two quests pointing at the same `event_*.tres` will both react. Usually what you want; occasionally a foot-gun.
- **Quest IDs must be stable** — save/load (future) will key on them. Change a title freely; never change the id.

---

## Where to look when things go wrong

| Symptom | First place to check |
|---|---|
| Quest never activates | Is `trigger_start_event` assigned? Is that event actually firing? (Add a print in the event's `fire()` path.) |
| Progress doesn't update | Does `target_id` match exactly? Does `item_id` match (for GIVE/GET)? |
| Quest completes instantly | Check `required_quantity` — default 0 will auto-complete. |
| Tracker doesn't appear | `pinned_quest_id` in the tracker scene points at a real quest id? |
| Console says "not in all_quests" | File is in the right folder? Is the resource actually a `Quest` script? |
