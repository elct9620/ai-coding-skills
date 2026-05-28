---
name: write
description: Implement features based on the agent skills.
argument-hint: feature|id [--skip-tests]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Edit, Skill(coding:design-forces), Skill(coding:clean-architecture), Skill(coding:domain-modeling), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:refactoring), Skill(coding:testing), Skill(coding:schema), Skill(coding:security)
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
| `coding:schema`             | The feature involves database changes, API contracts, or data serialization.             |
| `coding:security`           | The feature handles user input, auth, secrets, or crosses trust boundaries.              |

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

<function name="design-analyze">
    <description>Produce a Design Analysis Memo that frames the direction of the work before skills are activated. Surfaces forces, options grounded in this codebase, and a soft recommendation the user confirms or redirects.</description>
    <parameter name="overview" type="string" description="The overview of the feature and current codebase context." required="true"/>
    <step>1. use Skill(coding:design-forces) to load the diagnosis protocol</step>
    <step>2. follow the protocol: read recorded patterns (`docs/architecture.md` Patterns section, `docs/decisions/`), read framework posture and codebase signals, ask up to 3 targeted questions for unanswered forces, generate 4–6 options, write the memo</step>
    <step>3. present the memo to the user and confirm the chosen direction before active-skills runs</step>
    <return>Design Analysis Memo with the user-confirmed direction (selected option + recording proposal if any)</return>
</function>

<function name="active-skills">
    <description>According to the feature requirements and the confirmed memo direction, determine which skills are needed and activate them.</description>
    <parameter name="overview" type="string" description="The overview of the feature and current codebase context." required="true"/>
    <parameter name="memo" type="string" description="The Design Analysis Memo with the confirmed direction." required="true"/>
    <step>1. discover available skills from system-reminder</step>
    <step>2. analyze the overview with rubric of available skills, biased by the memo's chosen direction (a framework-default direction may need fewer heavy skills; a CA+DDD direction will activate `clean-architecture` and `domain-modeling`)</step>
    <step>3. select the skills that are most relevant to the chosen direction</step>
    <loop for="skill in $selected-skills">
        <step>4. use Skill($skill) to activate and load its knowledge</step>
    </loop>
    <return>list of activated skills with their knowledge loaded</return>
</function>

<function name="investigate">
    <description>Investigate the correct usage by checking official documentation for the libraries or APIs involved.</description>
    <parameter name="overview" type="string" description="The overview of the feature and current codebase context." required="true"/>
    <step>1. identify the specific library/API whose usage needs confirmation</step>
    <step>2. use WebSearch to check the official documentation for the current API signatures and standard usage</step>
    <step>3. confirm the officially recommended implementation approach</step>
    <return>confirmed usage patterns based on official documentation</return>
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
    <step>6. sequence the tasks outside-in: start from user-facing layers (controllers, presenters, API endpoints), then work inward to use cases, and finally to entities and infrastructure — defer schema and storage decisions until the domain model shape is clear from use case needs</step>
    <return>implementation plan for the feature</return>
</function>

<function name="execute-task">
    <description>Execute a single task from the plan using TDD approach.</description>
    <parameter name="task" type="string" description="The task to execute." required="true"/>
    <parameter name="skill" type="string" description="The skill to apply for this task." required="true"/>
    <parameter name="skip-tests" type="boolean" description="Whether to skip test-first approach." required="false" default="false"/>
    <condition if="not $skip-tests">
        <step>1. write failing test for the task (Red) — if you feel the urge to verify language/API behavior with `node -e` / `ruby -e` / `python -c` before writing code, that urge is telling you to add a test case for that assumption instead; see `coding:testing` Verification Discipline</step>
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
    <step>3. <execute name="design-analyze" overview="$overview"/></step>
    <step>4. <execute name="active-skills" overview="$overview" memo="$memo"/></step>
    <step>5. <execute name="investigate" overview="$overview"/></step>
    <step>6. deeply understand the project codebase related to the feature, stay within project boundaries and do not read library or framework source code</step>
    <step>7. enter the plan mode</step>
    <step>8. <execute name="create-plan" completed-overview="$overview" active-skills="$active-skills" skip-tests="$skip-tests"/></step>
    <step>9. review and finalize the implementation plan for minimal change instead of over-engineering</step>
    <condition if="over-engineering detected">
        <step>10. refine the plan to avoid over-engineering</step>
    </condition>
    <step>11. exit plan mode and wait for user confirmation</step>
    <step>12. create tasks from the plan using TaskCreate tool, so progress can be tracked</step>
    <loop for="task in $plan.tasks">
        <step>13. <execute name="execute-task" task="$task" skill="$task.skills" skip-tests="$skip-tests"/></step>
        <step>14. collect task result for quality report and update task status</step>
    </loop>
    <step>15. <execute name="quality-report" active-skills="$active-skills" task-results="$task-results"/></step>
    <condition if="$memo proposed a Patterns-section entry or ADR">
        <step>16. ask the user whether to append the proposed entry to `docs/architecture.md` Patterns section, or create the ADR in `docs/decisions/`; apply if confirmed</step>
    </condition>
    <step>17. ask user if they want to commit the changes</step>
    <step>18. suggest running `/review` to check style consistency, test quality, and architecture alignment</step>
    <return>implementation quality report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
