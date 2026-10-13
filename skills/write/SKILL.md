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

| Kind | Holds when |
|---|---|
| Feature | Each promise it makes has a test |
| Defect | The fix sits where the cause lives and covers every caller that reaches it |
| Refactor | The semantic contract is unchanged |

A refactor that would change the contract is a behavior change. Hold it for the user instead of continuing as a refactor.

## Held for the User

Some items only the user can decide: a structural choice, a preference, a contract change. Follow the References and `docs/architecture.md` first. When they do not settle it, run `/inspect` to look for the user's preference. When only the user can decide, report the item, set it aside, and continue with the rest; a running `/goal` cannot stop to ask.

## Principles

- Keep the whole in view. Before each change, re-check the scope and the files around it: callers, siblings, the convention, `git log`. A change judged from one file is judged blind.
- Climb before writing: something that exists usually answers the item. The smallest change in the wrong place is a second defect.
- Build inside the shape `/inspect` settled, outside-in — `references/design.md`.
- Check an API against its official documentation first; read its source only when the documentation does not settle it.
- Write tests with the code, turn doubt into a test, and prove the net — `references/testing.md`.
- Let names carry intent. Comment a library's public API, or a value that references something external; otherwise write none.
- Write what is true now. A corrected attempt needs no comment about the wrong one.
- Reach for a design pattern or an abstraction only for a variation that exists today.
- Follow How We Work in `AGENTS.md` for commits, specs, and documents.

## References

Open `references/smallest-change.md` and `references/testing.md` before the first item. Open `references/design.md` when the work contains what it covers.

| Reference | Open when the work involves |
|---|---|
| `references/smallest-change.md` | Every item — the climb, defect location, refactoring order |
| `references/testing.md` | Every item — the test net and its proof |
| `references/design.md` | Building inside a shape: domain objects, layers, boundaries, auth |

## Communication

- Write in the user's language. Explain each term at first use, and restate a concept when returning to it.
- Every mention of an item id, in tables and prose alike, carries a phrase saying what it is.
- Use a diagram where structure carries meaning: flow, layers, tree (before → after), sequence, or pseudocode.
- Draw diagrams with Unicode box-drawing characters and English labels.
- Keep one point per sentence and one topic per paragraph.

## Output

The report opens with its conclusion. The conclusion states facts only and never says whether the round may end; `/goal` reads its four rows, so keep them in this order.

```markdown
# /write — <what this round built>

## <"Conclusion" in the user's language>

| Check | Result |
|---|---|
| Items | <done> of <total>; each open one as id + phrase |
| Tests | `<command actually run>` → <pass, or what failed> |
| Test net | proven for <n> of <total>; each other one as id + phrase |
| Decisions held for the user | <count; each as id + phrase> |

| Item | Kind | Stopped at | Promises → tests | Net |
|---|---|---|---|---|
| G1 expired links answer 404 | Defect | existing `ExpiryPolicy` | 410 for expired → `links_spec.rb:42` | Held |

Departures: <from References or the recorded structure, or "none">
Decisions to record: <a structural decision likely to recur, or "none">
```

- Stopped at names the rung or the refactoring technique, and what it uses.

| Net | Means |
|---|---|
| Held | A promise was broken on purpose and a test failed |
| Unverified | The scope carries no promise worth breaking |
| Missing | The break went unnoticed; a test is owed |
