# Naming

Names are where shape becomes visible: a reader learns the structure from the words before reading any logic. Ubiquitous Language, intent-revealing names, and the language's own naming conventions are known. This file holds the checks this project applies.

## Checks

| Check | Holds when |
|---|---|
| One word, one meaning | A word names one concept across the scope; a second meaning gets a second word |
| One meaning, one word | One concept carries one name; synonyms for it are findings |
| Matches the codebase | The name follows how the surrounding code already names the same kind of thing |
| Carries the intent | A reader learns why it exists from the name; a comment restating the code means the name falls short |
| Vocabulary of its context | Directories and types use their context's words, not `models/`, `utils/`, `manager` |

## Concepts across contexts

The same real-world thing gets a different name where it plays a different role. Sales has a `Customer`, Shipping a `Recipient`, Billing a `Payer`. Forcing one name onto all three hides the boundary between them.

## Shapes in names

- A domain event is a past-tense fact: `OrderPlaced`, `PaymentReceived`.
- `domain/` signals DDD tactics; a thin domain uses `entities/`.
- A pattern name in a type (`Strategy`, `Factory`) is earned only when the pattern is really there.

## Severity

A name that departs from the codebase and will be copied is Med: the next feature follows it. A name that misleads about behavior — `save` that also sends mail — is High when it hides a promise the goal relies on.
