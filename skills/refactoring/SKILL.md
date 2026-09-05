---
name: refactoring
description: Safely restructure code without changing behavior using Extract Method, Rename, Move Method techniques. Use when preparing code for new features, improving code quality incrementally, cleaning up messy code, reducing duplication, or simplifying complex logic. Make sure to use this skill whenever the user mentions refactoring, cleaning up code, making code more readable, splitting large files or methods, or removing code smells.
---

## Related Skills

- Facing a design trade-off (DRY vs KISS)? → Use **principles** first to decide, then refactor
- Code is in the wrong architectural layer? → Use **architecture** to identify target, then refactor to move it
- Need to choose a pattern (Strategy, Factory)? → Use **design-patterns** first, then refactor toward it
- No tests before refactoring? → Use **testing** to add them first

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| Existing code modification | Need to change existing code | Writing new code only |
| Code comprehension issues | Code hard to understand/extend | Code is clear |
| Feature preparation | Preparing for new functionality | Direct implementation possible |
| Incremental improvement | Improving quality step by step | No improvement needed |

**Apply when**: Any condition passes

## Core Principles

### The Refactoring Cycle

```
1. Ensure tests exist (or add them)
   ↓
2. Make small change
   ↓
3. Run tests
   ↓
4. Commit if green
   ↓
5. Repeat
```

### Golden Rules

- **Never refactor and change behavior simultaneously**
- **Always have tests before refactoring**
- **Small steps, frequent commits**
- **If tests fail, revert immediately**
- **Never rewrite from scratch** — a big-bang rewrite throws away years of bug fixes and domain knowledge. Instead, extract one piece at a time, test it, and ship it. If your refactoring plan requires "stop the world and replace everything," the plan is wrong — break it into smaller incremental steps.

### Preserve the Semantic Contract, Not Just the Signature

Behavior is more than the type signature. A change that leaves names and types untouched can still alter what a return value promises, when effects become observable, or how failures are reported. If callers would need to reason differently about the function after the change, it is a behavior change rather than a refactor, even when the compiler is satisfied.

The semantic contract includes at least:

- Meaning of return values and out-parameters — what a given value promises happened.
- Completion timing — whether effects are visible by the time the call returns (sync vs. deferred/async).
- Observable side effects at return — which external state has been committed before returning.
- Error model — how failure is surfaced (exception, false, partial result, retried later).
- Ordering, atomicity, and delivery guarantees — all-or-nothing vs. partial, exactly-once vs. at-least-once, and similar.

If any of these shift, update the contract explicitly (rename, change return type, document the new guarantee, migrate callers) rather than hiding the change inside a refactor.

## Common Refactoring Techniques

### Blast Radius

How much a technique disturbs is a property of the technique, not of the situation it is used in. Read in this order, the cheapest technique that actually solves the problem is found before the expensive ones are considered — which is the difference between a change someone can review and a change they have to take on trust.

| Radius | Technique | What it disturbs |
|--------|-----------|------------------|
| 1 | Remove Dead Code | Nothing — provided every caller was searched for and none exists |
| 2 | Replace Magic Number | Literals inside one file; no caller sees a difference |
| 3 | Simplify Conditional | The inside of one method; no boundary is crossed |
| 4 | Replace with Existing | The block itself, which starts calling something this codebase already names |
| 5 | Rename | Every call site, but mechanically and with no behavioural surface |
| 6 | Extract Method | Adds one named thing; callers unchanged |
| 7 | Extract Class | Adds a file; the original class's callers may follow |
| 8 | Extract Interface | Adds a file and touches every type declaration |
| 9 | Replace Conditional with Polymorphism | Adds several types; the branch leaves every caller |
| 10 | Inject Dependency | Every construction site |
| 11 | Move Method | Two classes, and the dependency direction between them |
| 12 | Replace Inheritance with Delegation | The inheritance chain and every caller that relied on it |

**Existing** means a thing this codebase already names — a helper, a method, a class someone can go and read. Rewriting a working loop into a language builtin reuses nothing and names nothing new; it is a rewrite, and a rewrite of code that no item on the list complains about is churn however idiomatic the result reads. Code that merely could have been written another way is not a defect, so it belongs on no rung — note it and leave it.

Radius 1 is where a comment that restates its code belongs, and where a comment explaining why an earlier attempt was wrong belongs: correct code is its own evidence, so the explanation is residue of how it got here rather than a statement of what is now true.

The tables below group the same techniques by kind, which is what to read once the radius has narrowed the field.

### Code Organization

| Technique | When to Use | Before → After |
|-----------|-------------|----------------|
| Extract Method | Long method, repeated code | Inline code → Named method |
| Extract Class | Class has multiple responsibilities | One class → Two classes |
| Move Method | Method uses another class more | A.method() → B.method() |
| Rename | Name doesn't reveal intent | `d` → `elapsedDays` |
| Replace with Existing | This codebase already names something that does it | Hand-rolled block → call to what is already here |

### Simplification

| Technique | When to Use | Before → After |
|-----------|-------------|----------------|
| Replace Conditional with Polymorphism | Type-based switching | if/switch → Subclasses |
| Replace Magic Number | Unexplained literals | `86400` → `SECONDS_PER_DAY` |
| Remove Dead Code | Unused code | Code → Nothing |
| Simplify Conditional | Complex boolean logic | Nested ifs → Guard clauses |

### Dealing with Dependencies

| Technique | When to Use | Before → After |
|-----------|-------------|----------------|
| Extract Interface | Need to mock or swap | Concrete → Interface + Concrete |
| Inject Dependency | Hard-coded dependency | `new Dep()` → Constructor param |
| Replace Inheritance with Delegation | Inheritance misused | extends → has-a |

## Safe Refactoring Steps

### Extract Method

1. Identify code to extract
2. Create new method with descriptive name
3. Copy code to new method
4. Replace original code with method call
5. Run tests
6. Commit

### Rename

1. Find all usages
2. Rename (use IDE refactoring if available)
3. Remove comments the new name has made redundant
4. Run tests
5. Commit

### Move Method

1. Copy method to target class
2. Adjust for new context
3. Update original to delegate
4. Run tests
5. Remove original method
6. Run tests
7. Commit

## Completion Rubric

### Before Refactoring

| Criterion | Pass | Fail |
|-----------|------|------|
| Test coverage | Tests exist and pass | No tests or failing tests |
| Behavior understanding | Current behavior understood | Unclear behavior |
| Clear goal | Refactoring goal defined | No clear objective |
| Team awareness | Team knows the scope | Undisclosed changes |

### During Refactoring

| Criterion | Pass | Fail |
|-----------|------|------|
| Single focus | One refactoring at a time | Multiple simultaneous changes |
| Test validation | Tests run after each change | No test verification |
| Incremental commits | Commit after each step | Large uncommitted changes |
| Behavior preservation | Return-value meaning, completion timing, side-effect ordering, and error model all unchanged | Semantic contract shifted even though the signature stayed the same |

### After Refactoring

| Criterion | Pass | Fail |
|-----------|------|------|
| Tests passing | All tests still pass | Tests failing |
| Code clarity | Code is cleaner/clearer | Same or worse clarity |
| No new features | No functionality added | Features added |
| Review completed | Changes reviewed | No review |

## Code Smells to Watch For

| Smell | Signal | Refactoring |
|-------|--------|-------------|
| Long Method | Hard to describe in one sentence | Extract Method |
| Large Class | Multiple unrelated responsibilities | Extract Class |
| Long Parameter List | Parameters that always travel together | Introduce Parameter Object |
| Duplicated Code | Same logic in multiple places | Extract Method/Class |
| Feature Envy | Method uses another class's data more than its own | Move Method |
| Data Clumps | Same data groups appear together | Extract Class |
| Explanatory Comment | Comment restates the code in prose | Extract Method with an intent-revealing name |
