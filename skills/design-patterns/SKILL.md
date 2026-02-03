---
name: design-patterns
description: Select and apply GoF design patterns: Factory, Builder, Strategy, Observer, Adapter, Decorator. Use when solving recurring design problems or structuring multi-component changes.
---

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| Multi-component change | Feature affects multiple components | Single component change |
| Recognizable problem | Matches known design problem | Unique/novel problem |
| Flexibility needed | Requires extensible solution | Fixed requirements |
| Recurring challenge | Solving common design issue | One-off implementation |

**Apply when**: Any condition passes

## Core Principles

### Pattern Selection Process

```
1. Identify the problem
   ↓
2. Match problem to pattern category
   ↓
3. Evaluate pattern candidates
   ↓
4. Consider trade-offs
   ↓
5. Apply pattern minimally
```

### Pattern Categories

| Category | Purpose | Common Patterns |
|----------|---------|-----------------|
| Creational | Object creation | Factory, Builder, Singleton |
| Structural | Object composition | Adapter, Decorator, Facade |
| Behavioral | Object interaction | Strategy, Observer, Command |

## Common Patterns Quick Reference

### Creational Patterns

| Pattern | Use When | Example |
|---------|----------|---------|
| Factory Method | Object creation varies by context | `createLogger(type)` |
| Builder | Complex object construction | Fluent configuration |
| Singleton | Single instance needed globally | Configuration manager |

### Structural Patterns

| Pattern | Use When | Example |
|---------|----------|---------|
| Adapter | Interface incompatibility | Wrap legacy API |
| Decorator | Add behavior dynamically | Logging wrapper |
| Facade | Simplify complex subsystem | Unified API client |
| Composite | Tree structures | UI components |

### Behavioral Patterns

| Pattern | Use When | Example |
|---------|----------|---------|
| Strategy | Algorithm varies at runtime | Payment methods |
| Observer | One-to-many notifications | Event system |
| Command | Encapsulate operations | Undo/redo actions |
| State | Behavior changes with state | Order status |

## Pattern Decision Table

| Need | Situation | Pattern |
|------|-----------|---------|
| Create objects | Varying types by context | Factory Method |
| Create objects | Many optional parameters | Builder |
| Create objects | Exactly one instance | Singleton |
| Structure objects | Incompatible interface | Adapter |
| Structure objects | Add responsibilities dynamically | Decorator |
| Structure objects | Simplify complex subsystem | Facade |
| Structure objects | Tree hierarchies | Composite |
| Define behavior | Algorithm varies at runtime | Strategy |
| Define behavior | One-to-many notifications | Observer |
| Define behavior | Operations that can be undone | Command |
| Define behavior | Behavior changes with state | State |

## Completion Rubric

### Before Applying

| Criterion | Pass | Fail |
|-----------|------|------|
| Problem identification | Problem clearly defined | Vague problem statement |
| Real need | Solves actual problem | Hypothetical/speculative |
| Simpler alternatives | Considered simpler options first | Jumped to pattern |
| Team familiarity | Team understands pattern | Pattern is obscure |

### During Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Minimal application | Pattern applied minimally | Over-applied |
| Clear naming | Names reflect pattern intent | Generic/unclear names |
| Intent preservation | Pattern intent maintained | Pattern misused |
| Appropriate complexity | Complexity justified | Over-engineered |

### After Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Flexibility gained | Code more flexible | Same or less flexible |
| Documented | Pattern documented if not obvious | Undocumented complexity |
| Tested | Tests cover pattern behavior | Pattern untested |

## Anti-Pattern Warning

**Pattern Fever**: Applying patterns everywhere

Signs:
- Patterns for trivial problems
- Multiple patterns where one suffices
- Code harder to understand than before

Cure: YAGNI - Use patterns only when they solve real problems
