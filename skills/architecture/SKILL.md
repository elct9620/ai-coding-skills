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

No fresh analysis — this is what makes a structural decision persist across features instead of being re-litigated every time.

### Mode B — decide the structure (fresh)

When there is no record covering this area, or a revisit trigger has fired, the question is **not** "is `docs/architecture.md` missing?" — it is **"is this now complex enough to need structural planning?"**

Read the force signals — from the design-forces memo if present, otherwise a light read of the same lenses. Rule complexity, change rate, blast radius, and team fragmentation push toward structure; delivery pressure and code maturity pull back.

- **Forces are quiet** → stay with the default: framework as-is, no extra structure.
- **Forces are loud** → they surface as a concrete symptom. Recognise it, then read the technique that answers it (the reference explains how):

  - **Changes keep rippling outward** — touch one thing and you keep breaking code others depend on → `references/clean-architecture.md`
  - **The same word means different things in different places** — subdomains crammed into one model, teams tripping over each other's invariants → `references/ddd.md`
  - **A use case's behaviour is scattered** — one scenario's logic spans several objects with no place that tells its story → `references/dci.md`

These are starting points, not a menu; they compose, and a symptom matching none means reasoning from forces and principles directly.

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
| Record respected | An existing structure in `docs/architecture.md` is followed without re-analysis; a fresh decision leaves a record sized to it (Patterns entry, style declaration, or ADR) |
| Structure earned | Default is no extra structure; it is added only on a loud force named as a symptom — never from a missing doc or a framework→style reflex |
| Boundaries follow the model | Context/module partitioning aligns with aggregate boundaries from domain-modeling |
| Dependency direction sound | If a layered/CA technique was chosen, dependencies point inward; no circular references |
| Principles as baseline | KISS / SOLID / DRY / YAGNI treated as how the structure is built, never as something it defers |
