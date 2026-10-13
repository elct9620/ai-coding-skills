# Smallest Change

Climb and stop at the first rung that holds, then say why it fits. A rung you cannot justify is one you stopped at too early.

## Feature Ladder

1. Does this need to exist at all?
2. Does this codebase already have it, including what this round just built?
3. Does the language or its standard library do it?
4. Does the framework or platform do it?
5. Does an installed dependency do it? A new dependency is weighed at rung 7.
6. Can it be one line?
7. Write the minimum that works.

## Defect Location

Trace the symptom to the function that produces it, then search every caller. When several callers reach the same broken behavior, fix the shared function once.

## Refactoring Order

Take the lowest radius that resolves the item.

| Radius | Technique |
|---|---|
| 1 | Remove Dead Code — after every caller was searched for |
| 2 | Replace Magic Number |
| 3 | Simplify Conditional |
| 4 | Replace with Existing — something this codebase already names |
| 5 | Rename |
| 6 | Extract Method |
| 7 | Extract Class |
| 8 | Extract Interface |
| 9 | Replace Conditional with Polymorphism |
| 10 | Inject Dependency |
| 11 | Move Method |
| 12 | Replace Inheritance with Delegation |

## Before Refactoring

- Check the item still stands; an earlier item may have dissolved it.
- Check `git log`; leave what was changed deliberately or recently.
- Identify each class's layer before calling a smell. A Use Case reading Entity data is not Feature Envy.
- Rewriting working code into a builtin is churn when no item asks for it.

## Semantic Contract

A refactor keeps what callers rely on: what a return value promises, when effects become visible, which side effects are committed at return, how failure surfaces, and ordering or delivery guarantees. When any of these must change, it is a behavior change.
