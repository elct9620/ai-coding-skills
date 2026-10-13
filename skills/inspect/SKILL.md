---
name: inspect
description: Analyze what stands between the code and a goal — whether its shape (structure, layers, dependency direction) and its names hold — and converge on a work list with the user, or review finished work against the work list it was given. Read-only.
argument-hint: [path|--staged|intent] [--deep]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, WebFetch
---

## Purpose

`/inspect` answers one question: **are the shape and the names right for the goal?** Shape is structure, layers, dependency direction, and the structure the project recorded. Names are the words the code uses for its concepts. Implementation and process belong to `/write`; this skill reads and reports, and it changes nothing.

## Modes

| Mode | When | Who is present |
|---|---|---|
| Plan | No confirmed work list yet | The user — ask, then converge |
| Review | A confirmed work list exists, or `/write` just finished | Nobody — ask nothing, report |

In Plan mode the report opens a clarification. Each answer settles an unknown or sets a bound, and the list is redrawn. Once the user confirms it, the list runs to the end without stopping, so do not offer checkpoints inside it.

In Review mode the findings go back to `/write`. Drift from the work list, its bounds, or its references is a finding.

## Principles

- Take the width first: the log, the tree, and a search show the whole cheaply. Read a file closely only to answer a question a search cannot.
- Stop reading when one more file would not change the work list or its order.
- The goal is the user's. What bears on it belongs in the report; what is true but beside it stays out.
- A direction is not a destination. When the goal is "cleaner", first offer what arriving would look like.
- State each claim at the strength of its evidence. A false all-clear is worse than a miss.
- What the user decided is given. A README or spec that disagrees with the newest goal is an update to make.
- An item that still turns on an answer stays out of the work list, under Still unknown.
- Follow How We Work in `AGENTS.md` for where specs live and how the project reviews.

`--deep` means the user cannot see the problem. Trace each lead until it is confirmed or dropped, and follow each promise the goal relies on into the code that keeps it, even outside the diff.

## Lenses

Both lenses always apply. Open a reference only when the scope contains what it reads for.

| Lens | Asks | Reference |
|---|---|---|
| Shape | Is structure earned, does it follow the record, do dependencies point inward? | `references/structure.md` |
| Shape, open decision | Is a structural commitment still open — CA, DDD, a pattern, a scaffold? | `references/forces.md` |
| Names | Does each word mean one thing, match the codebase, and carry its intent? | `references/naming.md` |

In Review mode also check what `/write` owns, from its output: an item built new where something existing answered it, a test net that was never proven, a change that breaks the specs. For each decision `/write` flags to record, propose the record `references/structure.md` matches to its weight.

## Evidence

| Mark | Means |
|---|---|
| `traced` | Followed through the code to file and line |
| `read` | Seen in the code, not followed |
| `searched` | A search matched; meaning and completeness unknown |
| `unrun` | Needs execution to know; this skill does not run code |

## Severity

| Sev | Means |
|---|---|
| High | Breaks a promise of the goal or the specs, or blocks the work list |
| Med | A shape or name that departs from the record or convention and will spread |
| Low | Local polish |

## Communication

Write the report in ASD-STE100 style, in the user's language:

- One instruction per sentence, in the imperative; the condition comes before it.
- Instructions stay under 20 words; descriptions under 25.
- Active voice and simple tenses.
- One word for one meaning; refer to a finding by its id after its first statement.
- One topic per paragraph, at most six sentences.

## Output

Every report has this shape. `/goal` checks the last line, so keep its format exact.

```markdown
# /inspect [--deep] — <what this round is for>

Goal: … · Bounds: … · References: …
Coverage: <command or range read in full> · Read closely: … · Seen, not opened: …

| # | Sev | Evidence | Where | What stands between here and the goal |
|---|---|---|---|---|
| G1 | High | traced | `links_controller.rb:19` | expired links answer 404; the goal needs 410 |

**Work list** (Plan mode)

| Order | # | The work | Why it sits here |
|---|---|---|---|

**Still unknown:** <each question and what its answer changes, or "none">

Verdict: High <n> · Spec drift <none | G#…> · Coverage <full | partial: what was skipped>
```

- Bounds are the limits the user set; References are what they pointed at as the way to work. Both come only from what they said.
- Coverage names the real command or range. Partial coverage says what was skipped.
- Add two or three sentences under a finding only when its row cannot carry the reasoning.
- In Plan mode, end with one line offering `--deep` when leads remain unverified.
