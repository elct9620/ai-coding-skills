---
name: refactor
description: Clean up legacy code issues by identifying code smells and applying safe refactoring techniques.
argument-hint: [path|module]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Edit, Skill(coding:design-forces), Skill(coding:refactoring), Skill(coding:architecture), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:testing), Skill(coding:schema), Skill(coding:security)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Skills Rubric

To select skills for cleaning up legacy code, consider the following rubric:

| Skill                       | When to use                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `coding:refactoring`        | Core skill for all refactoring operations, always required.                 |
| `coding:architecture`       | Cross-class refactoring (Move Method, Extract Class), layer violations, module boundary issues, or structural reorganization. |
| `coding:principles`         | SOLID/DRY violations, coupling issues, or responsibility problems.          |
| `coding:design-patterns`    | Replace complex conditionals or duplicated logic with appropriate patterns. |
| `coding:testing`            | Missing test coverage that blocks safe refactoring.                         |
| `coding:schema`             | Restructuring database schemas, API contracts, or data access patterns.     |
| `coding:security`           | Refactoring reveals or addresses security issues (hardcoded secrets, missing input validation). |

The language-specific skills not listed, check all available skills before deciding skills to use.

## Definition

<function name="analyze-smells">
    <description>Analyze the target path for code smells and technical debt.</description>
    <parameter name="target" type="string" description="The path or module to analyze. Empty for whole project." required="false"/>
    <step>1. use `git log` and `git diff` to review recent changes and past refactoring history for the target area</step>
    <step>2. scan the target path for common code smells (Long Method, Large Class, Feature Envy, etc.)</step>
    <step>3. for cross-class smells (Feature Envy, Shotgun Surgery), identify the architectural layer of each class involved (Entity, Use Case, Interface Adapter, Framework) before confirming the smell</step>
    <step>4. exclude false positives where inner-layer coordination is normal (e.g., Use Case accessing Entity data is NOT Feature Envy, Repository handling serialization is NOT misplaced logic)</step>
    <step>5. identify duplication, dead code, and complex conditionals</step>
    <step>6. check for SOLID principle violations</step>
    <step>7. assess test coverage for the target area</step>
    <step>8. exclude smells that were intentionally introduced or recently refactored based on git history</step>
    <step>9. categorize findings by severity (high, medium, low)</step>
    <return>list of code smells with severity, location, architectural layer context, and git history context</return>
</function>

<function name="design-analyze">
    <description>Produce a Design Analysis Memo to frame the refactoring direction before skills are activated. Surfaces forces, options grounded in this codebase (including doing less, opening a seam, extracting a scaffold), and a soft recommendation the user confirms.</description>
    <parameter name="smells" type="list" description="The list of identified code smells." required="true"/>
    <step>1. use Skill(coding:design-forces) to load the diagnosis protocol</step>
    <step>2. follow the protocol with refactoring-specific framing: read recorded patterns (`docs/architecture.md`, `docs/decisions/`), read framework posture and codebase signals, ask up to 3 targeted questions, generate 4–6 options (seam-only, restructure-in-place, extract scaffold, defer with trigger, etc.), write the memo</step>
    <step>3. present the memo to the user and confirm the chosen direction before active-skills runs</step>
    <return>Design Analysis Memo with the user-confirmed direction</return>
</function>

<function name="active-skills">
    <description>According to the identified code smells and the confirmed memo direction, determine which skills are needed and activate them.</description>
    <parameter name="smells" type="list" description="The list of identified code smells." required="true"/>
    <parameter name="memo" type="string" description="The Design Analysis Memo with the confirmed direction." required="true"/>
    <step>1. discover available skills from system-reminder</step>
    <step>2. analyze the smells with rubric of available skills, biased by the memo's chosen direction</step>
    <step>3. select the skills that address the identified problems</step>
    <step>4. always include `coding:refactoring` as the core skill</step>
    <step>5. if any smell involves cross-class refactoring (Move Method, Extract Class), include `coding:architecture` to validate the structure and dependency direction against the recorded or chosen shape</step>
    <loop for="skill in $selected-skills">
        <step>6. use Skill($skill) to activate and load its knowledge</step>
    </loop>
    <return>list of activated skills with their knowledge loaded</return>
</function>

<function name="investigate">
    <description>Investigate the standard conventions by checking official documentation for the framework or library in use.</description>
    <parameter name="smells" type="list" description="The list of identified code smells." required="true"/>
    <step>1. identify the specific framework/library whose conventions need confirmation</step>
    <step>2. use WebSearch to check the official documentation or style guide for the recommended patterns</step>
    <step>3. confirm the officially recommended conventions applicable to the refactoring</step>
    <return>confirmed conventions based on official documentation</return>
</function>

<function name="create-refactoring-plan">
    <description>Create a refactoring plan that maintains behavior while improving code quality.</description>
    <parameter name="smells" type="list" description="The identified code smells to address." required="true"/>
    <parameter name="active-skills" type="list" description="The active skills for refactoring." required="true"/>
    <step>1. prioritize smells by impact and risk (high impact, low risk first)</step>
    <step>2. group related smells that can be addressed together</step>
    <step>3. ensure each refactoring step preserves the semantic contract — return-value meaning, completion timing, error model, and observable side effects at return — not merely the type signature; if the requested change would shift any of these (e.g. sync to deferred execution), stop and confirm with the user that this is a behavior change rather than a refactor before planning further</step>
    <step>4. for Move Method or Extract Class tasks, verify the target location respects the project's architectural layer rules — dependencies must point inward, do not move logic from outer layer into inner layer</step>
    <step>5. identify test verification points for each step</step>
    <step>6. plan small, incremental changes with frequent commits</step>
    <step>7. for each task, determine which active skill to apply</step>
    <return>refactoring plan with ordered tasks and verification points</return>
</function>

<function name="execute-refactoring">
    <description>Execute a single refactoring step following the golden rule: small steps, always green.</description>
    <parameter name="task" type="string" description="The refactoring task to execute." required="true"/>
    <parameter name="skill" type="string" description="The skill to apply for this task." required="true"/>
    <step>1. verify all tests pass before starting (baseline)</step>
    <step>2. apply the refactoring technique from the skill</step>
    <step>3. run tests immediately after the change</step>
    <condition if="tests fail">
        <step>4. revert the change and analyze the failure</step>
        <step>5. break down into smaller steps if needed</step>
    </condition>
    <step>7. invoke the skill to verify the refactoring quality</step>
    <return>completed refactoring step with verification result</return>
</function>

<function name="quality-report">
    <description>Generate refactoring quality report comparing before and after code quality.</description>
    <parameter name="original-smells" type="list" description="The original code smells identified." required="true"/>
    <parameter name="active-skills" type="list" description="The skills used in refactoring." required="true"/>
    <parameter name="task-results" type="list" description="The results from each refactoring step." required="true"/>
    <step>1. compare original smells with current code state</step>
    <step>2. list resolved smells and remaining issues</step>
    <step>3. for each active skill, invoke skill to verify completion rubric</step>
    <step>4. confirm all tests still pass AND that the assertions actually exercise the semantic contract (return-value meaning, observable side effects at return, error model); a green test suite that only pins return values is not evidence of behavior preservation</step>
    <step>5. summarize code quality improvements</step>
    <return>refactoring quality report with before/after comparison</return>
</function>

<procedure name="main">
    <parameter name="target" type="string" description="The path or module to refactor. Empty for whole project." required="false"/>
    <step>1. <execute name="analyze-smells" target="$target"/></step>
    <step>2. check whether the user's request is actually a refactor: if it would change the semantic contract (return-value meaning, completion timing, error model, delivery or ordering guarantees) while keeping signatures intact, name it as a behavior change and confirm scope with the user before continuing — do not proceed under the refactor frame</step>
    <step>3. use ask question tool to confirm refactoring scope and priorities</step>
    <step>4. <execute name="design-analyze" smells="$smells"/></step>
    <step>5. <execute name="active-skills" smells="$smells" memo="$memo"/></step>
    <step>6. <execute name="investigate" smells="$smells"/></step>
    <step>7. verify test coverage for the target area, stay within project boundaries and do not read library or framework source code</step>
    <step>8. enter the plan mode</step>
    <condition if="insufficient test coverage">
        <step>9. add tests for untested code before refactoring</step>
    </condition>
    <step>10. <execute name="create-refactoring-plan" smells="$smells" active-skills="$active-skills"/></step>
    <step>11. review plan to ensure minimal changes and behavior preservation</step>
    <condition if="plan too aggressive">
        <step>12. reduce scope to focus on highest impact improvements</step>
    </condition>
    <step>13. exit plan mode and wait for user confirmation</step>
    <step>14. create tasks from the plan using TaskCreate tool, so progress can be tracked</step>
    <loop for="task in $plan.tasks">
        <step>15. <execute name="execute-refactoring" task="$task" skill="$task.skill"/></step>
        <step>16. collect task result for quality report and update task status</step>
    </loop>
    <step>17. <execute name="quality-report" original-smells="$smells" active-skills="$active-skills" task-results="$task-results"/></step>
    <condition if="$memo proposed a Patterns-section entry or ADR">
        <step>18. ask the user whether to append the proposed entry to `docs/architecture.md` Patterns section, or create the ADR in `docs/decisions/`; apply if confirmed</step>
    </condition>
    <step>19. ask user if they want to commit the changes</step>
    <return>refactoring quality report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
