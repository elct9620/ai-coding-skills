Coding Skills
===

This is personalized agent skills for coding tasks. Mainly designed to Claude Code but fit for other LLMs as well.

## Why

Each team or individual has their own coding style, preferences, and best practices. In my opinion, each one or team should have their own coding skills to better fit their needs.

## Preferences

I use Ruby, TypeScript/JavaScript, and Golang the most. And love Clean Architecture, Domain-Driven Design, and Test-Driven Development. This skill set is build around these preferences.

| Type         | Selection               |
| ----         | ---------               |
| Architecture | Clean Architecture      |
| Design       | Domain-Driven Design    |
| Workflow     | Test-Driven Development |
| Principles   | SOLID, KISS, DRY        |
| Coding       | Design Patterns         |
| Coding       | Refactoring             |
| Coding       | Security                |

## Structure

This repository is designed as Claude Code Plugin which contains following components:

```
|- /coding-skills
    |- commands/   # Workflow commands (entry points)
       |- inspect.md  # Explore state and surface problems (read-only)
       |- write.md    # Implement a feature or correct a defect with TDD
       |- refactor.md # Clean up legacy code
       |- roadmap.md  # Spec-to-implementation tracking
    |- skills/     # Individual skills with specific knowledge
       |- design-forces/
       |- testing/
       |- architecture/
       |- domain-modeling/
       |- design-patterns/
       |- refactoring/
       |- principles/
       |- schema/
       |- security/
```

## Methodology

The command as entry which defines the workflow, then adaptively select necessary skills to complete the task.

For example, the `/write` command uses `architecture` to follow a structure already recorded in `docs/architecture.md`, or — when the design forces call for it — to decide a structural shape (Clean Architecture, DDD, DCI, or another). It defaults to adding no extra structure when the forces are quiet.

## Command Usage Matrix

Choose the appropriate command based on your task:

| Command     | Purpose              | Arguments                    |
|-------------|----------------------|------------------------------|
| `/inspect`  | Surface problems     | `[path\|module\|--staged] [--deep]` |
| `/write`    | Implement or correct behavior | `feature\|id [--skip-tests]` |
| `/refactor` | Clean up code        | `[path\|module]`             |
| `/roadmap`  | Track implementation | `[init\|update\|status] [feature]` |

### Skills per Command

| Skill                     | /inspect | /write | /refactor |
|---------------------------|:--------:|:------:|:---------:|
| coding:design-forces      |   ✓§    |  ✓†    |    ✓†     |
| coding:testing            |   ✓*    |   ✓    |     ✓     |
| coding:refactoring        |    ✓    |   ✓    |     ✓*    |
| coding:architecture       |    ✓    |   ✓    |     ✓     |
| coding:principles         |   ✓*    |   ✓    |     ✓     |
| coding:design-patterns    |    ✓    |   ✓    |     ✓     |
| coding:domain-modeling    |    -    |   ✓    |     -     |
| coding:schema             |    ✓    |   ✓    |     ✓     |
| coding:security           |    ✓    |   ✓    |     ✓     |

*Core skill for this command (always activated)
†Runs before active-skills selection to frame the direction
§Used to check changes against patterns recorded in `docs/architecture.md`

> `/roadmap` is a standalone tracking command and does not use coding skills.

### When to Use

- **`/inspect`**: Exploring the current state and surfacing problems in style, tests, and architecture — read-only, produces leads you act on
- **`/write`**: Starting a new feature, adding functionality, or correcting a defect
- **`/refactor`**: Improving code quality without changing behavior
- **`/roadmap`**: Tracking spec-to-implementation progress, initializing a roadmap from specs, or checking feature status

### Recommended Workflow

```
/write → /inspect → /refactor (if needed)
```

After implementing a feature or correction (`/write`), run `/inspect` to check quality. If the leads contain findings, use `/refactor` to address them.

Use `/roadmap init` to create a tracking index from your SPEC.md, then `/roadmap status` to check progress as you implement.

## Usage

To use this coding skills, install from the marketplace or use `claude plugin add` in Claude Code. Then choose the command which most fits the task.

## License

Apache-2.0 License. See [LICENSE](./LICENSE) for details.
