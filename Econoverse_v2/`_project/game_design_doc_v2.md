# Game Design Document: Econoverse
## Section 1: Core Concept & Overview
**Game Title:** Econoverse

**Genre:** Resource Management, Simulation, Strategy

**Core Loop:** The player travels between points of interest on the world map, buying low and selling high to make a profit. They use this profit to buy new gear and goods (pay their scheduled tithe/tax?). The loop expands as they unlock new trade routes and opportunities.

---
## Section 2: Gameplay & Mechanics

**Game Modes:**
- A single-player campaign with a focus on a main quest line (getting rich, paying a final debt, etc.).
- An open-ended "endless" mode where the player simply tries to survive for as long as possible.

**Player Abilities:**
- Move their merchant on the world map.
- Interact with Points of Interest (POIs) to trade or take quests.
- Manage their inventory and finances through the UI.
**Core Mechanics:**
- Trade with other merchants. Gold for commodities, commodities for gold, commodities for commodities.
- Speak with other merchants and make dialogue choices that affect the kingdom's economy system (supply and demand, valuation, available commodities).

- **Physics:** The game world has minimal physics. Player and NPC movement is based on a grid or pathfinding on the world map.
- **Combat System:** No direct combat. Encounters with enemies (e.g., bandits, tax collectors) are handled through a simple risk-reward system, possibly involving paying a bribe or losing some goods.
- **Progression:** The player's primary progression is through wealth accumulation. This can unlock new POIs, better trade rates and relationships, and access to more profitable goods.

**UI/UX:**

- **Main Menu:** Simple menu with options for New Game, Load Game, Settings, and Quit.
- **HUD (Heads-Up Display):** Shows the current time (day/night cycle), money, music menu, and a quick-access button to the inventory.
- **Inventory Screen:** A grid-based system for the player's goods. Items will have a clear icon, name, and quantity. Tooltips will show detailed information like item value, weight, and where it can be sold.

---
## Section 3: Story, World & Characters
**Story Synopsis:** The player is an inexperienced merchant learning to sell and trade items within the city. The ultimate goal is to make gold and become a renown trader in the kingdom.

**Lore & World:** The world is a medieval fantasy setting with different regions, each with unique goods and resources. For example:
- A lush forest region might have cheap Timber but expensive metal.
- A mountainous region has the opposite.

**Points of Interest (POIs):** Towns, resource-gathering sites, bandit camps, and ancient ruins.

**Characters:**
- The player character is a customizable merchant.
- NPCs are primarily vendors and quest-givers at different merchant shops within the city. They can have unique personalities and trade special goods.

**Enemies & NPCs:**
- The primary "enemy" is the time-based tithe/tax.
- Other antagonistic NPCs include bandits who can steal goods and corrupt tax collectors who demand more than is due.

---
## Section 4: Art & Audio
**Art Style:** A clean, vibrant pixel-art style with an isometric perspective. The character sprites and world objects will be small but detailed enough to be distinct. The UI will be simple and intuitive.

**Lighting & Color Palette:** The color palette will be vibrant and slightly saturated. The day/night cycle will be represented by a gradual shift in lighting and hue, from a warm, bright daytime to a cool, dark nighttime.

**Sound Design:**

- **Music:** A peaceful soundtrack with a medieval or folk theme. It should be calming during travel and subtly change to be more suspenseful when the tithe deadline approaches.
- **Sound Effects:** Simple, satisfying sounds for UI clicks, money transactions, and caravan movement. Environmental sounds like bird chirps or wind will add atmosphere.
- **Voice Acting:** No voice acting to keep production costs low and focus on gameplay. Dialogue will be text-based.

---
## Section 5: Technical Specifications
**Platform(s):** PC (Windows, Mac, Linux) via Steam.

**Engine & Tools:**
- Godot Engine is the primary engine.

**Minimum System Requirements:** Very low. A typical modern laptop with integrated graphics should be able to run it.

**Network & Online Features:** No online features. The game is a single-player experience.

**Save System:** An auto-save system that saves progress at key moments (e.g., entering a town) and a manual save option.

---
## Section 6: Monetization & Business Model
**Business Model:** A one-time premium purchase on Steam.

**Monetization Strategy:** No in-game microtransactions or DLC are planned for the initial release.

---
## Section 7: Project Plan & Milestones
**Development Timeline:** The project will be broken into manageable phases.

- **Phase 1 (Pre-production):** Complete the GDD, create a vertical slice with core mechanics, and finalize the art style. (Approx. 2-3 months)
- **Phase 2 (Alpha):** Build out the full world map, implement all core mechanics, and add a few POIs. (Approx. 4-6 months)
- **Phase 3 (Beta):** Add all content (story, POIs, items), polish the UI, and begin extensive bug testing. (Approx. 2-3 months)
- **Phase 4 (Launch):** Final bug fixes, marketing push, and release.

**Milestones:**
- **Vertical Slice:** A playable version with a single town and a handful of trade goods.
- **Alpha Build:** A full, playable game from start to finish with placeholder art.
- **Feature Complete:** All planned features are implemented and working.
- **Bug-Free:** No major bugs found during final testing.

**Team Roles:** Solo Developers. All roles are shared between by two people and negotiated as needed.