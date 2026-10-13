---
name: onboard
description: Maintain AGENTS.md as the onboarding every new session reads first — only what the code cannot tell, how this project works, and where to look first to grasp the whole. Use when creating AGENTS.md (usually after /init), pruning it, or bringing it up to date after the project changed.
argument-hint: [what changed]
allowed-tools: Read, Grep, Glob, Edit, Write, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(ls:*), Bash(test:*), Bash(wc:*)
---

## Purpose

Every session starts as a capable newcomer: it reads code fluently and knows nothing the code does not say. `AGENTS.md` is what it reads before anything else, and it loads into every session, so each line has to be worth its cost every time. This skill answers one question per line: **would a newcomer need this, and could they get it from the code?**

## Principles

- The reader already knows the language, the framework, and the common practice. A line earns its place by what differs from that.
- What the code cannot tell comes from the user. Ask for it; reading more code only finds what was already derivable.
- Write what is true now. A line that explains how the project got here belongs in the history, not here.
- Every line is concrete enough to check: a command that runs, a path that exists, a rule whose outcome can be observed.
- Fewer lines are followed more reliably. Stay under 200, and prefer removing a line to adding a qualifier.

## Contents

`AGENTS.md` holds three kinds of content, each with its own test.

| Section | A line stays when | Check |
|---|---|---|
| `## Context` | the code cannot tell it — a decision, a constraint, an environment quirk | reading the code would not reach it |
| `## Working Agreement` | it says how work is done here, including commands | the command runs; the rule's outcome is observable |
| `## Where to Start` | one file unfolds most of the whole — a composition root, a main router, an architecture doc | the path exists and leads to most modules |

What belongs elsewhere stays out: how the system should behave lives in the specs, and conventions the code already shows live in the code.

The Working Agreement is where `/goal` points, so it names the workflow in one line each:

```markdown
## Working Agreement

- Implement with `/coding:write`; review with `/coding:inspect`.
- Run `bundle exec rspec` before committing.
- Keep specs in `docs/specs/` current with the code; merge or remove stale ones.
```

## Loading

Claude Code reads `AGENTS.md` only when no `CLAUDE.md` or `CLAUDE.local.md` sits in the working directory or above it. When either exists, `CLAUDE.md` must import the file with `@AGENTS.md`, or this onboarding silently stops loading. Claude-specific lines go below that import in `CLAUDE.md`.

## Communication

Write `AGENTS.md` and the report in ASD-STE100 style, in the user's language:

- One instruction per sentence, in the imperative; the condition comes before it.
- Instructions stay under 20 words; descriptions under 25.
- Active voice and simple tenses.
- One word for one meaning; reuse that word everywhere.
- One topic per paragraph, at most six sentences.

## Output

Report the change so each claim can be checked:

1. Show the diff to `AGENTS.md`.
2. For each removed line, name why: derivable from code, stale, or belongs in the specs.
3. List every path under Where to Start with the result of checking that it exists.
4. State the line count.
5. State the loading result: read directly, imported by `CLAUDE.md`, or not loaded — and what fixes the last case.
