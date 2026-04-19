# Quest Start — Oblivion / Journal Style

## Diegetic framing
Oblivion's quest log speaks in first-person past tense ("I agreed to help..."), treating the player's journal as an in-world artifact. Parchment-toned backgrounds, scroll-edge vignettes, and a quill-ink aesthetic anchor the text inside the fiction rather than in UI-space. The implication: the *character* wrote this, not a system. Pillars of Eternity extends this with prose narration boxes. Pentiment makes the journal itself the entire visual language. Disco Elysium uses inner-monologue voice to similar diegetic effect.

## Text length
Oblivion opens a quest with one to three sentences — enough to establish who asked, what is wanted, and a vague stakes hint. Longer openers risk losing players before the first step loads. The sweet spot is ~25–40 words: enough for voice, not enough to scroll.

## Timing & skippability
The journal panel holds for roughly two seconds of fade-in/hold before the player can dismiss it. The ceremony is skippable via any confirm input. This respects player agency while giving the presentation time to register. Never gate progress behind a full read.

## Typography
Serifed fonts (Oblivion used a Trajan-adjacent face), italic for internal thought or emphasis, drop cap on the first letter of a new quest. Ink-black (`#1a1008`) on warm parchment (`#e8d8a0`). Line-height ~1.5, modest tracking. Avoid antialiased pixel blur — at small sizes, crisp bitmap serifs read better.

## When ceremony earns its length
Length is earned when the quest is narratively significant (a faction shift, a named NPC death, a moral choice). Routine fetch quests should stay at one line. Ceremony that outlasts its weight becomes friction.

## Godot 4 translation (concrete values)
- **Panel size:** 480×160 px (fits 3 lines at 16px font, 2× scale)
- **Font:** bitmap serif, 8px base, scaled 2×; drop cap at 3× on first letter
- **Colors:** bg `#e8d8a0`, text `#1a1008`, border/vignette `#7a5c2e`
- **Animation:** fade-in 0.3 s (`Tween`, alpha 0→1), hold 1.8 s, then await input
- **Dismiss:** any UI-confirm action; no timer-forced close
- **Padding:** 16 px all sides; scroll-edge sprite overlaid at panel edges
- **Voice token:** prefix entry text with `"I must..."` or `"[NPC] has asked me to..."` to enforce first-person register

## Sources
- Elder Scrolls IV: Oblivion (Bethesda, 2006) — in-game journal UI, direct observation
- General design knowledge: Pillars of Eternity, Pentiment, Disco Elysium journal/log conventions
