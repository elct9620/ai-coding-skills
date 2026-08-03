---
name: inspect
description: Confirm the spec, the code, and your understanding still describe the same system — surfacing gaps in style consistency, test quality, and architectural alignment along the way — then converge through clarification into the work list for this round. Read-only — it does not change code, and an item stays out of the work list while anything about it is still ambiguous.
argument-hint: [path|module|--staged|intent] [--deep]
# --deep scans the entire target scope holistically, not just recent diffs
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Skill(coding:design-forces), Skill(coding:testing), Skill(coding:refactoring), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:architecture), Skill(coding:schema), Skill(coding:security)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Skills Rubric

To select skills for inspecting changes, consider the following rubric:

| Skill                       | When to use                                                                    |
|-----------------------------|--------------------------------------------------------------------------------|
| `coding:testing`            | Core skill - always required for assessing test quality.                       |
| `coding:principles`         | Core skill - always required for checking style and principle consistency.      |
| `coding:refactoring`        | Changes contain code smells or structural issues worth refactoring.            |
| `coding:design-patterns`    | Changes involve patterns that may be misused or missing.                       |
| `coding:architecture`       | Changes cross architectural layers, affect dependency direction, or deviate from the recorded structure. |
| `coding:schema`             | Changes involve database schemas, API contracts, or data serialization.        |
| `coding:security`           | Changes handle user input, auth, secrets, or cross trust boundaries.           |

The language-specific skills not listed, check all available skills before deciding skills to use.

## Definition

<function name="collect-changes">
    <description>Collect the inspection scope. In deep mode, collects all files under the target instead of just recent diffs.</description>
    <parameter name="target" type="string" description="A path, module, --staged flag, or a sentence naming what the user wants confirmed. Empty defaults to the latest commit." required="false"/>
    <parameter name="deep" type="boolean" description="When true, scan all files under the target path (or project root if empty)." required="false"/>

    <step>0. when $target names what the user wants confirmed rather than where to look, keep it as the focus the report opens with and collect the scope as if $target were empty</step>

    <condition if="$deep">
        <step>1. use Glob to collect all source and test files under $target (or project root if empty)</step>
        <step>2. categorize files into: source, test, config, docs</step>
        <step>3. use `git log --oneline -10` on the scope to understand recent evolution</step>
        <return>categorized list of all files in scope with recent evolution context</return>
    </condition>

    <condition if="not $deep">
        <step>1. determine the diff source based on the target argument:</step>
        <condition if="$target == '--staged'">
            <step>2a. use `git diff --staged` to collect staged changes</step>
        </condition>
        <condition if="$target is a path or module">
            <step>2b. use `git diff HEAD -- $target` and `git log --oneline -5 -- $target` to collect recent changes for the path</step>
        </condition>
        <condition if="$target is empty">
            <step>2c. use `git show HEAD` to collect the latest commit changes</step>
        </condition>
        <step>3. list all changed files from the diff output</step>
        <step>4. categorize files into: source, test, config, docs</step>
        <step>5. use `git log --oneline -5` on the changed files to understand recent context</step>
        <return>categorized list of changed files with diff content and recent context</return>
    </condition>
</function>

<function name="active-skills">
    <description>According to the changes, determine which skills are needed and activate them.</description>
    <parameter name="changes" type="object" description="The categorized changes from collect-changes." required="true"/>
    <step>1. discover available skills from system-reminder</step>
    <step>2. analyze the changes with rubric of available skills</step>
    <step>3. always include `coding:testing` and `coding:principles` as core skills</step>
    <step>4. select additional skills based on change categories and content</step>
    <loop for="skill in $selected-skills">
        <step>5. use Skill($skill) to activate and load its knowledge</step>
    </loop>
    <return>list of activated skills with their knowledge loaded</return>
</function>

<function name="check-style-consistency">
    <description>Compare changes against existing codebase conventions for style consistency.</description>
    <parameter name="changes" type="object" description="The categorized changes." required="true"/>
    <parameter name="active-skills" type="list" description="The activated skills." required="true"/>
    <step>1. scan unchanged neighboring code to establish existing conventions (naming, structure, error handling, module organization)</step>
    <step>2. compare changed code against established conventions</step>
    <step>3. check naming consistency (variables, functions, classes, files)</step>
    <step>4. check structural consistency (module organization, file placement)</step>
    <step>5. check error handling consistency (exception types, error messages, recovery patterns)</step>
    <step>6. check import/dependency organization consistency</step>
    <step>7. flag deviations with severity (high: breaks convention, medium: inconsistent, low: minor style difference)</step>
    <return>list of style consistency findings with severity and location</return>
</function>

<function name="check-test-quality">
    <description>Assess test quality for the changed code including coverage, test smells, and boundary testing.</description>
    <parameter name="changes" type="object" description="The categorized changes." required="true"/>
    <parameter name="active-skills" type="list" description="The activated skills." required="true"/>
    <step>1. identify which changed source files have corresponding test files</step>
    <step>2. check for missing integration test coverage on new or changed behaviors</step>
    <step>2a. check user-journey integrity: for each critical user journey the changes touch, verify one E2E/integration test walks the whole real path — from the user's actual entry point through the real steps — and asserts the journey's goal outcome (what the user ends up with). Treat a journey covered only by shortcut-stitched segments (e.g. `sign_in_as` plus a direct request that skips a page the user passes through) or by waypoint assertions (a step renders, a redirect happens) as missing coverage, not as covered — even when branch and unit coverage report complete, since that satisfies the count while leaving the path unwalked (see coding:testing User Journey Integrity)</step>
    <step>3. detect test smells: over-mocking, testing implementation details, fragile assertions, test duplication, and assertions that pin only return values for functions with observable side effects (such a test cannot detect semantic-contract drift — e.g. sync-to-deferred execution or a shift in what the return value means — because the return type stays identical while the meaning changes)</step>
    <step>4. check boundary testing: edge cases, error paths, nil/null handling</step>
    <step>5. check for dead code testing (tests for removed or unreachable code)</step>
    <step>6. verify tests follow AAA pattern and have clear assertions</step>
    <step>7. flag issues with severity (high: missing coverage, medium: test smell, low: minor improvement)</step>
    <return>list of test quality findings with severity and location</return>
</function>

<function name="check-architecture">
    <description>Verify architectural alignment including layer boundaries, dependency direction, and circular dependencies.</description>
    <parameter name="changes" type="object" description="The categorized changes." required="true"/>
    <parameter name="active-skills" type="list" description="The activated skills." required="true"/>
    <step>1. identify the architectural layer of each changed file (Entity, Use Case, Interface Adapter, Framework)</step>
    <step>2. check dependency direction: dependencies must point inward (outer layers depend on inner layers)</step>
    <step>3. detect potential circular dependencies introduced by the changes</step>
    <step>4. verify new classes/modules are placed in the correct architectural layer</step>
    <step>5. check for layer violations (e.g., Entity importing from Framework, Use Case depending on concrete adapter)</step>
    <step>6. flag issues with severity (high: layer violation, medium: questionable placement, low: minor concern)</step>
    <return>list of architecture findings with severity and location</return>
</function>

<function name="check-pattern-alignment">
    <description>Check whether the changes align with patterns recorded in this project. Flags drift from recorded shapes and surfaces revisit triggers that may have fired.</description>
    <parameter name="changes" type="object" description="The categorized changes." required="true"/>
    <step>1. read `docs/architecture.md` Patterns section and any files under `docs/decisions/`</step>
    <condition if="no recorded patterns exist">
        <step>2. return an empty finding list — nothing to align against yet</step>
    </condition>
    <step>3. for each recorded pattern whose "When to apply" overlaps the changed surface, compare the actual implementation against the pattern's recorded Shape and canonical example</step>
    <step>4. flag drift with severity (high: implementation contradicts the pattern's Shape; medium: deviation in form but invariants intact; low: stylistic divergence from the canonical example)</step>
    <step>5. for each recorded pattern, check whether any "Revisit if" trigger appears to have fired (e.g. team fragmentation grew, blast radius increased, change rate accelerated) — flag as informational so the team can re-run design-forces deliberately, not as a review failure</step>
    <return>list of pattern-alignment findings with severity, location, and trigger-fired notes</return>
</function>

<function name="report-alignment">
    <description>Organize the findings into the alignment report — where the spec, the code, and the reader's understanding diverge — plus the work list for this round and whatever is still ambiguous. Ambiguity keeps an item out of the work list.</description>
    <parameter name="style-findings" type="list" description="Findings from style consistency check." required="true"/>
    <parameter name="test-findings" type="list" description="Findings from test quality check." required="true"/>
    <parameter name="architecture-findings" type="list" description="Findings from architecture check." required="true"/>
    <parameter name="pattern-findings" type="list" description="Findings from pattern alignment check." required="true"/>
    <parameter name="active-skills" type="list" description="The skills used in the inspection." required="true"/>
    <step>1. merge all findings into a single list and deduplicate what overlaps across checks</step>
    <step>2. for each finding, record the specific issue and location, the relevant technique name (e.g., Extract Method, Rename, Move Class), and the corresponding skill to apply (e.g., `coding:refactoring`, `coding:principles`)</step>
    <step>3. report the three divergences, one section each: spec against code (what the spec commits to but the code does not do, and what the code does that the spec does not describe), code against understanding (the findings above, plus anything the code now does that a reader would not expect), spec against understanding (what the spec states that no longer matches intent). `SPEC.md` and `ROADMAP.md` carry the spec side; an empty section is itself worth stating</step>
    <step>4. draw the work list for this round from the divergences, ordering within it by severity</step>
    <step>5. list separately whatever is still ambiguous — an item whose scope, cause, or desired outcome is unsettled — and hold it out of the work list until it resolves; write "none" when nothing is ambiguous</step>
    <return>the alignment report, the work list for this round, and the ambiguities held back from it</return>
</function>

<procedure name="main">
    <parameter name="target" type="string" description="A path, module, --staged flag, or a sentence naming what the user wants confirmed. Empty defaults to the latest commit." required="false"/>
    <parameter name="deep" type="boolean" description="When true, scan the entire target scope holistically instead of just recent diffs." required="false"/>
    <step>1. <execute name="collect-changes" target="$target" deep="$deep"/></step>
    <condition if="no changes found and not $deep">
        <step>2. report no recent changes found and suggest: "No recent changes to inspect. Run `/inspect [path] --deep` to perform a holistic inspection of the codebase or module."</step>
        <return>suggestion to use --deep</return>
    </condition>
    <step>3. <execute name="active-skills" changes="$changes"/></step>
    <step>4. scan unchanged neighboring code to establish codebase conventions</step>
    <step>5. <execute name="check-style-consistency" changes="$changes" active-skills="$active-skills"/></step>
    <step>6. <execute name="check-test-quality" changes="$changes" active-skills="$active-skills"/></step>
    <step>7. <execute name="check-architecture" changes="$changes" active-skills="$active-skills"/></step>
    <step>8. <execute name="check-pattern-alignment" changes="$changes"/></step>
    <step>9. <execute name="report-alignment" style-findings="$style-findings" test-findings="$test-findings" architecture-findings="$architecture-findings" pattern-findings="$pattern-findings" active-skills="$active-skills"/></step>
    <condition if="a work list confirmed in an earlier round is present in this context">
        <step>10. quote that work list verbatim and compare this round's changes against it, reporting whether the work stayed inside it. Nobody is waiting to answer here, so ask nothing: drift or a fresh ambiguity stops the run and is reported for the user to resolve</step>
    </condition>
    <condition if="no confirmed work list exists — this is the opening round">
        <step>11. present the alignment report, the work list, and the ambiguities, then invite the user to confirm it or ask further. Each answer resolves ambiguities and redraws the list; the user decides when it is settled enough to run `/write` or `/refactor`</step>
        <condition if="every section is empty and not $deep">
            <step>12. add: "Spec, code, and reading agree on the recent changes. Consider running `/inspect [path] --deep` for a broader holistic inspection."</step>
        </condition>
    </condition>
    <return>the alignment report with the work list for this round, or the drift report when a confirmed list already exists</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
