Authored by: Claude in collaboration with Kaelin

# Tithe Quest Design

## The Tithe

The run's win/lose condition. Pay 10,000 Coin before the deadline or it's game over.

---

## The Taxman

Visually distinct from all other NPCs. Puffy, pompous clothes. Oversized feather. Bearded. He radiates authority and discomfort. His presence is a deliberate contrast to the wholesome world — snyde, direct, and unsettling.

Speech examples:
- `speech.decline`: "Just the coin. Now."
- `speech.greeting`: (to be defined — cold, transactional)

He uses the standard trade UI. Accepts only Coin. Offers nothing. Rejects everything else. Payment is cumulative across interactions.

---

## MVP Requirements

Get the concept playable. Nothing fancy.

1. **Popup trigger** — At a set in-game time, a popup fires: "Pay 10,000 Coin" / "I don't have it." Response dialogue states the deadline.
2. **Taxman NPC on map** — Unique sprite, stationary. Uses existing trade UI with Coin-only restriction.
3. **QuestResource** — `quest_tithe.tres` with one objective: deliver 10,000 Coin to the taxman's `id`. `days_to_complete` set to the deadline. `completion_event` and `failure_event` attached.
4. **QuestManager wiring** — Listens for trade signals from the taxman, increments objective progress on Coin received.
5. **Win/lose events** — `completion_event` triggers a win screen with endgame stats and options (quit, review world). `failure_event` triggers game over.
6. **Pinned tracker** — Upper-right HUD showing "Tithe: X / 10,000 Coin" and days remaining. Hardcoded pin for MVP is fine.

That's it. No journal UI, no quest log browsing, no NPC reactions. Just the loop: popup → trade → track → win or lose.

---

## Post-MVP Quality Passes

Ranked by ROI — impact to player experience relative to effort.

| Priority | Feature | Why it matters | Effort |
|----------|---------|----------------|--------|
| 1 | **Taxman unique sprite** | Immediate visual identity. Player knows who he is on sight. | Art task, no code |
| 2 | **Notification toast on payment** | "Tithe payment received: 5,000 / 10,000" — confirms progress, feels responsive | Small UI addition |
| 3 | **Taxman speech personality** | Decline, greeting, partial payment reactions. Makes the interaction feel alive. | Data on Character resource |
| 4 | **Quest journal (back menu)** | Browse quest details, read description. Foundation for multiple quests. | Medium UI build |
| 5 | **NPC reactions via events_to_handle** | Carpenter congratulates you. Baker offers a discount. World acknowledges what happened. | Requires event system wiring |
| 6 | **Taxman walks you down** | He initiates the encounter. Scarier, more immersive. Replaces the popup. | Requires NPC movement/routine system |
| 7 | **Endgame stats depth** | Trade history, days taken, relationships built. Replayability hook. | Requires data tracking across the run |

---

## Key Design Notes

- The trade UI is the interaction. No special payment screen. The taxman teaches the player that the same interface can feel very different depending on who's on the other side.
- Game over on failure must have teeth. No soft outs in v1. The deadline is real.
- The Tithe creates urgency that gives every other trade in the game meaning — you're not trading for fun, you're trading to survive.
