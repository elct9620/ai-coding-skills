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
| Workflow     | Explore first, tests as the net |
| Principles   | SOLID, KISS, DRY        |
| Coding       | Design Patterns         |
| Coding       | Refactoring             |
| Coding       | Security                |

## Structure

This repository is designed as Claude Code Plugin which contains following components:

```
|- /coding-skills
    |- commands/   # Workflow commands (entry points)
       |- inspect.md  # Confirm spec, code, and understanding agree (read-only)
       |- write.md    # Implement a feature or correct a defect
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

Commands are the process — what a run does and in what order. Skills are the knowledge — what you need to know to do it. A command reaches for a skill through a lightweight index; each skill's own Applicability Rubric decides whether it fits.

The three commands form a funnel. `/inspect` opens the option space and closes it with the user present, producing the round's work list. `/write` then asks only how small the implementation's scope can be, and `/refactor` only how small the change can be — each climbing a ladder of what already exists and stopping at the first rung that answers. Heavier knowledge is opened at the last rung and not before, so work that a lower rung answers never pays for it.

## Command Usage Matrix

Choose the appropriate command based on your task:

| Command     | Purpose              | Arguments                    |
|-------------|----------------------|------------------------------|
| `/inspect`  | Confirm spec, code, and understanding agree | `[path\|module\|--staged\|intent] [--deep]` |
| `/write`    | Implement or correct behavior | `feature\|id`                |
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
†Opened only when an item reaches the ladder's last rung carrying a structural commitment
§The round where the option space is open — a direction confirmed here becomes the work list's references

> `/roadmap` is a standalone tracking command and does not use coding skills.

### When to Use

- **`/inspect`**: Confirming what still stands between the code and the goal you named — read-only, takes in the whole before reading any part of it closely, converges into the work list for this round
- **`/write`**: Starting a new feature, adding functionality, or correcting a defect
- **`/refactor`**: Improving code quality without changing behavior
- **`/roadmap`**: Tracking spec-to-implementation progress, initializing a roadmap from specs, or checking feature status

### Recommended Workflow

Plan with the user present, then let `/goal` run the work list to the end.

```
/inspect ──confirm──▶ /goal ┬─▶ /write ─▶ /inspect ─┐
 (plan)    work list        │      ▲    findings    │
                            │      └────────────────┘
                            └─▶ done: outcome criteria hold
```

Each layer carries one kind of statement, so the goal stays short.

| Layer | Holds | Checked by |
|---|---|---|
| `AGENTS.md` | How this project works | The agent, as guidance |
| `/goal` | This round's outcome | The goal evaluator |
| Hooks | Irreversible actions | The harness, before the action |

### Goal Template

Every line under "Done when" maps to output that `/write` and `/inspect` print, so the evaluator judges results rather than steps.

```
/goal Finish the work list confirmed by /inspect.

- Implement each item with /write, then review it with /inspect; hand findings back to /write.
- Follow the working agreement in AGENTS.md.
- Actions that need my approval, such as pushing, are outside this goal.

Done when:
- The test suite passes.
- The final /inspect covers the whole round and reports no open High finding.
- The final /inspect reports no drift between the specs and the code.
```

Use `/roadmap init` to create a tracking index from your SPEC.md, then `/roadmap status` to check progress as you implement.

## Usage

To use this coding skills, install from the marketplace or use `claude plugin add` in Claude Code. Then choose the command which most fits the task.

## License

Apache-2.0 License. See [LICENSE](./LICENSE) for details.
