---
name: domain-modeling
description: Model business domains using DDD patterns: Entity, Value Object, Aggregate, Domain Event. Use when implementing business logic, defining domain concepts, or designing aggregate boundaries. Make sure to use this skill whenever the user works on business rules, creates domain objects, discusses bounded contexts, models workflows or processes, or asks about entity vs value object distinctions — even for simple CRUD features that involve domain invariants.
---

## Related Skills

- Need to persist domain objects? → Use **schema** for database table design
- Deciding how to structure classes around patterns? → Use **design-patterns**
- Domain model needs to live in a specific layer? → Use **clean-architecture** for placement

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

### Snapshot vs Reference

When embedding data from another aggregate, decide: do you need the **current** value or the value **at the time of the action**?

| Strategy | When | Example |
|----------|------|---------|
| **Reference (by ID)** | Always need current data | `Order.customerId` → look up current customer |
| **Snapshot (copy as VO)** | Need historical accuracy | `Order.shippingAddress` → address at time of order |

Snapshots are Value Objects embedded in the aggregate. They never change even if the source changes later. Use snapshots for anything that affects business correctness if it were to change retroactively (prices, addresses, terms).

### Polymorphic Value Objects

When multiple Value Objects share a common concept (e.g., different discount types, different address formats), they must all implement the **same method signature**. The calling code should never need to type-check or use case/switch statements — polymorphism handles dispatch.

| Principle | Right | Wrong |
|-----------|-------|-------|
| Same interface | All types implement `compute(context)` | Different methods per type |
| No type checking | Call `discount.compute(order)` directly | `case discount.class` dispatch |
| Uniform parameters | Pass a common context object | Each type needs different args |
| Open for extension | New type = new class, no caller changes | New type = modify case statement |

When different Value Object variants need different data to operate (e.g., a percentage discount needs the order total, but a BOGO discount needs line items), design the interface to accept a context that contains all relevant data. Each implementation extracts what it needs:

```ruby
# All discount types implement the same interface
class PercentageDiscount
  def compute(order)
    order.subtotal * (rate / 100.0)
  end
end

class BuyOneGetOneFreeDiscount
  def compute(order)
    # Same interface — extracts line items from the order context
    eligible = order.line_items.select { |li| li.product_id == product_id }
    eligible.sum { |li| (li.quantity / 2) * li.unit_price.amount }
  end
end

# Caller — no case statement, no type checking
class Order
  def apply_discount(discount)
    @discount_amount = discount.compute(self)
  end
end
```

### Implementation Examples

**Value Object** — immutable, validated at construction, compared by value:

```ruby
class Money
  attr_reader :amount, :currency

  def initialize(amount, currency)
    raise ArgumentError, "amount must be positive" if amount < 0
    raise ArgumentError, "currency required" if currency.nil?
    @amount = amount.freeze
    @currency = currency.freeze
    freeze
  end

  def ==(other)
    amount == other.amount && currency == other.currency
  end

  def +(other)
    raise "currency mismatch" unless currency == other.currency
    Money.new(amount + other.amount, currency)
  end
end
```

**Entity** — has identity, encapsulates business rules:

```ruby
class LineItem
  attr_reader :id, :product_id, :quantity, :unit_price

  def initialize(id:, product_id:, quantity:, unit_price:)
    raise ArgumentError, "quantity must be positive" if quantity <= 0
    @id = id
    @product_id = product_id
    @quantity = quantity
    @unit_price = unit_price
  end

  def subtotal
    Money.new(unit_price.amount * quantity, unit_price.currency)
  end

  def ==(other)
    id == other.id  # compared by identity, not value
  end
end
```

**Domain Event** — immutable record of what happened:

```ruby
class OrderPlaced
  attr_reader :order_id, :customer_id, :total_amount, :occurred_at

  def initialize(order_id:, customer_id:, total_amount:, occurred_at: Time.now)
    @order_id = order_id
    @customer_id = customer_id
    @total_amount = total_amount
    @occurred_at = occurred_at
    freeze
  end
end
```

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

## Aggregate Design Steps

Aggregates are the hardest part to get right. Let them **emerge from use case requirements** rather than designing them upfront:

1. **Start from the use case** — What operation does the user need to perform?
2. **Discover the invariant** — What business rule must hold true for this operation to succeed?
3. **Find the minimum boundary** — What's the smallest set of objects needed to enforce it?
4. **Choose the root** — Which entity is the entry point for all modifications?
5. **Reference other aggregates by ID only** — Never hold direct object references across aggregate boundaries

Aggregate boundaries should be **discovered incrementally** as use cases reveal which objects must change together. Avoid designing the full aggregate structure before writing the first test.

### Aggregate Sizing Heuristic

| Sign | Too Large | Too Small |
|------|-----------|-----------|
| Performance | Loading is slow, locks contend | Invariants broken because data is split |
| Consistency | Transactions are long | Need distributed transactions |
| Change frequency | Unrelated changes conflict | Related changes require coordination |

**Rule of thumb**: If two objects must change together to maintain a business rule, they belong in the same aggregate. If they can change independently, they belong in separate aggregates linked by ID.

### Example: Order Aggregate

```
Order (Aggregate Root)
├── OrderId (Value Object)
├── LineItem[] (Entity - has identity within Order)
│   ├── ProductId (Value Object - reference by ID, not object)
│   ├── Quantity (Value Object)
│   └── Price (Value Object - captured at order time)
├── Money totalAmount (Value Object)
└── OrderStatus (Value Object)

Invariant: totalAmount == sum(lineItems.map(price * quantity))
Invariant: at least one LineItem required
```

Why this boundary?
- LineItems must be inside Order because the total invariant depends on them
- Product is outside — referenced by ID — because it can change independently
- Customer is outside — referenced by ID — an Order doesn't need to enforce Customer rules

## Bounded Context

Bounded Contexts define where a model applies. The same real-world concept may have different representations in different contexts.

### Context Mapping Patterns

| Pattern | When to Use | Example |
|---------|-------------|---------|
| Shared Kernel | Two teams co-own a small model | Shared `Money` type |
| Customer-Supplier | Upstream serves downstream | Order context feeds Shipping context |
| Anti-Corruption Layer | Protect from external model leaking in | Wrap third-party payment API |
| Published Language | Contexts communicate via standard format | Domain Events as JSON |

### Example: Same Concept, Different Models

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Sales Context  │     │  Shipping Context │     │  Billing Context  │
│                  │     │                   │     │                   │
│  Customer:       │     │  Recipient:       │     │  Payer:           │
│   - name         │     │   - name          │     │   - name          │
│   - email        │     │   - address       │     │   - paymentMethod │
│   - preferences  │     │   - phone         │     │   - billingAddress│
└──────────────────┘     └──────────────────┘     └──────────────────┘
```

"Customer" in Sales cares about preferences, in Shipping it's a "Recipient" with an address, in Billing it's a "Payer" with payment info. Don't force one model to serve all contexts.

### Directory Structure

Each bounded context maps to its own directory or package. A shared `domain/` directory blurs the boundaries that contexts exist to enforce — keep them separate so the compiler or module system catches cross-context coupling.

| Principle | Right | Wrong |
|-----------|-------|-------|
| One context per directory | `sales/`, `shipping/` | `domain/` with all contexts mixed |
| Context name as directory | Directory named after the context | Generic `domain/`, `models/`, `entities/` |

**Single-context projects** are the exception — when the entire application lives within one bounded context, a single directory for the domain layer is fine (this is the typical Clean Architecture scenario).

### Migrating from Monolith to Bounded Contexts

Splitting a monolithic model into bounded contexts is incremental work. Don't try to do it all at once.

1. **Identify seams** — Find groups of fields that change together and are used by the same team or feature
2. **Introduce a facade** — Keep the monolithic model but add context-specific interfaces on top of it
3. **Extract one context at a time** — Move the simplest, most independent context out first
4. **Use events for synchronization** — Contexts that used to share a database row now communicate via domain events
5. **Retire the monolith** — Once all contexts are extracted, remove the original model

```
Step 1: Monolith           Step 2: Facades          Step 3: Extract
┌─────────────┐         ┌──────────────────┐     ┌────────┐ ┌────────┐
│    User      │         │ ProfileFacade    │     │Profile │ │  Auth  │
│ - name       │   →     │ AuthFacade       │  →  │Context │ │Context │
│ - email      │         │ BillingFacade    │     └────────┘ └────────┘
│ - password   │         │   ↓ delegates    │     ┌────────┐
│ - card_info  │         │   User (legacy)  │     │Billing │
│ - prefs      │         └──────────────────┘     │Context │
└─────────────┘                                   └────────┘
```

**Key rule**: Each step should be independently deployable and testable. If a step requires a big-bang migration, the boundary is in the wrong place.

## Domain Event Patterns

Domain Events capture side effects and enable loose coupling between aggregates and contexts.

### When to Raise Events

| Situation | Event | Why |
|-----------|-------|-----|
| State transition | `OrderPlaced`, `OrderCancelled` | Other contexts need to react |
| Business milestone | `PaymentReceived` | Triggers downstream workflows |
| Policy decision | `CreditLimitExceeded` | Audit trail and notifications |

### Event Flow

```
Order.place()
  → raises OrderPlaced { orderId, customerId, items[], totalAmount, occurredAt }
    → Shipping context: creates Shipment
    → Billing context: initiates payment
    → Notification context: sends confirmation email
```

Each context handles the event independently — if Shipping fails, it doesn't roll back the Order.
