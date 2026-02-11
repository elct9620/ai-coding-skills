---
name: clean-architecture
description: Apply Clean Architecture with four concentric layers (Entities, Use Cases, Interface Adapters, Frameworks & Drivers). Use when creating docs/architecture.md, designing new modules, or restructuring code with proper dependency direction.
---

## Applicability Rubric

| Condition | Pass | Fail |
|-----------|------|------|
| Architecture documentation missing | `docs/architecture.md` not found | File exists |
| Significant structural changes | Feature affects 2+ layers | Single-layer change |
| New module creation | Creating new namespace/directory | Modifying existing |
| Legacy restructuring | Reorganizing unstructured code | Code already layered |

**Apply when**: Any condition passes

## Core Principles

### Layer Structure

```
┌─────────────────────────────────────────────┐
│          Frameworks & Drivers               │  ← Web, DB, Devices, External Interfaces
├─────────────────────────────────────────────┤
│          Interface Adapters                 │  ← Controllers, Presenters, Gateways
├─────────────────────────────────────────────┤
│             Use Cases                       │  ← Application-specific Business Rules
├─────────────────────────────────────────────┤
│             Entities                        │  ← Enterprise-wide Business Rules
└─────────────────────────────────────────────┘
```

### Dependency Rule

Dependencies MUST point inward:
- Frameworks & Drivers → Interface Adapters → Use Cases → Entities
- Entities have NO dependencies on outer layers
- Use interfaces (ports) at layer boundaries for dependency inversion

### Layer Responsibilities

| Layer | Contains | Depends On |
|-------|----------|------------|
| Entities | Enterprise-wide business rules, critical business data structures | Nothing |
| Use Cases | Application-specific business rules, input/output port interfaces | Entities |
| Interface Adapters | Controllers, Presenters, Gateways, DTOs, format converters | Use Cases, Entities |
| Frameworks & Drivers | Web framework, DB, external APIs, UI, devices | Interface Adapters |

## Completion Rubric

### Before Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Layer identification | Target layer explicitly stated | No layer consideration |
| Architecture doc | Created/updated when needed | No documentation |
| Dependency verification | All deps point inward | Outward deps exist |

### During Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| Entities layer purity | Contains only enterprise business rules, no framework imports | Has framework or application concerns |
| Use Case isolation | Each use case is a single application operation with clear input/output | Mixed responsibilities or coupled to adapters |
| Interface Adapter correctness | Converts data between use case format and external format | Business logic leaking into adapters |
| Framework/Driver isolation | External concerns contained in outermost layer | Framework details leaked into inner layers |
| Boundary interfaces | Defined at each layer boundary for dependency inversion | Direct coupling across layers |

### After Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| No circular deps | Layers have one-way inward deps | Circular references exist |
| Entities testability | Testable without any outer layer dependency | Requires framework or external deps |
| Convention adherence | Follows project patterns | Inconsistent with codebase |

## Architecture Documentation

If `docs/architecture.md` doesn't exist, create it with:

```markdown
# Architecture Overview

## Layer Structure
[Describe the four layers used in this project: Entities, Use Cases, Interface Adapters, Frameworks & Drivers]

## Directory Mapping
[Map directories to architectural layers]

## Dependency Guidelines
[Document dependency rules: all dependencies point inward, use interfaces at boundaries]
```
