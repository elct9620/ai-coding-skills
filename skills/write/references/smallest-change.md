# Smallest Change

Each item takes the smallest scope that works. Climb the ladder and stop at the first rung that holds. Then say why it fits: a rung you cannot justify is one you stopped at too early.

## Feature ladder

1. Does this need to exist at all? An item the round no longer needs is reported, not built.
2. Does this codebase already have it, including what earlier items in this round just built?
3. Does the language or its standard library do it?
4. Does the framework or platform do it?
5. Does an installed dependency do it? A new dependency is not this rung; weigh it at rung 7.
6. Can it be one line?
7. Write the minimum that works.

Answer rungs 3 to 5 from the official documentation and from how this codebase already uses the thing.

## Defect location

A report names a symptom; the cause can live elsewhere.

1. Trace from the symptom to the function that produces it.
2. Search for every caller of that function.
3. If several callers reach the same broken behavior, fix the shared function once.
4. If the callers really differ, fix the wrong one and say why the others differ.

## Refactoring order

How much a technique disturbs is a property of the technique. Take the lowest radius that resolves the item.

| Radius | Technique | Disturbs |
|---|---|---|
| 1 | Remove Dead Code | Nothing — after every caller was searched for |
| 2 | Replace Magic Number | Literals in one file |
| 3 | Simplify Conditional | The inside of one method |
| 4 | Replace with Existing | One block, now calling what the codebase already names |
| 5 | Rename | Every call site, mechanically |
| 6 | Extract Method | Adds one named thing |
| 7 | Extract Class | Adds a file; callers may follow |
| 8 | Extract Interface | Every type declaration |
| 9 | Replace Conditional with Polymorphism | Several new types; the branch leaves every caller |
| 10 | Inject Dependency | Every construction site |
| 11 | Move Method | Two classes and the dependency between them |
| 12 | Replace Inheritance with Delegation | The chain and every caller relying on it |

- Existing means something this codebase names. Rewriting a working loop into a builtin reuses nothing; it is churn when no item asks for it.
- A comment that restates its code, or explains an earlier wrong attempt, is dead code at radius 1.
- From radius 11, check the target respects the recorded structure: dependencies point inward.
- Grow by small steps, each one green. A plan that needs a big-bang rewrite is cut wrong.

## Semantic contract

A refactor keeps more than the signature. Callers rely on:

- What a return value promises happened.
- Whether effects are visible when the call returns.
- Which side effects are committed at return.
- How failure surfaces: exception, false, partial result, retry.
- Ordering, atomicity, and delivery guarantees.

When any of these must change, it is a behavior change: rename, change the type, or migrate callers in the open.
