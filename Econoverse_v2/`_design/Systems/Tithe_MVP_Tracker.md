# Tithe MVP Tracker

> **Purpose:** Track progress toward a playable Tithe run — the game's win/lose condition. Smallest vertical slice that proves the core loop: meet the Taxman → learn the tithe is owed → trade Coin across days → win or lose.
>
> **Source design:** `tithe_quest_design.md`, `quest_system_design.md`, `quest_system_MVP_loop_simplified.md`

---

## Status Summary

| # | MVP Requirement | Status | Notes |
|---|---|---|---|
| 1 | `quest_tithe.tres` resource fully configured | ✅ Done | Objective, trigger, on_completion/on_failure events, dialogue_by_npc all wired. `days_to_complete` still needs a real value. |
| 2 | Taxman NPC on map with unique sprite | ✅ Done | `npc_taxman`, sprite, speech, position in `world.tscn`. `accepts_only = ["Coin"]` whitelist prevents junk trades. |
| 3 | Quest activation via first-meeting trigger | ✅ Done | `on_first_talk_event` on Character → `GameController.on_character_met` fires it → `trigger_start_event` activates the quest. |
| 4 | QuestManager wiring — trades, progress, deadline, failure | ✅ Done | Folder scan, trigger pattern, `fail_quest()` primitive, F10 debug force-fail, item_id guard on GIVE/GET. |
| 5 | Pinned quest tracker HUD | ✅ Done | Coin / days display, intro shimmer, win (green) / lose (red) outro pulse with fade. |
| 6 | Quest-start toast | ✅ Done | Two-part Skyrim-style reveal ("Quest Started" → Title), free-floating typography, queued for multiple starts. Audio stinger + Music bus duck synced to text tween. |
| 7 | Consumed-once quest dialogue | ✅ Done | `dialogue_by_npc` on Quest + `get_pending_lines_for` / `mark_delivered` in QuestManager, walked through InteractionPopup. |
| 8 | Win/lose event handlers — endgame screens | ✅ Done | Single `endgame_screen.tscn` listens to both `GAME_WIN` and `GAME_LOSE`, shows conditional message + Exit. Verified both paths trigger correctly. |
| 9 | Tithe `days_to_complete` tuned | ⬜ Not started | Currently default. Pick a real value now that the loop is playable end-to-end. |

**Legend:** ✅ Done · 🟡 Partial · ⬜ Not started

---

## Remaining Work

### Step 9 — Tune `days_to_complete`
- [ ] Playtest the loop; pick a value that makes the deadline meaningful but not punishing
- [ ] Set in `quest_tithe.tres`

### Nice-to-have (post-MVP)
- Audio sting for win/lose screens
- Richer endgame summary (trades made, NPCs met, final Coin balance)
- Main menu return (currently Exit quits the app)

---

## Deferred / parked

- **Full DialoguePanel** — the larger Talk UI from earlier design discussions. Not needed; consumed-once lines + greeting fallback cover MVP.
- **Dynamic disposition / reactions** — `disposition` field exists on Character but nothing reads it yet.
- **Option 3 stateful-by-trigger dialogue** — documented in `quest_manager.gd` PolishRefactor region.

---

## Definition of Done for the MVP

A player can:
1. Start a new game
2. Walk around, discover the Taxman in the world
3. Talk to him — tithe quest activates, toast announces, tracker appears
4. Find other NPCs, trade goods, accumulate Coin
5. Return to the Taxman, trade Coin, watch the tracker update
6. Either: pay in full before the deadline → win screen
7. Or: miss the deadline → game over screen

That's the loop. Everything else is iteration.
