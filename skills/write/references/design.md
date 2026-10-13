# Design

`/inspect` settles the strategy: the shape, and which technique applies to which code. This file is the tactics: how code is built inside that shape. SOLID holds under every technique, and techniques combine.

## Building Blocks

| Technique | Building blocks |
|---|---|
| Clean Architecture | Entity, use case, port, adapter, composition root |
| DDD | Entity, value object, aggregate, repository, domain service, domain event |
| DCI | Data, context, role |
| None — a thin domain | Plain objects |

## Stances

- Clean Architecture: build outside-in; define ports where a layer meets a detail; wire everything in one composition root.
- DDD: aggregates emerge from use cases — start from the operation, find its invariant, take the smallest set that enforces it. Reference other aggregates by ID.
- DCI: one context per scenario; the role carries the algorithm; data stays thin.
- Variants of one concept share one method signature and take a common context, so callers never switch on type.

## Boundaries

- Describe non-obvious values — status codes, control bytes, enum meaning — at the boundary.
- Keep storage and transport names out of the domain layer.
- Use the framework's auth by default; escalate only when a constraint demands it.
- Security behavior gets tests: rejected input, denied access, enforced boundaries.
