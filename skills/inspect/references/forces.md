# Forces

Open this when a structural commitment is still open — Clean Architecture, DDD, a pattern, a scaffold. The output is a memo the user decides on. Plan mode is where this belongs: the option space is open while the user is present. A direction they confirm goes into the work list's References.

## Six forces

Look through every force. "Does not apply here" is a valid answer when it was checked.

| Force | Asks |
|---|---|
| Delivery pressure | Can a deeper investment pay back in the time available? |
| Rule complexity | Are the rules thick enough to model explicitly? |
| Change rate | Is flexibility now cheaper than rework later? |
| Team fragmentation | Will several teams or roles describe this in their own words? |
| Blast radius | What breaks if this is wrong, and how visibly? |
| Code maturity | Does the surrounding code need preparing first? |

Read signals before asking: the dependency manifest, `git log` churn, contributors, test presence, and words in the spec like "workflow", "invariant", "payment". Ask the user at most three questions, only for gaps.

## Option space

Give four to six options grounded in this codebase. The space includes:

- The framework's idiomatic option, in the framework's own vocabulary.
- At least one "do less" option: framework default, defer with a trigger, a spike.
- A meta-level option where plausible: a scaffold or generator, an internal library, a workflow change.
- One or two structural options.

Principles — KISS, SOLID, DRY, YAGNI — apply under every option; they are not options.

## Memo

Keep it under one screen. When a recorded pattern still fits, the memo confirms it and stops.

```markdown
# Design Analysis: <task>

## Context
<what is built, in which codebase and framework>

## Existing patterns considered
<recorded pattern: applies / applies with caveats / no longer fits because <trigger> — or "none">

## Forces in play
<one line per force, with its evidence>

## Options
1. **<name>** — <shape>; Pros: …; Cons: …

## Soft recommendation
<Lean toward N because …. Would change to M if <observable condition>.>

## Worth confirming
<1-2 questions whose answers change the recommendation>
```
