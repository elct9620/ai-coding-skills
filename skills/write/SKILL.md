---
name: write
description: Implement a feature, correct a defect, or restructure code without changing behavior — done right and done the right way, at the smallest scope that works, with a test net proven to catch a real break. Takes the work list or findings from /inspect.
argument-hint: [feature|finding|path]
allowed-tools: Read, Grep, Glob, Edit, Write, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, WebFetch, TaskCreate, TaskUpdate
---

## Purpose

`/write` answers one question: **is it done right, and done the right way?** Right is the implementation: the behavior the specs promise, at the smallest scope that works. The right way is the process: tests that hold, How We Work in `AGENTS.md`, and nothing reopened that `/inspect` settled. Shape and names belong to `/inspect`.

## Sources

| Source | Then |
|---|---|
| A work list `/inspect` confirmed | Take its items, Bounds, and References as decided; ask nothing and run to the end |
| Findings from an `/inspect` review | Each finding is an item |
| Nothing — called on its own | Clarify scope with the user, take the answers as Bounds, and confirm the plan first |

Track the items with TaskCreate so progress stays visible.

## Kinds of work

| Kind | Holds when | Reference |
|---|---|---|
| Feature | Each promise it makes has a test | `references/smallest-change.md` |
| Defect | The fix sits where the cause lives and covers every caller that reaches it | `references/smallest-change.md` |
| Refactor | The semantic contract is unchanged | `references/smallest-change.md` |

A refactor that would change the contract — return meaning, completion timing, error model, side effects at return — is a behavior change. Stop and report it instead of continuing as a refactor.

## Principles

- Climb before writing: something that exists usually answers the item. The smallest change in the wrong place is a second defect.
- Build outside-in: the user-facing layer first, storage decisions last.
- Check an API against its official documentation first; read its source only when the documentation does not settle it.
- Turn doubt about behavior into a test. A one-off `node -e` or `ruby -e` leaves no net behind.
- Prove the net: break one promise on purpose, watch a test fail, restore it, and confirm the diff matches.
- Let names carry intent. Comment a library's public API, or a value that references something external; otherwise write none.
- Write what is true now. A corrected attempt needs no comment about the wrong one.
- Reach for a design pattern or an abstraction only for a variation that exists today.
- Follow `docs/architecture.md` and the References. A departure is reported, not taken quietly.
- Follow How We Work in `AGENTS.md` for commits, specs, and documents.

## References

Open a reference when the work contains what it covers.

| Reference | Open when the work involves |
|---|---|
| `references/smallest-change.md` | Every item — the climb, defect location, refactoring order |
| `references/testing.md` | Every item — the test net and its proof |
| `references/domain.md` | Business rules, invariants, or domain objects |
| `references/boundaries.md` | Schemas, API contracts, external input, auth, or secrets |

## Communication

Write the report in ASD-STE100 style, in the user's language:

- One instruction per sentence, in the imperative; the condition comes before it.
- Instructions stay under 20 words; descriptions under 25.
- Active voice and simple tenses.
- One word for one meaning; reuse the item names from the work list.
- One topic per paragraph, at most six sentences.

## Output

Every report has this shape. `/goal` checks the last line, so keep its format exact.

```markdown
# /write — <what this round built>

| Item | Kind | Stopped at | Promises → tests | Net |
|---|---|---|---|---|
| G1 | Defect | existing `ExpiryPolicy` | 410 for expired → `links_spec.rb:42` | held |

Departures: <from References or the recorded structure, or "none">
Decisions to record: <a structural decision likely to recur, or "none">

Result: Items <done>/<total> · Tests `<command>` → <pass | fail> · Net held <n>/<total>
```

- Stopped at names the rung or the refactoring technique, and what it uses.
- Net is `held`, `unverified` (no promise worth breaking), or `missing` (the break went unnoticed — a test is owed).
- The test command is the one actually run, with its real result.
