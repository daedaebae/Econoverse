# Tithe MVP Tracker

> **Purpose:** Track progress toward a playable Tithe run — the game's win/lose condition. This is the smallest vertical slice that proves the core loop: meet the Taxman → learn the tithe is owed → trade Coin across days → win or lose.
>
> **Source design:** `tithe_quest_design.md`, `quest_system_design.md`, `quest_system_MVP_loop_simplified.md`

---

## Status Summary

| # | MVP Requirement | Status | Notes |
|---|---|---|---|
| 1 | Popup trigger — player learns about the tithe | 🟡 Half | InteractionPopup built. First Talk with Taxman needs to activate the quest. No full dialogue panel yet. |
| 2 | Taxman NPC on map with unique sprite | ✅ Done | Sprite, id `npc_taxman`, speech lines, position in `world.tscn`. Uses base artisan script. |
| 3 | `quest_tithe.tres` resource fully configured | 🟡 Shell only | Resource exists. Needs objective data, deadline, completion/failure events, trigger. |
| 4 | QuestManager wiring — listen for trades, track progress | ✅ Done generically | Dynamic folder scan + `trigger_start_event` pattern covers this — the tithe will plug in with zero code changes. |
| 5 | Win/lose event handlers — win screen, game over screen | ⬜ Not started | Needs two UI scenes + event listeners. |
| 6 | Pinned quest tracker on HUD | ⬜ Not started | "Tithe: X / 10,000 Coin" + days remaining. Hardcoded pin is acceptable for MVP. |

**Legend:** ✅ Done · 🟡 Partial · ⬜ Not started

---

## Design Decisions Made

### Interaction flow
The original MVP design called for a *popup at a set in-game time* to introduce the tithe. We've replaced that with a more diegetic flow: the player discovers the tithe by **talking to the Taxman**. This reuses the InteractionPopup we just built and eliminates the need for a time-triggered popup. The trade-off: the player must actively find the Taxman, where the original popup was guaranteed to fire.

### Quest activation pattern
We will use our proven `trigger_start_event` mechanism. The tithe quest listens for an EventResource that fires when the Taxman is first met via Talk. This keeps the quest generic — no quest-specific code in the Taxman's script, no hardcoded quest references anywhere.

**The hook:** the InteractionPopup's Talk button fires a "first meeting" event when `met` flips from false to true. For a general-purpose solution, NPCs can hold an optional `on_first_talk_event: EventResource` field. When any NPC is met, their event fires — and any quest pointed at that event activates.

### Deferred / parked
- **Coin-only trade restriction** — the tithe quest works without it. Player can give the Taxman other items; he just doesn't want them. Polish item for after the MVP loop is playable.
- **Full DialoguePanel** — the larger Talk UI from our earlier design discussions. Not needed for MVP; the InteractionPopup's greeting delivers the Taxman's one required line.
- **Dynamic disposition / reactions** — the `disposition` field exists on Character but nothing reads it yet. Add behavior when the conversation menu matures.

---

## Breakout Checklist

### Step 1 — Complete `quest_tithe.tres`
- [ ] Update `obj_01_tithe.tres`:
  - [ ] `target_id = "npc_taxman"`
  - [ ] `item_id = "Coin"`
  - [ ] `required_quantity = 10000`
  - [ ] `objective_type = GIVE`
- [ ] Create `event_tithe_paid.tres` (EventResource, id: `event_tithe_paid`)
- [ ] Create `event_tithe_failed.tres` (EventResource, id: `event_tithe_failed`)
- [ ] In `quest_tithe.tres`:
  - [ ] `id = "quest_tithe"`, `title`, `description`
  - [ ] `_type = MAIN_STORY`
  - [ ] `days_to_complete = 3` (tunable)
  - [ ] `completion_event = event_tithe_paid.tres`
  - [ ] `failure_event = event_tithe_failed.tres`
  - [ ] `trigger_start_event = event_taxman_met.tres` (see Step 2)

### Step 2 — Wire the Taxman's first-meeting trigger
- [ ] Create `event_taxman_met.tres` (EventResource, id: `event_taxman_met`)
- [ ] Add `on_first_talk_event: EventResource` to `Class_Character.gd`
- [ ] In `interaction_popup.gd`'s `_on_talk_pressed()`, fire `current_npc.on_first_talk_event` when `met` flips to true
- [ ] Assign `event_taxman_met.tres` to the Taxman's `on_first_talk_event` field in Inspector

### Step 3 — Win/lose event handlers
- [ ] Create `scenes/components/win_screen.tscn` with endgame text and a "Quit" button
- [ ] Create `scenes/components/game_over_screen.tscn` with text and a "Quit" button
- [ ] Have each scene connect to its corresponding EventResource's `triggered` signal in `_ready()`
- [ ] Decide stat display scope (MVP: days taken + final Coin balance)

### Step 4 — Pinned quest tracker
- [ ] Create HUD element on existing UI showing the pinned quest
- [ ] Listen to `QuestManager.quest_progress` signal to update "X / 10,000 Coin"
- [ ] Listen to `WorldClock.time_changed` to update days-remaining display
- [ ] Hardcode the pinned quest ID to `"quest_tithe"` for MVP

---

## Definition of Done for the MVP

A player can:
1. Start a new game
2. Walk around, discover the Taxman in the world
3. Click him, see his greeting, press Talk — tithe quest activates, tracker appears
4. Find other NPCs, trade goods, accumulate Coin
5. Return to the Taxman, trade Coin to him, watch the tracker update
6. Either: pay 10,000 Coin before the deadline → win screen
7. Or: fail to pay by the deadline → game over screen

That's the loop. Everything else is iteration.
