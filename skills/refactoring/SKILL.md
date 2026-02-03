---
name: refactoring
description: Safely restructure code without changing behavior using Extract Method, Rename, Move Method techniques. Use when preparing code for new features or improving code quality incrementally.
---

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

## Common Refactoring Techniques

### Code Organization

| Technique | When to Use | Before → After |
|-----------|-------------|----------------|
| Extract Method | Long method, repeated code | Inline code → Named method |
| Extract Class | Class has multiple responsibilities | One class → Two classes |
| Move Method | Method uses another class more | A.method() → B.method() |
| Rename | Name doesn't reveal intent | `d` → `elapsedDays` |

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
3. Update documentation/comments
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
| Behavior preservation | No behavior changes | Behavior modified |

### After Refactoring

| Criterion | Pass | Fail |
|-----------|------|------|
| Tests passing | All tests still pass | Tests failing |
| Code clarity | Code is cleaner/clearer | Same or worse clarity |
| No new features | No functionality added | Features added |
| Review completed | Changes reviewed | No review |

## Code Smells to Watch For

| Smell | Indication | Refactoring |
|-------|------------|-------------|
| Long Method | Method > 20 lines | Extract Method |
| Large Class | Class > 200 lines | Extract Class |
| Long Parameter List | > 3 parameters | Introduce Parameter Object |
| Duplicated Code | Same code in multiple places | Extract Method/Class |
| Feature Envy | Method uses other class's data | Move Method |
| Data Clumps | Same data groups appear together | Extract Class |
