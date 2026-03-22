---
name: roadmap
description: Maintain ROADMAP.md as a spec-to-implementation tracking index. Use when checking feature implementation status, initializing a roadmap from SPEC.md, or updating feature progress. Reduces codebase scanning by linking each feature to its entry points (directories, files).
argument-hint: [init|update|status] [feature]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Agent(Explore)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## ROADMAP.md Format

ROADMAP.md acts as a spec-to-implementation index. It mirrors the feature structure from SPEC.md but adds implementation tracking. The table format keeps everything scannable at a glance.

```markdown
# Roadmap

> Source: SPEC.md

| Feature | Status | Spec | Entry Points | Notes |
|---------|--------|------|-------------|-------|
| User Authentication | completed | [SPEC.md#user-authentication](SPEC.md#user-authentication) | [src/auth/handler.rb](src/auth/handler.rb), [src/auth/token.rb](src/auth/token.rb) | — |
| Task Management | pending | [SPEC.md#task-management](SPEC.md#task-management) | — | No implementation found |
| Billing | in progress | [docs/billing.md](docs/billing.md) | [src/billing/](src/billing/) | Plan validation only; payment and cancel missing |
```

**Column rules:**
- **Feature**: match SPEC.md section names exactly
- **Status**: one of `pending`, `in progress`, `completed`
- **Spec**: markdown link to spec source — either `SPEC.md#section-anchor` when the feature is defined inline, or the detail document path (e.g. `docs/billing.md`) when the spec has been split out per spec-methodology's splitting rules
- **Entry Points**: comma-separated markdown links to code paths; link directories with trailing `/` (e.g. `[src/billing/](src/billing/)`) and files directly (e.g. `[src/auth/handler.rb](src/auth/handler.rb)`); use `—` if none
- **Notes**: brief context about progress, gaps, or blockers; use `—` if nothing to note

### Status Transitions

| From | To | When |
|------|----|------|
| pending | in progress | Implementation begins |
| in progress | completed | All spec behaviors verified by tests |
| completed | in progress | Spec updated with new or changed behaviors |
| in progress | pending | Implementation rolled back or restarted |

Status may regress when the spec evolves — this is expected and should be noted.

## Definition

<function name="locate-spec">
    <description>Find and parse the project's specification to extract the feature list.</description>
    <step>1. search for SPEC.md in the project root and common locations (docs/, spec/)</step>
    <step>2. if SPEC.md acts as table-of-contents, follow links to detail documents (e.g. docs/billing.md)</step>
    <step>3. for each feature, determine the spec reference:</step>
    <step>   - feature defined inline in SPEC.md → use SPEC.md#section-anchor</step>
    <step>   - feature extracted to a detail document → use the detail document path (e.g. docs/billing.md)</step>
    <step>4. for each feature, extract the key behaviors or acceptance criteria from the spec</step>
    <return>list of features with spec references (as linkable paths) and expected behaviors</return>
</function>

<function name="locate-roadmap">
    <description>Find and parse the existing ROADMAP.md, if any.</description>
    <step>1. search for ROADMAP.md in the project root</step>
    <step>2. if found, parse each feature entry: status, spec reference, entry points, notes</step>
    <step>3. if not found, return empty (will be created by init)</step>
    <return>parsed roadmap entries or empty</return>
</function>

<function name="scan-implementation">
    <description>Check actual implementation status for a feature by examining its entry points and tests.</description>
    <parameter name="feature" type="object" description="Feature with spec behaviors and known entry points." required="true"/>
    <step>1. if entry points are known from existing roadmap, start scanning there</step>
    <step>2. if no entry points, use keyword search (feature name, related domain terms) to locate relevant code</step>
    <step>3. check for corresponding test files that exercise the feature behaviors</step>
    <step>4. compare implemented behaviors against spec expectations:</step>
    <step>   - all behaviors covered with passing tests → completed</step>
    <step>   - some behaviors implemented → in progress</step>
    <step>   - no implementation found → pending</step>
    <step>5. collect the directories and files that serve as entry points for this feature</step>
    <return>detected status, entry points list, and notes about coverage gaps</return>
</function>

<function name="write-roadmap">
    <description>Write or update ROADMAP.md with the collected feature statuses.</description>
    <parameter name="features" type="list" description="Features with detected statuses and entry points." required="true"/>
    <parameter name="existing-roadmap" type="object" description="Previously parsed roadmap entries, if any." required="false"/>
    <step>1. for each feature, merge detected status with existing roadmap data:</step>
    <step>   - preserve manually written notes from existing entries</step>
    <step>   - update status only if evidence supports the change</step>
    <step>   - update entry points to reflect current codebase state</step>
    <step>2. order features to match the SPEC.md structure</step>
    <step>3. write ROADMAP.md following the defined format</step>
    <step>4. report changes: which features changed status, which entry points were added or removed</step>
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
    <parameter name="feature" type="string" description="Optional feature name to narrow scope." required="false"/>

    <step>1. <execute name="locate-roadmap"/></step>

    <condition if="$action == 'init' or (no action given and no ROADMAP.md exists)">
        <step>2a. <execute name="locate-spec"/></step>
        <condition if="no SPEC.md found">
            <step>3a. report that no SPEC.md was found — roadmap requires a spec to track against</step>
            <return>error: no spec found</return>
        </condition>
        <step>4a. for each feature from spec, <execute name="scan-implementation" feature="$feature"/></step>
        <step>5a. <execute name="write-roadmap" features="$scanned-features"/></step>
        <return>initialized ROADMAP.md with current implementation statuses</return>
    </condition>

    <condition if="$action == 'update'">
        <step>2b. <execute name="locate-spec"/></step>
        <step>3b. <execute name="locate-roadmap"/></step>
        <condition if="$feature is specified">
            <step>4b. scan only the specified feature</step>
        </condition>
        <condition if="$feature is empty">
            <step>5b. scan all features from spec, using existing entry points to narrow search scope</step>
        </condition>
        <step>6b. <execute name="write-roadmap" features="$scanned-features" existing-roadmap="$existing-roadmap"/></step>
        <return>updated ROADMAP.md with changes summary</return>
    </condition>

    <condition if="$action == 'status' or (no action given and ROADMAP.md exists)">
        <step>2c. <execute name="status-report" feature="$feature" roadmap="$existing-roadmap"/></step>
        <return>status report</return>
    </condition>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
