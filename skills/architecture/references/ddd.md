# DDD: partitioning by domain meaning (strategic side)

DDD's strategic side is a technique for the problem where **one model is stretched across meanings that pull apart** — distinct subdomains crammed into a single model, teams tripping over each other's invariants, or the same word ("order", "account") meaning different things to sales, shipping, and billing. It addresses that by partitioning the system along those meanings, so each region keeps one ubiquitous language and one set of consistency boundaries.

This file covers the **strategic / structural** side: how bounded contexts and the domain layer are laid out. The **tactical** side — Entity vs Value Object, aggregate internals, domain events — belongs to **domain-modeling**, and the two are deeply linked: a bounded context's boundary normally aligns with the aggregate boundaries inside it. Knowing the tactical model is what makes the strategic layout obvious, so let domain-modeling establish the aggregate boundaries first, then mirror them here.

## Where DDD sits relative to layering

DDD's structural side is usually applied *on top of* a layered or Clean Architecture skeleton, not as an alternative to it. The layering decides which way dependencies point; DDD decides how the domain layer is partitioned. If the forces also called for an inward dependency rule, read `clean-architecture.md` alongside this.

## Single context vs multiple contexts

| Shape | When the forces point here | Domain layer looks like |
|-------|----------------------------|--------------------------|
| **Single bounded context** | One vocabulary, rich invariants, one team | A `domain/` directory holding the tactical building blocks for that one context |
| **Multiple bounded contexts** | Distinct subdomains, the same word means different things to different teams, separate consistency boundaries | One directory per context (`sales/`, `shipping/`, `billing/`), each with its own domain layer and use cases |

```
Single context             Multiple contexts
src/                        src/
├── domain/                 ├── sales/
│   ├── order.rb            │   ├── domain/
│   ├── line_item.rb        │   └── use_cases/
│   └── money.rb            ├── shipping/
├── use_cases/              │   ├── domain/
├── adapters/               │   └── use_cases/
└── infrastructure/         └── billing/
                                ├── domain/
                                └── use_cases/
```

## Context boundaries follow aggregate boundaries

Do not invent context boundaries independently of the domain model. A bounded context is a region within which one ubiquitous language and one set of aggregate invariants hold. So the partition emerges from the tactical work:

1. **domain-modeling** establishes the aggregates and the invariants each one enforces.
2. Aggregates that change together under a shared language belong to the same context.
3. The directory structure here mirrors that grouping.

This is why strategic structuring can be deferred: until the aggregates are clear, the context lines are guesses. Outside-in development lets them firm up as the model emerges, then the structure is recorded.

## Keep boundaries honest

The contexts exist to enforce separation, so the layout should make it impossible to blur them by accident:

- Give each context its own domain layer rather than a shared root `domain/` that every context reaches into — a shared root re-merges the boundaries the split was meant to create.
- Name directories in each context's own vocabulary, not a generic `models/`, so a reader can tell which rules belong where.

## Migrating into contexts incrementally

Splitting a monolithic model into bounded contexts is incremental work — carve out one context at a time behind its own use cases, verify the seam, then take the next. Recording the chosen partition (and the trigger that would prompt re-splitting) in `docs/architecture.md` keeps later features on the same lines.
