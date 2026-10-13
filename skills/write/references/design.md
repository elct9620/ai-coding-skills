# Design

Only this project's stances; DDD tactics, schema design, and security practice are known.

## Domain

- Model explicitly only a thick domain: rules spanning objects, objects that change together, or a word with several meanings. A thin domain keeps plain objects.
- Aggregates emerge from use cases: start from the operation, find its invariant, take the smallest set that enforces it. Other aggregates are referenced by ID.
- Variants of one concept share one method signature and take a common context, so callers never switch on type.

## Boundaries

- Describe non-obvious values — status codes, control bytes, enum meaning — at the boundary.
- Keep storage and transport names out of the domain layer.
- Use the framework's auth by default; escalate only when a constraint demands it.
- Security behavior gets tests: rejected input, denied access, enforced boundaries.
