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
       |- write.md    # Implement new features with TDD
       |- fix.md      # Diagnose and fix bugs
       |- refactor.md # Clean up legacy code
       |- review.md   # Post-implementation quality checks
       |- roadmap.md  # Spec-to-implementation tracking
    |- skills/     # Individual skills with specific knowledge
       |- testing/
       |- clean-architecture/
       |- domain-modeling/
       |- design-patterns/
       |- refactoring/
       |- principles/
       |- schema/
       |- security/
```

## Methodology

The command as entry which defines the workflow, then adaptively select necessary skills to complete the task.

For example, the `/write` command use `clean-architecture` when the structure is not defined and follow instructions to create necessary layers.

## Command Usage Matrix

Choose the appropriate command based on your task:

| Command     | Purpose              | Arguments                    |
|-------------|----------------------|------------------------------|
| `/write`    | Implement features   | `feature\|id [--skip-tests]` |
| `/refactor` | Clean up code        | `[path\|module]`             |
| `/fix`      | Fix bugs             | `bug\|issue\|error`          |
| `/review`   | Review changes       | `[path\|module\|--staged]`   |
| `/roadmap`  | Track implementation | `[init\|update\|status] [feature]` |

### Skills per Command

| Skill                     | /write | /refactor | /fix | /review |
|---------------------------|:------:|:---------:|:----:|:-------:|
| coding:testing            |   ✓    |     ✓     |  ✓*  |   ✓*    |
| coding:refactoring        |   ✓    |     ✓*    |  ✓   |    ✓    |
| coding:clean-architecture |   ✓    |     ✓     |  ✓   |    ✓    |
| coding:principles         |   ✓    |     ✓     |  ✓   |   ✓*    |
| coding:design-patterns    |   ✓    |     ✓     |  ✓   |    ✓    |
| coding:domain-modeling    |   ✓    |     -     |  ✓   |    -    |
| coding:schema             |   ✓    |     ✓     |  ✓   |    ✓    |
| coding:security           |   ✓    |     ✓     |  ✓   |    ✓    |

*Core skill for this command (always activated)

> `/roadmap` is a standalone tracking command and does not use coding skills.

### When to Use

- **`/write`**: Starting a new feature or adding new functionality
- **`/refactor`**: Improving code quality without changing behavior
- **`/fix`**: Diagnosing and fixing bugs with test verification
- **`/review`**: Reviewing recent changes for style consistency, test quality, and architecture alignment after `/write` or `/fix`
- **`/roadmap`**: Tracking spec-to-implementation progress, initializing a roadmap from specs, or checking feature status

### Recommended Workflow

```
/write or /fix → /review → /refactor (if needed)
```

After implementing features (`/write`) or fixing bugs (`/fix`), run `/review` to check quality. If the review report contains findings, use `/refactor` to address them.

Use `/roadmap init` to create a tracking index from your SPEC.md, then `/roadmap status` to check progress as you implement.

## Usage

To use this coding skills, install from the marketplace or use `claude plugin add` in Claude Code. Then choose the command which most fits the task.

## License

Apache-2.0 License. See [LICENSE](./LICENSE) for details.
