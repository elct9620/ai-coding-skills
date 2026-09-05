---
name: refactor
description: Clean up legacy code by finding the smallest change that resolves each issue — refactoring techniques are climbed by blast radius and the first one that works is the one applied.
argument-hint: [path|module]
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, Edit, Skill(coding:design-forces), Skill(coding:refactoring), Skill(coding:architecture), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:testing), Skill(coding:schema), Skill(coding:security)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## What This Command Converges

`/inspect` opens the option space and closes it with the user present; what reaches here is already decided. This command's own question is narrower: **for each item, what is the smallest change that resolves it.** Every step below either narrows or reports — nothing here reopens a decision the inspection settled.

## Skills Index

A lightweight index of where knowledge lives, not a judgement about what this work needs. The ladder decides that, and a skill is opened only once the ladder lands on a rung calling for it; each skill's own Applicability Rubric is the authority on whether it fits.

| Skill                    | Open it when the work involves                    |
|--------------------------|---------------------------------------------------|
| `coding:refactoring`     | any refactoring — the ladder itself lives here    |
| `coding:architecture`    | layer crossings, dependency direction, or the recorded structure |
| `coding:principles`      | SOLID, DRY, or responsibility questions           |
| `coding:design-patterns` | a variation a named pattern would carry           |
| `coding:testing`         | the test net under the change                     |
| `coding:schema`          | database schemas, API contracts, or serialization |
| `coding:security`        | user input, auth, secrets, or trust boundaries    |

Language-specific skills are not listed; check available skills before deciding.

## Definition

<function name="analyze-smells">
    <description>Establish what stands in the way, reading what has already been recorded before looking for it again. In the usual rhythm each work-list item runs `/write` → `/inspect` → `/refactor`, so the inspection that just ran has already read this change; scanning for it again spends a pass to find the same thing.</description>
    <parameter name="target" type="string" description="The path or module to analyze. Empty for whole project." required="false"/>
    <step>1. read what this round already recorded — the `/inspect` report covering this change with its work list, bounds and references, and the commits from items already done. Where a record covers the ground, it is the finding rather than a starting point for re-deriving one</step>
    <step>2. scan the target only for what the record leaves uncovered. With no record at all — `/refactor` called on its own — this scan is the whole of the analysis</step>
    <step>3. for cross-class smells (Feature Envy, Shotgun Surgery), identify the architectural layer of each class involved before confirming the smell, and exclude the cases where inner-layer coordination is normal: a Use Case reading Entity data is not Feature Envy, a Repository handling serialization is not misplaced logic</step>
    <step>4. exclude what `git log` shows was introduced deliberately or refactored recently</step>
    <step>5. categorize by severity</step>
    <return>the items standing in the way, with severity, location, layer context, and which of them came from the record rather than this scan</return>
</function>

<function name="climb">
    <description>Find the smallest change that resolves one item. How much a technique disturbs is a property of the technique, recorded as Blast Radius in `coding:refactoring`; climbing that order finds the cheapest technique that actually works before the expensive ones are considered.</description>
    <parameter name="item" type="string" description="One item from the list." required="true"/>
    <step>1. check the item still stands. Earlier items in this round may have removed the code it names or turned it into a different problem — an item that has dissolved is reported as dissolved, not worked around</step>
    <step>2. use Skill(coding:refactoring) to load the Blast Radius order, then take the technique at radius 1 and ask whether it resolves the item; if not, radius 2, and so on. Stop at the first technique that does</step>
    <step>3. say why that technique resolves it. A rung you cannot justify is one you stopped at too early — the smallest change in the wrong place is not the smallest change, it is a second problem</step>
    <step>4. radius 1 (Remove Dead Code) stands only once every caller has been searched for. "Nothing appears to use it" is a reading, not a proof, and this is the one rung where being wrong deletes working behaviour</step>
    <step>5. from radius 6 onward the technique adds something named, so open whichever skills the index points at for the shape that thing should take. Below radius 6 the technique is its own answer and no skill is needed</step>
    <return>the item with its chosen technique, the radius, and the reason that technique is enough</return>
</function>

<function name="design-analyze">
    <description>Frame a structural direction, for the rare item whose chosen technique is itself structural. Runs only when the climb has landed on the top of the ladder — below that there is no structural commitment to frame, and producing options for a settled question reopens it.</description>
    <parameter name="item" type="string" description="The item whose chosen technique reorganizes structure." required="true"/>
    <step>1. use Skill(coding:design-forces) to load the diagnosis protocol</step>
    <step>2. follow it with this item as the subject, reading recorded patterns first — a recorded pattern that still fits ends this in a Confirming Memo</step>
    <step>3. present the memo and confirm the direction before the item is executed</step>
    <return>the confirmed structural direction for that one item</return>
</function>

<function name="investigate">
    <description>Confirm a convention against official documentation, for the one or two places where the project's own code does not already answer it.</description>
    <parameter name="items" type="list" description="The climbed items." required="true"/>
    <step>1. identify where a framework or library convention is genuinely in doubt — where this codebase already shows the convention, that is the answer</step>
    <step>2. use WebSearch to check the official documentation or style guide for those</step>
    <return>confirmed conventions, or nothing when the codebase already answered</return>
</function>

<function name="create-refactoring-plan">
    <description>Order the climbed items into a plan that preserves behavior.</description>
    <parameter name="items" type="list" description="The climbed items with their chosen techniques and radii." required="true"/>
    <step>1. order by radius, smallest first, except where one item has to hold before another can be done — the cheap changes land first and shrink what the expensive ones have to move through</step>
    <step>2. group items that touch the same code, so one change is not applied twice against a moving target</step>
    <step>3. ensure each step preserves the semantic contract — return-value meaning, completion timing, error model, observable side effects at return — not merely the type signature</step>
    <step>4. for Move Method or Extract Class, verify the target location respects the project's layer rules: dependencies point inward, and logic does not move from an outer layer into an inner one</step>
    <step>5. name the test verification point for each step</step>
    <return>the plan, ordered by radius, with verification points</return>
</function>

<function name="execute-refactoring">
    <description>Execute one step following the golden rule: small steps, always green.</description>
    <parameter name="task" type="string" description="The refactoring task to execute." required="true"/>
    <parameter name="technique" type="string" description="The technique the climb chose, and its radius." required="true"/>
    <step>1. verify all tests pass before starting (baseline)</step>
    <step>2. apply the technique as `coding:refactoring` describes its safe steps</step>
    <step>3. run tests immediately after the change</step>
    <condition if="tests fail">
        <step>4. revert and analyze the failure, then break it into smaller steps</step>
    </condition>
    <step>5. invoke the skill to verify the refactoring quality</step>
    <return>the completed step with its verification result</return>
</function>

<function name="quality-report">
    <description>Report what the round changed, against what it set out to change.</description>
    <parameter name="original-items" type="list" description="The items originally standing in the way." required="true"/>
    <parameter name="task-results" type="list" description="The results from each step." required="true"/>
    <step>1. list what was resolved, what dissolved before it was reached, and what remains</step>
    <step>2. state the radius each item was resolved at. An item resolved above the radius it needed is work that was done and did not have to be</step>
    <step>3. for each skill that was opened, invoke it to verify its completion rubric</step>
    <step>4. confirm all tests still pass, and that they would have objected had the behavior moved — breaking one of the promises the work had to leave standing is how that gets shown, as `coding:testing` describes. A green suite that only pins return values, leaving the semantic contract unasserted, is not evidence of behavior preservation</step>
    <return>the refactoring report</return>
</function>

<procedure name="main">
    <parameter name="target" type="string" description="The path or module to refactor. Empty for whole project." required="false"/>
    <step>1. <execute name="analyze-smells" target="$target"/></step>
    <step>2. check whether the request is actually a refactor: if it would change the semantic contract (return-value meaning, completion timing, error model, delivery or ordering guarantees) while keeping signatures intact, name it as a behavior change and put it back to the user — the run stops there rather than proceeding under the refactor frame, and that reaches them whether or not anyone is waiting to answer</step>
    <condition if="a prior /inspect has already converged the work list for this round in the current context">
        <step>3. take that work list as the source, and its bounds and references as the confirmed direction. The scope question and the plan-confirmation gate are skipped: the inspection settled both with the user present, and putting them again to an empty room either stalls the run or answers on the user's behalf</step>
    </condition>
    <condition if="no confirmed work list exists — /refactor runs standalone">
        <step>4. use ask question tool to confirm scope and priorities, and take the answers as the bounds</step>
    </condition>
    <loop for="item in $items">
        <step>5. <execute name="climb" item="$item"/></step>
    </loop>
    <condition if="any item's chosen technique reorganizes structure (radius 11–12), or a chosen technique would depart from the round's references">
        <step>6. <execute name="design-analyze" item="$item"/> for those items only</step>
    </condition>
    <step>7. <execute name="investigate" items="$climbed-items"/></step>
    <step>8. verify the test coverage the climbed items rely on, staying within project boundaries and not reading library or framework source</step>
    <condition if="insufficient test coverage">
        <step>9. add tests for the untested code before refactoring — behavior preservation needs a safety net</step>
    </condition>
    <step>10. <execute name="create-refactoring-plan" items="$climbed-items"/></step>
    <condition if="no confirmed work list exists — /refactor runs standalone">
        <step>11. present the plan and wait for user confirmation</step>
    </condition>
    <step>12. create tasks from the plan using TaskCreate tool, so progress can be tracked</step>
    <loop for="task in $plan.tasks">
        <step>13. <execute name="execute-refactoring" task="$task" technique="$task.technique"/></step>
        <step>14. collect the result and update task status</step>
    </loop>
    <step>15. <execute name="quality-report" original-items="$items" task-results="$task-results"/></step>
    <condition if="a design-analyze ran and its direction is likely to recur">
        <step>16. name the proposed Patterns-section entry or ADR in the report rather than writing it — `docs/architecture.md` and `docs/decisions/` are read by people, and a record laid down without them is one they have to rewrite</step>
    </condition>
    <step>17. suggest running `/inspect` to confirm the spec, the code, and the reader's understanding still agree after this work</step>
    <return>the refactoring report</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
