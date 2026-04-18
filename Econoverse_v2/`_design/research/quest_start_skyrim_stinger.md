# Quest Start — Skyrim Stinger Style

## Visual primitives
- **Font:** Futura Condensed ExtraBold (or close condensed sans-serif substitute)
- **Color:** Off-white (~#E8E0D0), no background panel or box
- **Placement:** Top-center of screen, roughly 15–20% down from top edge
- **Text shadow:** Soft drop shadow (black, ~50% opacity, 2–3px offset) for legibility against any background
- **No outline stroke** — shadow only; keeps it clean and non-game-UI-feeling
- **Two lines:** Smaller label ("Quest Updated" / "New Objective") above a larger objective title

## Timing primitives
- **Fade-in:** ~0.3s ease-in
- **Hold:** ~1.2–1.5s at full opacity
- **Fade-out:** ~0.5s ease-out
- **Total display time:** ~2.0–2.3s from trigger to fully gone

## Audio primitives
- **Stinger:** Short brass/horn hit — single note or two-note rise, ~0.8–1.0s duration
- **Music ducking:** Background music briefly dips ~3–4 dB for ~1s to let stinger cut through, then recovers over ~0.5s
- **No voice, no UI click** — the horn does all the emotional work

## Why it lands
Skyrim's stinger works because it interrupts nothing. No pause, no modal, no input block — the world keeps moving while the text fades in and out. The minimalism signals confidence: the game trusts you noticed. The brief horn acknowledges the moment without celebrating it. It respects flow.

## Godot 4 translation (concrete values)
```gdscript
# Label settings
label.add_theme_font_size_override("font_size", 18)  # smaller tag line
title.add_theme_font_size_override("font_size", 26)  # objective text
# Tween sequence
tween.tween_property(container, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
tween.tween_interval(1.3)
tween.tween_property(container, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
# Placement: anchor top-center, y_offset = 80px from top
# Audio: play horn_sting.ogg at 0s; AudioStreamPlayer bus volume -3dB duck for 1s
```

## Sources
- Skyrim UI observation (widely documented in modding community and UI design breakdowns)
- Futura usage confirmed via Bethesda font resources and fan wikis
- Timing/audio values approximated from frame-by-frame community captures
