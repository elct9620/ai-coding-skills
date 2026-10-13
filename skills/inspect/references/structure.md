# Structure

The common techniques — Clean Architecture, DDD strategic design, DCI, Ports and Adapters — are known. This file holds only where this project's stance differs from common practice.

## Default: no extra structure

The framework is already an architecture. Following its grain plainly is often the right answer. Structure earns its place only when its absence costs more than adding it.

A framework does not pick a style. "Rails, so DCI" or "Spring, so layers" skips the judgement; the framework is one input to it.

## Recorded structure first

`docs/architecture.md` holds the decisions the project already made.

| The record | Action |
|---|---|
| Covers the area, no revisit trigger fired | Follow it as written; no fresh analysis |
| Missing for the area, or a trigger fired | Ask whether the area is now complex enough to need structure |

A missing record is not a reason to add structure.

## Symptom to technique

Structure answers a symptom someone can name. These are starting points; they compose.

| Symptom | Technique |
|---|---|
| A change keeps rippling into code others depend on | Clean Architecture — dependencies point inward |
| One word means different things in different places | DDD bounded contexts |
| One scenario's logic spreads across objects with no place telling its story | DCI — roles cast onto data in a context |

When no symptom matches, reason from the forces in `forces.md`.

## Stances inside the techniques

- Dependencies point inward, but implementation runs outside-in: user-facing layer first, storage decisions last.
- The Entities layer is a concept. A thin domain uses `entities/` with plain objects; `domain/` is for a domain modeled with DDD tactics.
- Context boundaries follow aggregate boundaries. Until the aggregates are clear, context lines are guesses — defer them.
- Each bounded context owns its domain layer. A shared root `domain/` merges what the split separated.
- Split a monolith one context at a time, each step deployable.

## Module type

Decide once per package. It sets the commenting default `/write` follows.

| Module type | Public symbols |
|---|---|
| Application | The source is the documentation |
| Library or shared module | Doc comments state intent and when to reach for it |

## Recording a decision

Match the record's weight to the decision's weight. Propose the record in the report; people write `docs/architecture.md`, so do not write it for them.

| Decision | Record |
|---|---|
| Will recur in this project | Patterns entry in `docs/architecture.md` |
| Sets a project-wide default | Style declaration in `docs/architecture.md` |
| Large blast radius, multi-team, hard to reverse | ADR in `docs/decisions/` |

A Patterns entry is six to ten lines:

```markdown
### <Pattern name in this project's vocabulary>
- **When to apply**: <situation, 1-2 sentences>
- **Shape**: <the structural commitment>
- **Canonical example**: <file path>
- **Forces this resolves**: <dominant forces>
- **Revisit if**: <observable condition>
```
