# Structure

Only this project's stances; the techniques themselves are known.

## Stances

- No extra structure by default. The framework is already an architecture; structure earns its place when its absence costs more.
- A framework does not pick a style. "Rails, so DCI" skips the judgement.
- `docs/architecture.md` comes first. Follow it as written until a recorded revisit trigger fires; a missing record is not a reason to add structure.
- Structure answers a named symptom:

| Symptom | Technique |
|---|---|
| A change keeps rippling into code others depend on | Clean Architecture |
| One word means different things in different places | DDD bounded contexts |
| One scenario's logic spreads with no place telling its story | DCI |

- Context boundaries follow aggregate boundaries. Until the aggregates are clear, defer the context lines.
- A thin domain keeps plain objects in `entities/`; `domain/` signals DDD tactics.

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
