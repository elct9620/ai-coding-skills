---
name: domain-modeling
description: Model business domains using DDD patterns: Entity, Value Object, Aggregate, Domain Event. Use when implementing business logic, defining domain concepts, or designing aggregate boundaries.
---

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| Business logic involved | Feature contains business rules | Pure technical/UI change |
| Domain entity work | Working with entities/aggregates | Infrastructure-only change |
| New business concept | Defining new domain terms | Using existing concepts |
| Complex process modeling | Multi-step business workflow | Simple CRUD operation |

**Apply when**: Any condition passes

## Core Principles

### Building Blocks

| Pattern | Purpose | Characteristics |
|---------|---------|-----------------|
| Entity | Object with identity | Has unique ID, lifecycle, mutable |
| Value Object | Immutable data | No ID, compared by value, immutable |
| Aggregate | Consistency boundary | Root entity + related objects |
| Domain Service | Stateless operations | Logic that doesn't belong to entities |
| Domain Event | Record of something happened | Immutable, past tense naming |

### Pattern Selection Guide

| Question | Entity | Value Object | Aggregate |
|----------|--------|--------------|-----------|
| Has unique identity? | Yes | No | Root has |
| Identity across changes? | Persists | N/A | Root persists |
| How compared? | By ID | By value | By root ID |
| Mutability | Mutable | Immutable | Controlled |
| Consistency boundary? | No | No | Yes |

## Completion Rubric

### Entity Design

| Criterion | Pass | Fail |
|-----------|------|------|
| Unique identifier | Has immutable ID | No identifier or mutable ID |
| Identity immutability | ID unchanged after creation | ID can be modified |
| Business rule encapsulation | Rules inside entity | Logic scattered outside |
| Invariant validation | Validates on state changes | No validation |

### Value Object Design

| Criterion | Pass | Fail |
|-----------|------|------|
| Immutability | Cannot be modified after creation | Has setters or mutable state |
| Value equality | Compared by all attributes | Compared by reference |
| Self-validation | Validates on construction | Accepts invalid state |
| Side-effect free | No external state changes | Has side effects |

### Aggregate Design

| Criterion | Pass | Fail |
|-----------|------|------|
| Clear root | Aggregate root identified | No clear entry point |
| Access control | External access through root only | Direct access to internals |
| Invariant enforcement | Consistency rules enforced | Invariants can be violated |
| Size appropriateness | Small and focused | Too large or unfocused |

### Domain Event Design

| Criterion | Pass | Fail |
|-----------|------|------|
| Past tense naming | Named like `OrderPlaced` | Present/future tense |
| Complete data | Contains all relevant info | Missing important data |
| Immutability | Cannot be changed | Mutable fields |
| Timestamped | Has occurrence time | No timestamp |

## Bounded Context

When modeling, consider:

- **Context boundaries**: Where does this model apply?
- **Ubiquitous language**: Use domain expert terminology
- **Context mapping**: How does this context relate to others?

```
┌──────────────────┐     ┌──────────────────┐
│   Sales Context  │     │  Shipping Context │
│                  │     │                   │
│  Order (Entity)  │────▶│  Shipment (Entity)│
│  Customer (VO)   │     │  Address (VO)     │
└──────────────────┘     └──────────────────┘
```
