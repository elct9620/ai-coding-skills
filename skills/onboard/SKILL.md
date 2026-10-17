---
name: onboard
description: Maintain AGENTS.md as the onboarding every new session reads first — the project's intent, how we work, and an index of where to look first. Use when creating AGENTS.md (usually after /init), pruning it, or bringing it up to date after the project changed.
argument-hint: [what changed]
allowed-tools: Read, Grep, Glob, Edit, Write, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(ls:*), Bash(test:*), Bash(wc:*)
---

## Purpose

Every session starts as a capable newcomer: it reads code fluently and knows nothing the code does not say. `AGENTS.md` is what it reads first, in every session, so each line has to be worth that cost every time. This skill answers one question per line: **would a newcomer need this, and could they get it from the code?**

## Sections

`AGENTS.md` has exactly three sections, in this order. Each has a fixed shape, because lists, tables, and paragraphs all grow when nothing bounds them.

| Section | Holds | Shape |
|---|---|---|
| `## Intent` | Why the project exists and for whom | At most three sentences, or one sentence pointing to an intent document |
| `## How We Work` | Decisions every change follows, commands the tooling does not list, what moves together | A rule table of at most five topics; an upkeep table |
| `## Index` | Where to look first to grasp the whole | A two-column table, at most ten rows |

### Intent

The code cannot tell why it exists. Only the user can define the intent, so ask for it and write their words down. Until they answer, the section holds a marked question, never a guessed purpose. When the project keeps an intent document, point to it instead of copying it.

### How We Work

A rule is a short phrase a reader can act on. Rules sit in a two-column table, grouped by the area of work they govern:

```markdown
| Topic | Rule |
|---|---|
| Data | The ledger is append-only; never commit `data/` |
| Commits | Run `rake` first; write messages in English |
| Workflow | `/coding:write` implements; `/coding:inspect` reviews |
```

A topic names an area most changes touch, so five cover the project. A rule that needs a sixth topic is narrow enough for the code, the specs, or a nested `AGENTS.md`. A command belongs here only when the tool's own catalog — `rake -T`, `package.json` scripts, `make help` — does not show it. What must change together goes in a two-column table:

```markdown
| When this changes | Also update |
|---|---|
| A behavior or an interface | `.spec/` first; `sumi verify` reports no difference |
| A module, layer, or dependency | `docs/architecture.md` |
```

Name the workflow skills in a Workflow row, so `/goal` can point to this section.

### Index

Each row names a file or directory and what reading it teaches about the whole — a composition root, a main router, the specs, the architecture document. A row never lists the commands a file holds.

```markdown
| Path | What you learn here |
|---|---|
| `src/app.ts` | Where every module is wired together |
| `docs/architecture.md` | Layers and the rules between them |
```

When ten rows cannot cover the project, give a large directory its own `AGENTS.md`. Claude Code loads it when work reaches that directory.

## Principles

- The reader already knows the language, the framework, and common practice. A line earns its place by what differs.
- A list that will drift keeps its intent and a pointer to the document that owns it.
- What the code already shows stays out; how the system behaves lives in the specs.
- Write what is true now. How the project got here belongs in its history.
- Prefer removing a line to adding a qualifier.

## Writing

Write `AGENTS.md` in ASD-STE100 style, in the user's language:

- The whole file stays within 100 lines.
- A sentence stays under 25 words; an instruction under 20, one instruction per sentence.
- A paragraph holds one topic, at most six sentences.
- A table cell holds a term or short phrases, at most 15 words each; a Rule cell holds at most three rules.
- Active voice and simple tenses; one word for one meaning.

## Loading

Claude Code reads `AGENTS.md` only when no `CLAUDE.md` or `CLAUDE.local.md` sits in the working directory or above it. This skill edits `AGENTS.md` only. When a `CLAUDE.md` exists without an `@AGENTS.md` import, report it; the user decides the fix.

## Output

Report the change so each claim can be checked:

1. Show the diff to `AGENTS.md`.
2. For each removed line, name why: derivable from code, stale, a drifting list, or belongs in the specs.
3. List every path in the Index with the result of checking that it exists.
4. State the line count against the 100-line limit, and the Index row count against ten.
5. State the loading result: read directly, imported by `CLAUDE.md`, or not loaded.
