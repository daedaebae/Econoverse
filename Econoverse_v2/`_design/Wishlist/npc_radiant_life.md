Authored by: Claude in collaboration with Kaelin

# NPC Radiant Life — Ideation

Loose notes on making NPCs feel alive through economic behavior, routines, and personal goals. Not a spec — a place to think.

---

## The Core Idea

Radiant life in Econoverse isn't about pathfinding to a tavern at 8pm. It's about NPCs having **economic drives** that play out whether or not the player is involved. The player is a merchant in a living market where everyone has their own agenda.

---

## Tier 1: NPC Needs

Each NPC has a `needs` dictionary — what they want, how badly, and what they'll do about it.

- A carpenter who's low on timber gets more desperate — speech changes, prices shift, maybe they come to *you*
- Unmet needs could organically generate quests for the player ("I'll pay double for 20 timber by Thursday")
- Needs are just data on the Character resource. No AI, no pathfinding. But the world talks about what it wants.

Things to consider:
- How do needs deplete over time? Flat rate per day? Tied to what the NPC "produces"?
- Should needs be visible to the player (a tooltip, a visual cue) or discovered through conversation?
- Could NPC mood or disposition be a function of how well their needs are met?

---

## Tier 2: NPC-to-NPC Trading

NPCs trade with each other using the same trade system the player uses. Same signals, same flow.

- The baker buys corn from the farmer. The smith buys stone from the mason.
- NPC inventories change over time. Prices shift based on supply and demand.
- The player competes with NPCs for scarce resources and can observe patterns to exploit.
- The economy becomes a living simulation, not a static storefront.

Things to consider:
- How do NPCs decide who to trade with? Proximity? Relationship? Best price?
- Should NPC-to-NPC trades be visible to the player? Overhearing a deal, seeing goods change hands?
- Can the player disrupt NPC trade routes by buying up supply first? That's emergent gameplay.
- What prevents NPCs from perfectly optimizing the economy and leaving nothing for the player?

---

## Tier 3: NPC Routines and Personal Quests

NPCs have their own quest-like goals evaluated by the same QuestManager architecture.

- The carpenter's goal: "acquire enough timber to build a house by day 30." If he succeeds, a new building appears on the map. If he fails, the frame sits unfinished.
- The taxman has a route — he visits each merchant in order, collecting dues. The player watches him coming.
- NPCs who achieve their goals trigger events. A new NPC moves into the carpenter's house. The baker expands her stall.

These are just QuestResources with `target_id` pointing at NPCs instead of the player. Same deadlines, same events, same system.

Things to consider:
- Should the player be able to see NPC quests, or only infer them from behavior and conversation?
- Can the player sabotage an NPC's quest (buy up all the timber so the carpenter fails)? What are the consequences?
- NPC quest failure should be visible — the unfinished house, the closed shop, the changed dialogue. Consequences the player can witness.
- How do NPC routines interact with the day/night cycle? Does the baker only trade in the morning?

---

## Tier 4: NPC Movement and Initiation

NPCs move through the world with purpose and can initiate interactions with the player.

- The taxman walks you down instead of waiting to be approached
- A desperate farmer seeks you out because he heard you have surplus corn
- NPCs travel between locations to trade, creating visible economic activity on the map
- NPCs who need something might congregate near the player or near a resource source

Things to consider:
- Movement doesn't have to be pathfinding-complex. Simple waypoint routes or "move toward target" with collision avoidance goes a long way.
- NPC initiation flips the power dynamic — the player isn't always the one deciding when to engage. This could create tension, surprise, or comedy.
- Should some NPCs be stationary (shopkeepers) while others roam (traders, the taxman)?
- The taxman walking toward you is scarier than a popup. That feeling is worth building toward.

---

## Broader Considerations

**The player as observer.** Some of the best moments might come from watching the economy happen around you. Two NPCs trading in the background. A merchant struggling because their supplier dried up. The player notices, connects dots, and acts. This is the Age of Empires strategic mindset applied to a living world.

**Relationships as economic history.** If the game tracks who you've traded with and how fairly, NPCs could develop opinions. The carpenter gives you better deals because you've been reliable. The taxman is slightly less hostile because you paid on time. Relationship isn't a separate system — it's a byproduct of economic behavior.

**Seasonal or event-driven disruption.** A festival week where demand for certain goods spikes. A cold snap that cuts timber supply. These aren't quests but they ripple through the NPC need/trade systems and create emergent pressure. The player who reads the market thrives.

**NPC failure as worldbuilding.** When an NPC's personal quest fails, the world should show it. An empty stall. A boarded-up shop. A character who used to be cheerful now says "times are hard." This is cheap to implement (swap a sprite, change a speech string) but emotionally powerful. The world remembers.

**The merchant's dilemma.** The most interesting moments happen when helping one NPC hurts another. Selling all your timber to the carpenter means the brewer can't get barrel staves. The player has to choose who to serve — and that choice has economic and emotional consequences. This is where Econoverse stops being a trading game and becomes a story.
