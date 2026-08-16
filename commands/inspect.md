---
name: inspect
description: Prepare for what you have noticed or mean to take on next — taking in the whole the work sits in before reading any part of it closely, then working out what still stands between the code and the goal you named, and converging through clarification into the work list for this round. Read-only — it does not change code, and an item stays out of the work list while anything about it is still ambiguous.
argument-hint: [path|module|--staged|intent] [--deep]
# --deep looks harder for what the user cannot see; without it, leads are reported unverified
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), WebSearch, WebFetch, Skill(coding:design-forces), Skill(coding:testing), Skill(coding:refactoring), Skill(coding:principles), Skill(coding:design-patterns), Skill(coding:architecture), Skill(coding:schema), Skill(coding:security)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## How Wide, How Deep

You are preparing for something the user has named — what they have noticed, or what they mean to take on next. Being prepared means knowing the whole this work sits in and what still stands between it and their goal. This runs before the work starts and the clarification that follows keeps filling it in, so a pass that stops early and says where it stopped serves better than one that tries to be exhaustive.

Width and depth cost different things, so they answer to different rules. Width is cheap — how the project got here from its log, what stands where from a tree, what else names this thing from a search — and it is what tells you which parts bear on the goal at all. Take it first and take it for the whole, not only for the place the target names: a part judged without the whole is judged without knowing what else moves when it moves. A narrow pass does not find less, it finds the same volume with nothing to rank it by.

Depth is expensive, so it is spent where width has already pointed. What licenses reading a file closely is a question it answers that a search cannot, so name the question first — *is this how the codebase everywhere else acquires a collaborator?* — and put it to whatever search the environment offers; a file you cannot attach a question to stays closed, whatever its size. When the file is long, search inside it and read the range that answers. Stop when one more file would no longer change what the work list holds or the order it should be taken in.

What bears on the goal is the one test both reading and reporting answer to — the goal being what the user wants to reach, not the state of the system around it. Something standing between them and it belongs to this round whether or not it sits where they happened to be looking; something true, real, and beside the point stays out, because a round that carries it has to rank it, and ranking it is what turns a short list into a survey.

A goal you cannot tell you have reached narrows nothing, since everything near it bears on it. When the user named a direction rather than a destination — *easier to maintain*, *cleaner* — what the round owes them first is a destination they would recognise on arrival: offer the readings you can see, or the smallest thing that would count as arriving. A list built to satisfy every reading at once is the union of several rounds, and it hands back the narrowing they asked you for.

Anything you would have to trace further to be sure of becomes a **lead** — its location, the question it raises, and why it might matter — recorded rather than chased. Holding a lead costs one line; chasing it costs the run. Ambiguity keeps an item out of the work list anyway, so digging until it resolves buys nothing here.

Every conclusion is stated at the strength of the evidence behind it. Reading is not proof, so leads stay marked unverified until something traces them. A search is weaker still: it shows where a pattern matches, not what a match means in context nor that nothing else matches — *elsewhere the codebase injects its collaborators*, never *this is the only place that does not*. Weakest of all is anything you would have to run or evaluate to know — what a range expands to, where a boundary falls, what an expression computes — which stays unconfirmed however plainly it reads, because this command reads rather than runs. Certifying a broken promise as kept is worse than missing it: a miss leaves the doubt alive, a false all-clear ends it.

`--deep` says the user cannot see the thing themselves and is asking you to look harder. Width is already taken by then, so the extra effort goes downward: tracing each lead until it can be confirmed or dropped, and following each promise that bears on the goal to wherever the code that keeps it lives — a promise broken outside the diff is exactly what someone cannot see from where they stand.

## Lenses

`coding:testing` and `coding:principles` are always active; every change has a test surface and a style surface. The rest activate only when the scope actually contains what they read for, so an unused lens costs nothing:

| Skill                    | Activates when the scope contains                                              |
|--------------------------|--------------------------------------------------------------------------------|
| `coding:refactoring`     | code smells or structural issues worth refactoring                             |
| `coding:design-patterns` | patterns that may be misused or missing                                        |
| `coding:architecture`    | crossings of architectural layers, dependency direction, or the recorded structure |
| `coding:schema`          | database schemas, API contracts, or data serialization                         |
| `coding:security`        | user input, auth, secrets, or trust boundaries                                  |

Language-specific skills are not listed here; check available skills before deciding.

## The Report

Whoever reads this is deciding what the round takes on, and that decision needs the whole shape first — how many findings, how bad, how well backed — before any one of them is worth reading closely. So the shape comes first and the reasoning follows it, rather than leaving the reader to assemble the shape out of the reasoning.

Most of what a finding carries is the same every time: where it is, how severe, what backs it, and a line saying what still stands in the way. That part sits well in a row. What differs is the reasoning that makes a claim non-obvious — the coupling that makes a fix larger than it looks, the counter-evidence that keeps a rule from being overdrawn — and that is what the prose beneath the row is for. State a finding in full once and refer to it by id after; the work list carries a phrase for each item rather than the finding again, so it reads on its own without becoming a second copy of the table.

Two or three sentences is usually the whole of that prose. This report opens a round of clarification rather than closing it, so what is easy to reach from the row is better left for the reader to reach, and a finding whose shape genuinely turns on its reasoning is where the extra sentences should go instead. An item under Still unknown is sized the same way — the question, and what its answer would change.

This shape usually serves:

```markdown
# /inspect [--deep] — <what this round prepares for>

Goal: … · Bounds: … · References: …
The whole: … · Read closely: … · Seen but not opened: …

| # | Sev | Evidence | Where | What stands between here and the goal |
|---|---|---|---|---|
| G1 | High | traced | `links_controller.rb:19` | expired links answer 404; the goal needs 410 |
| G4 | Med | unrun | `code_generator.rb:3` | `l` appears to survive in ALPHABET |
| G6 | Med | traced | `README.md:64` | says this is never deployed — an earlier decision, to update |

**Work list**

| Order | # | This step | Why it sits here |
|---|---|---|---|
| 1 | G4 | drop `l` from the alphabet | nothing else can be trusted while codes are still wrong |
| 2 | G1 | answer 410 for expired links | the promise the goal named |
| 3 | G6 | bring the README line up to date | it records the decision this round replaces |

**Held back:** G3, G9

## G1 — expired links answer 404 · High · traced
<only what the row cannot carry>

## Still unknown — held out of the work list
<each in full: what is unsettled, and what its resolution would change>
```

`The whole` is what width bought — how the project got to here and what state it is in, in a line or two. It sits above the findings because it is what makes them rankable: without it a reader has a list, with it they have a list they can weigh.

`Bounds` carries the limits the user set while clarifying — how heavy a solution is wanted, what must not be touched — and `References` whatever they pointed at as the way to do the work. Both sit with the goal and carry no evidence mark, since nothing backs them but the user having said so. Work downstream follows both, and departing from a reference is a finding that needs saying rather than a choice made quietly; a later round can only check they were kept because they were written here.

The Evidence column is where the ladder above lands. Every finding names what backs it, so a row with nothing to put there is a finding that has not been established yet — which is easier to notice in a column than in a paragraph.

Reach for an ASCII diagram when a finding runs through several places and prose would have to walk the reader through them in order — a request path that branches, a promise kept across three files. Where one line of prose says it, one line of prose is better.

Depart from this where the report is better for it: a pass with one finding needs no index, and a claim a cell would make sound firmer than its evidence belongs in prose.

## Definition

<function name="take-in-the-whole">
    <description>Settle what this round is for, then take in the whole it sits in — cheaply, before anything is read closely. Width comes before depth because it is what makes the parts rankable.</description>
    <parameter name="target" type="string" description="A path, module, --staged flag, or a sentence naming what the user wants confirmed." required="false"/>
    <step>1. settle the goal from the target: `--staged` → `git diff --staged`; a path → `git diff HEAD -- $target`, or what stands under it when it carries no pending changes; empty → `git show HEAD`. A sentence naming what the user wants confirmed carries its own goal and usually its own places, be they source, notes, a record of earlier rounds, or a scratch directory. What it decides is taken as given rather than reopened, since deciding is theirs; what it points at as the way to do the work is read until you could restate that way in your own words, because a reference half-read is what turns "follow this" into "do it however I already knew"</step>
    <step>2. take the width: `git log --oneline` for how the project got here and what has been moving, a tree for what stands where, a search for whatever else names what the goal is about. Categorize what this turns up into source, test, config, docs. Nothing is read closely in this pass, and it runs whether or not the target named a place</step>
    <step>3. rank what the width turned up by what bears on the goal, and carry forward those as the key files. Something outside the place the target named still counts when the goal runs through it; something inside it does not when nothing the goal needs touches it</step>
    <step>4. use ask question tool for whatever the target leaves unsettled, and only for that — asking what the user already answered wastes the round trip that reading the wrong thing was going to cost</step>
    <return>the goal with its bounds and references, the whole in a line or two, and the key files ranked by what bears on the goal</return>
</function>

<function name="read-key-files">
    <description>Read the key files through the active lenses and record what still stands between the code and the goal. Depth is bounded by the stopping rule in "How Wide, How Deep".</description>
    <parameter name="whole" type="object" description="The goal, the whole, and the key files." required="true"/>
    <step>1. activate the lenses the key files call for and load them with Skill()</step>
    <step>2. read the key files, and whatever states the intended behaviour for them — a spec and roadmap where the project keeps them, otherwise the notes and records it keeps instead</step>
    <step>3. record each thing standing between the code and the goal as a lead: location, the question it raises, severity, and the technique or skill that would address it (e.g. Extract Method via `coding:refactoring`)</step>
    <step>4. mark every lead unverified</step>
    <return>the leads, each unverified</return>
</function>

<function name="spend-depth">
    <description>Spend the effort --deep asks for. Width is already taken, so this goes downward: on the leads already held, and on the promises the default pass left untraced. Only runs under --deep.</description>
    <parameter name="leads" type="list" description="The unverified leads." required="true"/>
    <parameter name="whole" type="object" description="The goal, the whole, and the key files." required="true"/>
    <loop for="lead in $leads">
        <step>1. trace the lead from what it points at until it can be confirmed or dropped; a confirmed lead loses its unverified mark and carries the evidence — file and line — that confirmed it</step>
    </loop>
    <step>2. then take each promise that bears on the goal and check it against what the code does, opening whatever keeps that promise even when it sits outside the diff. Whoever asked for depth cannot see it themselves, so the point is to find what they missed, and a promise the goal runs through is what makes a distant file worth opening</step>
    <step>3. record anything new the same way read-key-files does, and mark it verified only where it was traced rather than searched</step>
    <return>the confirmed leads, whatever the deeper reading turned up, and a one-line list of what was checked and found to be nothing</return>
</function>

<function name="report-the-round">
    <description>Organize the leads into the round's report: the whole this work sits in, what still stands between it and the goal, the work list, and whatever is still unknown. Ambiguity keeps an item out of the work list.</description>
    <parameter name="leads" type="list" description="The leads, verified or not." required="true"/>
    <parameter name="whole" type="object" description="The goal, the whole, and the key files." required="true"/>
    <step>1. merge the leads and deduplicate what overlaps across lenses, then index them as "The Report" lays out</step>
    <step>2. state the whole in the line or two the width bought, and name what was read closely against what was seen but never opened — the reader can only tell where this list stops once the unread parts are stated</step>
    <step>3. say what still stands between the code and the goal. The goal is the user's and it is the newest thing they have said, so where a README, a note, or a roadmap says otherwise, that record is carrying an earlier decision: it belongs in the work list as a line to bring up to date, not in the report as a position to argue against. What they have claimed about how things are stays open to the evidence, and evidence that contradicts a claim is worth reporting — but as a gap between here and where they mean to get, rather than as a verdict on who was right</step>
    <step>4. add what would block or undo the goal from outside what it touches — a broken test net under the work, a boundary that will not hold the change. This is your reading rather than anyone's stated position. This command reads rather than runs, so judge coverage by reading and mark where that leaves a result unconfirmed: what you could not execute is a limit of the inspection, not a fault in the code</step>
    <step>5. draw the work list for this round from the sections above. Order it by what has to hold before the next item can be done, and by severity where nothing forces the order; each item carries the reason it sits where it does, because an order whose reason is left out is one the reader can only trust or re-derive, and the list is what they take away</step>
    <step>6. record the limits the user set as the round's bounds and whatever they pointed at as its references, taking both from what they said and nowhere else, and leaving either line empty where they set none</step>
    <step>7. list separately whatever is still unknown — an item whose scope, cause, or desired outcome is unsettled — and hold it out of the work list until it resolves, along with any work whose shape would change with the resolution. Work that merely stands near an unsettled question is not held: a finding with one clear fix keeps its place at its own severity however much is unsettled around it. Write "none" when nothing is unknown</step>
    <return>the round's report, the work list with its bounds and references, and the unknowns held back from it</return>
</function>

<procedure name="main">
    <parameter name="target" type="string" description="A path, module, --staged flag, or a sentence naming what the user wants confirmed." required="false"/>
    <parameter name="deep" type="boolean" description="When true, verify each lead with evidence instead of reporting it unverified." required="false"/>
    <step>1. <execute name="take-in-the-whole" target="$target"/></step>
    <step>2. <execute name="read-key-files" whole="$whole"/></step>
    <condition if="$deep">
        <step>3. <execute name="spend-depth" leads="$leads" whole="$whole"/></step>
    </condition>
    <step>4. <execute name="report-the-round" leads="$leads" whole="$whole"/></step>
    <condition if="a work list confirmed in an earlier round is present in this context">
        <step>5. quote that work list with its bounds and references verbatim and compare this round's changes against all three. Work can finish every item and still overshoot — a solution heavier than was wanted breaks no item on the list — so the bounds are the only place that catches it. Nobody is waiting to answer here, so ask nothing: drift or a fresh unknown stops the run and is reported for the user to resolve</step>
    </condition>
    <condition if="no confirmed work list exists — this is the opening round">
        <step>6. present the report, the work list, and the unknowns, then invite the user to confirm it or ask further. Each answer resolves an unknown and redraws the list; an answer that sets a limit rather than settling an item belongs in the bounds instead. The user decides when it is settled enough to run `/write` or `/refactor`</step>
        <condition if="leads remain unverified and not $deep">
            <step>7. add one line offering `/inspect [same target] --deep` to trace them</step>
        </condition>
    </condition>
    <return>the round's report with its work list, bounds and references, or the drift report when a confirmed list already exists</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
