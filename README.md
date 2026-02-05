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

## Structure

This repository is designed as Claude Code Plugin which contains following components:

```
|- /coding-skills
    |- commands/ # Workflow shortcuts
       |- coding.md # Implement new feature
       |- refactor.md # Refactor existing code
       |- review.md # Code review checklist
       |- ...
    |- skills/   # Individual skills with specific knowledge
       |- clean-architecture/
       |- domain-driven-design/
       |- test-driven-development/
       |- design-patterns/
          |- references/
             |- factory.js.md
             |- factory.rb.md # Language-specific implementation references
       |- ...
```

## Methodology

The command as entry which defines the workflow, then adaptively select necessary skills to complete the task.

For example, the `coding.md` command use `clean-architecture` when the structure is not defined and follow instructions to create necessary layers.

## Command Usage Matrix

Choose the appropriate command based on your task:

| Command     | Purpose            | Arguments                    |
|-------------|--------------------|------------------------------|
| `/write`    | Implement features | `feature\|id [--skip-tests]` |
| `/refactor` | Clean up code      | `[path\|module]`             |
| `/fix`      | Fix bugs           | `bug\|issue\|error`          |

### Skills per Command

| Skill                     | /write | /refactor | /fix |
|---------------------------|:------:|:---------:|:----:|
| coding:testing            |   ✓    |     ✓     |  ✓*  |
| coding:refactoring        |   ✓    |     ✓*    |  ✓   |
| coding:clean-architecture |   ✓    |     ✓     |  ✓   |
| coding:principles         |   ✓    |     ✓     |  ✓   |
| coding:design-patterns    |   ✓    |     ✓     |  ✓   |
| coding:domain-modeling    |   ✓    |     -     |  ✓   |

*Core skill for this command (always activated)

### When to Use

- **`/write`**: Starting a new feature or adding new functionality
- **`/refactor`**: Improving code quality without changing behavior
- **`/fix`**: Diagnosing and fixing bugs with test verification

## Usage

To use this coding skills, add to your marketplace or use `--plugin-dir` in Claude Code. Then choose the command which most fits the task.

## License

Apache-2.0 License. See [LICENSE](./LICENSE) for details.
