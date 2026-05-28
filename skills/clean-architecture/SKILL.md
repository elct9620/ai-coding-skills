---
name: clean-architecture
description: Apply Clean Architecture with four concentric layers (Entities, Use Cases, Interface Adapters, Frameworks & Drivers). Use when creating docs/architecture.md, designing new modules, or restructuring code with proper dependency direction. Make sure to use this skill whenever the user discusses layer boundaries, dependency direction, where to put new code, separating business logic from frameworks, or organizing project directory structure around architectural layers.
---

## Related Skills

- Need to move code between layers? → Use **refactoring** for safe migration steps
- Designing the domain layer's internal structure? → Use **domain-modeling** for entities and aggregates
- Defining API contracts or DB schemas at boundaries? → Use **schema**

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| Architecture documentation missing | `docs/architecture.md` not found | File exists |
| Significant structural changes | Feature affects 2+ layers | Single-layer change |
| New module creation | Creating new namespace/directory | Modifying existing |
| Legacy restructuring | Reorganizing unstructured code | Code already layered |

**Apply when**: Any condition passes

## Core Principles

### Layer Structure

```
┌─────────────────────────────────────────────┐
│          Frameworks & Drivers               │  ← Web, DB, Devices, External Interfaces
├─────────────────────────────────────────────┤
│          Interface Adapters                 │  ← Controllers, Presenters, Gateways
├─────────────────────────────────────────────┤
│             Use Cases                       │  ← Application-specific Business Rules
├─────────────────────────────────────────────┤
│             Entities                        │  ← Enterprise-wide Business Rules
└─────────────────────────────────────────────┘
```

### Dependency Rule

Dependencies MUST point inward:
- Frameworks & Drivers → Interface Adapters → Use Cases → Entities
- Entities have NO dependencies on outer layers
- Use interfaces (ports) at layer boundaries for dependency inversion

### Implementation Order: Outside-In

**Dependency direction (inward) and implementation order are independent concepts.** Clean Architecture prescribes that dependencies point inward, but does NOT prescribe starting implementation from the inner layers.

Implement **outside-in** — start from the user-facing layer, work inward:

```
1. User need / acceptance test (E2E or integration)
   ↓
2. Interface Adapter — define controller/presenter shape
   ↓
3. Use Case — discover required application operations, define ports (interfaces)
   ↓
4. Entity — let domain model emerge from use case needs
   ↓
5. Infrastructure — defer database, ORM, and external service decisions until last
```

| Principle | Description |
|-----------|-------------|
| **Defer decisions** | Inner-layer details (schema, ORM mapping, storage engine) should be decided as late as possible |
| **Ports as placeholders** | Define interfaces (ports) at boundaries early; implement adapters last |
| **Emergent domain model** | Let entities and value objects emerge from use case requirements, not upfront design |
| **Test-driven discovery** | Integration tests from the outer layer reveal what inner layers need to provide |

### Layer Responsibilities

| Layer | Contains | Depends On |
|-------|----------|------------|
| Entities | Enterprise-wide business rules, critical business data structures | Nothing |
| Use Cases | Application-specific business rules, input/output port interfaces | Entities |
| Interface Adapters | Controllers, Presenters, Gateways, DTOs, format converters | Use Cases, Entities |
| Frameworks & Drivers | Web framework, DB, external APIs, UI, devices | Interface Adapters |

## Module Type

Pick once per package. Audience determines whether the source is the documentation or whether signatures must carry it.

| Module type | Audience | Public symbols |
|-------------|----------|----------------|
| Application | Operators, end users | Source is the documentation |
| Library / shared module | Other developers via IDE | Signatures carry doc comments stating intent |
| Monorepo with both | Both | Decide per package, not per file |

Feeds the **principles** Commenting rules.

## Entities Layer: Naming and Internal Structure

The Entities layer is a **conceptual layer**, not a specific directory name. Before writing code, decide how the Entities layer will be expressed in the project. This decision depends on one question: **does this system benefit from DDD, or does plain Clean Architecture already model it clearly enough?**

### Do we need DDD on top of CA?

DDD adds vocabulary (Aggregate, Value Object, Bounded Context, Ubiquitous Language) and modelling cost. It pays off when the domain has rich invariants, non-trivial workflows, or multiple teams speaking different languages about the same nouns. It is overhead when the system is mostly CRUD with thin rules.

| Signal | Pure CA is enough | CA + DDD helps |
|--------|-------------------|----------------|
| Business rules | Mostly validation and CRUD | Multi-step invariants, state machines |
| Ubiquitous language | One obvious vocabulary | Same word means different things to different teams |
| Aggregates | Nothing that must change together under a rule | Clear consistency boundaries with enforced invariants |
| Team / scale | Single team, small surface area | Multiple teams or subdomains |
| Change driver | Technical features | Domain experts drive requirements |

When in doubt, start with **pure CA**. Introducing DDD later is a refactor; ripping out premature DDD is a harder refactor because the vocabulary spreads into tests and conversations.

### Three styles, three directory layouts

| Style | When | Entities layer looks like | Example |
|-------|------|---------------------------|---------|
| **Pure CA** | Small system, thin domain, single team | `entities/` holding plain business objects | Internal admin tool, CRUD-heavy API |
| **CA + DDD, single context** | One bounded context, rich invariants | `domain/` holding DDD building blocks (Entity, Value Object, Aggregate) | E-commerce checkout, workflow engine |
| **CA + DDD, multiple contexts** | Distinct subdomains with their own vocabulary | One directory per context (`sales/`, `shipping/`, `billing/`), each with its own domain model | Marketplace platform, ERP |

```
Pure CA                    CA + DDD (single)          CA + DDD (multi-context)
src/                       src/                       src/
├── entities/              ├── domain/                ├── sales/
│   ├── user.rb            │   ├── order.rb           │   ├── domain/
│   └── invoice.rb         │   ├── line_item.rb       │   └── use_cases/
├── use_cases/             │   └── money.rb           ├── shipping/
├── adapters/              ├── use_cases/             │   ├── domain/
└── infrastructure/        ├── adapters/              │   └── use_cases/
                           └── infrastructure/        └── billing/
                                                          ├── domain/
                                                          └── use_cases/
```

**Do not mix the styles by accident.** The most common mistake is defaulting to `domain/` because DDD vocabulary feels more "professional", even when the project has no aggregates and no ubiquitous-language conflicts. If you cannot name an aggregate or an invariant the directory is enforcing, use `entities/` and plain CA — it is not a downgrade, it is the right fit.

When DDD is the right call, use the **domain-modeling** skill to shape the internal structure (Entity vs Value Object, aggregate boundaries, domain events). CA decides *where* the layer lives; DDD decides *what lives inside it*.

## Completion Rubric

### Before Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Layer identification | Target layer explicitly stated | No layer consideration |
| Architecture doc | Created/updated when needed | No documentation |
| Dependency verification | All deps point inward | Outward deps exist |
| Outside-in approach | Start from user need or outer layer | Jump straight to entity/schema design |
| Style selection | Pure CA vs CA+DDD chosen with rationale | Defaulted to `domain/` without checking if DDD is warranted |

### During Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Boundary interfaces | Defined at each layer boundary for dependency inversion | Direct coupling across layers |
| Interface Adapter correctness | Converts data between use case format and external format | Business logic leaking into adapters |
| Use Case isolation | Each use case is a single application operation with clear input/output | Mixed responsibilities or coupled to adapters |
| Entities layer purity | Contains only enterprise business rules, no framework imports | Has framework or application concerns |
| Framework/Driver isolation | External concerns contained in outermost layer | Framework details leaked into inner layers |
| Deferred decisions | Infrastructure details decided after use case shape is clear | Schema or ORM chosen before domain model emerges |

### After Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| No circular deps | Layers have one-way inward deps | Circular references exist |
| Entities testability | Testable without any outer layer dependency | Requires framework or external deps |
| Convention adherence | Follows project patterns | Inconsistent with codebase |

## Before/After Pattern

When explaining layer violations or restructuring, always show both the problematic code (BEFORE) and the corrected code (AFTER). This makes the improvement concrete and reviewable.

### Example: Controller with ORM Leak

**BEFORE** — controller directly uses ORM (Frameworks & Drivers leaking into Interface Adapters):

```ruby
class OrdersController
  def show
    # BAD: ORM query directly in controller
    order = DB[:orders].where(id: params[:id]).join(:line_items, order_id: :id).all
    total = order.sum { |row| row[:price] * row[:quantity] }
    render json: { order: order, total: total }
  end
end
```

**AFTER** — controller depends on interface, ORM isolated in infrastructure:

```ruby
# Use Case layer: defines the port (interface)
class OrderRepository
  def find_with_total(id) = raise NotImplementedError
end

# Infrastructure layer: implements the port
class SqlOrderRepository < OrderRepository
  def find_with_total(id)
    rows = DB[:orders].where(id: id).join(:line_items, order_id: :id).all
    Order.new(rows)  # maps to domain object
  end
end

# Interface Adapter layer: controller uses the port
class OrdersController
  def initialize(order_repo:)
    @order_repo = order_repo
  end

  def show
    order = @order_repo.find_with_total(params[:id])
    render json: OrderPresenter.new(order).as_json
  end
end
```

When demonstrating architectural improvements, the BEFORE block helps the user recognize their current situation, while the AFTER block shows the target. Without BEFORE, the guidance feels abstract.

## Architecture Documentation

If `docs/architecture.md` doesn't exist, create it with:

```markdown
# Architecture Overview

## Layer Structure
[Describe the four layers used in this project: Entities, Use Cases, Interface Adapters, Frameworks & Drivers]

## Directory Mapping
[Map directories to architectural layers]

## Dependency Guidelines
[Document dependency rules: all dependencies point inward, use interfaces at boundaries]
```
