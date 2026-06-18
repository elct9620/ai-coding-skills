---
name: roadmap
description: Maintain ROADMAP.md as a spec-to-implementation tracking index. Use when checking feature implementation status, initializing a roadmap from SPEC.md, or updating feature progress. Reduces codebase scanning by linking each feature to its entry points (directories, files).
argument-hint: [init|update|status] [--deep] [feature]
# --deep only applies to init and update, ignored for status
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Agent(Explore)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## ROADMAP.md Format

ROADMAP.md acts as a spec-to-implementation index. It tracks the project's feature list — the features the spec commits to — and records the implementation status of each, one row per feature, so the whole thing stays scannable at a glance.

A spec is organized by layers (intent, behaviors, terminology), not by feature, and its shape changes with size: a small project keeps everything inline in SPEC.md, a larger one splits each feature into its own detail document. A roadmap row maps to a feature wherever it lives — an inline section, a group of behaviors, or a linked detail document — and follows the spec's own feature order. Supporting content such as purpose, terminology, or cross-cutting error scenarios is not a feature and gets no row.

The roadmap's sectioning mirrors the spec's context boundaries, never its feature granularity. When the spec keeps everything in one context, the roadmap is a single flat table with no headings. When the spec partitions features by bounded context or domain — grouping them under context headings in Scope, or splitting detail documents into context groups — give each context its own `## [Context]` heading with its own flat feature table, in the spec's order. Either way, a feature is never its own section.

The description paragraph below the heading summarizes the project's purpose and key features, giving readers immediate context without needing to read the full spec.

**Single context — one flat table:**

```markdown
# Roadmap

A task management app built with Rails. Features include user authentication,
billing with Stripe integration, and team-based task management.

| Feature | Entry Points | Notes |
|---------|-------------|-------|
| ✅ [User Authentication](SPEC.md#user-authentication) | [src/auth/](src/auth/) | JWT-based, refresh token rotation |
| 📌 [Task Management](SPEC.md#task-management) | — | Not started |
| ⏳ [Billing](docs/billing.md) | [src/billing/](src/billing/) | Plan validation only; payment and cancel missing |
```

**Partitioned by bounded context — one `## [Context]` section per context, each a flat table:**

```markdown
# Roadmap

A subscription billing service. Account owners manage plans and payment;
finance admins review monthly invoices.

## Subscriptions

| Feature | Entry Points | Notes |
|---------|-------------|-------|
| ✅ [Plan Catalog](docs/plan-catalog.md) | [src/subscriptions/plan.rb](src/subscriptions/plan.rb) | List and find-by-id, both tested |
| ⏳ [Subscription Lifecycle](docs/subscription-lifecycle.md) | [src/subscriptions/subscription.rb](src/subscriptions/subscription.rb) | Subscribe and upgrade done; cancel missing |

## Billing

| Feature | Entry Points | Notes |
|---------|-------------|-------|
| ⏳ [Payment](docs/payment.md) | [src/billing/payment.rb](src/billing/payment.rb) | Implemented; no test exercises it (unverified) |
| 📌 [Invoicing](docs/invoicing.md) | — | Not started |
```

**Column rules:**
- **Feature**: status emoji followed by a markdown link whose text matches the feature name and whose href points to the spec source — either `SPEC.md#section-anchor` when defined inline, or the detail document path (e.g. `docs/billing.md`) when the spec has been split out
- **Entry Points**: a single markdown link to where a reader starts reading the feature's code — the directory (trailing `/`, e.g. `[src/billing/](src/billing/)`) when the feature owns it, or one representative file (e.g. `[src/billing/payment.rb](src/billing/payment.rb)`) when it shares a directory with other features. Keep it to one link; enumerating several files just re-expands the directory and defeats the purpose of a single starting point. Use `—` if none
- **Notes**: quick context for navigating the feature — technology choices, current gaps, key implementation details; helps locate relevant code when debugging or onboarding; use `—` if nothing to note

### Status Emoji

| Emoji | Meaning | When |
|-------|---------|------|
| 📌 | pending | No implementation found |
| ⏳ | in progress | Some behaviors implemented |
| ✅ | completed | Every spec behavior is exercised by a test |

### Status Transitions

| From | To | When |
|------|----|------|
| 📌 pending | ⏳ in progress | Implementation begins |
| ⏳ in progress | ✅ completed | Every spec behavior is exercised by a test |
| ✅ completed | ⏳ in progress | Spec updated with new or changed behaviors |
| ⏳ in progress | 📌 pending | Implementation rolled back or restarted |

Status may regress when the spec evolves — this is expected and should be noted.

By default this command reads code and tests rather than running them, so "exercised by a test" is judged by reading: a behavior qualifies when a test calls it. Whether that test passes is stronger evidence — to confirm it, read a test or coverage report when the project produces one, or ask the user for permission to run the suite (running is outside the command's default tools, so it needs the user's approval). When passing cannot be confirmed, still mark ✅ on read coverage but note in the row that the result is unverified.

## Definition

<function name="locate-spec">
    <description>Find the spec and extract its feature list — the features that become roadmap rows.</description>
    <step>1. search for SPEC.md in the project root and common locations (docs/, spec/)</step>
    <step>2. identify the feature list. A spec is organized by layers, not by feature, and names its features differently depending on size — find them in whichever of these shapes the spec uses:</step>
    <step>   - a scope or feature-list section enumerates them directly → take that list and its order</step>
    <step>   - features written inline as their own sections → each such section is a feature</step>
    <step>   - table-of-contents mode (SPEC.md links out to detail documents) → each linked detail document is a feature</step>
    <step>   - a small spec with one behavior table and no per-feature split → treat the whole spec as a single feature, or the few groupings it names</step>
    <step>3. ignore non-feature content: purpose, users, terminology, patterns, and cross-cutting error scenarios do not become rows</step>
    <step>4. note whether the spec partitions features by bounded context or domain (grouped under context headings in Scope, or split into context groups of detail documents) — if so, record each feature's context and the context order so the roadmap can mirror it as `## [Context]` sections; otherwise the roadmap stays a single flat table</step>
    <step>5. for each feature, determine its spec reference — SPEC.md#section-anchor when defined inline, or the detail document path (e.g. docs/billing.md) when split out</step>
    <step>6. for each feature, extract the behaviors or acceptance criteria that define when it is done</step>
    <return>ordered feature list (with bounded-context grouping when present), each feature with a spec reference (linkable path) and expected behaviors</return>
</function>

<function name="locate-roadmap">
    <description>Find and parse the existing ROADMAP.md, if any.</description>
    <step>1. search for ROADMAP.md in the project root</step>
    <step>2. if found, parse each feature entry: status, spec reference, entry points, notes</step>
    <step>3. if not found, return empty (will be created by init)</step>
    <return>parsed roadmap entries or empty</return>
</function>

<function name="scan-implementation">
    <description>Check actual implementation status for a feature by examining its entry points and tests. When --deep is set, spawns Agent(Explore) sub-agents with model=sonnet for behavior-level tracing.</description>
    <parameter name="feature" type="object" description="Feature with spec behaviors and known entry points." required="true"/>
    <parameter name="deep" type="boolean" description="When true, use Sonnet sub-agents for recursive code tracing." required="false"/>

    <step>1. if entry points are known from existing roadmap, start scanning there</step>
    <step>2. if no entry points, use keyword search (feature name, related domain terms) to locate relevant code</step>

    <condition if="$deep">
        <step>3. spawn one Agent(Explore) with model=sonnet per feature (parallel when multiple features)</step>
        <step>4. each agent receives the feature's expected behaviors and known entry points</step>
        <step>5. the agent recursively traces code from entry points: follows function calls, module imports, and dependency chains to find where each behavior is actually implemented</step>
        <step>6. for each expected behavior, the agent reports: implemented and tested, implemented but no test, or not found</step>
        <step>7. use the agent's findings to determine status and collect precise entry points</step>
    </condition>
    <condition if="not $deep">
        <step>3. check for corresponding test files that exercise the feature behaviors</step>
        <step>4. compare implemented behaviors against spec expectations</step>
    </condition>

    <step>8. determine status:</step>
    <step>   - every behavior exercised by a test → completed</step>
    <step>   - some behaviors implemented → in progress</step>
    <step>   - no implementation found → pending</step>
    <step>9. collect the directories and files that serve as entry points for this feature</step>
    <step>10. compose notes summarizing coverage gaps, technology choices, and key findings</step>
    <return>detected status, entry points list, and notes for ROADMAP.md</return>
</function>

<function name="write-roadmap">
    <description>Write or update ROADMAP.md with the collected feature statuses.</description>
    <parameter name="features" type="list" description="Features with detected statuses and entry points." required="true"/>
    <parameter name="existing-roadmap" type="object" description="Previously parsed roadmap entries, if any." required="false"/>
    <step>1. for each feature, merge detected status with existing roadmap data:</step>
    <step>   - preserve manually written notes from existing entries</step>
    <step>   - update status only if evidence supports the change</step>
    <step>   - update entry points to reflect current codebase state</step>
    <step>2. write a description paragraph summarizing the project's purpose and key features</step>
    <step>3. order rows to match the feature list from locate-spec (the spec's own feature order); when locate-spec found a bounded-context grouping, place each context under its own `## [Context]` heading in the spec's context order, otherwise emit a single flat table</step>
    <step>4. write ROADMAP.md following the defined format</step>
    <step>5. report changes: which features changed status, which entry points were added or removed</step>
    <return>written ROADMAP.md path and summary of changes</return>
</function>

<function name="status-report">
    <description>Generate a focused status report for a specific feature or the full roadmap.</description>
    <parameter name="feature" type="string" description="Feature name to report on, or empty for full summary." required="false"/>
    <parameter name="roadmap" type="object" description="Parsed roadmap data." required="true"/>
    <condition if="$feature is specified">
        <step>1. find the feature in the roadmap</step>
        <step>2. show its status, spec reference, entry points, and notes</step>
        <step>3. if entry points exist, briefly verify they still exist in the codebase</step>
    </condition>
    <condition if="$feature is empty">
        <step>4. summarize all features grouped by status</step>
        <step>5. show counts: N completed, N in progress, N pending</step>
    </condition>
    <return>status report for the requested scope</return>
</function>

<procedure name="main">
    <parameter name="action" type="string" description="Action: init, update, status. Defaults to status if ROADMAP.md exists, init otherwise." required="false"/>
    <parameter name="deep" type="boolean" description="When set, use Sonnet sub-agents in scan-implementation for behavior-level tracing. Only applies to init and update." required="false"/>
    <parameter name="feature" type="string" description="Optional feature name to narrow scope." required="false"/>

    <step>1. <execute name="locate-roadmap"/></step>

    <condition if="$action == 'init' or (no action given and no ROADMAP.md exists)">
        <step>2a. <execute name="locate-spec"/></step>
        <condition if="no SPEC.md found">
            <step>3a. report that no SPEC.md was found — roadmap requires a spec to track against</step>
            <return>error: no spec found</return>
        </condition>
        <step>4a. for each feature from spec, <execute name="scan-implementation" feature="$feature" deep="$deep"/></step>
        <step>5a. <execute name="write-roadmap" features="$scanned-features"/></step>
        <return>initialized ROADMAP.md with current implementation statuses</return>
    </condition>

    <condition if="$action == 'update'">
        <step>2b. <execute name="locate-spec"/> (the existing roadmap is already loaded from step 1)</step>
        <condition if="$feature is specified">
            <step>3b. <execute name="scan-implementation" feature="$feature" deep="$deep"/></step>
        </condition>
        <condition if="$feature is empty">
            <step>4b. for each feature from spec, <execute name="scan-implementation" feature="$feature" deep="$deep"/> using existing entry points to narrow search scope</step>
        </condition>
        <step>5b. <execute name="write-roadmap" features="$scanned-features" existing-roadmap="$existing-roadmap"/></step>
        <return>updated ROADMAP.md with changes summary</return>
    </condition>

    <condition if="$action == 'status' or (no action given and ROADMAP.md exists)">
        <step>2c. <execute name="status-report" feature="$feature" roadmap="$existing-roadmap"/></step>
        <return>status report</return>
    </condition>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
