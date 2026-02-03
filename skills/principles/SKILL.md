---
name: principles
description: Apply SOLID, KISS, DRY, YAGNI principles to code design. Use when building new features from scratch, making design decisions, or reviewing code for principle violations.
---

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| New feature from scratch | Building without existing reference | Modifying existing code |
| Design decision needed | Choosing between approaches | Implementation is clear |
| Code quality review | Evaluating design quality | No review needed |
| No existing patterns | No codebase conventions apply | Can follow existing code |

**Apply when**: Any condition passes

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

## Anti-Patterns to Avoid

| Anti-Pattern | Symptom | Remedy |
|--------------|---------|--------|
| God Class | Does everything, knows everything | Extract Class |
| Shotgun Surgery | One change requires many edits | Move Method, consolidate |
| Feature Envy | Method uses another class more | Move Method |
| Primitive Obsession | Overuse of primitives | Introduce Value Object |
