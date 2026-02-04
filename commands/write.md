---
name: write
description: Implement features based on the agent skills.
disable-model-invocation: true
argument-hint: feature|id [--skip-tests]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Skill(coding:clean-architecture), Skill(coding:domain-modeling), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:refactoring), Skill(coding:testing)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Skills Rubric

To select skills for implementing the feature, consider the following rubric:

| Skill                       | When to use                                                                              |
|-----------------------------|------------------------------------------------------------------------------------------|
| `coding:clean-architecture` | No `docs/architecture.md` exists or the feature requires significant structural changes. |
| `coding:domain-modeling`    | The feature is related to business logic or domain entities.                             |
| `coding:principles`         | Fully new feature no existing code, following principles is essential.                   |
| `coding:design-patterns`    | The feature needs changes multiple components that can benefit from design patterns.     |
| `coding:refactoring`        | Need to change existing code to accommodate the new feature.                             |
| `coding:testing`            | Each new feature or behavior change requires apply testing.                              |

The language-specific skills not listed, check all available skills before deciding skills to use.

## Definition

<function name="overview">
    <description>Fast overview of the feature to implement, use keyword search to find relevant information in the codebase.</description>
    <parameter name="feature" type="string" description="The feature to implement." required="true"/>
    <step>1. read the specification of the feature, e.g. SPEC.md, issue tracker, project management tool</step>
    <step>2. use lightweight sub-agents to review codebase to understand current implementation related to the feature</step>
    <step>3. use `git log` to get context of recent changes related to the feature</step>
    <return>summary of the feature and current codebase context</return>
</function>

<function name="active-skills">
    <description>According to the feature requirements, determine which skills are needed to implement the feature.</description>
    <parameter name="overview" type="string" description="The overview of the feature and current codebase context." required="true"/>
    <step>1. discover available skills from system-reminder</step>
    <step>2. analyze the overview with rubric of available skills</step>
    <step>3. select the skills that are most relevant to the feature implementation</step>
    <return>list of active skills needed for the feature implementation</return>
</function>

<function name="create-plan">
    <description>Create an implementation plan for the feature using the active skills.</description>
    <parameter name="completed-overview" type="string" description="The completed overview of the feature and current codebase context." required="true"/>
    <parameter name="active-skills" type="list" description="The active skills for implementation." required="true"/>
    <parameter name="skip-tests" type="boolean" description="Whether to skip test case creation." required="false" default="false"/>
    <condition if="not $skip-tests">
        <step>1. review the feature requirements and create integration test cases to verify components work together</step>
        <step>2. add unit test cases for edge cases and complex logic if necessary</step>
        <step>3. depend on the test cases, break down the implementation into smaller tasks</step>
    </condition>
    <condition if="$skip-tests">
        <step>4. break down the implementation into smaller tasks</step>
    </condition>
    <step>5. for each task, determine which active skill to apply</step>
    <step>6. sequence the tasks in a logical order for implementation</step>
    <return>implementation plan for the feature</return>
</function>

<function name="execute-task">
    <description>Execute a single task from the plan using TDD approach.</description>
    <parameter name="task" type="string" description="The task to execute." required="true"/>
    <parameter name="skill" type="string" description="The skill to apply for this task." required="true"/>
    <parameter name="skip-tests" type="boolean" description="Whether to skip test-first approach." required="false" default="false"/>
    <condition if="not $skip-tests">
        <step>1. write failing test for the task (Red)</step>
        <step>2. implement minimum code to pass the test (Green)</step>
        <step>3. refactor the code while keeping tests passing (Refactor)</step>
    </condition>
    <condition if="$skip-tests">
        <step>4. implement the task directly</step>
        <step>5. refactor if necessary</step>
    </condition>
    <step>6. invoke the skill to verify completion rubric</step>
    <return>completed task with skill verification result</return>
</function>

<function name="quality-report">
    <description>Generate implementation quality report using active skills' completion rubrics.</description>
    <parameter name="active-skills" type="list" description="The skills used in implementation." required="true"/>
    <parameter name="task-results" type="list" description="The results from each executed task." required="true"/>
    <step>1. for each active skill, invoke skill to verify completion rubric against implementation</step>
    <step>2. collect all verification results and identify gaps</step>
    <step>3. summarize overall implementation quality</step>
    <return>implementation quality report with skill-based verification</return>
</function>

<procedure name="main">
    <parameter name="feature" type="string" description="The feature to implement." required="true"/>
    <parameter name="skip-tests" type="boolean" description="Whether to skip test case creation." required="false" default="false"/>
    <step>1. <execute name="overview" feature="$feature"/></step>
    <step>2. use ask question tool to clarify scope of the feature</step>
    <step>3. <execute name="active-skills" overview="$overview"/></step>
    <step>4. deeply understand the codebase related to the feature</step>
    <step>5. enter the plan mode</step>
    <step>6. <execute name="create-plan" completed-overview="$overview" active-skills="$active-skills" skip-tests="$skip-tests"/></step>
    <step>7. review and finalize the implementation plan for minimal change instead of over-engineering</step>
    <condition if="over-engineering detected">
        <step>8. refine the plan to avoid over-engineering</step>
    </condition>
    <step>9. exit plan mode and wait for user confirmation</step>
    <loop for="task in $plan.tasks">
        <step>10. <execute name="execute-task" task="$task" skill="$task.skills" skip-tests="$skip-tests"/></step>
        <step>11. collect task result for quality report</step>
    </loop>
    <step>12. <execute name="quality-report" active-skills="$active-skills" task-results="$task-results"/></step>
    <return>implementation quality report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
