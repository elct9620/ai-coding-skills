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

### Layer Responsibilities

| Layer | Contains | Depends On |
|-------|----------|------------|
| Entities | Enterprise-wide business rules, critical business data structures | Nothing |
| Use Cases | Application-specific business rules, input/output port interfaces | Entities |
| Interface Adapters | Controllers, Presenters, Gateways, DTOs, format converters | Use Cases, Entities |
| Frameworks & Drivers | Web framework, DB, external APIs, UI, devices | Interface Adapters |

## Completion Rubric

### Before Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Layer identification | Target layer explicitly stated | No layer consideration |
| Architecture doc | Created/updated when needed | No documentation |
| Dependency verification | All deps point inward | Outward deps exist |

### During Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Entities layer purity | Contains only enterprise business rules, no framework imports | Has framework or application concerns |
| Use Case isolation | Each use case is a single application operation with clear input/output | Mixed responsibilities or coupled to adapters |
| Interface Adapter correctness | Converts data between use case format and external format | Business logic leaking into adapters |
| Framework/Driver isolation | External concerns contained in outermost layer | Framework details leaked into inner layers |
| Boundary interfaces | Defined at each layer boundary for dependency inversion | Direct coupling across layers |

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
