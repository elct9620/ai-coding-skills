# Domain

DDD tactical design — Entity, Value Object, Aggregate, Domain Service, Domain Event — is known. This file holds when to use it and the stances this project takes.

## Thick or thin

Model explicitly only when the domain is thick: rules span several fields or objects, objects must change together, or a word means different things to different teams. A thin, CRUD-shaped domain keeps plain objects in `entities/`; the tactical vocabulary there is overhead.

## Aggregates emerge

Let aggregates come from use cases, not from upfront design.

1. Start from the operation the user performs.
2. Find the invariant that must hold for it.
3. Take the smallest set of objects that enforces it.
4. Choose the root every change goes through.
5. Reference other aggregates by ID only.

Objects that must change together for a rule share an aggregate. Objects that change independently are separate aggregates linked by ID.

## Snapshot or reference

| Need | Use | Example |
|---|---|---|
| The current value | Reference by ID | `Order.customer_id` |
| The value at the time of the action | Snapshot as a Value Object | `Order.shipping_address`, price at order time |

Snapshot anything whose retroactive change would break business correctness.

## Polymorphic Value Objects

Variants of one concept share one method signature, so callers never switch on type. When variants need different data, pass a context that holds all of it and let each variant take what it needs:

```ruby
class PercentageDiscount
  def compute(order) = order.subtotal * (rate / 100.0)
end

class BuyOneGetOneFree
  def compute(order) = order.line_items.select { _1.product_id == product_id }.sum { (_1.quantity / 2) * _1.unit_price }
end
```

## Events

A domain event is an immutable past-tense fact with its occurrence time. Each context handles it on its own; a failure downstream does not roll back the source.
