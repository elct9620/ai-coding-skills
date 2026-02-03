---
name: refactor
description: Clean up legacy code issues by identifying code smells and applying safe refactoring techniques.
disable-model-invocation: true
argument-hint: [path|module]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Skill(coding:refactoring), Skill(coding:clean-architecture), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:testing)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Skills Rubric

To select skills for cleaning up legacy code, consider the following rubric:

| Skill                       | When to use                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `coding:refactoring`        | Core skill for all refactoring operations, always required.                 |
| `coding:clean-architecture` | Layer violations, module boundary issues, or structural reorganization.     |
| `coding:principles`         | SOLID/DRY violations, coupling issues, or responsibility problems.          |
| `coding:design-patterns`    | Replace complex conditionals or duplicated logic with appropriate patterns. |
| `coding:testing`            | Missing test coverage that blocks safe refactoring.                         |

The language-specific skills not listed, check all available skills before deciding skills to use.

## Definition

<function name="analyze-smells">
    <description>Analyze the target path for code smells and technical debt.</description>
    <parameter name="target" type="string" description="The path or module to analyze. Empty for whole project." required="false"/>
    <step>1. scan the target path for common code smells (Long Method, Large Class, Feature Envy, etc.)</step>
    <step>2. identify duplication, dead code, and complex conditionals</step>
    <step>3. check for SOLID principle violations</step>
    <step>4. assess test coverage for the target area</step>
    <step>5. categorize findings by severity (high, medium, low)</step>
    <return>list of code smells with severity and location</return>
</function>

<function name="active-skills">
    <description>According to the identified code smells, determine which skills are needed for refactoring.</description>
    <parameter name="smells" type="list" description="The list of identified code smells." required="true"/>
    <step>1. analyze the smells with rubric of available skills</step>
    <step>2. select the skills that address the identified problems</step>
    <step>3. always include `coding:refactoring` as the core skill</step>
    <return>list of active skills needed for the refactoring</return>
</function>

<function name="create-refactoring-plan">
    <description>Create a refactoring plan that maintains behavior while improving code quality.</description>
    <parameter name="smells" type="list" description="The identified code smells to address." required="true"/>
    <parameter name="active-skills" type="list" description="The active skills for refactoring." required="true"/>
    <step>1. prioritize smells by impact and risk (high impact, low risk first)</step>
    <step>2. group related smells that can be addressed together</step>
    <step>3. ensure each refactoring step preserves existing behavior</step>
    <step>4. identify test verification points for each step</step>
    <step>5. plan small, incremental changes with frequent commits</step>
    <step>6. for each task, determine which active skill to apply</step>
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
    <condition if="tests pass">
        <step>6. commit the change with descriptive message</step>
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
    <step>4. confirm all tests still pass (behavior preserved)</step>
    <step>5. summarize code quality improvements</step>
    <return>refactoring quality report with before/after comparison</return>
</function>

<procedure name="main">
    <parameter name="target" type="string" description="The path or module to refactor. Empty for whole project." required="false"/>
    <step>1. <execute name="analyze-smells" target="$target"/></step>
    <step>2. use ask question tool to confirm refactoring scope and priorities</step>
    <step>3. <execute name="active-skills" smells="$smells"/></step>
    <step>4. verify test coverage for the target area</step>
    <step>5. enter the plan mode</step>
    <condition if="insufficient test coverage">
        <step>6. add tests for untested code before refactoring</step>
    </condition>
    <step>7. <execute name="create-refactoring-plan" smells="$smells" active-skills="$active-skills"/></step>
    <step>8. review plan to ensure minimal changes and behavior preservation</step>
    <condition if="plan too aggressive">
        <step>9. reduce scope to focus on highest impact improvements</step>
    </condition>
    <step>10. exit plan mode and wait for user confirmation</step>
    <loop for="task in $plan.tasks">
        <step>11. <execute name="execute-refactoring" task="$task" skill="$task.skill"/></step>
        <step>12. collect task result for quality report</step>
    </loop>
    <step>13. <execute name="quality-report" original-smells="$smells" active-skills="$active-skills" task-results="$task-results"/></step>
    <return>refactoring quality report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
