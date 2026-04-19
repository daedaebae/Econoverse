# Quest Visual Editor — Future Tool

## Idea

A custom Godot EditorPlugin that visualizes quest connections as a node graph. Quests appear as nodes, event wires show activation chains. Author and view quest relationships visually instead of editing `.tres` fields by hand.

## Objective

Make quest authoring intuitive — see the full quest tree at a glance, drag connections between quests and events, catch orphaned or misconfigured quests visually.

## Basic Requirements

- GraphEdit panel showing quest nodes with title, type, and objectives
- Drag-to-connect from a quest's completion/failure event to another quest's activation input
- Auto-populate from scanning quest bundle folders
- Write connections back to `.tres` files (via `activation_event_id` field on Quest)

## What to Investigate

- Godot `GraphEdit` and `GraphNode` API — how dialogue plugins (Dialogic, Dialogue Manager) implement custom graph editors
- `EditorPlugin` for adding a custom dock or bottom panel
- Serialization: reading `.tres` quest files into graph nodes and writing changes back cleanly
- How behavior tree plugins (Beehave, LimboAI) handle node-to-resource mapping
