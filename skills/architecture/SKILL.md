---
name: architecture
description: Plan how a system is structured — which layers, modules, or contexts exist and how code is laid out — driven by the forces at play, not by a fixed pattern. The default is to add no extra structure; structure is introduced only when complexity calls for it, and the chosen shape (Clean Architecture, DDD, DCI, or another) is judged in the moment. Use this skill when following a recorded structure in docs/architecture.md, or when deciding the structural shape for a non-trivial feature, a new module, or a restructuring — especially after a design-forces memo recommends a layered or partitioned structure.
---

## Related Skills

This skill owns **structural planning** — how the system is organised. Two neighbouring concerns are different *kinds* of problem and stay separate:

- Defining what the domain concepts *are* (Entity, Value Object, Aggregate, Domain Event)? → **domain-modeling**. Structure follows the model: context and module boundaries align with aggregate boundaries, so let domain-modeling settle those first.
- Solving a recurring local problem with a named pattern (Strategy, Adapter, Observer…)? → **design-patterns**.
- Moving code between structures safely? → **refactoring** for the mechanical steps.
- A trust boundary in the structure? → **security** + **schema**.

A **design-forces** memo, when one exists, is the input to this skill: it carries the force signals that decide whether and what to structure. Principles (KISS, SOLID, DRY, YAGNI, fail-fast) are how every structure is implemented, never something a structure replaces.

## The default is no extra structure

Start from the position that the feature needs **no architectural ceremony beyond what the framework already gives you**. A framework is itself an architecture; following its grain plainly is a legitimate, often correct, answer. Structure earns its place only when forces make the absence of it more expensive than the cost of adding it.

Resist mapping a framework to a named style by reflex ("Rails, so DCI"; "Spring, so layers"). That is mechanical correspondence wearing a different hat — it bypasses the judgement that makes structure fit. The framework's nature is one *input* to the force judgement, not a lookup that pre-decides the answer.

## When this skill applies — two modes

### Mode A — follow the recorded structure (cheap path)

`docs/architecture.md` is a deliberately cheap, maintainable signal. When it exists and covers the area being touched:

1. Read its style declaration and Patterns section.
2. Apply the recorded structure as-is.
3. Re-open the decision **only** if a recorded revisit trigger has fired.

No fresh analysis. This is what makes a structural decision persist across features instead of being re-litigated every time. (A design-forces memo reaches the same conclusion via its Confirming Memo; this skill honours the record directly when invoked without one.)

### Mode B — decide the structure (fresh)

When there is no record covering this area, or a revisit trigger has fired, the question is **not** "is `docs/architecture.md` missing?" — it is **"is this now complex enough to need structural planning?"**

Read the force signals (from the design-forces memo if present, otherwise a light read of the same signals):

| Force | What pushes toward adding structure |
|-------|--------------------------------------|
| Rule complexity | Multi-step invariants, state machines, consistency boundaries — not field validation |
| Change rate | The shape will churn; isolation pays for itself over time |
| Blast radius | Failure is costly or visible; isolation contains it |
| Team fragmentation | More than one team or vocabulary touches the same nouns |
| Delivery pressure | Pulls the *other* way — is the investment recoverable in the time available? |
| Code maturity | Does the surrounding code even support the structure landing cleanly yet? |

- **Forces are quiet** → stay with the default: framework as-is, no extra structure. This is the right answer far more often than the instinct to "set up the architecture" suggests.
- **Forces are loud** → they show up as a concrete symptom in the code or the work. Recognise the symptom, then go read the technique that speaks to it. Each reference solves a specific kind of problem:

**Changes keep rippling outward.** Touch the framework, the database, or one module and you keep having to edit elsewhere — a small change breaks code other people depend on. That is change amplification. Clean Architecture's idea — controlling which way dependencies point, so they all point inward toward the stable business rules — is what addresses it. → `references/clean-architecture.md`

**The same words mean different things in different places.** Distinct subdomains are crammed into one model, teams trip over each other's invariants, or "order" means one thing to sales and another to shipping. DDD's strategic side — partitioning the system along those meanings so each region keeps one language and one set of consistency boundaries — addresses it. → `references/ddd.md`

**A use case's behaviour is scattered and hard to follow.** The logic of one scenario spans several objects with no single place that tells its story, or data classes bloat because every use case piles methods onto them. DCI — separating slow-changing data from fast-changing behaviour, casting behaviour onto data as roles within a context — addresses it. → `references/dci.md`

These are starting points, not an exhaustive list, and they compose (CA controls dependency direction, DDD partitions the domain, DCI organises behaviour). If the symptom matches none of them, reason from the forces and principles directly — the technique that fits may simply not be named here.

After committing, **record the decision** so Mode A applies next time (see Recording below).

## Module Type

Pick once per package; it decides whether the source is the documentation or whether signatures must carry intent. Feeds the **principles** Commenting rules.

| Module type | Audience | Public symbols |
|-------------|----------|----------------|
| Application | Operators, end users | Source is the documentation |
| Library / shared module | Other developers via IDE | Signatures carry doc comments stating intent |
| Monorepo with both | Both | Decide per package, not per file |

## Recording the decision

A fresh Mode B decision should leave a trace, so the next feature reads it instead of re-deciding. Match the weight of the record to the weight of the decision:

- **Default — Patterns section in `docs/architecture.md`** (~6–10 lines): name in this project's vocabulary / when to apply / shape / canonical example / forces it resolves / revisit-if.
- **Style declaration in `docs/architecture.md`** when the choice sets a project-wide default (e.g. "layered with an inward dependency rule").
- **ADR in `docs/decisions/`** only when the decision is large-blast-radius, multi-team, or hard to reverse.

If `docs/architecture.md` does not exist and a structure was chosen, create it with the style declaration, a directory→structure mapping, and the dependency guidelines for the chosen technique.

## Completion Rubric

| Criterion | Pass |
|-----------|------|
| Recorded structure honoured | Mode A path taken when `docs/architecture.md` covers the area; no needless re-analysis |
| Default respected | Mode B starts from "no extra structure"; structure added only on a loud force, not on a missing doc |
| No framework reflex | Technique chosen from the symptom in the work, not from a framework→style lookup |
| Force-justified | The chosen technique names the specific symptom (loud force) it resolves |
| Boundaries follow the model | Context/module partitioning aligns with aggregate boundaries from domain-modeling |
| Dependency direction sound | If a layered/CA technique was chosen, dependencies point inward; no circular references |
| Recorded when fresh | A Mode B decision left a Patterns entry, style declaration, or ADR sized to the decision |
| Principles as baseline | KISS / SOLID / DRY / YAGNI treated as how the structure is built, never as something it defers |
