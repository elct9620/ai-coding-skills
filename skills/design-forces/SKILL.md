---
name: design-forces
description: Surface design forces and lay out the option space — including framework defaults, scaffolds, and deferring — before committing to Clean Architecture, DDD, or any heavier pattern. Produces a Design Analysis Memo at the start of /write, /refactor, or non-trivial /fix. Make sure to use this skill whenever the user starts a non-trivial feature, restructures code, or asks "do we really need Clean Architecture / DDD / pattern X here".
---

## Related Skills

- Memo recommends modelling rules explicitly? → **domain-modeling**
- Memo recommends a layered or partitioned structure? → **architecture**
- Memo recommends introducing a Strategy / Polymorphism for a recurring variation? → **design-patterns**
- Memo says open a seam in legacy code first? → **refactoring**
- Memo flags a trust boundary? → **security** + **schema** + deeper **testing**

Principles (KISS, SOLID, DRY, YAGNI, fail-fast) apply underneath every option. The memo operates one layer above them.

## Applicability Rubric

| Condition | Pass |
|-----------|------|
| Architectural commitment on the table | Question of the form "do we use CA / DDD / pattern X / scaffold?" is live |
| Non-trivial scope | Feature crosses files or layers, or replaces existing behaviour |
| Surrounding code lacks a clear convention | Legacy area or framework-inconsistent code |
| Risk-bearing change | Auth, payments, data integrity, external API, migration |

**Apply when**: Any condition passes.

## What the Memo Produces

A short note for the developer: **forces** pulling on the decision, **4–6 options** drawn from this codebase, framework, and wider repertoire (framework defaults, scaffolds, internal libraries, defer, spike, plus structural choices), **trade-offs**, and a **soft recommendation** with the conditions under which it would change. The developer reads and decides; other skills activate based on the chosen direction.

## Six Forces (lenses)

| Force | The question this lens asks |
|-------|------------------------------|
| Delivery pressure | Is the cost of deeper investment recoverable in the time we have? |
| Rule complexity | Are the rules thick enough to deserve explicit modelling? |
| Change rate | Is paying upfront for flexibility cheaper than paying later for rework? |
| Team and language fragmentation | Will more than one team or role describe this in their own words? |
| Blast radius | What breaks if this is wrong, and how visibly? |
| Code maturity | Does the surrounding code need preparing before this lands cleanly? |

Look through every lens. "Doesn't really apply here" is a fine answer, as long as the lens was consulted.

## Diagnosis Protocol

### Step 0 — Read recorded patterns

| Source | What to find |
|--------|--------------|
| `docs/architecture.md` Patterns section | Lightweight pattern entries the team has already chosen |
| `docs/decisions/` (or `docs/adr/`) | Heavier ADRs when present |
| `docs/architecture.md` body | Style declarations (Pure CA, CA+DDD, conventional Rails) |

For each recorded pattern overlapping the task's surface, ask: does the situation still match, and have any revisit triggers fired? If a recorded pattern fits and triggers are quiet, write a Confirming Memo and stop. Otherwise continue.

### Step 1 — Read codebase and framework

Framework posture is the priority signal — the idiomatic option is a first-class candidate, not a baseline to bypass.

| Signal | Source | Maps to |
|--------|--------|---------|
| Framework + idiom | `Gemfile`, `package.json`, `pyproject.toml`, `go.mod`; `app/services/`, `pages/`, `cmd/` | Framework posture, conventional option |
| File age & churn | `git log --since='3 months ago' -- <paths>` | Change rate, code maturity |
| Contributors | `git shortlog -sn --since='6 months ago'` | Team fragmentation |
| Test presence | `find . -name '*_test.*' -o -name '*.spec.*'` | Code maturity |
| Domain hints in spec | "multi-step", "workflow", "invariant", "approval" | Rule complexity |
| Risk hints in spec | "payment", "auth", "PII", "audit" | Blast radius |
| Repetition signal | 2+ similar structures already hand-written; a third coming | Scaffold/generator as candidate |

Use signals first. Reach for questions only for gaps.

### Step 2 — Ask up to three targeted questions

| Question | Pins |
|----------|------|
| When does this need to ship? | Delivery pressure |
| How likely is this spec to change in the next 6 months? | Change rate |
| Will more than one team or role describe this in their own words? | Team fragmentation |
| What breaks for users if this is wrong? | Blast radius |
| Is this likely the first of several similar features? | Scaffold/generator candidacy |
| How comfortable is the team deviating from the framework's idiomatic shape? | Realism of non-idiomatic options |

When a signal strongly implies an answer, state the inference and move on.

### Step 3 — Generate options

Aim for 4–6, grounded in this project. Include:

- The idiomatic option for the framework in use, named with its own vocabulary
- At least one "do less" option (framework default, defer with a trigger, throwaway spike)
- At least one meta-level option where plausible (scaffold/generator, internal library, workflow change)
- One or two structural options drawing on this repo's skills

### Step 4 — Write the memo

Keep it under one screen.

## Memo Template

```markdown
# Design Analysis: <task name>

## Context
<2-3 sentences: what is being built, in what codebase, with what framework.>

## Existing patterns considered
<For each overlapping recorded pattern: applies cleanly / applies with caveats / no longer fits because <trigger>. Or: "None — fresh decision.">

## Forces in play
- Delivery pressure: <level — evidence>
- Rule complexity: <…>
- Change rate: <…>
- Team fragmentation: <…>
- Blast radius: <…>
- Code maturity: <…>

## Options on the table
1. **<Concrete option name>** — <shape in one sentence>; Pros: <…>; Cons: <…>
2. ...

## Trade-offs
<Strongest tension. Which forces pull which way. Cost of being wrong in each direction.>

## Soft recommendation
<Lean toward Option N because <forces and grounding>. Would change to Option M if <observable condition>.>

## Worth confirming before committing
<1–2 questions whose answers would meaningfully change the recommendation.>

## Recording (if adopted)
<If the option is likely to recur, propose a Patterns-section entry (see format below). For a one-off, write "One-off — no recording." For a large-blast-radius / multi-team / hard-to-reverse decision, propose an ADR in `docs/decisions/` instead.>
```

## Confirming Memo

When Step 0 finds a recorded pattern that fits cleanly:

```markdown
# Design Analysis: <task name> (confirming existing pattern)

Falls under recorded pattern **<name>** in docs/architecture.md.

## Forces re-check
- <Each force in one line, confirming the situation still matches.>
- <If any revisit trigger has fired, switch back to the full memo.>

## Plan
Apply the pattern as recorded. Canonical example: <file path>.

## Anything unusual
<One sentence on what differs (if anything) and how to handle it. "Standard application." is a valid answer.>
```

## Patterns Section Format

Lives in `docs/architecture.md`. Each entry is ~6–10 lines.

```markdown
## Patterns

### <Pattern name in this project's vocabulary>
- **When to apply**: <situation in this project, 1-2 sentences>
- **Shape**: <structural commitment — e.g. "service object + audit invariant + role check at the use case boundary">
- **Canonical example**: <file path>
- **Forces this resolves**: <dominant forces that selected this>
- **Revisit if**: <observable condition that would prompt reconsideration>
```

**An entry earns its place when**:

- The decision will plausibly recur (≥2 future tasks of similar shape are likely)
- The shape is non-obvious from the canonical example alone — there is a *reason* this was chosen over alternatives
- The forces that selected it might change, and the team wants the trigger written down

**For decisions large enough to need full context, alternatives discussion, and explicit acceptance** — large blast radius, multi-team, hard to reverse — write an ADR in `docs/decisions/` instead.

## Completion Rubric

### Memo quality

| Criterion | Pass |
|-----------|------|
| All six lenses consulted | Each force has a line, evidenced from a signal or an answer |
| Recorded patterns considered | Step 0 result appears in the memo |
| Framework posture named | The idiomatic option appears as a real candidate, in the framework's own vocabulary |
| Option space deliberately wide | At least one "do less" option and, where plausible, one meta-level option |
| Grounded in this codebase | Option names refer to actual directories, conventions, or libraries here |
| Soft recommendation conditional | Includes the observable conditions that would change it |
| Principles as baseline | Memo treats KISS / SOLID / DRY / YAGNI as baseline underneath every option |

### Cost respected

| Criterion | Pass |
|-----------|------|
| Time budget | Diagnosis completes in a single short turn |
| Signal-first | Codebase and framework signals consulted before user questions |
| Question budget | ≤3 questions asked of the user |
| Memo length | Body fits under one screen |

### Handoff

| Criterion | Pass |
|-----------|------|
| Clear next step | Memo ends with the developer's next move — confirm, redirect, or sanity-check named items |
| Recording proposed when appropriate | If the option will recur, a Patterns-section entry is drafted; if heavy, an ADR is named |
