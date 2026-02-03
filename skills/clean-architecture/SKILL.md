---
name: clean-architecture
description: Apply Clean Architecture with layered structure (Domain, Application, Infrastructure). Use when creating docs/architecture.md, designing new modules, or restructuring code into layers with proper dependency direction.
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
┌─────────────────────────────────────┐
│           Infrastructure            │  ← Frameworks, DB, External APIs
├─────────────────────────────────────┤
│            Application              │  ← Use Cases, DTOs, Services
├─────────────────────────────────────┤
│              Domain                 │  ← Entities, Value Objects, Domain Services
└─────────────────────────────────────┘
```

### Dependency Rule

Dependencies MUST point inward:
- Infrastructure → Application → Domain
- Domain has NO dependencies on outer layers
- Use interfaces (ports) for dependency inversion

### Layer Responsibilities

| Layer | Contains | Depends On |
|-------|----------|------------|
| Domain | Entities, Value Objects, Domain Services, Repository Interfaces | Nothing |
| Application | Use Cases, Application Services, DTOs | Domain |
| Infrastructure | Controllers, DB Adapters, External APIs, Framework Code | Application, Domain |

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
| Domain layer purity | Contains only business logic | Has infrastructure concerns |
| Application orchestration | Coordinates use cases properly | Mixed responsibilities |
| Infrastructure isolation | External concerns separated | Leaked into inner layers |
| Interface definition | Defined for external deps | Direct coupling |

### After Implementation

| Criterion | Pass | Fail |
|-----------|------|------|
| No circular deps | Layers have one-way deps | Circular references exist |
| Domain testability | Testable without infrastructure | Requires external deps |
| Convention adherence | Follows project patterns | Inconsistent with codebase |

## Architecture Documentation

If `docs/architecture.md` doesn't exist, create it with:

```markdown
# Architecture Overview

## Layer Structure
[Describe the layers used in this project]

## Directory Mapping
[Map directories to architectural layers]

## Dependency Guidelines
[Document dependency rules and conventions]
```
