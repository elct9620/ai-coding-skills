# Structure

Only this project's stances; the techniques themselves are known.

## Stances

- No extra structure by default. The framework is already an architecture; structure earns its place when its absence costs more.
- A framework does not pick a style. "Rails, so DCI" skips the judgement.
- `docs/architecture.md` comes first. Follow it as written until a recorded revisit trigger fires; a missing record is not a reason to add structure.

## Problem, Then Technique

SOLID holds under every technique. Before a problem has a name, divide code by responsibility with it.

Once a problem has a name, choose the technique for the code that has it. Techniques combine: Clean Architecture layers with DDD contexts inside them is common.

| Problem | Technique | What it buys |
|---|---|---|
| Volatile details keep forcing changes in the core | Clean Architecture | Inward dependencies; details change behind ports |
| A complex domain, or one word with several meanings | DDD | Contexts split the problem; one language per context |
| One scenario's logic scattered across objects | DCI | One context tells the scenario; data stays thin |

Context boundaries follow aggregate boundaries. Until the aggregates are clear, defer the context lines.

## Module Type

| Module type | Public symbols |
|---|---|
| Application | The source is the documentation |
| Library or shared module | Doc comments state intent and when to use it |

## Recording

Propose the record; people write `docs/architecture.md`.

| Decision | Record |
|---|---|
| Will recur | Patterns entry: when to apply, shape, canonical example, forces, revisit if |
| Sets a project-wide default | Style declaration |
| Large blast radius, multi-team, hard to reverse | ADR in `docs/decisions/` |
