---
name: schema
description: Design database schemas and API contracts at system boundaries. Use when creating or modifying database tables, API endpoints, or data serialization formats.
---

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| Database structure change | Adding/modifying tables, columns, or indexes | No persistence changes |
| API contract work | Designing or changing request/response shapes | No API boundary changes |
| Data boundary crossing | Serialization/deserialization between layers | Data stays within single layer |
| Schema restructuring | Normalizing, denormalizing, or optimizing existing schemas | No structural changes needed |

**Apply when**: Any condition passes

## Core Principles

### Schema Design Principles

| Principle | Description | Violation Sign |
|-----------|-------------|----------------|
| Single Source of Truth | Each fact stored exactly once | Same data duplicated across tables without clear denormalization rationale |
| Explicit Contracts | API shapes and DB schemas defined clearly | Implicit structures, untyped fields, or missing documentation |
| Boundary Alignment | Schema matches system boundary responsibilities | Schema leaks internal details or couples unrelated concerns |
| Minimal Exposure | Expose only what consumers need | Internal fields visible in API responses, over-fetching by default |

### Schema Types

| Type | Clean Architecture Layer | Purpose | Boundary with Domain Modeling |
|------|--------------------------|---------|-------------------------------|
| Database Schema | Infrastructure | Persist and query data efficiently | Translates domain entities into storage format |
| API Contract | Interface Adapters | Define external communication shape | Maps domain output to external representation |
| DTO | Interface Adapters | Transfer data between layers | Decouples domain model from transport format |

### Database Schema Decisions

#### Normalization vs. Denormalization

| Factor | Normalize | Denormalize |
|--------|-----------|-------------|
| Write frequency | High writes, frequent updates | Read-heavy, rare updates |
| Data consistency | Critical consistency required | Eventual consistency acceptable |
| Query complexity | Simple joins acceptable | Complex joins causing performance issues |
| Storage | Minimize redundancy | Trade storage for speed |

#### Index Selection Guide

| Scenario | Index Type | When to Use |
|----------|------------|-------------|
| Exact lookups | B-tree (default) | Primary keys, foreign keys, unique constraints |
| Text search | Full-text / GIN | Search within text content |
| Range queries | B-tree | Date ranges, numeric ranges |
| Multi-column filter | Composite | Frequently queried column combinations |

### API Contract Design

#### Resource Design Principles

| Principle | Description |
|-----------|-------------|
| Resource-oriented | Model endpoints around resources, not actions |
| Consistent naming | Use plural nouns, consistent casing conventions |
| Proper status codes | Match HTTP status codes to outcomes |
| Pagination | Always paginate collection endpoints |
| Error format | Consistent error response structure across all endpoints |

#### Versioning Strategy

| Strategy | Pros | Cons | Best For |
|----------|------|------|----------|
| URL path (`/v1/`) | Simple, explicit | URL pollution | Public APIs with clear major versions |
| Header-based | Clean URLs | Less discoverable | Internal APIs with frequent changes |
| Query parameter | Easy to test | Caching complexity | Transitional versioning |

### Schema vs. Domain Modeling

| Aspect | Schema (this skill) | Domain Modeling |
|--------|---------------------|-----------------|
| Focus | Data structure at boundaries | Business concepts and rules |
| Layer | Infrastructure / Interface Adapters | Domain (Entities) |
| Artifacts | Tables, columns, indexes, API contracts, DTOs | Entities, Value Objects, Aggregates |
| Question answered | How is data stored and transmitted? | What are the business rules and concepts? |

## Completion Rubric

### Before

| Criterion | Pass | Fail |
|-----------|------|------|
| Purpose confirmed | Schema purpose and consumers identified | Unclear who uses this schema or why |
| Existing structure reviewed | Current schema/contracts examined | Designing without knowing existing state |
| Naming convention | Follows project naming conventions | Inconsistent or arbitrary naming |
| Backward compatibility | Breaking changes identified and planned | Unaware of downstream impact |

### During

| Criterion | Pass | Fail |
|-----------|------|------|
| Domain model independence | Schema can change without altering domain | Domain entities shaped by storage format |
| Constraint correctness | NOT NULL, foreign keys, unique constraints match business rules | Missing constraints or overly permissive schema |
| Contract completeness | All required fields, types, and validation documented | Partial or ambiguous contract definition |
| Minimal exposure | Only necessary fields exposed to consumers | Internal details leaked through API or schema |

### After

| Criterion | Pass | Fail |
|-----------|------|------|
| Contract verified | API contracts tested with request/response examples | No contract verification |
| No domain leakage | Storage/transport details absent from domain layer | Domain layer references DB columns or API fields |
| Documentation updated | Schema changes reflected in docs/migrations | Undocumented schema changes |
