---
name: write
description: Implement a new feature or correct a defect by finding the smallest scope the implementation can take — what already exists is climbed through before anything new is written.
argument-hint: feature|id
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Edit, Skill(coding:design-forces), Skill(coding:architecture), Skill(coding:domain-modeling), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:refactoring), Skill(coding:testing), Skill(coding:schema), Skill(coding:security)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## What This Command Converges

`/inspect` opens the option space and closes it with the user present; what reaches here is already decided. This command's own question is narrower: **for each item, what is the smallest scope the implementation can take.** Every step below either narrows or reports — nothing here reopens a decision the inspection settled.

## Skills Index

A lightweight index of where knowledge lives, not a judgement about what this work needs. The ladder decides that, and a skill is opened only once the ladder lands on its last rung; each skill's own Applicability Rubric is the authority on whether it fits.

| Skill                    | Open it when the work involves                    |
|--------------------------|---------------------------------------------------|
| `coding:testing`         | the test net under the change                     |
| `coding:principles`      | class structure, boundaries, or dependency direction |
| `coding:architecture`    | the recorded structure, or a layer decision       |
| `coding:domain-modeling` | business rules or domain concepts                 |
| `coding:design-patterns` | a variation a named pattern would carry           |
| `coding:refactoring`     | existing code that must move first                |
| `coding:schema`          | database schemas, API contracts, or serialization |
| `coding:security`        | user input, auth, secrets, or trust boundaries    |

Language-specific skills are not listed; check available skills before deciding.

## Definition

<function name="overview">
    <description>Establish the context, reading what has already been recorded before looking for it again. In the usual rhythm each work-list item runs `/write` → `/inspect` → `/refactor`, so the round's inspection has already taken in the whole this sits in; scanning for it again spends a pass to find the same thing.</description>
    <parameter name="feature" type="string" description="The feature to implement." required="true"/>
    <step>1. read what this round already recorded — the `/inspect` report with its work list, bounds, references and the order it gave them, plus the commits from items already done in this round. Where a record covers the ground, it is the context rather than a starting point for re-deriving one</step>
    <step>2. read whatever states the intended behavior where the record does not reach: a spec, an issue, or the notes the project keeps instead</step>
    <step>3. search the codebase only for what neither covers. With no record at all — `/write` called on its own — this search is the whole of the overview</step>
    <return>the feature with its context, the bounds and references it runs under, and what this round has already built</return>
</function>

<function name="climb">
    <description>Find the smallest scope one item's implementation can take. Each rung asks whether something that already exists answers the item, ordered so the cheapest answer is found before anything new is written. Stop at the first rung that holds.</description>
    <parameter name="item" type="string" description="One item, or one thing about to be created." required="true"/>
    <step>1. does this need to exist at all? An item the round no longer needs is reported as such, not built</step>
    <step>2. does this codebase already have it — including whatever earlier items in this round just built? This is the rung that keeps a round from building the same thing twice, so its search covers what was written minutes ago as well as what was there this morning</step>
    <step>3. does the language or its standard library already do it?</step>
    <step>4. does the framework or platform already do it?</step>
    <step>5. does an already-installed dependency already do it? Adding a new dependency is not this rung — it is new, and gets weighed at the last rung against writing the small thing here instead</step>
    <step>6. can it be one line?</step>
    <step>7. only here, write the minimum that works</step>
    <step>8. answer rungs 3 to 5 by searching the official documentation first, and by how this codebase already uses the thing. The source is there to read when the documentation does not settle it — reaching for it before the documentation is what turns a cheap rung expensive</step>
    <step>9. whichever rung holds, say why what it offers actually fits. A rung you cannot justify is one you stopped at too early: forcing an ill-fitting existing thing costs more than writing the small new one, and the smallest change in the wrong place is a second defect rather than a saving</step>
    <return>the rung this item stopped at, what it uses, and why that fits</return>
</function>

<function name="locate-the-cause">
    <description>For an item that corrects a defect, find where the fix belongs. A report names a symptom, and the place it was noticed is not always the place it lives.</description>
    <parameter name="item" type="string" description="The defect item." required="true"/>
    <step>1. trace from the symptom to the function that produces it</step>
    <step>2. search for every caller of that function. Where several reach the same broken behavior, the fix belongs in the shared function once — one guard there is a smaller change than one per caller, and patching only the path the report names leaves a sibling caller still broken</step>
    <step>3. where the callers genuinely differ, say so and fix the one that is wrong</step>
    <return>where the fix belongs, and which callers it covers</return>
</function>

<function name="design-analyze">
    <description>Frame a structural direction, for the rare item that reaches the last rung and carries a structural commitment with it. Runs only then — below that rung there is nothing structural to frame, and producing options for a settled question reopens it.</description>
    <parameter name="item" type="string" description="The item whose implementation carries a structural commitment." required="true"/>
    <step>1. use Skill(coding:design-forces) to load the diagnosis protocol</step>
    <step>2. follow it with this item as the subject, reading recorded patterns first — a recorded pattern that still fits ends this in a Confirming Memo</step>
    <step>3. present the memo and confirm the direction before the item is executed</step>
    <return>the confirmed structural direction for that one item</return>
</function>

<function name="investigate">
    <description>Confirm an API or convention against official documentation, for the one or two places the project's own code does not already answer.</description>
    <parameter name="items" type="list" description="The climbed items." required="true"/>
    <step>1. identify where a library or API signature is genuinely in doubt — where this codebase already uses it, that use is the answer</step>
    <step>2. use WebSearch to check the official documentation for those</step>
    <return>confirmed usage, or nothing when the codebase already answered</return>
</function>

<function name="create-plan">
    <description>Turn the climbed items into an implementation plan.</description>
    <parameter name="climbed-items" type="list" description="The items with the rung each stopped at." required="true"/>
    <step>1. drop the items that stopped below the last rung and need no new code; what they use is recorded rather than built</step>
    <step>2. name the integration test cases that will verify the components work together, and unit cases only for the edges those cannot practically reach</step>
    <step>3. break the remaining work into tasks along the design's own seams; where a confirmed work list already names them, those are the tasks. Name for each task which promises it makes good on — drawn from the spec, or from whatever states the intended behavior where no spec exists — or, where a task changes structure rather than behavior, which promises it has to leave standing. A task that can name neither has nothing to be judged complete against, and reporting that serves better than calling it done</step>
    <step>4. sequence outside-in: user-facing layers first (controllers, presenters, API endpoints), then use cases, then entities and infrastructure — deferring schema and storage decisions until the domain model shape is clear from what the use cases need</step>
    <step>5. for each task, open whichever skills the index points at for the shape the new code should take</step>
    <return>the implementation plan</return>
</function>

<function name="execute-task">
    <description>Execute a single task from the plan.</description>
    <parameter name="task" type="string" description="The task to execute." required="true"/>
    <step>1. anything the task turns out to need that was not named in the plan gets its own climb before it is written — the need for a particular helper usually surfaces here rather than at plan time, which is exactly where the round would otherwise rebuild what it already has</step>
    <step>2. implement the task together with the tests that cover the promises it names. If you feel the urge to verify language or API behavior with `node -e` / `ruby -e` / `python -c` before writing code, that urge is telling you to add a test case for that assumption instead — see `coding:testing` Verification Discipline</step>
    <step>3. let the code carry its own intent, in this order: can a name or an extracted method say it, in which case say it there and write no comment; is this a library or shared module's public API, where a doc comment states intent and when to reach for it; does a value reference something external — an RFC code, a control byte, a ticket — where the comment names that reference. Otherwise write none. Not writing one is only right because the name already carries the intent, so a name you cannot make carry it is the case that needs the comment</step>
    <step>4. when a first attempt was wrong and the second is right, the correction is the whole record: working code is the evidence of what is true now, and a comment explaining why the earlier attempt failed is residue of how the code got here. If a real constraint made the first attempt wrong, state that constraint as something now true — never as the history of the mistake</step>
    <step>5. with the task standing complete and the suite green, prove the net holds as `coding:testing` describes — break one of the promises the task names, watch a test object, restore, confirm the diff matches. A suite nobody has challenged says only that the code passes its own tests</step>
    <step>6. refactor while the suite stays green</step>
    <step>7. invoke the skills opened for this task to verify their completion rubrics</step>
    <return>the completed task with its verification result</return>
</function>

<function name="quality-report">
    <description>Report what the round built, against what it set out to build.</description>
    <parameter name="climbed-items" type="list" description="The items with the rung each stopped at." required="true"/>
    <parameter name="task-results" type="list" description="The results from each executed task." required="true"/>
    <step>1. state the rung each item stopped at, and what it used. An item built new that a lower rung would have answered is work that was done and did not have to be</step>
    <step>2. for each skill that was opened, invoke it to verify its completion rubric</step>
    <step>3. collect the verification results and identify gaps</step>
    <return>the implementation report</return>
</function>

<procedure name="main">
    <parameter name="feature" type="string" description="The feature to implement." required="true"/>
    <step>1. <execute name="overview" feature="$feature"/></step>
    <condition if="a prior /inspect has already converged the work list for this round in the current context">
        <step>2. take that work list as the source, and its bounds and references as the confirmed direction. The scope question and the plan-confirmation gate are skipped: the inspection settled both with the user present, and putting them again to an empty room either stalls the run or answers on the user's behalf</step>
    </condition>
    <condition if="no confirmed work list exists — /write runs standalone">
        <step>3. use ask question tool to clarify the scope, and take the answers as the bounds</step>
    </condition>
    <loop for="item in $items">
        <condition if="the item corrects a defect">
            <step>4. <execute name="locate-the-cause" item="$item"/></step>
        </condition>
        <step>5. <execute name="climb" item="$item"/></step>
    </loop>
    <condition if="any item reached the last rung carrying a structural commitment, or its implementation would depart from the round's references">
        <step>6. <execute name="design-analyze" item="$item"/> for those items only</step>
    </condition>
    <step>7. <execute name="investigate" items="$climbed-items"/></step>
    <step>8. <execute name="create-plan" climbed-items="$climbed-items"/></step>
    <condition if="no confirmed work list exists — /write runs standalone">
        <step>9. present the plan and wait for user confirmation</step>
    </condition>
    <step>10. create tasks from the plan using TaskCreate tool, so progress can be tracked</step>
    <loop for="task in $plan.tasks">
        <step>11. <execute name="execute-task" task="$task"/></step>
        <step>12. collect the result and update task status</step>
    </loop>
    <step>13. <execute name="quality-report" climbed-items="$climbed-items" task-results="$task-results"/></step>
    <condition if="a design-analyze ran and its direction is likely to recur">
        <step>14. name the proposed Patterns-section entry or ADR in the report rather than writing it — `docs/architecture.md` and `docs/decisions/` are read by people, and a record laid down without them is one they have to rewrite</step>
    </condition>
    <step>15. suggest running `/inspect` to confirm the spec, the code, and the reader's understanding still agree after this work</step>
    <return>the implementation report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
