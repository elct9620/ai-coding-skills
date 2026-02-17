---
name: fix
description: Fix bugs by diagnosing root cause, reproducing with tests, and applying minimal fixes.
argument-hint: bug|issue|error
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), WebSearch, Skill(coding:testing), Skill(coding:refactoring), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:domain-modeling), Skill(coding:clean-architecture), Skill(coding:schema)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Skills Rubric

To select skills for fixing bugs, consider the following rubric:

| Skill                       | When to use                                                              |
|-----------------------------|--------------------------------------------------------------------------|
| `coding:testing`            | Core skill - always required for reproducing bugs and verifying fixes.   |
| `coding:refactoring`        | Bug fix requires untangling coupled or messy code.                       |
| `coding:principles`         | Bug stems from principle violations (e.g., coupling, SRP violations).    |
| `coding:design-patterns`    | Bug caused by missing or misused patterns.                               |
| `coding:domain-modeling`    | Bug in business logic or domain rules.                                   |
| `coding:clean-architecture` | Bug related to layer violations or dependency issues.                    |
| `coding:schema`             | Bug in database queries, migration failures, or API contract mismatches. |

The language-specific skills not listed, check all available skills before deciding skills to use.

## Definition

<function name="diagnose">
    <description>Analyze bug report and identify root cause through investigation.</description>
    <parameter name="bug" type="string" description="The bug description, error message, or issue reference." required="true"/>
    <step>1. parse the bug report to extract symptoms, error messages, and reproduction steps</step>
    <step>2. use lightweight sub-agents to search for related code and recent changes</step>
    <step>3. use `git log` and `git diff` to identify when the bug might have been introduced</step>
    <step>4. trace the code path to identify the root cause location</step>
    <step>5. categorize the bug type (logic error, edge case, integration issue, etc.)</step>
    <return>diagnosis with root cause analysis, affected files, and bug category</return>
</function>

<function name="active-skills">
    <description>According to the diagnosis, determine which skills are needed and activate them.</description>
    <parameter name="diagnosis" type="string" description="The diagnosis with root cause analysis." required="true"/>
    <step>1. discover available skills from system-reminder</step>
    <step>2. analyze the diagnosis with rubric of available skills</step>
    <step>3. always include `coding:testing` as the core skill</step>
    <step>4. select additional skills based on bug category and root cause</step>
    <loop for="skill in $selected-skills">
        <step>5. use Skill($skill) to activate and load its knowledge</step>
    </loop>
    <return>list of activated skills with their knowledge loaded</return>
</function>

<function name="investigate">
    <description>Investigate the correct fix approach by checking official documentation for the involved library or framework.</description>
    <parameter name="diagnosis" type="string" description="The diagnosis with root cause analysis." required="true"/>
    <step>1. identify the specific library/framework and version involved in the bug</step>
    <step>2. use WebSearch to check the official documentation, changelog, or migration guide for the standard way to handle this issue</step>
    <step>3. confirm the officially recommended fix approach</step>
    <return>confirmed fix approach based on official documentation</return>
</function>

<function name="create-reproduction-test">
    <description>Design a failing test that reproduces the bug (Red phase of TDD).</description>
    <parameter name="diagnosis" type="string" description="The diagnosis with root cause analysis." required="true"/>
    <step>1. identify the expected behavior vs actual behavior</step>
    <step>2. determine the minimal test case that exposes the bug</step>
    <step>3. choose appropriate test level (unit, integration, or E2E)</step>
    <step>4. design test with clear assertion that will pass when bug is fixed</step>
    <return>reproduction test specification that fails with current code</return>
</function>

<function name="create-fix-plan">
    <description>Plan the minimal fix to resolve the bug without scope creep.</description>
    <parameter name="diagnosis" type="string" description="The diagnosis with root cause analysis." required="true"/>
    <parameter name="reproduction-test" type="string" description="The reproduction test specification." required="true"/>
    <parameter name="active-skills" type="list" description="The active skills for the fix." required="true"/>
    <step>1. identify the minimal code change to fix the root cause</step>
    <step>2. ensure fix addresses root cause, not just symptoms</step>
    <step>3. break down fix into smallest possible incremental steps</step>
    <step>4. for each step, determine which active skill to apply</step>
    <step>5. identify potential regression risks</step>
    <return>minimal fix plan with ordered steps and regression considerations</return>
</function>

<function name="execute-fix">
    <description>Execute the fix following TDD Green phase - make the reproduction test pass.</description>
    <parameter name="task" type="string" description="The fix task to execute." required="true"/>
    <parameter name="skill" type="string" description="The skill to apply for this task." required="true"/>
    <step>1. verify reproduction test fails before fix (confirms Red state)</step>
    <step>2. apply the minimal fix as planned</step>
    <step>3. run reproduction test to verify fix (Green)</step>
    <condition if="test still fails">
        <step>4. analyze failure and adjust fix approach</step>
    </condition>
    <step>5. invoke the skill to verify fix quality</step>
    <return>completed fix with test verification result</return>
</function>

<function name="regression-check">
    <description>Verify the fix does not introduce regressions in related functionality.</description>
    <parameter name="affected-areas" type="list" description="The areas affected by the fix." required="true"/>
    <step>1. run all tests in the affected module/area</step>
    <step>2. run integration tests that cover the fixed code path</step>
    <step>3. verify no new failures introduced</step>
    <condition if="regressions found">
        <step>4. identify the regression cause and report for fix adjustment</step>
    </condition>
    <return>regression check result with pass/fail status</return>
</function>

<function name="quality-report">
    <description>Generate fix quality report summarizing the bug fix process and results.</description>
    <parameter name="diagnosis" type="string" description="The original diagnosis." required="true"/>
    <parameter name="active-skills" type="list" description="The skills used in the fix." required="true"/>
    <parameter name="fix-results" type="list" description="The results from fix execution." required="true"/>
    <parameter name="regression-result" type="string" description="The regression check result." required="true"/>
    <step>1. summarize root cause and fix applied</step>
    <step>2. list reproduction test added to prevent future regressions</step>
    <step>3. for each active skill, invoke skill to verify completion rubric</step>
    <step>4. confirm all tests pass (including new reproduction test)</step>
    <step>5. assess if fix is minimal and focused</step>
    <return>fix quality report with diagnosis, fix summary, and verification results</return>
</function>

<procedure name="main">
    <parameter name="bug" type="string" description="The bug description, error message, or issue reference." required="true"/>
    <step>1. <execute name="diagnose" bug="$bug"/></step>
    <step>2. use ask question tool to confirm understanding of the bug scope</step>
    <step>3. <execute name="active-skills" diagnosis="$diagnosis"/></step>
    <condition if="fix involves external library API and need to confirm correct approach from official docs">
        <step>4. <execute name="investigate" diagnosis="$diagnosis"/></step>
    </condition>
    <step>5. deeply understand the codebase related to the bug</step>
    <step>6. enter the plan mode</step>
    <step>7. <execute name="create-reproduction-test" diagnosis="$diagnosis"/></step>
    <step>8. <execute name="create-fix-plan" diagnosis="$diagnosis" reproduction-test="$reproduction-test" active-skills="$active-skills"/></step>
    <step>9. review plan to ensure minimal fix without scope creep</step>
    <condition if="scope creep detected">
        <step>10. reduce scope to focus only on the bug fix</step>
    </condition>
    <step>11. exit plan mode and wait for user confirmation</step>
    <step>12. write reproduction test (Red)</step>
    <loop for="task in $plan.tasks">
        <step>13. <execute name="execute-fix" task="$task" skill="$task.skill"/></step>
        <step>14. collect fix result for quality report</step>
    </loop>
    <step>15. <execute name="regression-check" affected-areas="$diagnosis.affected-areas"/></step>
    <step>16. <execute name="quality-report" diagnosis="$diagnosis" active-skills="$active-skills" fix-results="$fix-results" regression-result="$regression-result"/></step>
    <step>17. ask user if they want to commit the changes</step>
    <return>fix quality report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
