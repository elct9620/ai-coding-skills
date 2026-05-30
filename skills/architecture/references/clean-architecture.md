# Clean Architecture

Clean Architecture is a technique for taming **change amplification** — the situation where touching the framework, the database, or one module keeps forcing edits elsewhere, so a small change ripples out and breaks code other people depend on. It addresses that by controlling which way dependencies point: every dependency points inward toward the stable business rules, so volatile outer details (web, DB, delivery mechanism) can change without dragging the core with them. The cost is the indirection of ports and adapters, so it pays off when that volatility is real and the isolation is recoverable.

It decides *where* code lives and which way dependencies point — not what the domain objects are (**domain-modeling**) nor which local pattern solves a recurring problem (**design-patterns**).

## Layer Structure

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

## Dependency Rule

Dependencies point inward:
- Frameworks & Drivers → Interface Adapters → Use Cases → Entities
- Entities have no dependencies on outer layers
- Use interfaces (ports) at layer boundaries for dependency inversion

## Implementation Order: Outside-In

**Dependency direction (inward) and implementation order are independent concepts.** Clean Architecture prescribes that dependencies point inward, but does not prescribe starting implementation from the inner layers.

Implement outside-in — start from the user-facing layer, work inward:

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

## Layer Responsibilities

| Layer | Contains | Depends On |
|-------|----------|------------|
| Entities | Enterprise-wide business rules, critical business data structures | Nothing |
| Use Cases | Application-specific business rules, input/output port interfaces | Entities |
| Interface Adapters | Controllers, Presenters, Gateways, DTOs, format converters | Use Cases, Entities |
| Frameworks & Drivers | Web framework, DB, external APIs, UI, devices | Interface Adapters |

## Naming the Entities Layer

The Entities layer is a **conceptual layer**, not a fixed directory name. How it is expressed depends on whether the domain is thick enough to warrant DDD's tactical vocabulary:

- Thin domain (mostly validation and CRUD) → `entities/` holding plain business objects. This is not a downgrade; it is the right fit when there is no aggregate or invariant a richer structure would enforce.
- Thick domain (multi-step invariants, consistency boundaries) → consider **DDD**'s approach for partitioning the layer's internals, and **domain-modeling** for the tactical building blocks (Entity, Value Object, Aggregate). CA decides *where* the layer lives; domain modelling decides *what lives inside it*.

## Before/After: showing a layer violation

When explaining a layer violation or restructuring, show both the problematic code (BEFORE) and the corrected code (AFTER). Without the BEFORE, the guidance feels abstract; the reader can't recognise their own situation in it.

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

**AFTER** — controller depends on a port, ORM isolated in infrastructure:

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

## Application checks

| Criterion | Pass |
|-----------|------|
| Dependency direction | All dependencies point inward; no outward references |
| Boundary interfaces | Ports defined at each layer boundary for dependency inversion |
| Interface Adapter correctness | Converts data between use-case format and external format; no business logic |
| Use Case isolation | Each use case is a single application operation with clear input/output |
| Entities purity | Only enterprise business rules; no framework imports |
| Deferred decisions | Infrastructure details decided after use-case shape is clear |
| Entities testability | Testable without any outer-layer dependency |
