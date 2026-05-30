# DCI: Data, Context, Interaction

DCI is a technique for the problem where **use-case behaviour is scattered and hard to follow** — the logic of one scenario spans several objects with no single place that tells its story, or data classes bloat because every use case piles its methods onto them. It addresses that by separating the slow-changing data model from the fast-changing behaviour of use cases, expressing behaviour as **roles** cast onto data objects within a **context**.

DCI (Data, Context, Interaction — Trygve Reenskaug and James Coplien) decides how behaviour is laid out — not what the domain objects are (**domain-modeling**) nor which micro-pattern solves a local problem (**design-patterns**).

## The three parts

| Part | Holds | Changes |
|------|-------|---------|
| **Data** | What the system *is* — the relatively dumb domain objects and their persistent state | Slowly |
| **Context** | A single use-case scenario; assigns roles to the data objects and runs the interaction | Per use-case |
| **Interaction** | What the system *does* — the behaviour, expressed as **roles** that are cast onto data objects for the duration of a context | With requirements |

The key move is that behaviour lives in **roles**, not in the data classes. A data object plays a role only while a context is executing; the role carries the algorithm. This keeps the data model thin and stable while use-case behaviour stays grouped by scenario where a reader can follow it end to end.

## When the forces favour DCI

- Behaviour is **scenario-shaped**: a request reads as a story spanning several objects (transfer money: source account, destination account, the transfer rule between them), and you want that story in one place.
- The same data objects participate in **many use-cases** playing different roles, and piling every role's methods onto the data class would bloat it.
- The team thinks in terms of **what happens** (interactions, mental model of the running system) more than **what exists** (a taxonomy of types).

When behaviour is thin and CRUD-like, DCI is overhead — the context layer adds indirection with little to organise. When the hard part is consistency invariants rather than scenario behaviour, DDD aggregates fit better.

## Shape

```
src/
├── data/                  # dumb-ish domain objects + persistent state
│   ├── account.rb
│   └── customer.rb
├── contexts/              # one per use-case scenario
│   ├── money_transfer.rb  # assigns roles, runs the interaction
│   └── account_opening.rb
└── roles/                 # behaviour cast onto data within a context
    ├── source_account.rb
    └── destination_account.rb
```

The context is the entry point for a use-case: it selects the data objects, casts the roles onto them, and triggers the interaction. Roles hold the algorithm; data holds the state.

## Relationship to layering

A context maps naturally onto a Clean Architecture use case, and DCI's data objects onto the entities layer. If the forces also called for an inward dependency rule, the two compose: read `clean-architecture.md` for the dependency direction and keep contexts/roles as the use-case-layer expression of behaviour.
