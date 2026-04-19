# UI Sprawling Ideas

Ideas for UI elements that have character, personality, and respond to the world through the event system. Every UI element is a listener — it doesn't care why the event fired, it just performs.

---

## Quest Completion Fanfare — Kaelin

Anytime a main_quest is completed, horns appear on screen and play a triumphant short score. A UI element fades in stating the quest name with "Quest Completed," and small print below shows the date — like a record or a stamp. A moment of ceremony that says this mattered.

---

*The following ideas are by Claude.*

## The Seal/Stamp System

Extend the horns idea across quest types so each completion has its own weight. Tutorial quests get a simple ink stamp, almost casual — you learned something, here's a pat on the back. Main story completions get the full ceremony — horns, a wax seal pressed with an animated sigil, the date in Roman numerals. Surprise quests get a cracked seal, like it was unexpected even to the record-keeper. Failed quests get a black border that slowly bleeds in from the edges before the stamp lands — a mourning card. Over time, the player's quest log becomes a collection of seals that tells a visual story at a glance.

## The Ledger as a Living Journal
Not a spreadsheet. A leather-bound book that opens with a page-turn animation. Each trade gets an entry written in handwriting font, with the ink still wet — it dries over a few seconds. Completed quests get a wax seal stamped onto the page. Failed quests get a visible cross-out, the text still readable underneath. Over time the player is flipping through a book that tells the story of their entire playthrough, smudges and all.

## Town Crier Ticker
A scrolling ribbon along the bottom or top of the screen — parchment-styled — that announces world events in third person. "The baker has raised bread prices." "A stranger arrived from the northern road." "The taxman grows impatient." It listens to a broad set of events and translates them into gossip. Gives the player ambient awareness of the simulation running underneath. Sometimes it lies — rumors aren't always accurate.

## Trade Receipts That Stack on the Desk
Every completed trade drops a small paper receipt onto a corner of the screen. They pile up slightly askew, like a messy desk. Click the pile to fan them out and review recent trades. At the end of a season, they get swept away with a satisfying whoosh. It's a UI element that makes the player feel how much commerce they've done without reading a number.

## NPC Mood Portraits
Small framed portraits of key NPCs sit along the edge of the screen, like a shelf of paintings. Their expressions shift based on relationship state and recent events. The baker smiles when you trade fairly. The taxman's portrait literally turns away from you if you're behind on payments. If an NPC leaves town, their portrait frame goes empty — just a nail on the wall. Unsettling.

## A Clock That Has Weight
WorldClock shouldn't just be numbers. A physical clock face — maybe a pocket watch that hangs in the corner. It ticks. On deadline days, it ticks louder. The last day of a quest, it glows faintly, the ticking becomes audible. When a deadline passes, the watch chain snaps and it falls off screen for a moment before resetting. The player learns to dread the ticking without ever reading a number.

## Toast Notifications with Physicality
When events fire, don't just fade in text. Have a wax-sealed letter slide in from the side. The player sees the seal's sigil before it opens — they learn to recognize which seals mean good news and which mean trouble. Main story events come by royal courier — the letter is larger, the seal is ornate. Surprise events arrive crumpled, like someone threw them through the window.

## The Approval Candle
Instead of a reputation bar, a candle burns on screen. Good standing keeps it tall and bright. Poor reputation and it melts down. If it goes out — consequences. The player never sees a number, just a candle getting shorter. They feel the pressure instead of calculating it.

## The Economy Weather Vane
A small decorative weather vane on a rooftop in the UI corner. It points toward economic health. Prosperity and it points up, gilded. Recession and it rusts, points down, creaks in the wind. It's ornamental, tells you nothing precise, but creates atmosphere. Seasoned players learn to read it like a real merchant reads the wind.

## Breaking News Scroll for Chain Reactions
When event dominos cascade — tithe failed, shop seized, baker homeless — an official proclamation unrolls from the top of the screen. Each consequence is listed as a new line item that stamps onto the parchment one by one. The player watches the fallout unfold in real time. It's dramatic, it's informative, and it makes the player understand that their failure had a cost.

---

The thread connecting all of these: every UI element is a character in the world, not a data display. The ledger has handwriting. The clock has anxiety. The portraits have opinions. The receipts have mess. None of them need special code paths — they're all just listeners on the event bus, reacting with personality instead of data.
