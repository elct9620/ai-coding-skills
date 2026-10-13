---
name: inspect
description: Find what still stands between the code and a goal, always checking its shape (structure, layers, dependency direction) and its names. Converges on a work list with the user, or checks finished work against the work list the user confirmed. Read-only.
argument-hint: [path|--staged|intent] [--deep]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, WebFetch
---

## Purpose

`/inspect` answers one question: **what still stands between the code and the goal?** Two lenses always apply: shape — structure, layers, dependency direction — and names. How the code is written in detail belongs to `/write`. This skill reads and reports; it changes nothing.

The target sets the goal: `--staged` is the staged diff, a path is its pending changes or its contents, a sentence states the intent, and nothing means the last commit.

## Two Uses

A **work list** is the table of what this round does, in order. It is **confirmed** once the user approves it.

| Use | When | Does |
|---|---|---|
| Planning | No confirmed work list in this conversation | Asks the user, converges on a work list |
| Checking | A confirmed work list exists | Asks nothing; compares the work with the list, its Bounds, and its References |

In planning, each answer settles an unknown or sets a bound, and the list is redrawn. A confirmed list runs to the end without stopping, so offer no checkpoints inside it.

In checking, each drift from the confirmed list is one of two kinds:

| Kind | Example | Handling |
|---|---|---|
| Verifiable | The specs, the Bounds, a formula, or a convention settles it | Verify it, then hand the finding to `/write` |
| Preference | The work list left a choice open, and the work made it | Hold it for the user: list the options without leaning toward one |

## Principles

- Take the width first: the log, the tree, and a search show the whole cheaply. Read a file closely only to answer a question a search cannot.
- Stop reading when one more file would not change the work list or its order.
- What bears on the goal belongs in the report; what is true but beside it stays out.
- A direction is not a destination. When the goal is "cleaner", first offer what arriving would look like.
- State each claim at the strength of its evidence. A false all-clear is worse than a miss.
- What the user decided is given. A README or spec that disagrees with the newest goal is an update to make.
- An item that still turns on an answer stays out of the work list, under Still unknown.
- Follow How We Work in `AGENTS.md` for where specs live and how the project reviews.

`--deep` means the user cannot see the problem. Trace each lead until it is confirmed or dropped, and follow each promise the goal relies on into the code that keeps it.

## Lenses

| Lens | Asks | Reference |
|---|---|---|
| Shape | Is structure earned, does it follow the record, do dependencies point inward? | `references/structure.md` |
| Shape, still open | Is a structural choice — CA, DDD, a pattern — still undecided? | `references/forces.md` |
| Names | Does the call site read as a phrase, following the convention? | `references/naming.md` |

Shape includes the principles visible at that level: dependency direction, module boundaries, layers nobody needs, one concept in one place. Detail-level principles and how tests are written belong to `/write`. In checking, read `/write`'s report for an unproven test net or something rebuilt that already existed.

When the project divides into contexts — areas with their own vocabulary and rules — apply the lenses inside each context. Between contexts, check only the interfaces and translations; a different name for a similar concept there is by design.

## Evidence and Severity

| Evidence | Means |
|---|---|
| Traced | Followed through the code to file and line |
| Read | Seen in the code, not followed |
| Searched | A search matched; meaning and completeness unknown |
| Unrun | Needs execution to know; this skill does not run code |

| Severity | Means |
|---|---|
| High | Breaks a promise of the goal or the specs, or blocks the work list |
| Med | Departs from the record or convention and will spread |
| Low | Local polish |

## Communication

- Write in the user's language. Explain each term at first use, and restate a concept when returning to it.
- Every mention of a finding id, in tables and prose alike, carries a phrase saying what it is.
- Use a diagram where structure carries meaning: flow, layers, tree (before → after), sequence, or pseudocode.
- Draw diagrams with Unicode box-drawing characters and English labels.
- Keep one point per sentence and one topic per paragraph; add two or three sentences under a finding only when its row cannot carry the reasoning.

## Output

The report opens with its conclusion. The conclusion states facts only and never says whether the round may end; `/goal` reads its four rows, so keep them in this order. The conclusion table is the only summary: the report closes without a verdict on the round.

```markdown
# /inspect [--deep] — <what this round is for>

## <"Conclusion" in the user's language>

| Check | Result |
|---|---|
| High findings | <count; each as id + phrase> |
| Specs and code | <agree, or what differs; mark each gap a held decision leaves> |
| Decisions held for the user | <count; each as id + phrase> |
| Coverage | <full, or what was skipped> — <command or range read> |

- Goal: …
- Bounds: …
- References: …
- Opened: <files read closely>
- Not opened: <parts seen in the width but not read>

| # | Severity | Evidence | Where | What stands between here and the goal |
|---|---|---|---|---|

**Work list** (planning)

| Order | # | The work | Why it sits here |
|---|---|---|---|

**Still unknown:** <each question and what its answer changes, or "none">
```

Bounds are limits the user set; References are what they pointed at as the way to work. Both come only from what they said. In planning, end with one line offering `--deep` when leads remain unverified.
