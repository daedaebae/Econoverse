# Quest System MVP Loop — Simplified

## Design Time (Inspector)

1. Create **EventResources** as `.tres` files — `event_tithe_paid`, `event_tithe_failed`. Just an id and a signal. These are your vocabulary of "things that can happen."

2. Create **QuestObjectives** — `obj_tithe_payment`, target is `npc_taxman`, needs 10,000 Coin.

3. Create **QuestResources** — `quest_tithe` bundles the objectives and points to `event_tithe_paid` as completion, `event_tithe_failed` as failure.

4. Configure **NPCs** — the baker's `events_to_handle` includes `event_tithe_paid` with whatever reaction you want. The taxman's includes both. Each NPC is told which events from the library they care about.

5. Configure **UI/world objects** — the win screen connects to `event_tithe_paid`, the game over screen to `event_tithe_failed`.

## Runtime

1. Something **activates** the quest — QuestManager loads `quest_tithe` into the active set.

2. Player **trades** Coin to the taxman — trade signal flows through GameController.

3. QuestManager **hears** the trade, matches it against active objectives, updates progress. Emits `quest_progress`.

4. Player pays enough — QuestManager sees all objectives satisfied, calls `completion_event.fire()`.

5. `event_tithe_paid` **broadcasts** — every listener reacts independently. Win screen shows. Baker changes speech. Taxman changes speech. Quest archived.

## One Sentence

You build the event library, wire objectives to events in quests, assign events to listeners in the Inspector, and QuestManager connects it all at runtime through signals.
