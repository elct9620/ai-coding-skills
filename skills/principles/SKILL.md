---
name: principles
description: Apply SOLID, KISS, DRY, YAGNI principles to code design decisions. Use when building new features from scratch and need to decide on class structure, interface boundaries, or dependency direction. Make sure to use this skill when the user faces design trade-offs, asks about SOLID principles, debates whether to abstract or keep things simple, or needs to evaluate competing design approaches — but not for code smell detection (use refactoring skill instead).
---

## Related Skills

- Detected a code smell (long method, feature envy)? → Use **refactoring** for specific techniques
- Need a specific pattern (Strategy, Factory)? → Use **design-patterns** for selection and implementation
- Deciding which architectural layer or structure code belongs in? → Use **architecture**

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

### Commenting

- Library / shared module public API: doc comment states intent and when to reach for it
- Application code: names and call sites carry the intent
- Private method: comment only when a value references something external (RFC code, control byte, ticket ID)
- A comment that restates the code in prose: extract a method whose name carries the meaning

Module type (application vs library) decides which default applies — see **architecture** Module Type.

## Completion Rubric

Use the **Violation Sign** column in the SOLID table above as the primary checklist. Additionally verify:

| Criterion | Pass | Fail |
|-----------|------|------|
| Describable | Each class/function describable in one sentence | Needs a paragraph to explain |
| Simplest solution | Chosen approach is the simplest that works | Over-engineered for hypothetical needs |
| Dependencies injected | High-level modules depend on abstractions | Direct instantiation of concretions |

## Scope Boundary

This skill addresses **design-level decisions** (abstraction level, coupling, interface shape). For **code-level restructuring** (long methods, duplicated code, feature envy), use the **refactoring** skill — it has specific techniques and safe steps for each smell.
