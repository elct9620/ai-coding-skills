---
name: review
description: Review recent changes for style consistency, test quality, and architectural alignment, then propose refactoring suggestions.
argument-hint: [path|module|--staged]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Skill(coding:testing), Skill(coding:refactoring), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:clean-architecture), Skill(coding:schema)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Skills Rubric

To select skills for reviewing changes, consider the following rubric:

| Skill                       | When to use                                                                    |
|-----------------------------|--------------------------------------------------------------------------------|
| `coding:testing`            | Core skill - always required for assessing test quality.                       |
| `coding:principles`         | Core skill - always required for checking style and principle consistency.      |
| `coding:refactoring`        | Changes contain code smells or structural issues worth refactoring.            |
| `coding:design-patterns`    | Changes involve patterns that may be misused or missing.                       |
| `coding:clean-architecture` | Changes cross architectural layers or affect dependency direction.             |
| `coding:schema`             | Changes involve database schemas, API contracts, or data serialization.        |

The language-specific skills not listed, check all available skills before deciding skills to use.

## Definition

<function name="collect-changes">
    <description>Collect the change scope using git diff/show and categorize affected files.</description>
    <parameter name="target" type="string" description="A path, module, or --staged flag. Empty defaults to the latest commit." required="false"/>
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
    <step>3. detect test smells: over-mocking, testing implementation details, fragile assertions, test duplication</step>
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

<function name="generate-review-report">
    <description>Merge all findings, deduplicate, sort by severity, and produce refactoring suggestions for /refactor consumption.</description>
    <parameter name="style-findings" type="list" description="Findings from style consistency check." required="true"/>
    <parameter name="test-findings" type="list" description="Findings from test quality check." required="true"/>
    <parameter name="architecture-findings" type="list" description="Findings from architecture check." required="true"/>
    <parameter name="active-skills" type="list" description="The skills used in the review." required="true"/>
    <step>1. merge all findings into a single list</step>
    <step>2. deduplicate findings that overlap across checks</step>
    <step>3. sort by severity: high → medium → low</step>
    <step>4. for each finding, generate a refactoring suggestion with:</step>
    <step>   - the specific issue and location</step>
    <step>   - the recommended refactoring technique name (e.g., Extract Method, Rename, Move Class)</step>
    <step>   - the corresponding skill to apply (e.g., `coding:refactoring`, `coding:principles`)</step>
    <step>5. group suggestions by category (style, testing, architecture)</step>
    <step>6. produce a summary with counts per severity and category</step>
    <return>formatted review report with refactoring suggestions ready for /refactor</return>
</function>

<procedure name="main">
    <parameter name="target" type="string" description="A path, module, or --staged flag. Empty defaults to the latest commit." required="false"/>
    <step>1. <execute name="collect-changes" target="$target"/></step>
    <condition if="no changes found">
        <step>2. report no changes to review and exit</step>
    </condition>
    <step>3. <execute name="active-skills" changes="$changes"/></step>
    <step>4. scan unchanged neighboring code to establish codebase conventions</step>
    <step>5. <execute name="check-style-consistency" changes="$changes" active-skills="$active-skills"/></step>
    <step>6. <execute name="check-test-quality" changes="$changes" active-skills="$active-skills"/></step>
    <step>7. <execute name="check-architecture" changes="$changes" active-skills="$active-skills"/></step>
    <step>8. <execute name="generate-review-report" style-findings="$style-findings" test-findings="$test-findings" architecture-findings="$architecture-findings" active-skills="$active-skills"/></step>
    <condition if="review report contains high or medium severity findings">
        <step>9. suggest running `/refactor` with the identified targets to address the findings</step>
    </condition>
    <return>review report with refactoring suggestions</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
