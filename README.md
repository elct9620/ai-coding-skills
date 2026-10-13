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

The plugin ships three skills and one command; each skill keeps its knowledge in `references/`.

```
coding-skills/
├── skills/
│   ├── inspect/      # Analyze shape and names (read-only)
│   │   └── references/   structure, forces, naming
│   ├── write/        # Implement, fix, or refactor
│   │   └── references/   smallest-change, testing, design
│   └── onboard/      # Maintain AGENTS.md
└── commands/
    └── roadmap.md    # Spec-to-implementation tracking
```

## Methodology

Each skill answers one question and prints output that can be checked.

| Skill | Question | Checkable output |
|---|---|---|
| `/inspect` | What still stands between the code and the goal? | Conclusion table |
| `/write` | Is it done right, the right way? | Conclusion table |
| `/onboard` | Does a newcomer need this line? | Path and loading checks |

Skills state principles and an output contract, not steps. Knowledge the model already has stays a keyword; references hold only where this project differs from common practice.

## Skill Usage Matrix

Invoke each by name with the `coding:` prefix, such as `/coding:inspect`.

| Name | Use for | Arguments |
|---|---|---|
| `inspect` | Plan a round, or review finished work | `[path\|--staged\|intent] [--deep]` |
| `write` | Build a feature, fix a defect, refactor | `[feature\|finding\|path]` |
| `onboard` | Create or prune `AGENTS.md` | `[what changed]` |
| `roadmap` | Track spec-to-implementation progress | `[init\|update\|status] [feature]` |

## Recommended Workflow

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

Each "Done when" line maps to a row of the conclusion table that `/write` and `/inspect` print first. The evaluator judges results, not steps.

```
/goal Finish the work list confirmed by /coding:inspect.

- Implement each item with /coding:write, then review it with /coding:inspect; hand findings back to /coding:write.
- Follow How We Work in AGENTS.md.
- Actions that need my approval, such as pushing, are outside this goal.

Done when:
- The final /coding:write conclusion shows each item done or held for me, and the tests passing.
- The final /coding:inspect conclusion shows no High findings, specs and code agreeing,
  and full coverage.
- Every decision held for me is listed in a conclusion.
```

## Usage

Install from the marketplace or with `claude plugin add`, then start a round with `/coding:inspect`.

```
/coding:onboard
/coding:inspect add expiry to share links
/goal Finish the work list confirmed by /coding:inspect. ...
```

## License

Apache-2.0 License. See [LICENSE](./LICENSE) for details.
