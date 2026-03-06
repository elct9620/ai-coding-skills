---
name: principles
description: Apply SOLID, KISS, DRY, YAGNI principles to code design decisions. Use when building new features from scratch and need to decide on class structure, interface boundaries, or dependency direction. Make sure to use this skill when the user faces design trade-offs, asks about SOLID principles, debates whether to abstract or keep things simple, or needs to evaluate competing design approaches — but not for code smell detection (use refactoring skill instead).
---

## Related Skills

- Detected a code smell (long method, feature envy)? → Use **refactoring** for specific techniques
- Need a specific pattern (Strategy, Factory)? → Use **design-patterns** for selection and implementation
- Deciding which architectural layer code belongs in? → Use **clean-architecture**

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| New feature from scratch | Building without existing reference | Modifying existing code |
| Design trade-off | Choosing between competing approaches | Implementation path is clear |
| Interface/boundary design | Defining class responsibilities or contracts | Internal implementation detail |
| Dependency structure | Deciding coupling and injection strategy | No dependency decisions |

**Apply when**: Any condition passes
**Do NOT apply when**: The task is purely about restructuring existing code (use refactoring) or detecting code smells (use refactoring)

## Core Principles

### SOLID

| Principle | Description | Violation Sign |
|-----------|-------------|----------------|
| **S**ingle Responsibility | One reason to change | Class does too many things |
| **O**pen/Closed | Open for extension, closed for modification | Frequent changes to existing code |
| **L**iskov Substitution | Subtypes must be substitutable | Type checks or conditional logic on types |
| **I**nterface Segregation | Many specific interfaces over one general | Clients implement unused methods |
| **D**ependency Inversion | Depend on abstractions, not concretions | Direct instantiation of dependencies |

### KISS (Keep It Simple, Stupid)

- Prefer straightforward solutions
- Avoid unnecessary complexity
- Write code that's easy to understand
- If it's hard to explain, it's too complex

### DRY (Don't Repeat Yourself)

- Extract repeated logic into functions
- BUT: Premature abstraction is worse than duplication
- Rule of three: Abstract after third repetition
- Accept some duplication for clarity

### YAGNI (You Aren't Gonna Need It)

- Don't build features until needed
- Avoid speculative generality
- Solve today's problem, not tomorrow's

## Completion Rubric

### Single Responsibility

| Criterion | Pass | Fail |
|-----------|------|------|
| Clear purpose | One responsibility per class/function | Multiple unrelated responsibilities |
| Describable | Can describe in one sentence | Needs paragraph to explain |
| Change isolation | Changes for only one reason | Changes for multiple reasons |

### Open/Closed

| Criterion | Pass | Fail |
|-----------|------|------|
| Extension over modification | New behavior via extension | Modifying existing code |
| Abstraction usage | Variation points use abstractions | Hardcoded variations |
| Core stability | Core logic unchanged | Core frequently modified |

### Liskov Substitution

| Criterion | Pass | Fail |
|-----------|------|------|
| Contract adherence | Subtypes honor base contracts | Subtypes break expectations |
| No type checking | Client uses base type only | instanceof/type checks in client |
| Precondition consistency | Preconditions not strengthened | Stricter preconditions |
| Postcondition consistency | Postconditions not weakened | Weaker postconditions |

### Interface Segregation

| Criterion | Pass | Fail |
|-----------|------|------|
| Focused interfaces | Interfaces are cohesive | Fat interfaces |
| Client-specific | Clients use all methods | Unused method implementations |
| No bloat | No "fat" interfaces | Interface has unrelated methods |

### Dependency Inversion

| Criterion | Pass | Fail |
|-----------|------|------|
| Abstraction dependency | High-level depends on abstractions | Depends on concretions |
| Bidirectional abstraction | Both levels use abstractions | Direct low-level dependency |
| Injection | Dependencies injected | Dependencies created internally |

### Simplicity Check

| Criterion | Pass | Fail |
|-----------|------|------|
| Junior-friendly | Understandable by junior dev | Requires expert knowledge |
| Minimal complexity | Simplest working solution | Over-engineered |
| Current focus | Solves only current problem | Solves hypothetical problems |

## Principle Violations vs Code Smells

When you detect **design principle violations** (wrong abstraction level, tight coupling, fat interfaces), apply this skill to fix the design.

When you detect **code smells** (long methods, duplicated code, feature envy), use the **refactoring** skill instead — it has specific techniques and safe steps for each smell.
