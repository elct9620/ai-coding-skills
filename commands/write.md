---
name: write
description: Implement a new feature or correct a defect based on the agent skills.
argument-hint: feature|id
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Edit, Skill(coding:design-forces), Skill(coding:architecture), Skill(coding:domain-modeling), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:refactoring), Skill(coding:testing), Skill(coding:schema), Skill(coding:security)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Skills Rubric

To select skills for implementing the feature, consider the following rubric:

| Skill                       | When to use                                                                              |
|-----------------------------|------------------------------------------------------------------------------------------|
| `coding:architecture`       | Following a structure recorded in `docs/architecture.md`, or the memo's forces call for a structural decision (layers, modules, contexts). Defaults to no extra structure when forces are quiet. |
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
    <description>According to the feature requirements and the confirmed direction, determine which skills are needed and activate them.</description>
    <parameter name="overview" type="string" description="The overview of the feature and current codebase context." required="true"/>
    <parameter name="direction" type="string" description="The confirmed direction: a Design Analysis Memo when /write runs standalone, the inspection's bounds and references when it follows /inspect." required="true"/>
    <step>1. discover available skills from system-reminder</step>
    <step>2. analyze the overview with rubric of available skills, biased by the confirmed direction (a direction asking for no extra structure needs fewer heavy skills; one calling for layers or partitioning activates `architecture` and, where the domain is thick, `domain-modeling`)</step>
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
    <step>1. name the integration test cases that will verify the components work together, and unit cases only for edge cases those cannot practically reach</step>
    <step>2. break the implementation into tasks along the design's own seams; where a confirmed work list already names them, those are the tasks. Tests cover the design rather than carve it, so letting the test cases decide the breakdown would hand the shape of the code to whatever the first case happened to assume. A seam carries no verdict of its own, though, so name for each task which promises it makes good on — drawn from the spec, or from whatever states the intended behavior where no spec exists — or, where the task changes structure rather than behavior, which promises it has to leave standing. A task that can name neither has nothing to be judged complete against, and reporting that serves better than calling it done</step>
    <step>3. for each task, determine which active skill to apply</step>
    <step>4. sequence the tasks outside-in: start from user-facing layers (controllers, presenters, API endpoints), then work inward to use cases, and finally to entities and infrastructure — defer schema and storage decisions until the domain model shape is clear from use case needs</step>
    <return>implementation plan for the feature</return>
</function>

<function name="execute-task">
    <description>Execute a single task from the plan.</description>
    <parameter name="task" type="string" description="The task to execute." required="true"/>
    <parameter name="skill" type="string" description="The skill to apply for this task." required="true"/>
    <step>1. implement the task together with the tests that cover the promises it names — if you feel the urge to verify language/API behavior with `node -e` / `ruby -e` / `python -c` before writing code, that urge is telling you to add a test case for that assumption instead; see `coding:testing` Verification Discipline</step>
    <step>2. with the task standing complete and the suite green, prove the net holds as `coding:testing` describes — break one of the promises the task names, watch a test object, restore, confirm the diff matches. A suite nobody has challenged says only that the code passes its own tests</step>
    <step>3. refactor while the suite stays green</step>
    <step>4. invoke the skill to verify completion rubric</step>
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
    <step>1. <execute name="overview" feature="$feature"/></step>
    <condition if="a prior /inspect has already converged the work list for this round in the current context">
        <step>2. take that work list as the plan's source and its bounds and references as the confirmed direction, then skip the scope question, the design memo, and the plan-confirmation gate. Each of the three settles something — what the user wants, which shape the work should take, whether the approach is whole — that the inspection settled with the user present. Put again to an empty room, they either stall the run or get answered on the user's behalf</step>
        <step>3. <execute name="active-skills" overview="$overview" direction="$bounds-and-references"/></step>
        <step>4. <execute name="investigate" overview="$overview"/></step>
        <step>5. <execute name="create-plan" completed-overview="$overview" active-skills="$active-skills"/></step>
    </condition>
    <condition if="no confirmed work list exists — /write runs standalone">
        <step>6. use ask question tool to clarify scope of the feature</step>
        <step>7. <execute name="design-analyze" overview="$overview"/></step>
        <step>8. <execute name="active-skills" overview="$overview" direction="$memo"/></step>
        <step>9. <execute name="investigate" overview="$overview"/></step>
        <step>10. deeply understand the project codebase related to the feature, stay within project boundaries and do not read library or framework source code</step>
        <step>11. enter the plan mode</step>
        <step>12. <execute name="create-plan" completed-overview="$overview" active-skills="$active-skills"/></step>
        <step>13. review and finalize the implementation plan for minimal change instead of over-engineering; refine if over-engineering detected</step>
        <step>14. exit plan mode and wait for user confirmation</step>
    </condition>
    <step>15. create tasks from the plan using TaskCreate tool, so progress can be tracked</step>
    <loop for="task in $plan.tasks">
        <step>16. <execute name="execute-task" task="$task" skill="$task.skills"/></step>
        <step>17. collect task result for quality report and update task status</step>
    </loop>
    <step>18. <execute name="quality-report" active-skills="$active-skills" task-results="$task-results"/></step>
    <condition if="the confirmed direction proposed a Patterns-section entry or ADR">
        <step>19. name the proposal in the report rather than writing it — `docs/architecture.md` and `docs/decisions/` are read by people, and a record laid down without them is one they have to rewrite</step>
    </condition>
    <step>20. suggest running `/inspect` to confirm the spec, the code, and the reader's understanding still agree after this work</step>
    <return>implementation quality report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
