# Naming

A name is right when its call site reads as a phrase: `player.name`, `player.attack(target)`. Then a comment adds nothing, so leave it out.

## Order

1. Follow the convention: the language, the framework, then the project's own convention document or the same module's names. Keep a name another side fixes exactly as it is spelled.
2. Let the role pick the word class.
3. Read it at the call site.

## Sources

| Source | Brings |
|---|---|
| Swift API Design Guidelines | Clarity at the point of use; side effects as verb phrases, others as noun phrases; Booleans as assertions; role over type |
| Clean Code, chapter 2 | Intention-revealing; no disinformation or noise words; one word per concept; length follows scope |
| Rust API Guidelines | Conversions with `as_`, `to_`, `into_`; no `get_`; consistent word order |

## Participles

A bare `-ed` or `-ing` hides the role: a reader cannot tell a query from a question or an action. Use one only after a verb (`release_queued`), beside a noun (`running_router`, `StepFailed`), as a field or variable recording a state (`expired`, `reviewed`), as an enum state (`Running`), as a dictionary noun (`heading`), or where a convention fixes it (`sorted()` in Swift).

## Contexts

Each context uses its own words. The same real-world thing takes the name of its role there — a `Customer` in sales, a `Recipient` in shipping.
